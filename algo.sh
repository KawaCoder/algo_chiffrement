#!/bin/bash

function chiffrer() {
    echo -e "\n\n\e[34m-- CHIFFRER UN MESSAGE \e[0m"
    config_file="config.txt"
    if [ ! -f "$config_file" ]; then
        echo -e "[!] Pas de config.txt trouvé."
        exit 1
    fi

    totalchar=$(grep -oP 'totalchar=\K[^[:space:]]+' "$config_file")

    nouveau_totalchar=$(echo -n "$msg" | wc -m)

    sed -i "s/^totalchar=.*/totalchar=$nouveau_totalchar/" config.txt

    seed="$2"

    echo -e "\e[32m[-]\e[0m Trouvé: \e[34mconfig.txt\e[0m\n"

    echo -e "\e[32m[-]\e[0m Calcul de la clef...\e[0m\n"

    clef=$(./generer_clef.sh "$seed")

    echo -e "\e[32m[-]\e[0m Encodage du message (1/2)...\e[0m\n"

    msg=$(bash xor.sh -e "$clef" <<< "$msg")

    msg+="."

    msg+=$seed

    echo -e "\e[32m[-]\e[0m Calcul de la clef secondaire...\e[0m\n"

    clef_secondaire=$(./generer_clef.sh "$totalchar")

    echo -e "\e[32m[-]\e[0m Encodage du message (2/2)...\e[0m\n"

    msg=$(bash xor.sh -e "$clef_secondaire" <<< "$msg")

    echo "$msg"

}

function dechiffrer() {

    echo -e "\n\n\e[34m-- DECHIFFRER UN MESSAGE \e[0m\n"

    config_file="config.txt"

    if [ ! -f "$config_file" ]; then

        echo -e "[!] Pas de config.txt trouvé."

        exit 1

    fi

    totalchar=$(grep -oP 'totalchar=\K[^[:space:]]+' "$config_file")

    echo -e "\e[32m[-]\e[0m Calcul de la clef secondaire...\e[0m\n"

    clef_secondaire=$(./generer_clef.sh "$totalchar")

    echo -e "\e[32m[-]\e[0m Decodage du message (1/2)...\e[0m\n"

    msg=$(bash xor.sh -d "$clef_secondaire" <<< "$msg")

    seed=$(echo "$msg" | cut -d '.' -f 2)

    msg=$(cut -d '.' -f 1 <<< "$msg")

    echo -e "\e[34m Seed trouvée! \e[0m\n"

    echo -e "\e[32m[-]\e[0m Calcul de la clef principale...\e[0m\n"

    clef=$(./generer_clef.sh "$seed")

    echo -e "\e[32m[-]\e[0m Decodage du message (2/2)...\e[0m\n"

    msg=$(bash xor.sh -d "$clef" <<< "$msg")

    echo "$msg"

    nouveau_totalchar=$(echo -n "$msg" | wc -m)

    sed -i "s/^totalchar=.*/totalchar=$nouveau_totalchar/" config.txt


}
if [ "$#" -ne 2 ] && [ "$#" -ne 3 ]; then
    echo "Utilisation: $0 [-c|-d] <message> (seed)"
    exit 1
fi

msg="$2"
case "$1" in
    -c)
        seed="$3"
        chiffrer "$msg" "$seed"
        ;;
    -d)
        dechiffrer "$msg"
        ;;
    *)
        echo "Option invalide: $1"
        exit 1
        ;;
esac

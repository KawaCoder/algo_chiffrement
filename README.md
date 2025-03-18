# algo chiffrement
./algo.sh [-c|-d] <message> (seed)

## EXEMPLES D'UTILISATION:
- Chiffrer:
`./algo.sh -c "Message codé" 567898876)`
Rq: plus la seed est grande plus le chiffrage est robuste en général.


- Déchiffrer:
`./algo.sh -d "01002100288b024Yv12Ru"`


#### Cet algorithme marche seulement avec une paire de contacts.
#### ⚠️Une seule version du programme ne peut pas décoder ses propres messages, il faut un dossier tiers avec une copie complête du programme pour décoder le message!⚠️

Comment fonctionne l'algorithme:

- Au préalable Echange des parametres de polynome (degres, coefficients)
 
#### Chiffrement:
1. Calcul d'une clef primaire grâce à la seed donnée
2. Hashage de la clef avec sha-256
3. Opération XOR entre le message et la clef
4. Calcul d'une clef secondaire grâce au polynome et au nombre de charactères envoyés précédemment (contenu dans config.txt)
5. Opération XOR entre la clef secondaire et le message précédent suivit de l'index de la clef (messagecodé.indexclef XOR total_characteres)
6. Mise à jour du nombre de charactère dans config.txt (pour les futures opérations)

### Dechiffrement:
1. Calcul de la clef secondaire avec le nombre total de charactères envoyés (grâce au polynome)
2. Operation XOR pour retrouver l'index de la clef
3. Calcul de la clef grâce à l'index
4. Opération XOR pour retrouver le message codé
5. Mise à jour du nombre de charactère dans config.txt (pour les futures opérations)


## Screenshots

![chiffrement](https://github.com/user-attachments/assets/c95c1f44-ca70-4648-badd-4af92d42d461)





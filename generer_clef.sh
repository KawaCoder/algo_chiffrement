#!/bin/bash

config_file="config.txt"
degree=$(grep -oP 'degres=\K\d+' "$config_file")
coefficients=$(grep -oP 'coef=\K[^[:space:]]+' "$config_file")
number_index=$1

if [ -z "$degree" ] || [ -z "$coefficients" ] || [ -z "$number_index" ]; then
    echo "Error: Missing or invalid values in config file."
    exit 1
fi

IFS=',' read -r -a coefficients_array <<< "$coefficients"

if [ "${#coefficients_array[@]}" -ne "$((degree + 1))" ]; then
    echo -e "[!] Le nombre de coefficient doit correspondre au nombre spécifié."
    exit 1
fi

expression="${coefficients_array[-1]}"

for ((i = ${#coefficients_array[@]} - 2; i >= 0; i--)); do
    coefficient=${coefficients_array[$i]}
    if [ "$coefficient" != "0" ]; then
        if [ "$i" -eq "1" ]; then
            expression="$expression + $coefficient * x"
        elif [ "$i" -eq "0" ]; then
            expression="$expression + $coefficient"
        else
            expression="$expression + $coefficient * x^$i"
        fi
    fi
done
result=$(echo "x=$number_index; $expression" | bc -l)
echo -n "$result" | sha256sum | awk '{print $1}'

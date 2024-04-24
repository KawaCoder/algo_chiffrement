#!/bin/bash

encode() {
    local key="$1"
    local length=${#key}
    while read -r -N1 byte
    do
        char=${key:$((i % length)):1}
        ((i++))
        printf -v byteval "%d" "'$byte"
        printf -v charval "%d" "'$char"
        printf "%02x" $((byteval ^ charval))
    done
    echo""
}

decode() {
    local key="$1"
    local length=${#key}
    local res=
    local out=
    while read -r -N2 byte
    do
        char=${key:$((i % length)):1}
        ((i++))
        printf -v byteval "%d" "0x$byte"
        printf -v charval "%d" "'$char"
        res=$((byteval ^ charval))
        printf -v out "\\\x%02x" $((byteval ^ charval))
        if [ "$res" -gt '0' ]; then
            printf $out
        else
            printf " "
        fi
    done
    echo""
}

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 [-e|-d] <key>"
    exit 1
fi

key="$2"

case "$1" in
    -e)
        while IFS= read -r line; do
            encoded=$(encode "$key" <<<"$line")
            printf "%s\n" "$encoded"
        done
        ;;
    -d)
        while IFS= read -r line; do
            decoded=$(decode "$key" <<<"$line")
            printf "%s\n" "$decoded"
        done
        ;;
    *)
        echo "Invalid option: $1"
        exit 1
        ;;
esac

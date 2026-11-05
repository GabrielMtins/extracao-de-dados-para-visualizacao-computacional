#!/bin/sh

if [ ! -e "$1" ]; then
	printf "Error: File $1 does not exist.\n"
	exit 1
fi

if [ -z "$2" ]; then
	printf "Error: Second argument is empty.\n"
	exit 1
fi

input_file="$1"
output_file="$2"

# Pequeno script em Python que converte a primeira tabela do html para um csv
python3 -c "import pandas as pd; pd.read_html('$input_file')[0].to_csv('$output_file', index=False)"

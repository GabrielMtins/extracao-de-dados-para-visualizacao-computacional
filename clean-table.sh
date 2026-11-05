#!/bin/sh

if [ ! -e "$1" ]; then
	printf "Error: File $1 does not exist.\n"
	exit 1
fi

if [ -z "$2" ]; then
	printf "Error: Second argument is empty.\n"
	exit 1
fi

base_folder="./grades"
working_table="$1"
export_folder="$base_folder/$2"

table_header="sigla,nome,cred aula, cred trabalho, ch, ce, cp, atpa, ext"

mkdir -p "$base_folder"
mkdir -p "$export_folder"

cuts=$(grep -n "Período Ideal," $working_table | sed "s/º.*$//g")

for i in $cuts; do
	line_jump=$(echo "$i" | sed "s/:/ /g" | awk '{print $1}')
	periodo=$(echo "$i" | sed "s/:/ /g" | awk '{print $2}')
	periodo=$(printf "%02d" "$periodo")

	tmp_table=$(tail -n "+$line_jump" "$working_table" | tail -n +2) 

	line_subtotal=$(printf "$tmp_table" | grep -n "Subtotal:" | head -n 1 | sed "s/:.*$//g")

	if [ -z "$line_subtotal" ]; then
		break
	fi

	final_table=$(printf "$tmp_table" | head -n "$line_subtotal" | head -n -1 | sed "/Requisito/d; /Indicação de Conjunto/d")

	printf "$table_header\n$final_table\n" > "$export_folder/$periodo.csv"

	printf "Criado tabela para periodo $periodo em: $export_folder/$periodo.csv.\n"
done

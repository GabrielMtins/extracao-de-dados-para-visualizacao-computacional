#!/bin/sh

# Anda por todas as tabelas e converte
for i in raw/*.html; do
	printf "Convertendo arquivo: $i...\n"

	# O sed aqui serve para tirar a terminação do arquivo
	export_folder=$(basename "$i" | sed "s/\..*$//g")

	./extract-table.sh "$i" "./tmp.csv"
	./clean-table.sh "./tmp.csv" "$export_folder"
done

rm -f "./tmp.csv"

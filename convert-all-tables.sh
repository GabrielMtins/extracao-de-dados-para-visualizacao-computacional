#!/bin/sh

for i in raw/*.html; do
	printf "Convertendo arquivo: $i...\n"

	export_folder=$(basename "$i" | sed "s/\..*$//g")

	./extract-table.sh "$i" "./tmp.csv"
	./clean-table.sh "./tmp.csv" "$export_folder"
done

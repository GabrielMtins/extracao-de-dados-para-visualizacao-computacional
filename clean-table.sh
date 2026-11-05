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

table_header="departamento,nome,cred aula,cred trabalho,ch,ce,cp,atpa,ext"

mkdir -p "$base_folder"
mkdir -p "$export_folder"

# Isso daqui serve para pegar o início das tabelas válidas de que determinam as
# matérias por período ideal
cuts=$(grep -n "Período Ideal," $working_table | sed "s/º.*$//g")

for i in $cuts; do
	# Basicamente, pegar o número da linha da tabela e o período
	line_jump=$(echo "$i" | sed "s/:/ /g" | awk '{print $1}')
	periodo=$(echo "$i" | sed "s/:/ /g" | awk '{print $2}')
	periodo=$(printf "%02d" "$periodo")

	# Pegar apenas a tabela a partir do seu início
	tmp_table=$(tail -n "+$line_jump" "$working_table" | tail -n +2) 

	# Notou-se que no final de cada tabela de semestre válido, há uma linha com
	# "Subtotal:"; utiliza-se isso para delimitar o fim da tabela.
	line_subtotal=$(printf "$tmp_table" | grep -n "Subtotal:" | head -n 1 | sed "s/:.*$//g")

	# Se não há Subtotal:, então não é uma tabela válida e pode-se sair.
	if [ -z "$line_subtotal" ]; then
		break
	fi

	# Aqui, fazemos a filtragem final; pegamos apenas as linhas válidas da
	# tabela, removemos todas as linhas com Requisito ou Indicação de Conjunto
	# E removemos os números do código da disciplina, para ficarmos
	# apenas com nome do departamento
	final_table=$(printf "$tmp_table" | head -n "$line_subtotal" | head -n -1 | sed "/Requisito/d; /Indicação de Conjunto/d" | sed -E ':a; s/^([^,]*)[0-9]/\1/; ta')

	# Adicionamos o cabeçalho e exportamos para a pasta correta
	printf "$table_header\n$final_table\n" > "$export_folder/$periodo.csv"

	printf "Criado tabela para periodo $periodo em: $export_folder/$periodo.csv.\n"
done

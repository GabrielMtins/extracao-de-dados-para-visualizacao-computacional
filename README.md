# Extração de dados

Esse repositório extrai os dados de páginas HTML do Jupiter Web da USP,
organizando em .csv de disciplinas por semestre. Criei esses scripts para o meu
trabalho de visualização computacional.

Para executar, coloque os .html na pasta `raw/` (o repositório já vem com
alguns) e digite:

```
$ ./extract-all-tables.sh
```

Os arquivos serão extraídos na pasta grades/, colocando a grande horária de
cada semestre em csv/pastas separadas.

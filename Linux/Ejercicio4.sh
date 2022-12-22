#!/bin/bash

url="https://ejemplo.com/pagina.html"

wget "$url" -O pruebapagina.html

palabra=$1

total=$(grep -c "$palabra" pagina.html)

if [ "$total" -eq 0 ]; then
  echo "No se ha encontrado la palabra "$palabra" "
else
  first=$(grep -n "$palabra" pagina.html | head -n 1 | cut -d ':' -f 1)
  echo "La palabra \"$palabra\" aparece $contador veces"
  echo "Aparece por primera vez en la línea $first"
fi

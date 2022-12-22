#!/bin/bash

predeterminado="Que me gusta la bash!!!!"

parametro=$1
if [ -z "$parametro" ]; then
  parametro=$predeterminado
fi

mkdir -p foo/dummy foo/empty
touch foo/dummy/{file1,file2}.txt

echo "$parametro" > foo/dummy/file1.txt

cd foo/dummy
cat file1.txt > file2.txt
mv file2.txt ../empty
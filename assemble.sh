#!/bin/bash

echo 'Assembling with Nasm'
nasm -f elf32 -o $1.o $1.asm

echo 'Linking'
ld -m elf_i386 -z execstack -o $1 $1.o

echo 'Done !'


echo 'shellcode:'

objdump -d ./$1|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g'

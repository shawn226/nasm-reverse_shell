# nasm-reverse_shell
Reverse shell in assembly x86_64 


Installation

You need to install nasm package

Then run : nasm -f elf32 -o reverse.o reverse.asm && ld -m elf_i386 -z execstack -o reverse reverse.o

From these commands you get a a.out, you have to execute it on the victime's computer

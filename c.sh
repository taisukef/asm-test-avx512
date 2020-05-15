nasm -f macho64 $1.s
ld -lSystem -o $1 $1.o
./$1


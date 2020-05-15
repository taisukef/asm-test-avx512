nasm -f macho64 test.s
ld -lSystem -o test test.o
./test


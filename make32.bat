del bin\boot_sect.bin bin\text.bin bin\data.bin bin\bss.bin bin\os-image.bin
nasm boot\boot_sect.asm -f bin  -o bin\boot_sect.bin
rem 512*9 old 3584
bash -c "truncate -s 4608 bin/boot_sect.bin"
rem set /A DATASEG = 1400  old 0x6000
gcc -Wall -pedantic-errors -m32 -march=i386 -ffreestanding kernel32\*.c drivers32\*.c lib32\*.c utils32\*.c -o bin\kernel32.exe -nostdlib -Ttext 0x1000 -nostdlib -Wl,--image-base=0x00000 -Tdata 0x8E00
rem objdump -f kernel32.exe
objcopy -O binary -j .text bin\kernel32.exe bin\text.bin
objcopy -O binary -j .data bin\kernel32.exe bin\data.bin
objcopy -O binary -j .bss bin\kernel32.exe bin\bss.bin
del bin\kernel32.exe
bash -c "cat bin/boot_sect.bin bin/text.bin > bin/os-image-text"
rem =data-0x1000+512*9 old4608 6144 7168 7680 11776 15872 24064 21504
bash -c "truncate -s 22528 bin/os-image-text"
bash -c "cat bin/os-image-text bin/data.bin > bin/os-image.bin"
del bin\os-image-text
rem 16 sectors   old8192 11264 28672 32256
bash -c "truncate -s 33280 bin/os-image.bin"

rem bash -c "cat bin/os-image.bin bmp/742801360-2.bmp > bin/os-image2.bin"

rem default 128 MB RAM -full-screen
qemu-system-i386w.exe -m 512 -vga std -soundhw pcspk bin\os-image.bin

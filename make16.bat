del bin\boot_sect.bin
nasm boot\boot_sect.asm -f bin  -o bin\boot_sect.bin

rem 16 sectors
bash -c "truncate -s 8192 bin/boot_sect.bin"
rem default 128 MB RAM -full-screen
qemu-system-i386w.exe -m 512 bin\boot_sect.bin

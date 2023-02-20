cls
del bin\k32text.sys bin\k32data.sys bin\k32bss.bin

 gcc -Wall -pedantic-errors -m32 -march=i386 -ffreestanding kernel32\*.c drivers32\*.c lib32\*.c utils32\*.c -o bin\kernel32.exe -nostdlib -Ttext 0x30000 -nostdlib -Wl,--image-base=0x00000 -Tdata 0x40000
rem -Ttext 0x10000 -nostdlib -Wl,--image-base=0x00000 -Tdata 0x20000
 objcopy -O binary -j .text bin\kernel32.exe bin\k32text.sys
 objcopy -O binary -j .data bin\kernel32.exe bin\k32data.sys
 objcopy -O binary -j .bss bin\kernel32.exe bin\k32bss.bin
 del bin\kernel32.exe

rem nasm boot\boot_sect.asm -f bin  -o bin\boot_sect.sys
nasm kernel16\kernel16.asm -f bin  -o bin\kernel16.sys
nasm utils16\basic.asm -f bin  -o bin\basic.com
nasm utils16\sqlite.asm -f bin  -o bin\sqlite.com
nasm kernel16\shell.asm -f bin  -o bin\shell.com
nasm utils16\win.asm -f bin  -o bin\win.com
nasm utils16\melody.asm -f bin  -o bin\melody.com
nasm utils16\pm.asm -f bin  -o bin\pm.com
nasm utils16\com.asm -f bin  -o bin\com.com
nasm utils16\a20.asm -f bin  -o bin\a20.com
nasm utils16\vesa.asm -f bin  -o bin\vesa.com
nasm utils16\bios.asm -f bin  -o bin\bios.com
rem gcc -Wall -pedantic-errors -m16 -march=i386 -ffreestanding utils16\flag.c -o bin\flag.exe -nostdlib -Ttext 0x100 -nostdlib -Wl,--image-base=0x00000 -Tdata 0x8E00
copy D:\IT\C\Projects\DOORS\bin\kernel16.sys F:\
copy D:\IT\C\Projects\DOORS\bin\sqlite.com F:\
copy D:\IT\C\Projects\DOORS\bin\basic.com F:\
copy D:\IT\C\Projects\DOORS\bin\shell.com F:\
copy D:\IT\C\Projects\DOORS\bin\win.com F:\
copy D:\IT\C\Projects\DOORS\bin\melody.com F:\
copy D:\IT\C\Projects\DOORS\bin\pm.com F:\
copy D:\IT\C\Projects\DOORS\bin\com.com F:\
copy D:\IT\C\Projects\DOORS\bin\a20.com F:\
copy D:\IT\C\Projects\DOORS\bin\vesa.com F:\
copy D:\IT\C\Projects\DOORS\bin\bios.com F:\

 copy D:\IT\C\Projects\DOORS\bin\k32text.sys F:\
 copy D:\IT\C\Projects\DOORS\bin\k32data.sys F:\
rem objdump -f bin\kernel32.exe

rem qemu-system-i386w.exe -m 512 -vga std -soundhw pcspk -serial stdio -hda \\.\PhysicalDrive2

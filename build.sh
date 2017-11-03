#!/bin/bash
# Build script for Simple OS (Barebone)

if [ $# -eq 0 ]; then
    echo "Usage: build.sh [asm|c] [debug]"
    exit -1
fi

if [ -z "$1" ]; then
    echo "Usage: build.sh [asm|c] [debug]"
    exit -1
fi

if [ ! -z "$2" ]; then
    if [ "$2" == "debug" ]; then
        set -x
    fi
fi

# Variables
WORKINGDIR="$HOME"/projects/sos
SOURCEDIR="$WORKINGDIR"/src
OBJDIR="$WORKINGDIR"/obj
COMPILERDIR="$HOME"/opt/cross/bin
OBJLIST=" "
echo Change directory to working directory...
cd "$WORKINGDIR"

# Compile to object files
echo Begin compiling source code.
rm -rf "$OBJDIR"
mkdir -p "$OBJDIR"

for f in $SOURCEDIR/$1/*."$1"; do
    echo " "
    echo Compiling "$f"...
    filename=$(basename "$f")
    target="$OBJDIR"/${filename%.*}.o
    if [ "$1" == "asm" ]
        then
            nasm -felf32 "$f" -o "$target" -F dwarf -g
        else
            i686-elf-gcc -c "$f" -o "$target" -std=gnu99 -ffreestanding -O2 -Wall -Wextra
    fi
    if [ $? -ne 0 ]; then
        exit
    fi
    OBJLIST+="$target "
done

if [ "$1" == "c" ]; then
    echo
    echo Compiling "$SOURCEDIR"/"$1"/multiboot.asm...
    nasm -felf32 "$SOURCEDIR"/"$1"/multiboot.asm -o "$OBJDIR"/boot.o
    if [ $? -ne 0 ]; then
        exit
    fi
    OBJLIST+="$OBJDIR"/boot.o
fi

echo 
echo Finish compiling.

# Link all objects
echo Linking...
OUTPUTDIR="$WORKINGDIR"/bin
rm -rf "$OUTPUTDIR"/boot
mkdir -p "$OUTPUTDIR"/boot
if [ "$1" == "c" ]
    then
        i686-elf-gcc -T "$SOURCEDIR"/linker.ld -o "$OUTPUTDIR"/boot/simpleos.bin -ffreestanding -O2 -nostdlib -I"$SOURCEDIR"/"$1"/ $OBJLIST -lgcc
    else
        i686-elf-gcc -T "$SOURCEDIR"/linker.ld -o "$OUTPUTDIR"/boot/simpleos.bin -ffreestanding -O2 -nostdlib $OBJLIST -lgcc
fi
if [ $? -ne 0 ]; then
    exit
fi

# Verification and ISO creation
if grub-file --is-x86-multiboot "$OUTPUTDIR"/boot/simpleos.bin; then
  echo multiboot confirmed
else
  echo the file is not multiboot
  exit -2
fi

objcopy --only-keep-debug "$OUTPUTDIR"/boot/simpleos.bin "$OUTPUTDIR"/simpleos.sym
chmod -x "$OUTPUTDIR"/simpleos.sym

# Verify directory exits
ISODIR="$OUTPUTDIR"/isodir
echo Createing ISO image...
rm -rf "$ISODIR"
ISOBOOT="$ISODIR"/boot
ISOGRUB="$ISOBOOT"/grub
mkdir -p "$ISOBOOT"
mkdir -p "$ISOGRUB"

cp "$OUTPUTDIR"/boot/simpleos.bin "$ISOBOOT"/simpleos.bin
cp "$SOURCEDIR"/grub.cfg "$ISOGRUB"/grub.cfg

rm "$OUTPUTDIR"/simpleos.iso
grub-mkrescue -o "$OUTPUTDIR"/simpleos.iso "$ISODIR"
if [ $? -ne 0 ]; then
    exit
fi
echo Done.


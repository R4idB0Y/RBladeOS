#!/bin/bash
# Builder for RBladeOS for Linux
# Writed by R4idB0y
# Copyright (C) 2024 - R4idB0Y

echo "Compiling the bootloader"
nasm -f bin boot.asm -o bin/boot.bin

echo "Compiling the kernel"
nasm -f bin kernel.asm -o bin/kernel.bin

echo "Creating a disk image"
dd if=/dev/zero of=disk_img/rblade.img bs=512 count=2880

dd if=bin/boot.bin of=disk_img/rblade.img conv=notrunc

dd if=bin/kernel.bin of=disk_img/rblade.img bs=512 seek=1 conv=notrunc

echo "Build completed successfully!"
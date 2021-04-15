#!bin/bash

# Go to the working directory
mkdir ~/Kramel && cd ~/Kramel

# Configure git
git config --global user.email "100Daisy@protonmail.com"
git config --global user.name "GitDaisy"
git config --global color.ui false

# Clone device tree and common tree
git clone https://github.com/100Daisy/AnyKernel3
git clone https://github.com/100Daisy/android_kernel_motorola_deen -b android/motorola/deen-LA.UM.8.6.r1-04200-89xx.0 StockPlus
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 gcc

ls -l
echo $PWD
export PATH="/home/builder/Kramel/gcc/bin:$PATH"

# Build Kernel
cd StockPlus
make deen_defconfig ARCH=arm64 O=out
make -j$(nproc --all) O=out ARCH=arm64 CROSS_COMPILE=aarch64-linux-android-

# Make AnyKernel3
cp $(pwd)/out/arch/arm64/boot/Image.gz-dtb ../AnyKernel3
cd ../AnyKernel3
DATE_TIME=$(date +"%d%m%Y%H%M")
zip -r9 Stock+-"${DATE_TIME}".zip ./*

# Upload artifacts
curl -T *.zip https://oshi.at

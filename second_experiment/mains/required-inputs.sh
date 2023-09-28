#!/usr/bin/env bash

# This script contains the inputs that are required to run all our subject programs
# The downloaded artifacts should be in the "initial_experiment/test-inputs/" path.

# set -x
####10go file####
# fallocate -l 10g ./test-inputs/10gofile # This generates a useless file, we need to find another solution

####Debian ISO#### 
iso_url="https://cdimage.debian.org/debian-cd/current/source/iso-dvd/debian-12.0.0-source-DVD-1.iso"
output_folder="./inputs/folder"

# Create the output folder if it doesn't exist
mkdir -p "$output_folder"

# Download the ISO file
echo "Downloading Debian ISO..."
wget -q --show-progress "$iso_url" -O "$output_folder/debian-12.0.0-source-DVD-1.iso"

# Extract the ISO contents
echo "Extracting ISO contents..."
sudo mkdir /mnt/iso
sudo mount -o loop "$output_folder/debian-12.0.0-source-DVD-1.iso" /mnt/iso
sudo cp -rT /mnt/iso "$output_folder"
sudo umount /mnt/iso

####Enwik9####
download_url="https://mattmahoney.net/dc/enwik9.zip"
# Download the ZIP file
echo "Downloading $zip_file..."
curl -o "./test-inputs/enwik9.zip" "$download_url"

# Unzip the file
echo "Unzipping $zip_file..."
unzip "./inputs/enwik9.zip" -d "./test-inputs/"

echo "Extraction completed."
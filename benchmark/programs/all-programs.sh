#!/usr/bin/env bash

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

# base32 benchmark
#$JOULEIT echo -n "Hello World" | base32 > /dev/null

# base64 benchmark
#$JOULEIT base64 -w 0 input.jpg > /dev/null

# basename benchmark
#$JOULEIT basename /home/user/documents/example.txt > /dev/null

# cat benchmark
#$JOULEIT cat file1.txt file2.txt > /dev/null

# chgrp benchmark
$JOULEIT chgrp --changes groupname file.txt > /dev/null

# chmod benchmark
# $JOULEIT chmod --reference=file.txt script.sh > /dev/null

# chown benchmark
# $JOULEIT chown --reference=file.txt user:group file.txt > /dev/null

# chroot benchmark
$JOULEIT chroot /newroot /bin/bash -c "exit" > /dev/null

# cksum benchmark
# $JOULEIT cksum -b file.txt > /dev/null

# comm benchmark
# $JOULEIT comm -1 -2 file1.txt file2.txt > /dev/null

# cp benchmark
# $JOULEIT cp -p file.txt destination/ > /dev/null

# cut benchmark
# $JOULEIT cut -d ',' -f 2,4 --output-delimiter='|' file.csv > /dev/null

# date benchmark
# $JOULEIT date +"%Y-%m-%d %H:%M:%S" > /dev/null

# df benchmark
# $JOULEIT df -hT > /dev/null

# dirname benchmark
# $JOULEIT dirname "/home/user/documents/example.txt" > /dev/null

# du benchmark
# $JOULEIT du -sh --exclude=directory/subdir/ directory/ > /dev/null

# echo benchmark
# $JOULEIT echo -e "Hello, world!\n" > /dev/null

# env benchmark
$JOULEIT env -i HOME=/tmp USER=testuser bash -c 'echo $HOME' > /dev/null

# expand benchmark
# $JOULEIT expand -t 4 file.txt > /dev/null

# factor benchmark
# $JOULEIT factor -e 42 > /dev/null

# false benchmark
# $JOULEIT false > /dev/null

# groups benchmark
$JOULEIT groups --group basefile username > /dev/null

# head benchmark
# $JOULEIT head -n 5 file.txt > /dev/null

# id benchmark
# $JOULEIT id -u -n > /dev/null

# kill benchmark
$JOULEIT kill -s HUP $$ > /dev/null

# link benchmark
# $JOULEIT link -v file.txt hardlink.txt > /dev/null

# ln benchmark
# $JOULEIT ln -sfT file.txt symlink.txt > /dev/null

# logname benchmark
# $JOULEIT logname > /dev/null

# ls benchmark
# $JOULEIT ls -alh --group-directories-first > /dev/null

# md5sum benchmark
# $JOULEIT md5sum -c file.txt.md5 > /dev/null

# mkdir benchmark
# $JOULEIT mkdir -p directory/subdir > /dev/null

# mkfifo benchmark
$JOULEIT mkfifo --mode=0666 pipe > /dev/null

# mknod benchmark
$JOULEIT mknod --mode=0600 device.txt b 1 3 > /dev/null

# mktemp benchmark
$JOULEIT mktemp -d -p /tmp mytempdir.XXXXXX > /dev/null

# mv benchmark
# $JOULEIT mv -i file.txt newfile.txt > /dev/null

# nice benchmark
$JOULEIT nice -n 10 command > /dev/null

# nl benchmark
$JOULEIT nl -s ': ' -w 6 -n rz file.txt > /dev/null

# nohup benchmark
$JOULEIT nohup command > /dev/null

# nproc benchmark
$JOULEIT nproc --all > /dev/null

# od benchmark
$JOULEIT od -t x1 -w8 file.txt > /dev/null

# paste benchmark
$JOULEIT paste -d '|' file1.txt file2.txt > /dev/null

# printenv benchmark
$JOULEIT printenv | grep -i "path" > /dev/null

# printf benchmark
$JOULEIT printf "The value of pi is %.2f\n" 3.14 > /dev/null

# pwd benchmark
$JOULEIT pwd -P > /dev/null

# readlink benchmark
$JOULEIT readlink -f symlink.txt > /dev/null

# realpath benchmark
$JOULEIT realpath -eL file.txt > /dev/null

# rm benchmark
$JOULEIT rm -rf file.txt > /dev/null

# rmdir benchmark
$JOULEIT rmdir directory/subdir > /dev/null

# seq benchmark
$JOULEIT seq -s ',' 1 10 > /dev/null

# sha1sum benchmark
$JOULEIT sha1sum -b file.txt > /dev/null

# sha256sum benchmark
$JOULEIT sha256sum -b file.txt > /dev/null

# sha512sum benchmark
$JOULEIT sha512sum -b file.txt > /dev/null

# shred benchmark
$JOULEIT shred -u -n 5 file.txt > /dev/null

# sleep benchmark
$JOULEIT sleep 5

# sort benchmark
# $JOULEIT sort -r -n -k 2 file.txt > /dev/null

# split benchmark
$JOULEIT split -b 1M -d -a 3 file.txt part > /dev/null

# stat benchmark
$JOULEIT stat -c "File: %n Size: %s bytes" file.txt > /dev/null

# sync benchmark
$JOULEIT sync

# tac benchmark
$JOULEIT tac file.txt > /dev/null

# tail benchmark
$JOULEIT tail -n 5 file.txt > /dev/null

# tee benchmark
# $JOULEIT echo "Hello, world!" | tee file.txt > /dev/null

# test benchmark
$JOULEIT test -f file.txt > /dev/null

# $JOULEITout benchmark
$JOULEIT $JOULEITout 10s command > /dev/null

# touch benchmark
# $JOULEIT touch -d "2 days ago" file.txt > /dev/null

# true benchmark
# $JOULEIT true > /dev/null

# truncate benchmark
$JOULEIT truncate -s 1K file.txt > /dev/null

# tty benchmark
$JOULEIT tty > /dev/null

# uname benchmark
$JOULEIT uname -a > /dev/null

# uniq benchmark
$JOULEIT uniq -c file.txt > /dev/null

# unlink benchmark
$JOULEIT unlink hardlink.txt > /dev/null

# up$JOULEIT benchmark
$JOULEIT up$JOULEIT > /dev/null

# wc benchmark
# $JOULEIT wc -l -w -c file.txt > /dev/null

# who benchmark
$JOULEIT who --heading > /dev/null

# whoami benchmark
$JOULEIT whoami > /dev/null

# yes benchmark
$JOULEIT yes "Hello, world!" > /dev/null

exit 0

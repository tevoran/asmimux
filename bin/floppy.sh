#!/bin/bash
export MTOOLSRC=$1/tmp/tevopsys.cfg

mkdir $1/tmp 2> /dev/null

cat << EOF > $MTOOLSRC
drive x:
   file="$2" cylinders=80 heads=2 sectors=18 filter
EOF

echo "CP       $1/base.img.bz2 -> $2.bz2"
cp $1/base.img.bz2 $2.bz2
rm $2 2> /dev/null
echo "BUNZIP   $2.bz2"
bunzip2 $2.bz2

mcopy $1/menu.lst x:/grub/menu.lst
echo "CP       $1/content/* -> $2"
mcopy -s $1/content/* x:/

rm $MTOOLSRC
rm -R $1/tmp

exit

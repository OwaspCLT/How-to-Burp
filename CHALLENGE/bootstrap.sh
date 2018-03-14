#!/bin/bash

echo "Welcome to the Magic Burp Challenge"

# Ya don't need to do this every time, comment it out once provisioned.
apt-get update
apt-get install -y apache2 php5 php-pear 

rm -rf /var/www/html/*
mkdir /var/www/html/1/

#####
#
# MAKE $NUM Directories
#
#####
NUM=50
HOWHARD=3

EVIL=$(cat /dev/urandom | tr -dc 'a-z' | fold -w $HOWHARD | head -n 1)

for i in `seq 1 $NUM`; do 
	mkdir /var/www/html/1/$i; 
	INC=$(($i+1))
	PRV=$(($i-1))
	echo 'NOPE<br/><a href="../'$PRV'">PREV</a> | <a href="../'$INC'/">NEXT</a><?=file_get_contents($_GET["'$EVIL'"]);?>' > /var/www/html/1/$i/index.php;

done;


RAND=`awk -v min=1 -v max=$NUM 'BEGIN{srand(); print int(min+rand()*(max-min+1))}'`

INC=$(($RAND+1))
PRV=$(($RAND-1))


echo "YOU CHEATER - Page: $RAND GET Param = $EVIL"

echo '<?php if (isset($_GET['info'])) { phpinfo(); echo file_get_contents($_GET["'$EVIL'"]); } else { echo "NOPE<br/><a href=\"../'$PRV'\">PREV</a> | <a href=\"../'$INC'/\">NEXT</a>"; } ?>' > /var/www/html/1/$RAND/index.php


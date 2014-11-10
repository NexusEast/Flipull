#!/bin/sh
from_dir=$QUICK_COCOS2DX_ROOT/../summoner/scripts
to_file=$QUICK_COCOS2DX_ROOT/../summoner/res_phone/game.dat
to_another_file=$QUICK_COCOS2DX_ROOT/../summoner/res/game.dat

mkdir -p $to_dir
./compile_scripts.sh -i  $from_dir -o  $to_file -e xxtea_zip -ek CFgrrwCFewrf;if [ -f $to_file ]; then ls -al $to_file;cp -f $to_file $to_another_file;fi
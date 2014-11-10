#!/bin/sh
from_dir=$QUICK_COCOS2DX_ROOT/../summoner/res
to_dir=$QUICK_COCOS2DX_ROOT/../summoner/res_phone
tmp_dir=$QUICK_COCOS2DX_ROOT/bin/Temp_CacheDir

mkdir -p $to_dir
mkdir -p $tmp_dir


type=normal
while getopts "ac" arg
do 
   case $arg in
     a)
      type=all
      ;;
     c)
      type=copy
      ;;
    esac
done

if [ $type == all ]
then
   echo "type == all"
   if [ -d $tmp_dir ]; then
      rm -rf $tmp_dir/*
   fi
   if [ -d $to_dir ]; then
      rm -rf $to_dir/*
   fi
   ./pack_files.sh -i  $from_dir -o  $to_dir -ek CFgrrwCFewrf -t $tmp_dir
elif [ $type == copy ]
then
   echo "type == copy"
   if [ -d $to_dir ]; then
      rm -rf $to_dir/*
   fi
   if [ -d $from_dir ]; then
      cp -rf $from_dir/* $to_dir
   fi
else
   echo "type == normal"
   ./pack_files.sh -i  $from_dir -o  $to_dir -ek CFgrrwCFewrf -t $tmp_dir
fi

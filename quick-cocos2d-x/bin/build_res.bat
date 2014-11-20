@echo off
e:
cls
set from_dir=E:\Porjects\Flipull\Flipull\res
set to_dir=E:\Porjects\Flipull\Flipull\res_phone
set tmp_dir=E:\Porjects\Flipull\Flipull\Temp_CacheDir

cd E:\Porjects\Flipull\quick-cocos2d-x\bin
mkdir %from_dir%
mkdir %tmp_dir%
  
echo "type == all"
if exist  %tmp_dir%(rd /s/q %tmp_dir% & md %tmp_dir% )
if exist %to_dir%(rd /s/q %to_dir% & md %to_dir%)  
echo "encrypting resources..."
pack_files.bat -i  %from_dir% -o %to_dir% -ek CFgrrwCFewrf -t  %tmp_dir%  
echo "done encrypting resources "
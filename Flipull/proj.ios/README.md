summoner_client
===============


summoner client source

test in branch feature-test
Nothing to say, you guys know the rules:)  

----------------文件加密说明---begin------------------------
该功能只针对ios和android,mac和win32没变
加密后的资源目录为"res_phone/",ios和android项目将不会再包含“res/”,而是“res_phone/”,
lua层添加了app.Utitls.DirBase模块，用来根据平台的不同选择返回“res/”还是“res_phone/”,

操作说明：
由于加密很多图片耗时比较久，所以加密脚本就不自动运行了，需要手动运行
一般在以下情况调用脚本：
1:res_phone目录第一次使用
2:某种出错情况下想全部重新加密
方法：cd $QUICK_COCOS2DX_ROOT/bin;./build_res.sh -a


2:res目录修改，添加、修改了某些文件
方法：cd $QUICK_COCOS2DX_ROOT/bin;./build_res.sh
 
----------------文件加密说明---end--------------------------
a new 2nd line
a new 3th line
/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:SDK初始化接口，android平台该类在C++侧只对外
提供一个接口，其它接口需要开发者在java侧调用    
**************************************************/  

#ifndef __DATAEYE_DCAGENT_H__
#define __DATAEYE_DCAGENT_H__

class DCLuaAgent
{
public: 
	/************************************************* 
	* Description: 自定义错误接口
	* title      : 错误名
    * error      : 错误内容，建议传入错误堆栈信息	
	*************************************************/ 
	static void reportError(const char* title, const char* error);
};

#endif
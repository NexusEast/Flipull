/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:玩家相关接口 
**************************************************/  


#ifndef __DATAEYE_DCACCOUNT_H__
#define __DATAEYE_DCACCOUNT_H__
#include "DCAccountType.h"
#include "DCGender.h"

class DCLuaAccount {
public:
	/************************************************* 
	* Description: 玩家登陆，在DC_AFTER_LOGIN模式下使用
	* accountId  : 玩家账号ID，该参数请保证全局唯一   
	*************************************************/ 
	static void login(const char* accountId);
	
	/************************************************* 
	* Description: 玩家登出，在DC_AFTER_LOGIN模式下使用
	*************************************************/ 
	static void logout();
	
	/************************************************* 
	* Description: 设置玩家账号类型
	* accountType: 玩家账号类型，值为DCAccountType中的枚举   
	*************************************************/ 
	static void setAccountType(DCAccountType accountType);
	
	/************************************************* 
	* Description: 设置玩家等级
	* level      : 玩家账号等级   
	*************************************************/ 
	static void setLevel(int level);
	
	/************************************************* 
	* Description: 设置玩家性别
	* gender     : 玩家性别   
	*************************************************/ 
	static void setGender(DCGender gender);
	
	/************************************************* 
	* Description: 设置玩家年龄
	* age        : 玩家年龄   
	*************************************************/ 
	static void setAge(int age);
	
	/************************************************* 
	* Description: 设置玩家所在区服
	* gameServer : 玩家账号所在区服   
	*************************************************/ 
	static void setGameServer(const char* gameServer);
	
	/************************************************* 
	* Description: 给玩家打标签，用户SDK的后续推送功能
	* tag        : 玩家标签   
	*************************************************/ 
	static void tag(const char* tag);
	
	/************************************************* 
	* Description: 取消玩家标签，用户SDK的后续推送功能
	* tag        : 玩家标签   
	*************************************************/ 
	static void unTag(const char* tag);
};
#endif
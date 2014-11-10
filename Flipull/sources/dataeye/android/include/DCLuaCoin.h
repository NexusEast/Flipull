/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:虚拟币相关接口 
**************************************************/  

#ifndef __DATAEYE_DCCOIN_H__
#define __DATAEYE_DCCOIN_H__

class DCLuaCoin
{
public: 
	/************************************************* 
	* Description: 设置虚拟币总量
	* coinNum    : 虚拟币总量
    * coinType   : 虚拟币类型
	*************************************************/ 
	static void setCoinNum(long long coinNum, const char* coinType);
	
	/************************************************* 
	* Description: 消耗虚拟币
	* id         : 消耗虚拟币时关注的属性，如消耗原因
    * coinType   : 虚拟币类型
	* lost       : 消耗虚拟币的数量
	* left       : 玩家剩余虚拟总量
	*************************************************/ 
	static void lost(const char* id, const char* coinType, long long lost, long long left);
	
	/************************************************* 
	* Description: 消耗虚拟币
	* id         : 消耗虚拟币时关注的属性，如消耗原因
    * coinType   : 虚拟币类型
	* gain       : 消耗虚拟币的数量
	* left       : 玩家剩余虚拟总量
	*************************************************/
	static void gain(const char* id, const char* coinType, long long gain, long long left);
};

#endif
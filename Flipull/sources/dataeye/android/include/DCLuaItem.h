/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:道具接口 
**************************************************/

#ifndef __DATAEYE_DCITEM_H__
#define __DATAEYE_DCITEM_H__

class DCLuaItem
{
public:
    /************************************************* 
	* Description: 购买道具
	* itemId    : 道具ID
    * itemType  : 道具类型
	* itemCount : 购买的道具数量
	* virtualCurrency:购买的道具的虚拟价值
	* currencyType:支付方式
	* consumePoint:消费点，如关卡内消费，可以为空
	*************************************************/
	static void buy(const char* itemId, const char* itemType, int itemCount, long long virtualCurrency, const char* currencyType, const char* consumePoint);
	
	/************************************************* 
	* Description: 获得道具
	* itemId    : 道具ID
    * itemType  : 道具类型
	* itemCount : 道具数量
	* reason    : 获得道具的原因
	*************************************************/
	static void get(const char* itemId, const char* itemType, int itemCount, const char* reason);
	
	/************************************************* 
	* Description: 消耗道具
	* itemId    : 道具ID
    * itemType  : 道具类型
	* itemCount : 道具数量
	* reason    : 消耗道具的原因
	*************************************************/
	static void consume(const char* itemId, const char* itemType, int itemCount, const char* reason);
};

#endif


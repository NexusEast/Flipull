/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:棋牌专项接口 
**************************************************/  

#ifndef __DATAEYE_DCCARDSGAME_H__
#define __DATAEYE_DCCARDSGAME_H__

class DCLuaCardsGame
{
public:
	/************************************************* 
	* Description: 房间中完成一局游戏
	* roomId     : 房间ID
    * id         : 其它属性
    * coinType   : 虚拟币类型
    * lostOrGain : 获得或者输掉的虚拟币数量，值为负时，表示该局游戏结果为输
    * tax        : 完成一局系统收取的台费
    * left       : 玩家剩余虚拟币数量	
	*************************************************/ 
	static void play(const char* roomId, const char* id, const char* coinType, long long loseOrGain, long long tax, long long left);
	
	/************************************************* 
	* Description: 房间中赢一局游戏
	* roomId     : 房间ID
    * id         : 其它属性
    * coinType   : 虚拟币类型
    * gain       : 获得虚拟币数量
	* left       : 玩家剩余虚拟币数量
	*************************************************/ 
	static void gain(const char* roomId, const char* id, const char* coinType, long long gain, long long left);
	
	/************************************************* 
	* Description: 房间中输掉一局游戏
	* roomId     : 房间ID
    * id         : 其它属性
    * coinType   : 虚拟币类型
    * lost       : 输掉的虚拟币数量
	* left       : 玩家剩余虚拟币数量
	*************************************************/ 
	static void lost(const char* roomId, const char* id, const char* coinType, long long lost, long long left);
};
#endif
/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:关卡接口 
**************************************************/

#ifndef __DATAEYE_DCLEVELS_H__
#define __DATAEYE_DCLEVELS_H__

class DCLuaLevels
{
public:
	/************************************************* 
	* Description: 开始关卡
	* levelNumber: 关卡顺序号
    * levelId    : 关卡ID
	*************************************************/
	static void begin(int levelNumber, const char* levelId);
	
	/************************************************* 
	* Description: 成功完成关卡
    * levelId    : 关卡ID
	*************************************************/
	static void complete(const char* levelId);
	
	/************************************************* 
	* Description: 关卡失败，玩家关卡中退出游戏时，建议调用该接口
    * levelId    : 关卡ID
	* failPoint  : 失败原因
	*************************************************/
	static void fail(const char* levelId, const char* failPoint);
private:
    static const char* path;
};

#endif

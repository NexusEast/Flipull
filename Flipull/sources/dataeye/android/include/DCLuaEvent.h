/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:自定义事件接口 
**************************************************/

#ifndef __DATAEYE_DCEVENT_H__
#define __DATAEYE_DCEVENT_H__
#include <jni.h>
#include <map>
#include <string>

using namespace std;

class DCLuaEvent
{
public:
	/************************************************* 
	* Description: 登陆前自定义事件，用户登陆之后该接口无效
	* eventId    : 事件ID
    * map        : 事件发生时关注的属性map
	* duration   : 事件发生时长
	*************************************************/
	static void onEventBeforeLogin(const char* eventId, map<string, string>* map, long long duration);
	
	/************************************************* 
	* Description: 事件计数
	* eventId    : 事件ID
    * count      : 事件发生次数
	*************************************************/
	static void onEventCount(const char* eventId, int count);
	
	/************************************************* 
	* Description: 事件发生
	* eventId    : 事件ID
	*************************************************/
	static void onEvent(const char* eventId);
	
	/************************************************* 
	* Description: 事件发生
	* eventId    : 事件ID
    * label      : 事件发生时关注的一个属性
	*************************************************/
	static void onEvent(const char* eventId, const char* label);
	
	/************************************************* 
	* Description: 事件发生
	* eventId    : 事件ID
    * label      : 事件发生时关注的多个属性map
	*************************************************/
	static void onEvent(const char* eventId, map<string, string>* map);
	
	/************************************************* 
	* Description: 时长事件发生
	* eventId    : 事件ID
    * duration   : 事件发生时长
	*************************************************/
	static void onEventDuration(const char* eventId, long long duration);
	
	/************************************************* 
	* Description: 时长事件发生
	* eventId    : 事件ID
	* label      : 事件发生时关注的单个属性
    * duration   : 事件发生时长
	*************************************************/
	static void onEventDuration(const char* eventId, const char* label, long long duration);
	
	/************************************************* 
	* Description: 时长事件发生
	* eventId    : 事件ID
	* map        : 事件发生时关注的多个属性
    * duration   : 事件发生时长
	*************************************************/
	static void onEventDuration(const char* eventId, map<string, string>* map, long long duration);
	
	/************************************************* 
	* Description: 过程性事件开始，与onEventEnd(eventId)配合使用
	* eventId    : 事件ID
	*************************************************/
	static void onEventBegin(const char* eventId);
	
	/************************************************* 
	* Description: 过程性事件开始，与onEventEnd(eventId)配合使用
	* eventId    : 事件ID
	* map        : 事件发生时关注的多个属性
	*************************************************/
	static void onEventBegin(const char* eventId, map<string, string>* map);
	
	/************************************************* 
	* Description: 过程性事件开始，与onEventEnd(eventId, flag)配合使用
	* eventId    : 事件ID
	* map        : 事件发生时关注的多个属性
	* flag       : eventId的一个标识，与eventId共同决定一个事件，比如玩家升级事件，
	               eventId可以为玩家升级，flag则为玩家具体的等级
	*************************************************/
	static void onEventBegin(const char* eventId, map<string, string>* map, const char* flag);
	
	/************************************************* 
	* Description: 过程性事件结束，与onEventBegin(eventId)或onEventBegin(eventId, map)配合使用
	* eventId    : 事件ID
	*************************************************/
	static void onEventEnd(const char* eventId);
	
	/************************************************* 
	* Description: 过程性事件结束，与onEventBegin(eventId, map, flag)配合使用
	* eventId    : 事件ID
	* flag       : eventId的一个标识，与eventId共同决定一个事件，比如玩家升级事件，
	               eventId可以为玩家升级，flag则为玩家具体的等级
	*************************************************/
	static void onEventEnd(const char* eventId, const char* flag);
};
#endif

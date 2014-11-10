/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:任务接口 
**************************************************/

#ifndef __DATAEYE_DCTASK_H__
#define __DATAEYE_DCTASK_H__
#include "DCTaskType.h"

class DCLuaTask
{
public:
	/************************************************* 
	* Description: 开始任务
	* taskId     : 任务ID
    * taskType   : 任务类型
	*************************************************/
	static void begin(const char* taskId, DCTaskType taskType);
	
	/************************************************* 
	* Description: 任务完成
	* taskId     : 任务ID
	*************************************************/
	static void complete(const char* taskId);
	
	/************************************************* 
	* Description: 任务失败
	* taskId     : 任务ID
    * reason     : 任务失败原因
	*************************************************/
	static void fail(const char* taskId, const char* reason);
};

#endif

/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:����ӿ� 
**************************************************/

#ifndef __DATAEYE_DCTASK_H__
#define __DATAEYE_DCTASK_H__
#include "DCTaskType.h"

class DCLuaTask
{
public:
	/************************************************* 
	* Description: ��ʼ����
	* taskId     : ����ID
    * taskType   : ��������
	*************************************************/
	static void begin(const char* taskId, DCTaskType taskType);
	
	/************************************************* 
	* Description: �������
	* taskId     : ����ID
	*************************************************/
	static void complete(const char* taskId);
	
	/************************************************* 
	* Description: ����ʧ��
	* taskId     : ����ID
    * reason     : ����ʧ��ԭ��
	*************************************************/
	static void fail(const char* taskId, const char* reason);
};

#endif

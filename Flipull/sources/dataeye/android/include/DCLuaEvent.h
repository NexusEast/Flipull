/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:�Զ����¼��ӿ� 
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
	* Description: ��½ǰ�Զ����¼����û���½֮��ýӿ���Ч
	* eventId    : �¼�ID
    * map        : �¼�����ʱ��ע������map
	* duration   : �¼�����ʱ��
	*************************************************/
	static void onEventBeforeLogin(const char* eventId, map<string, string>* map, long long duration);
	
	/************************************************* 
	* Description: �¼�����
	* eventId    : �¼�ID
    * count      : �¼���������
	*************************************************/
	static void onEventCount(const char* eventId, int count);
	
	/************************************************* 
	* Description: �¼�����
	* eventId    : �¼�ID
	*************************************************/
	static void onEvent(const char* eventId);
	
	/************************************************* 
	* Description: �¼�����
	* eventId    : �¼�ID
    * label      : �¼�����ʱ��ע��һ������
	*************************************************/
	static void onEvent(const char* eventId, const char* label);
	
	/************************************************* 
	* Description: �¼�����
	* eventId    : �¼�ID
    * label      : �¼�����ʱ��ע�Ķ������map
	*************************************************/
	static void onEvent(const char* eventId, map<string, string>* map);
	
	/************************************************* 
	* Description: ʱ���¼�����
	* eventId    : �¼�ID
    * duration   : �¼�����ʱ��
	*************************************************/
	static void onEventDuration(const char* eventId, long long duration);
	
	/************************************************* 
	* Description: ʱ���¼�����
	* eventId    : �¼�ID
	* label      : �¼�����ʱ��ע�ĵ�������
    * duration   : �¼�����ʱ��
	*************************************************/
	static void onEventDuration(const char* eventId, const char* label, long long duration);
	
	/************************************************* 
	* Description: ʱ���¼�����
	* eventId    : �¼�ID
	* map        : �¼�����ʱ��ע�Ķ������
    * duration   : �¼�����ʱ��
	*************************************************/
	static void onEventDuration(const char* eventId, map<string, string>* map, long long duration);
	
	/************************************************* 
	* Description: �������¼���ʼ����onEventEnd(eventId)���ʹ��
	* eventId    : �¼�ID
	*************************************************/
	static void onEventBegin(const char* eventId);
	
	/************************************************* 
	* Description: �������¼���ʼ����onEventEnd(eventId)���ʹ��
	* eventId    : �¼�ID
	* map        : �¼�����ʱ��ע�Ķ������
	*************************************************/
	static void onEventBegin(const char* eventId, map<string, string>* map);
	
	/************************************************* 
	* Description: �������¼���ʼ����onEventEnd(eventId, flag)���ʹ��
	* eventId    : �¼�ID
	* map        : �¼�����ʱ��ע�Ķ������
	* flag       : eventId��һ����ʶ����eventId��ͬ����һ���¼���������������¼���
	               eventId����Ϊ���������flag��Ϊ��Ҿ���ĵȼ�
	*************************************************/
	static void onEventBegin(const char* eventId, map<string, string>* map, const char* flag);
	
	/************************************************* 
	* Description: �������¼���������onEventBegin(eventId)��onEventBegin(eventId, map)���ʹ��
	* eventId    : �¼�ID
	*************************************************/
	static void onEventEnd(const char* eventId);
	
	/************************************************* 
	* Description: �������¼���������onEventBegin(eventId, map, flag)���ʹ��
	* eventId    : �¼�ID
	* flag       : eventId��һ����ʶ����eventId��ͬ����һ���¼���������������¼���
	               eventId����Ϊ���������flag��Ϊ��Ҿ���ĵȼ�
	*************************************************/
	static void onEventEnd(const char* eventId, const char* flag);
};
#endif

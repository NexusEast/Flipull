/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:SDK��ʼ���ӿڣ�androidƽ̨������C++��ֻ����
�ṩһ���ӿڣ������ӿ���Ҫ��������java�����    
**************************************************/  

#ifndef __DATAEYE_DCAGENT_H__
#define __DATAEYE_DCAGENT_H__

class DCLuaAgent
{
public: 
	/************************************************* 
	* Description: �Զ������ӿ�
	* title      : ������
    * error      : �������ݣ����鴫������ջ��Ϣ	
	*************************************************/ 
	static void reportError(const char* title, const char* error);
};

#endif
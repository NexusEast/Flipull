/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:�����ؽӿ� 
**************************************************/  


#ifndef __DATAEYE_DCACCOUNT_H__
#define __DATAEYE_DCACCOUNT_H__
#include "DCAccountType.h"
#include "DCGender.h"

class DCLuaAccount {
public:
	/************************************************* 
	* Description: ��ҵ�½����DC_AFTER_LOGINģʽ��ʹ��
	* accountId  : ����˺�ID���ò����뱣֤ȫ��Ψһ   
	*************************************************/ 
	static void login(const char* accountId);
	
	/************************************************* 
	* Description: ��ҵǳ�����DC_AFTER_LOGINģʽ��ʹ��
	*************************************************/ 
	static void logout();
	
	/************************************************* 
	* Description: ��������˺�����
	* accountType: ����˺����ͣ�ֵΪDCAccountType�е�ö��   
	*************************************************/ 
	static void setAccountType(DCAccountType accountType);
	
	/************************************************* 
	* Description: ������ҵȼ�
	* level      : ����˺ŵȼ�   
	*************************************************/ 
	static void setLevel(int level);
	
	/************************************************* 
	* Description: ��������Ա�
	* gender     : ����Ա�   
	*************************************************/ 
	static void setGender(DCGender gender);
	
	/************************************************* 
	* Description: �����������
	* age        : �������   
	*************************************************/ 
	static void setAge(int age);
	
	/************************************************* 
	* Description: ���������������
	* gameServer : ����˺���������   
	*************************************************/ 
	static void setGameServer(const char* gameServer);
	
	/************************************************* 
	* Description: ����Ҵ��ǩ���û�SDK�ĺ������͹���
	* tag        : ��ұ�ǩ   
	*************************************************/ 
	static void tag(const char* tag);
	
	/************************************************* 
	* Description: ȡ����ұ�ǩ���û�SDK�ĺ������͹���
	* tag        : ��ұ�ǩ   
	*************************************************/ 
	static void unTag(const char* tag);
};
#endif
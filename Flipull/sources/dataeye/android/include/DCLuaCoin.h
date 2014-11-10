/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:�������ؽӿ� 
**************************************************/  

#ifndef __DATAEYE_DCCOIN_H__
#define __DATAEYE_DCCOIN_H__

class DCLuaCoin
{
public: 
	/************************************************* 
	* Description: �������������
	* coinNum    : ���������
    * coinType   : ���������
	*************************************************/ 
	static void setCoinNum(long long coinNum, const char* coinType);
	
	/************************************************* 
	* Description: ���������
	* id         : ���������ʱ��ע�����ԣ�������ԭ��
    * coinType   : ���������
	* lost       : ��������ҵ�����
	* left       : ���ʣ����������
	*************************************************/ 
	static void lost(const char* id, const char* coinType, long long lost, long long left);
	
	/************************************************* 
	* Description: ���������
	* id         : ���������ʱ��ע�����ԣ�������ԭ��
    * coinType   : ���������
	* gain       : ��������ҵ�����
	* left       : ���ʣ����������
	*************************************************/
	static void gain(const char* id, const char* coinType, long long gain, long long left);
};

#endif
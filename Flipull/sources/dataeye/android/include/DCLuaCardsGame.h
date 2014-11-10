/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:����ר��ӿ� 
**************************************************/  

#ifndef __DATAEYE_DCCARDSGAME_H__
#define __DATAEYE_DCCARDSGAME_H__

class DCLuaCardsGame
{
public:
	/************************************************* 
	* Description: ���������һ����Ϸ
	* roomId     : ����ID
    * id         : ��������
    * coinType   : ���������
    * lostOrGain : ��û�������������������ֵΪ��ʱ����ʾ�þ���Ϸ���Ϊ��
    * tax        : ���һ��ϵͳ��ȡ��̨��
    * left       : ���ʣ�����������	
	*************************************************/ 
	static void play(const char* roomId, const char* id, const char* coinType, long long loseOrGain, long long tax, long long left);
	
	/************************************************* 
	* Description: ������Ӯһ����Ϸ
	* roomId     : ����ID
    * id         : ��������
    * coinType   : ���������
    * gain       : ������������
	* left       : ���ʣ�����������
	*************************************************/ 
	static void gain(const char* roomId, const char* id, const char* coinType, long long gain, long long left);
	
	/************************************************* 
	* Description: ���������һ����Ϸ
	* roomId     : ����ID
    * id         : ��������
    * coinType   : ���������
    * lost       : ��������������
	* left       : ���ʣ�����������
	*************************************************/ 
	static void lost(const char* roomId, const char* id, const char* coinType, long long lost, long long left);
};
#endif
/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:���߽ӿ� 
**************************************************/

#ifndef __DATAEYE_DCITEM_H__
#define __DATAEYE_DCITEM_H__

class DCLuaItem
{
public:
    /************************************************* 
	* Description: �������
	* itemId    : ����ID
    * itemType  : ��������
	* itemCount : ����ĵ�������
	* virtualCurrency:����ĵ��ߵ������ֵ
	* currencyType:֧����ʽ
	* consumePoint:���ѵ㣬��ؿ������ѣ�����Ϊ��
	*************************************************/
	static void buy(const char* itemId, const char* itemType, int itemCount, long long virtualCurrency, const char* currencyType, const char* consumePoint);
	
	/************************************************* 
	* Description: ��õ���
	* itemId    : ����ID
    * itemType  : ��������
	* itemCount : ��������
	* reason    : ��õ��ߵ�ԭ��
	*************************************************/
	static void get(const char* itemId, const char* itemType, int itemCount, const char* reason);
	
	/************************************************* 
	* Description: ���ĵ���
	* itemId    : ����ID
    * itemType  : ��������
	* itemCount : ��������
	* reason    : ���ĵ��ߵ�ԭ��
	*************************************************/
	static void consume(const char* itemId, const char* itemType, int itemCount, const char* reason);
};

#endif


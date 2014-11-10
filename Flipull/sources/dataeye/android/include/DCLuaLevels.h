/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:�ؿ��ӿ� 
**************************************************/

#ifndef __DATAEYE_DCLEVELS_H__
#define __DATAEYE_DCLEVELS_H__

class DCLuaLevels
{
public:
	/************************************************* 
	* Description: ��ʼ�ؿ�
	* levelNumber: �ؿ�˳���
    * levelId    : �ؿ�ID
	*************************************************/
	static void begin(int levelNumber, const char* levelId);
	
	/************************************************* 
	* Description: �ɹ���ɹؿ�
    * levelId    : �ؿ�ID
	*************************************************/
	static void complete(const char* levelId);
	
	/************************************************* 
	* Description: �ؿ�ʧ�ܣ���ҹؿ����˳���Ϸʱ��������øýӿ�
    * levelId    : �ؿ�ID
	* failPoint  : ʧ��ԭ��
	*************************************************/
	static void fail(const char* levelId, const char* failPoint);
private:
    static const char* path;
};

#endif

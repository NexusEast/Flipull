/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:���߲������ýӿ� 
**************************************************/

#ifndef __DATAEYE_DCCONFIGPARAMS_H__
#define __DATAEYE_DCCONFIGPARAMS_H__
#include <jni.h>
#include <cocos2d.h>

#ifdef __cplusplus
extern "C"
{
#endif

//���ø��³ɹ���,java��ص�C++��Ľӿڣ��ڲ�ʹ��
JNIEXPORT void JNICALL Java_com_dataeye_data_DCConfigParams_updateSuccess(JNIEnv *, jobject obj);

#ifdef __cplusplus
}
#endif

//���ø��³ɹ���SDK����Ϸ���͵ĸ��³ɹ���Ϣ����������Ҫ�ڼ�������Ϣ
#define DCCONFIGPARAMS_UPDATE_SUCCESS "DCConfigParamsUpdateSuccess"

class DCLuaConfigParams
{
public:
	/************************************************* 
	* Description: ���߲������½ӿ�
	*************************************************/
    static void update();
	
	/************************************************* 
	* Description: ��ȡString�Ͳ���
	* key        : ��Ҫ��ȡ�Ĳ�����keyֵ
    * defaultValue: ��Ҫ��ȡ�Ĳ�����Ĭ��ֵ
	*************************************************/
    static const char* getParameterString(const char* key, const char* defaultValue);
	
	/************************************************* 
	* Description: ��ȡint�Ͳ���
	* key        : ��Ҫ��ȡ�Ĳ�����keyֵ
    * defaultValue: ��Ҫ��ȡ�Ĳ�����Ĭ��ֵ
	*************************************************/
    static int getParameterInt(const char* key, int defaultValue);
	
	/************************************************* 
	* Description: ��ȡlong long�Ͳ���
	* key        : ��Ҫ��ȡ�Ĳ�����keyֵ
    * defaultValue: ��Ҫ��ȡ�Ĳ�����Ĭ��ֵ
	*************************************************/
	static long long getParameterLong(const char* key, long long defaultValue);
	
	/************************************************* 
	* Description: ��ȡbool�Ͳ���
	* key        : ��Ҫ��ȡ�Ĳ�����keyֵ
    * defaultValue: ��Ҫ��ȡ�Ĳ�����Ĭ��ֵ
	*************************************************/
    static bool getParameterBool(const char* key, bool defaultValue);
};

#endif
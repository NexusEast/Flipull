/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:在线参数配置接口 
**************************************************/

#ifndef __DATAEYE_DCCONFIGPARAMS_H__
#define __DATAEYE_DCCONFIGPARAMS_H__
#include <jni.h>
#include <cocos2d.h>

#ifdef __cplusplus
extern "C"
{
#endif

//配置更新成功后,java侧回调C++侧的接口，内部使用
JNIEXPORT void JNICALL Java_com_dataeye_data_DCConfigParams_updateSuccess(JNIEnv *, jobject obj);

#ifdef __cplusplus
}
#endif

//配置更新成功后，SDK向游戏发送的更新成功消息，开发者需要在监听该消息
#define DCCONFIGPARAMS_UPDATE_SUCCESS "DCConfigParamsUpdateSuccess"

class DCLuaConfigParams
{
public:
	/************************************************* 
	* Description: 在线参数更新接口
	*************************************************/
    static void update();
	
	/************************************************* 
	* Description: 获取String型参数
	* key        : 需要获取的参数的key值
    * defaultValue: 需要获取的参数的默认值
	*************************************************/
    static const char* getParameterString(const char* key, const char* defaultValue);
	
	/************************************************* 
	* Description: 获取int型参数
	* key        : 需要获取的参数的key值
    * defaultValue: 需要获取的参数的默认值
	*************************************************/
    static int getParameterInt(const char* key, int defaultValue);
	
	/************************************************* 
	* Description: 获取long long型参数
	* key        : 需要获取的参数的key值
    * defaultValue: 需要获取的参数的默认值
	*************************************************/
	static long long getParameterLong(const char* key, long long defaultValue);
	
	/************************************************* 
	* Description: 获取bool型参数
	* key        : 需要获取的参数的key值
    * defaultValue: 需要获取的参数的默认值
	*************************************************/
    static bool getParameterBool(const char* key, bool defaultValue);
};

#endif
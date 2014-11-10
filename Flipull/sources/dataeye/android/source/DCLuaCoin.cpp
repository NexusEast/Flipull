#include "DCLuaCoin.h"
#include "DCJniHelper.h"

extern jclass jDCCoin;

void DCLuaCoin::setCoinNum(long long coinNum, const char* coinType)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCCoin, "setCoinNum", "(JLjava/lang/String;)V"))
	{
		jlong jCoinNum = coinNum;
        jstring jCoinType = methodInfo.env->NewStringUTF(coinType);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jCoinNum, jCoinType);
        methodInfo.env->DeleteLocalRef(jCoinType);
	}
}

void DCLuaCoin::lost(const char* id, const char* coinType, long long lost, long long left)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCCoin, "lost", "(Ljava/lang/String;Ljava/lang/String;JJ)V"))
	{
		jlong jLost = lost;
		jlong jLeft = left;
		jstring jId = methodInfo.env->NewStringUTF(id);
        jstring jCoinType = methodInfo.env->NewStringUTF(coinType);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jId, jCoinType, jLost, jLeft);
		methodInfo.env->DeleteLocalRef(jId);
        methodInfo.env->DeleteLocalRef(jCoinType);
	}
}

void DCLuaCoin::gain(const char* id, const char* coinType, long long gain, long long left)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCCoin, "gain", "(Ljava/lang/String;Ljava/lang/String;JJ)V"))
	{
		jlong jGain = gain;
		jlong jLeft = left;
		jstring jId = methodInfo.env->NewStringUTF(id);
        jstring jCoinType = methodInfo.env->NewStringUTF(coinType);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jId, jCoinType, jGain, jLeft);
		methodInfo.env->DeleteLocalRef(jId);
        methodInfo.env->DeleteLocalRef(jCoinType);
	}
}

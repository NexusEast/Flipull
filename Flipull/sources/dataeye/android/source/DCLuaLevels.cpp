#include "DCLuaLevels.h"
#include "DCJniHelper.h"

extern jclass jDCLevels;

void DCLuaLevels::begin(int levelNumber, const char* levelId)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCLevels, "begin", "(ILjava/lang/String;)V"))
	{
		jstring jLevelId = methodInfo.env->NewStringUTF(levelId);
		jint jLevelNumber = levelNumber;
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jLevelNumber, jLevelId);
		methodInfo.env->DeleteLocalRef(jLevelId);
	}
}

void DCLuaLevels::complete(const char* levelId)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCLevels, "complete", "(Ljava/lang/String;)V"))
	{
		jstring jLevelId = methodInfo.env->NewStringUTF(levelId);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jLevelId);
		methodInfo.env->DeleteLocalRef(jLevelId);
	}
}

void DCLuaLevels::fail(const char* levelId, const char* failPoint)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCLevels, "fail", "(Ljava/lang/String;Ljava/lang/String;)V"))
	{
		jstring jLevelId = methodInfo.env->NewStringUTF(levelId);
		jstring jFailPoint = methodInfo.env->NewStringUTF(failPoint);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jLevelId, jFailPoint);
		methodInfo.env->DeleteLocalRef(jLevelId);
		methodInfo.env->DeleteLocalRef(jFailPoint);
	}
}

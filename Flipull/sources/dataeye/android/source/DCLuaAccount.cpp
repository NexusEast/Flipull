#include "DCLuaAccount.h"
#include <jni.h>
#include <DCJniHelper.h>
#include <android/log.h>

extern jclass jDCAccount;

void DCLuaAccount::login(const char* accountId)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCAccount, "login", "(Ljava/lang/String;)V"))
	{
		jstring jaccountId = methodInfo.env->NewStringUTF(accountId);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jaccountId);
		methodInfo.env->DeleteLocalRef(jaccountId);
	}
}

void DCLuaAccount::logout()
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCAccount, "logout", "()V"))
	{
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID);
	}
}

void DCLuaAccount::setAccountType(DCAccountType accountType)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCAccount, "setAccountType", "(I)V"))
	{
		jint jType = accountType;
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jType);
	}
}

void DCLuaAccount::setLevel(int level)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCAccount, "setLevel", "(I)V"))
	{
		jint jLevel = level;
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jLevel);
	}
}

void DCLuaAccount::setGender(DCGender gender)
{
	DCJniMethodInfo methodInfo;
	DCJniMethodInfo mi;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCAccount, "setGender", "(I)V"))
	{
		jint jGender = gender;
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jGender);
	}
}

void DCLuaAccount::setAge(int age)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCAccount, "setAge", "(I)V"))
	{
		jint jAge = age;
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jAge);
	}
}

void DCLuaAccount::setGameServer(const char* gameServer)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCAccount, "setGameServer", "(Ljava/lang/String;)V"))
	{
		jstring jgameServer = methodInfo.env->NewStringUTF(gameServer);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jgameServer);
		methodInfo.env->DeleteLocalRef(jgameServer);
	}
}

void DCLuaAccount::tag(const char* tag)
{
    DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCAccount, "tag", "(Ljava/lang/String;)V"))
	{
		jstring jtag = methodInfo.env->NewStringUTF(tag);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jtag);
		methodInfo.env->DeleteLocalRef(jtag);
	}
}

void DCLuaAccount::unTag(const char* tag)
{
    DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCAccount, "unTag", "(Ljava/lang/String;)V"))
	{
		jstring jtag = methodInfo.env->NewStringUTF(tag);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jtag);
		methodInfo.env->DeleteLocalRef(jtag);
	}
}


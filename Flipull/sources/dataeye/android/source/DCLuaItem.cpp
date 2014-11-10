#include "DCLuaItem.h"
#include "DCJniHelper.h"

extern jclass jDCItem;

void DCLuaItem::buy(const char* itemId, const char* itemType, int itemCount, long long virtualCurrency, const char* currencyType, const char* consumePoint)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCItem, "buy", "(Ljava/lang/String;Ljava/lang/String;IJLjava/lang/String;Ljava/lang/String;)V"))
	{
		jstring jItemId = methodInfo.env->NewStringUTF(itemId);
		jstring jItemType = methodInfo.env->NewStringUTF(itemType);
		jstring jCurrencyType = methodInfo.env->NewStringUTF(currencyType);
		jstring jConsumePoint = methodInfo.env->NewStringUTF(consumePoint);
		jint jItemCount = itemCount;
		jlong jVirtualCurrency = virtualCurrency;
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jItemId, jItemType, jItemCount, jVirtualCurrency, jCurrencyType, jConsumePoint);
		methodInfo.env->DeleteLocalRef(jItemId);
		methodInfo.env->DeleteLocalRef(jItemType);
		methodInfo.env->DeleteLocalRef(jCurrencyType);
		methodInfo.env->DeleteLocalRef(jConsumePoint);
	}
}

void DCLuaItem::get(const char* itemId, const char* itemType, int itemCount, const char* reason)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCItem, "get", "(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)V"));
	{
		jstring jItemId = methodInfo.env->NewStringUTF(itemId);
		jstring jItemType = methodInfo.env->NewStringUTF(itemType);
		jstring jReason = methodInfo.env->NewStringUTF(reason);
		jint jItemCount = itemCount;
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jItemId, jItemType, jItemCount, jReason);
		methodInfo.env->DeleteLocalRef(jItemId);
		methodInfo.env->DeleteLocalRef(jItemType);
		methodInfo.env->DeleteLocalRef(jReason);
	}
}

void DCLuaItem::consume(const char* itemId, const char* itemType, int itemCount, const char* reason)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCItem, "consume", "(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)V"));
	{
		jstring jItemId = methodInfo.env->NewStringUTF(itemId);
		jstring jItemType = methodInfo.env->NewStringUTF(itemType);
		jstring jReason = methodInfo.env->NewStringUTF(reason);
		jint jItemCount = itemCount;
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jItemId, jItemType, jItemCount, jReason);
		methodInfo.env->DeleteLocalRef(jItemId);
		methodInfo.env->DeleteLocalRef(jItemType);
		methodInfo.env->DeleteLocalRef(jReason);
	}
}

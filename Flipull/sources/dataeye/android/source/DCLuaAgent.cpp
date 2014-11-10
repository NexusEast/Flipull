#include "DCLuaAgent.h"
#include "DCJniHelper.h"

extern jclass jDCEvent;

void DCLuaAgent::reportError(const char* title, const char* error)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCEvent, "reportError", "(Ljava/lang/String;Ljava/lang/String;)V"))
	{
		jstring jTitle = methodInfo.env->NewStringUTF(title);
        jstring jError = methodInfo.env->NewStringUTF(error);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jTitle, jError);
        methodInfo.env->DeleteLocalRef(jTitle);
		methodInfo.env->DeleteLocalRef(jError);
	}
}


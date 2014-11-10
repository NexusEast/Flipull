#include "DCLuaTask.h"
#include "DCJniHelper.h"

extern jclass jDCTask;

void DCLuaTask::begin(const char* taskId, DCTaskType taskType)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCTask, "begin", "(Ljava/lang/String;I)V"))
	{
		jstring jTaskId = methodInfo.env->NewStringUTF(taskId);
		jint jTaskType = taskType;
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jTaskId, jTaskType);
		methodInfo.env->DeleteLocalRef(jTaskId);
	}
}

void DCLuaTask::complete(const char* taskId)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCTask, "complete", "(Ljava/lang/String;)V"))
	{
		jstring jTaskId = methodInfo.env->NewStringUTF(taskId);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jTaskId);
		methodInfo.env->DeleteLocalRef(jTaskId);
	}
}

void DCLuaTask::fail(const char* taskId, const char* reason)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCTask, "fail", "(Ljava/lang/String;Ljava/lang/String;)V"))
	{
		jstring jTaskId = methodInfo.env->NewStringUTF(taskId);
		jstring jReason = methodInfo.env->NewStringUTF(reason);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jTaskId, jReason);
		methodInfo.env->DeleteLocalRef(jTaskId);
		methodInfo.env->DeleteLocalRef(jReason);
	}
}

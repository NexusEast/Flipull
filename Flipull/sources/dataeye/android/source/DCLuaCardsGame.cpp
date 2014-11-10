#include "DCLuaCardsGame.h"
#include "DCJniHelper.h"

extern jclass jDCCardGame;

void DCLuaCardsGame::play(const char* roomId, const char* id, const char* coinType, long long loseOrGain, long long tax, long long left)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCCardGame, "play", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JJJ)V"))
	{
		jstring jRoomId = methodInfo.env->NewStringUTF(roomId);
		jstring jId = methodInfo.env->NewStringUTF(id);
		jstring jCoinType = methodInfo.env->NewStringUTF(coinType);
		jlong jLoseOrGain = loseOrGain;
		jlong jTax = tax;
		jlong jLeft = left;
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jRoomId, jId, jCoinType, jLoseOrGain, jTax, jLeft);
		methodInfo.env->DeleteLocalRef(jRoomId);
		methodInfo.env->DeleteLocalRef(jId);
		methodInfo.env->DeleteLocalRef(jCoinType);
	}
}

void DCLuaCardsGame::lost(const char* roomId, const char* id, const char* coinType, long long lost, long long left)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCCardGame, "lost", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JJ)V"))
	{
		jstring jRoomId = methodInfo.env->NewStringUTF(roomId);
		jstring jId = methodInfo.env->NewStringUTF(id);
		jstring jCoinType = methodInfo.env->NewStringUTF(coinType);
		jlong jLost = lost;
		jlong jLeft = left;
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jRoomId, jId, jCoinType, jLost, jLeft);
		methodInfo.env->DeleteLocalRef(jRoomId);
		methodInfo.env->DeleteLocalRef(jId);
		methodInfo.env->DeleteLocalRef(jCoinType);
	}
}

void DCLuaCardsGame::gain(const char* roomId, const char* id, const char* coinType, long long gain, long long left)
{
	DCJniMethodInfo methodInfo;
	if(DCJniHelper::getStaticMethodInfo(methodInfo, jDCCardGame, "gain", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JJ)V"))
	{
		jstring jRoomId = methodInfo.env->NewStringUTF(roomId);
		jstring jId = methodInfo.env->NewStringUTF(id);
		jstring jCoinType = methodInfo.env->NewStringUTF(coinType);
		jlong jGain = gain;
		jlong jLeft = left;
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, jRoomId, jId, jCoinType, jGain, jLeft);
		methodInfo.env->DeleteLocalRef(jRoomId);
		methodInfo.env->DeleteLocalRef(jId);
		methodInfo.env->DeleteLocalRef(jCoinType);
	}
}
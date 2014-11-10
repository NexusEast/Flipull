#include "DCJniHelper.h"
#include <android/log.h>

#if 1
#define  LOG_TAG    "DCJniHelper"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)
#else
#define  LOGD(...) 
#endif

#define JAVAVM    DCJniHelper::getJVM()

#define DCACCOUNT_CLASS            "com/dataeye/DCAccount"
#define DCVIRTUALCURRENCY_CLASS    "com/dataeye/DCVirtualCurrency"
#define DCCOIN_CLASS               "com/dataeye/DCCoin"
#define DCEVENT_CLASS              "com/dataeye/DCEvent"
#define DCCARDGAME_CLASS           "com/dataeye/plugin/DCCardsGame"
#define DCLEVELS_CLASS             "com/dataeye/plugin/DCLevels"
#define DCCONFIGPARAMS_CLASS       "com/dataeye/DCCocos2dConfigParams"
#define DCITEM_CLASS               "com/dataeye/DCItem"
#define DCTASK_CLASS               "com/dataeye/DCTask"

jclass jDCAccount;
jclass jDCVirtualCurrency;
jclass jDCCoin;
jclass jDCEvent;
jclass jDCCardGame;
jclass jDCConfigParams;
jclass jDCItem;
jclass jDCTask;
jclass jDCLevels;

extern "C"
{

    //////////////////////////////////////////////////////////////////////////
    // java vm helper function
    //////////////////////////////////////////////////////////////////////////

    static bool getEnv(JNIEnv **env)
    {
        bool bRet = false;

        do 
        {
            if (JAVAVM->GetEnv((void**)env, JNI_VERSION_1_4) != JNI_OK)
            {
                LOGD("Failed to get the environment using GetEnv()");
                if (JAVAVM->AttachCurrentThread(env, 0) < 0)
				{
					LOGD("Failed to get the environment using AttachCurrentThread()");
					break;
				}
            }

            bRet = true;
        } while (0);        

        return bRet;
    }

    static jclass getClassID_(const char *className, JNIEnv *env)
    {
        JNIEnv *pEnv = env;
        jclass ret = 0;

        do 
        {
            if (! pEnv)
            {
                if (! getEnv(&pEnv))
                {
                    break;
                }
            }
            
            ret = pEnv->FindClass(className);
            if (! ret)
            {
                LOGD("Failed to find class of %s", className);
                break;
            }
        } while (0);

        return ret;
    }

    static bool getStaticMethodInfo_(DCJniMethodInfo &methodinfo, jclass classID, const char *methodName, const char *paramCode)
    {
        jmethodID methodID = 0;
        JNIEnv *pEnv = 0;
        bool bRet = false;

        do 
        {
            if (! getEnv(&pEnv))
            {
                break;
            }

            methodID = pEnv->GetStaticMethodID(classID, methodName, paramCode);
            if (! methodID)
            {
                LOGD("Failed to find static method id of %s", methodName);
                break;
            }

            methodinfo.classID = classID;
            methodinfo.env = pEnv;
            methodinfo.methodID = methodID;

            bRet = true;
        } while (0);

        return bRet;
    }

    static bool getMethodInfo_(DCJniMethodInfo &methodinfo, const char *className, const char *methodName, const char *paramCode)
    {
        jmethodID methodID = 0;
        JNIEnv *pEnv = 0;
        bool bRet = false;

        do 
        {
            if (! getEnv(&pEnv))
            {
                break;
            }

            jclass classID = getClassID_(className, pEnv);

            methodID = pEnv->GetMethodID(classID, methodName, paramCode);
            if (! methodID)
            {
                LOGD("Failed to find method id of %s", methodName);
                break;
            }

            methodinfo.classID = classID;
            methodinfo.env = pEnv;
            methodinfo.methodID = methodID;

            bRet = true;
        } while (0);

        return bRet;
    }
    
    static string jstring2string_(jstring jstr) {
        if (jstr == NULL) {
            return "";
        }
        
        JNIEnv *env = 0;
        
        if (! getEnv(&env)) {
            return 0;
        }
        
        const char* chars = env->GetStringUTFChars(jstr, NULL);
        string ret(chars);
        env->ReleaseStringUTFChars(jstr, chars);
        
        return ret;
    }
}

JavaVM* DCJniHelper::m_jvm = NULL;

void DCJniHelper::setJVM(JavaVM* jvm)
{
	JNIEnv* env;
	m_jvm = jvm;
	
	getEnv(&env);
	
	jclass c = env->FindClass(DCACCOUNT_CLASS);
	jDCAccount = (jclass)env->NewGlobalRef(c);
	
	c = env->FindClass(DCVIRTUALCURRENCY_CLASS);
	jDCVirtualCurrency = (jclass)env->NewGlobalRef(c);
	
	c = env->FindClass(DCCOIN_CLASS);
	jDCCoin = (jclass)env->NewGlobalRef(c);
	
	c = env->FindClass(DCEVENT_CLASS);
	jDCEvent = (jclass)env->NewGlobalRef(c);
	
	c = env->FindClass(DCCARDGAME_CLASS);
	jDCCardGame = (jclass)env->NewGlobalRef(c);
	
	c = env->FindClass(DCCONFIGPARAMS_CLASS);
	jDCConfigParams = (jclass)env->NewGlobalRef(c);

	c = env->FindClass(DCITEM_CLASS);
	jDCItem = (jclass)env->NewGlobalRef(c);

	c = env->FindClass(DCTASK_CLASS);
	jDCTask = (jclass)env->NewGlobalRef(c);
    
    c = env->FindClass(DCLEVELS_CLASS);
    jDCLevels = (jclass)env->NewGlobalRef(c);
}

void DCJniHelper::globalDeinit()
{
	JNIEnv* env;
	getEnv(&env);
	
	env->DeleteGlobalRef(jDCAccount);
	jDCAccount = NULL;
	
	env->DeleteGlobalRef(jDCVirtualCurrency);
	jDCVirtualCurrency = NULL;
	
	env->DeleteGlobalRef(jDCCoin);
	jDCCoin = NULL;
	
	env->DeleteGlobalRef(jDCEvent);
	jDCEvent = NULL;
	
	env->DeleteGlobalRef(jDCCardGame);
	jDCCardGame = NULL;
	
	env->DeleteGlobalRef(jDCConfigParams);
	jDCConfigParams = NULL;

	env->DeleteGlobalRef(jDCItem);
	jDCItem = NULL;

	env->DeleteGlobalRef(jDCTask);
	jDCTask = NULL;
    
    env->DeleteGlobalRef(jDCLevels);
    jDCLevels = NULL;
}

JavaVM* DCJniHelper::getJVM()
{
	return m_jvm;
}

bool DCJniHelper::getJNIEnv(JNIEnv **env) {
	return getEnv(env);
}

void DCJniHelper::detachEnv()
{
	if(m_jvm)
	{
		m_jvm->DetachCurrentThread();
	}
}

bool DCJniHelper::getStaticMethodInfo(DCJniMethodInfo& info, jclass classId, const char* methodName, const char* methodParam)
{
	return getStaticMethodInfo_(info, classId, methodName, methodParam);
}

bool DCJniHelper::getMethodInfo(DCJniMethodInfo &methodinfo, const char *className, const char *methodName, const char *paramCode)
{
    return getMethodInfo_(methodinfo, className, methodName, paramCode);
}

jobject DCJniHelper::cMapToJMap(std::map<string, string>* map)
{
	DCJniMethodInfo methodInfo;
	getMethodInfo_(methodInfo, "java/util/HashMap", "<init>", "()V");
	jobject obj = methodInfo.env->NewObject(methodInfo.classID, methodInfo.methodID);

	getMethodInfo_(methodInfo, "java/util/HashMap", "put", "(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;");
	std::map<string, string>::iterator it;
	for(it = map->begin(); it != map->end(); ++it)
	{
		jstring key = methodInfo.env->NewStringUTF(it->first.c_str());
		jstring value = methodInfo.env->NewStringUTF(it->second.c_str());
		methodInfo.env->CallObjectMethod(obj, methodInfo.methodID, key, value);
		methodInfo.env->DeleteLocalRef(key);
		methodInfo.env->DeleteLocalRef(value);
	}
	return obj;
}

string DCJniHelper::jstring2string(jstring str)
{
    return jstring2string_(str);
}

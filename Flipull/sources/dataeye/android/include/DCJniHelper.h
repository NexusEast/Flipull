#ifndef cocos2d_dcjnihelper_h
#define cocos2d_dcjnihelper_h

#include <jni.h>
#include <string>
#include <map>

using namespace std;

typedef struct _DCJniMethodInfo
{
	JNIEnv* env;
	jclass classID;
	jmethodID methodID;
}DCJniMethodInfo;

class DCJniHelper
{
private:
	static JavaVM* m_jvm;
public:
	static JavaVM* getJVM();
	static bool getJNIEnv(JNIEnv **env);
	static void setJVM(JavaVM* jvm);
	static void detachEnv();
	static void globalDeinit();
	static bool getStaticMethodInfo(DCJniMethodInfo& info, jclass classId, const char* methodName, const char* methodParam);	
	static bool getMethodInfo(DCJniMethodInfo &methodinfo, const char *className, const char *methodName, const char *paramCode);
	static jobject cMapToJMap(std::map<string, string>* map);
	static string jstring2string(jstring str);
};
#endif

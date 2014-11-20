
#include "cocos2d.h"
#include "AppDelegate.h"
#include "SimpleAudioEngine.h"
#include "support/CCNotificationCenter.h"
#include "CCLuaEngine.h"
#include <string> 
#include <sys/stat.h> 
#include<fstream>
using namespace std;
using namespace cocos2d;
using namespace CocosDenshion;

AppDelegate::AppDelegate()
{
    // fixed me
    //_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF|_CRTDBG_LEAK_CHECK_DF);
}

AppDelegate::~AppDelegate()
{
    // end simple audio engine here, or it may crashed on win32
    SimpleAudioEngine::sharedEngine()->end();
}
void Tranfile(string srcFile, string tgtFile )
{
	fstream fsCopee( srcFile, ios::binary | ios::in ) ;
	fstream fsCoper( tgtFile, ios::binary | ios::out ) ;
	fsCoper << fsCopee.rdbuf() ;
}

int MyCopyFile(string  SourceFile,string NewFile)
{
	if ( CCFileUtils::sharedFileUtils()->isFileExist(SourceFile ))
	{
		
		unsigned long len = 0;
		unsigned char * buff = CCFileUtils::sharedFileUtils()->getFileData(SourceFile.c_str(),"r",&len);
		FILE* in = fopen(NewFile.c_str(),"wb");
		fwrite(buff, len * sizeof(char), 1, in);
        fclose(in);
	}
	else
	{
		CCLog("File [%s] not exists!",SourceFile.c_str());
	}
}

bool CheckDir(const char* Dir)  
{  
 
        if(mkdir(Dir,0755)==0)  
        {  
            return true;//文件夹创建成功  
        }  
        else  
        {  
			return false;//can not make a dir;  
        }  
 
} 

bool AppDelegate::applicationDidFinishLaunching()
{
//#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
//	//Lua版本、JS版本请参考并在lua侧或js侧调用，同时请在该applicationFinishLaunching接口调用dataeye.h中的接口注入接口
//    //添加DataEye需要配置的appID和channelId
//    //APPID 是一组32位的代码，可以在g.dataeye.com创建游戏后获得.
//    //“937042C1192B1833CD8DF4895B281674”的部分要按照实际情况设置，一定要记得替换哦
//    //DC_AFTER_LOGIN模式适用于有账号体系的游戏，后面必须要调用DCAccount login，否则不会上报数据。
//    //DEFAULT模式适用于不存在账号体系的游戏（如单机），SDK会用设备ID作为用户的ID
//    //请选择合适于自己游戏的上报模式
//    DCAgent::setReportMode(DC_AFTER_LOGIN);
//    DCAgent::setDebugMode(true);
//    DCAgent::onStart("937042C1192B1833CD8DF4895B281674", "DataEye");
//#endif
    // initialize director
    CCDirector *pDirector = CCDirector::sharedDirector();
    pDirector->setOpenGLView(CCEGLView::sharedOpenGLView());
    pDirector->setProjection(kCCDirectorProjection2D);

	/////.........COPY 3 FILES FIRST. //////////////////
	string Srcfile = CCFileUtils::sharedFileUtils()->getSearchPaths()[0] + "res_phone/";//game.dat"; //game.dat
	string cachePath = CCFileUtils::sharedFileUtils()->getWritablePath() + "res_iphone/";
	string lockPath = cachePath + ".lock";
			fstream _file;
     _file.open(lockPath.c_str(),ios::in);
	 CCLog("Srcfile:%s",Srcfile.c_str());
	 CCLog("cachePath:%s",cachePath.c_str());
	 CCLog("lockPath:%s",lockPath.c_str());
	if (!_file)
	{

	if ( CheckDir(cachePath.c_str()) )
	{
		
		CCLog("create :%s success!",cachePath.c_str());
		MyCopyFile(Srcfile + "game.dat",cachePath + "game.dat");
		MyCopyFile(Srcfile + "framework_precompiled.zip",cachePath + "framework_precompiled.zip");
		ofstream fout;
		fout.open(cachePath+".lock",ios::app);
		fout<<" "<<endl;
	}
	else
	{
		CCLog("create :%s failed!",cachePath.c_str());
	}
	}
	else
	{
		CCLog(".lock exists!");
	}
		
    
    
    // set FPS. the default value is 1.0/60 if you don't call this
    pDirector->setAnimationInterval(1.0 / 60);
    
    // register lua engine
    CCLuaEngine *pEngine = CCLuaEngine::defaultEngine();
    CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);
    
    CCLuaStack *pStack = pEngine->getLuaStack();
    
    #if CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID 
        lua_State *tolua_s = pStack->getLuaState(); 
    #endif
    
#if defined(ENCRYPT_RESOURCE_ENABLED) && ENCRYPT_RESOURCE_ENABLED == 1
    std::string pathBase = "res_phone/";
#else
    std::string pathBase = "res/";
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    // load framework
    pathBase = "res_phone/";
    std::string pre_zip = "framework_precompiled.zip";
    pre_zip = pathBase+pre_zip;
    
    CCLog("cpp loadChunksFromZIP begin-- ");
    pStack->loadChunksFromZIP(pre_zip.c_str());
    CCLog("cpp loadChunksFromZIP end-- ");
    // set script path
    string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("scripts/main.lua");
#endif
    
    size_t pos;
    while ((pos = path.find_first_of("\\")) != std::string::npos)
    {
        path.replace(pos, 1, "/");
    }
    size_t p = path.find_last_of("/\\");
    if (p != path.npos)
    {
        const string dir = path.substr(0, p);
        pStack->addSearchPath(dir.c_str());
        
        p = dir.find_last_of("/\\");
        if (p != dir.npos)
        {
            pStack->addSearchPath(dir.substr(0, p).c_str());
        }
    }
    
    string env = "__LUA_STARTUP_FILE__=\"";
    env.append(path);
    env.append("\"");
    
    pStack->setXXTEAKeyAndSign("CFgrrwCFewrf", 12);
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
#if 0
    std::string rootDir = CCFileUtils::sharedFileUtils()->getWritablePath();
#else
    std::string rootDir =  CCFileUtils::sharedFileUtils()->getWritablePath();
#endif
    std::string dataPath =   cachePath + "game.dat";
    CCLog("LOAD MAIN.LUA dataPath=%s",dataPath.c_str());
    CCLog("LOAD MAIN.LUA begin--");
    bool runCompliedScript = true;                         ////////////////////////------------------USE COMPILED RESOURCE??
    if (runCompliedScript) {
        
        if(pStack->loadChunksFromZIP(dataPath.c_str()))
        {
            CCLog("LOAD MAIN.LUA end2--");
            pEngine->executeString("require \"main\"");
            CCLog("LOAD MAIN.LUA end3--");
        }
    }
    else
    {

    CCLog("LOAD MAIN.LUA end5--");
    
    pEngine->executeString("print(\"blah\")");
    pEngine->executeString("CCLuaLog(\"blah\")");
    std::string dataPath = rootDir+pathBase + "scripts/main.lua";
    CCLog("dataPath:%s",dataPath.c_str());
        if(pStack->executeScriptFile(dataPath.c_str()))
        {

    CCLog("LOAD MAIN.LUA end6--");
            pEngine->executeString("require \"main\"");
        }
    }
    CCLog("LOAD MAIN.LUA end7--");
    pEngine->executeString(env.c_str());
    CCLog("LOAD MAIN.LUA end4--");
    CCLog("LOAD MAIN.LUA end4--");
#else
    
	string dataPath = CCFileUtils::sharedFileUtils()->getWritablePath();
	dataPath += "res"DIRECTORY_SEPARATOR"game2.dat";
	if(pStack->loadChunksFromZip(dataPath.c_str()))
	{
		pEngine->executeString("require \"main\"");
	}
	else
	{
        CCLOG("------------------------------------------------");
        CCLOG("LOAD LUA FILE: %s", path.c_str());
        CCLOG("------------------------------------------------");
        pEngine->executeScriptFile(path.c_str());
	}
#endif
    return true;
}
// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    CCDirector::sharedDirector()->stopAnimation();
    CCDirector::sharedDirector()->pause();
//    SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
//    SimpleAudioEngine::sharedEngine()->pauseAllEffects();
    CCNotificationCenter::sharedNotificationCenter()->postNotification("APP_ENTER_BACKGROUND");
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    CCDirector::sharedDirector()->startAnimation();
    CCDirector::sharedDirector()->resume();
//    SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
//    SimpleAudioEngine::sharedEngine()->resumeAllEffects();
    CCNotificationCenter::sharedNotificationCenter()->postNotification("APP_ENTER_FOREGROUND");
}

void AppDelegate::setProjectConfig(const ProjectConfig& config)
{
    m_projectConfig = config;
}

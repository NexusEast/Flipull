#include "cocos2d.h"
extern "C" {
#include "lua.h"
#include "xxtea.h"
}
#include "CCLuaEngine.h"
#include "CZHelperFunc.h"

#include "CCScheduler.h"
USING_NS_CC;

long getCurrentTime()
{
    struct cc_timeval tv;
    CCTime::gettimeofdayCocos2d(&tv, NULL);
    return tv.tv_sec * 1000 + tv.tv_usec / 1000;
}
unsigned char* CZHelperFunc::getFileData(const char* pszFileName, const char* pszMode, unsigned long * pSize)
{
    unsigned long size;
    CCLog("CZHelperFunc::getFileData-->pszFileName=%s",pszFileName);
    
    long time1 = getCurrentTime();
    
    //CCLog("time1 = %ld",time1);
    unsigned char* buf = CCFileUtils::sharedFileUtils()->getFileData(pszFileName, pszMode, &size);
    
    long time2 = getCurrentTime();
    
    //CCLog("time2 = %ld",time2);
    
     CCLog("(time2-time1) = %ld",time2-time1);
    
    if (NULL==buf) return NULL;
    
    CCLuaStack* stack = CCLuaEngine::defaultEngine()->getLuaStack();
    unsigned char* buffer = NULL;
    
    bool _xxteaEnabled = stack->getXXTEAEnabled();
    
    char* _xxteaKey = stack->getXXTEAKey();
    int _xxteayKeyLen = stack->getXXTEAKeyLen();
    
    char* _xxteaSign = stack->getXXTEASign();
    int _xxteaySignLen = stack->getXXTEASignLen();
    
    
    bool isXXTEA = stack && _xxteaEnabled;
    for (unsigned int i = 0; isXXTEA && i < _xxteaySignLen && i < size; ++i)
    {
        isXXTEA = buf[i] == _xxteaSign[i];
    }
    
    if (isXXTEA)
    {
        // decrypt XXTEA
        CCLog("isXXTEA-----------");
        xxtea_long len = 0;
        buffer = xxtea_decrypt(buf + _xxteaySignLen,
                               (xxtea_long)size - (xxtea_long)_xxteaySignLen,
                               (unsigned char*)_xxteaKey,
                               (xxtea_long)_xxteayKeyLen,
                               &len);
        delete []buf;
        buf = NULL;
        size = len;
    }
    else
    {
        CCLog("NOT isXXTEA-----------");
        buffer = buf;
    }
    long time3 = getCurrentTime();
    
    //CCLog("time3 = %ld",time3);
    
    CCLog("(time3-time2) = %ld",time3-time2);
    if (pSize) *pSize = size;
    return buffer;
}
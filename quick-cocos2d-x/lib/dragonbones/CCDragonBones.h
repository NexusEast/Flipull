//
//  CCDragonBones.h
//
//
//  Created by Wayne Dimart on 14-4-18.
//  Copyright (c) 2014 . All rights reserved.
//	Modified by zrong(zengrong.net) on 2014-04-22
//

#ifndef __CCDRAGONBONES__
#define __CCDRAGONBONES__

#include <iostream>
#include "cocos2d.h"
#include "preDB.h"
#include "Animation.h"
#include "Event.h"

extern "C" {
#include "lua.h"
}
#include "CCLuaEngine.h"

namespace dragonBones {
    class Armature;
    class CCDragonBones:public cocos2d::CCNode {
    public:
		// create
        static cocos2d::ccBlendFunc DEFAULT_BLENDMODE;// ={GL_ONE,GL_ONE_MINUS_SRC_ALPHA};
        CCDragonBones():m_luaListener(0),m_Callback(0),m_Caller(0){};
        static Armature* buildArmature(	const char* skeletonXMLFile,
                                       const char* textureXMLFile,
                                       const char* texturePNGFile ,
                                        const char* dragonBonesName,
                                        const char* armatureName,
                                       cocos2d::ccBlendFunc blendMode ,
                                       const char* animationName = "");
 
															 
        static CCDragonBones* create(	const char* skeletonXMLFile,
                                     const char* textureXMLFile,
                                     const char* texturePNGFile ,
                                        const char* dragonBonesName,
                                         const char* armatureName,
                                     cocos2d::ccBlendFunc blendMode,
                                     const char* animationName = "" );
        ~CCDragonBones();

        CCNode* getDisplayNode();
        Armature* getArmature();
        Animation* getAnimation();
        cocos2d::CCArray* getAnimationList();
        void gotoAndPlay(   const String &animationName,
                            Number fadeInTime = -1,
                            Number duration = -1,
                            Number loop = NaN,
                            uint layer = 0,
                            const String &group = "",
                            const String &fadeOutMode = Animation::SAME_LAYER_AND_GROUP,
                            bool displayControl = true,
                            bool pauseFadeOut = true,
                            bool pauseFadeIn = true
			);
 
		void addEventListener(	const String &type, 
                                const String &key,
                                cocos2d::CCObject*pObj,
                                cocos2d::SEL_CallFuncND callback); 
		bool hasEventListener(const String &type);
		void removeEventListener(const String &type, const std::string &key);
		void dispatchEvent(Event *event);
        void                                   addEventListenerWithLua(
                                                                       const String &type,
                                                                       const String &key,
                                                                       cocos2d::LUA_FUNCTION listener);
		// Methods for cocos2d-x users.
        void setBoneTexture(const char* boneName, const char* textureName, const char* textureAtlasName);

		// Override cocos2d-x method.
		virtual void onExit();

        
    private:
        void initWithArmature(Armature* arm);
        void update(float dt);
        Armature* m_Armature; 
		cocos2d::SEL_CallFuncND	m_Callback;
		cocos2d::CCObject*	m_Caller;
		void eventBridge(Event* e);
        std::map<std::string,cocos2d::LUA_FUNCTION>              m_luaListenerDict;
        cocos2d::LUA_FUNCTION                                    m_luaListener;
    };
}
#endif // __CCDRAGONBONES__

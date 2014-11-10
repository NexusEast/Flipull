//
//  CCNodeMenuItem.h
//  quickcocos2dx
//
//  Created by yang on 14-5-5.
//  Copyright (c) 2014年 qeeplay.com. All rights reserved.
//

#ifndef __quickcocos2dx__CCNodeMenuItem__
#define __quickcocos2dx__CCNodeMenuItem__

#include "base_nodes/CCNode.h"
#include "CCProtocols.h"
#include "cocoa/CCArray.h"
#include "CCMenuItem.h"

NS_CC_BEGIN


//enum {
//    kCCNodeMenuItemPressedAction = 123,
//    kCCNodeMenuItemUnPressedAction = 124,
//};

/** @brief CCMenuItem base class
 *
 *  Subclass CCMenuItem (or any subclass) to create your custom CCMenuItem objects.
 */
class CC_DLL CCNodeMenuItem :  public CCMenuItemSprite
{
    /** run action when pressed*/
//    CC_PROPERTY(CCAction*, m_pressedAction, PressedAction);
//    CC_PROPERTY(CCAction*, m_unpressedAction, UnPressedAction);
    /** 按钮相应延时*/
//    CC_PROPERTY(float, m_delay, Delay);
    CCAction* m_pressedAction;
    CCAction* m_unpressedAction;
    float m_delay;
    
public:
    void setPressAction(CCAction* pressedAction,CCAction* unpressedAction);
    void setDelay(float delay);
    /**
     *  @js ctor
     */
    CCNodeMenuItem()
    :m_pressedAction(NULL)
    ,m_unpressedAction(NULL)
    ,m_delay(0.5f)
    {}
    
    
    /** creates a menu item with a normal, selected and disabled image*/
    static CCNodeMenuItem * create(CCNode* normalSprite, CCNode* selectedSprite, CCNode* disabledSprite = NULL);
    /** creates a menu item with a normal and selected image with target/selector
     * @lua NA
     */
    static CCNodeMenuItem * create(CCNode* normalSprite, CCNode* selectedSprite, CCObject* target, SEL_MenuHandler selector);
    /** creates a menu item with a normal,selected  and disabled image with target/selector
     * @lua NA
     */
    static CCNodeMenuItem * create(CCNode* normalSprite, CCNode* selectedSprite, CCNode* disabledSprite, CCObject* target, SEL_MenuHandler selector);
    
    /**  */
    virtual void activate();
    void  delayActivite(float dt);
    void realActivite();
    /**
     @since v0.99.5
     */
    virtual void selected();
    virtual void unselected();
    virtual void setEnabled(bool bEnabled);
    
    ////
    
protected:
    virtual void updateImagesVisibility();
};

NS_CC_END

#endif /* defined(__quickcocos2dx__CCNodeMenuItem__) */

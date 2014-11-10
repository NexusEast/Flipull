//
//  CCNodeMenuItem.cpp
//  quickcocos2dx
//
//  Created by yang on 14-5-5.
//  Copyright (c) 2014年 qeeplay.com. All rights reserved.
//

#include "CCNodeMenuItem.h"

#include "CCMenuItem.h"
#include "support/CCPointExtension.h"
#include "actions/CCActionInterval.h"
#include "sprite_nodes/CCSprite.h"
#include "label_nodes/CCLabelAtlas.h"
#include "label_nodes/CCLabelTTF.h"
#include "script_support/CCScriptSupport.h"
#include <stdarg.h>
#include <cstring>

NS_CC_BEGIN

//
// CCNodeMenuItem
//

CCNodeMenuItem * CCNodeMenuItem::create(CCNode* normalSprite, CCNode* selectedSprite, CCNode* disabledSprite)
{
    return CCNodeMenuItem::create(normalSprite, selectedSprite, disabledSprite, NULL, NULL);
}

CCNodeMenuItem * CCNodeMenuItem::create(CCNode* normalSprite, CCNode* selectedSprite, CCObject* target, SEL_MenuHandler selector)
{
    return CCNodeMenuItem::create(normalSprite, selectedSprite, NULL, target, selector);
}

CCNodeMenuItem * CCNodeMenuItem::create(CCNode *normalSprite, CCNode *selectedSprite, CCNode *disabledSprite, CCObject *target, SEL_MenuHandler selector)
{
    CCNodeMenuItem *pRet = new CCNodeMenuItem();
    pRet->initWithNormalSprite(normalSprite, selectedSprite, disabledSprite, target, selector);
    pRet->autorelease();
    return pRet;
}

void CCNodeMenuItem::activate()
{
    unschedule(schedule_selector(CCNodeMenuItem::delayActivite));
    schedule(schedule_selector(CCNodeMenuItem::delayActivite), m_delay);
}
void CCNodeMenuItem::delayActivite(float dt)
{
    unschedule(schedule_selector(CCNodeMenuItem::delayActivite));
    realActivite();
}
void CCNodeMenuItem::realActivite()
{
    CCMenuItem::activate();
}

/**
 @since v0.99.5
 */
void CCNodeMenuItem::selected()
{
    CCMenuItem::selected();
    
    if(m_pressedAction&&m_unpressedAction)
    {
        CCAction* pressedAction = getActionByTag(123);
        CCAction* unpressedAction = getActionByTag(125);
        if(unpressedAction){
            stopActionByTag(125);
        }
        if(!pressedAction) {
            m_pressedAction->setTag(123);
           runAction(m_pressedAction);
        }
    }
    else if (m_pNormalImage)
    {
        if (m_pDisabledImage)
        {
            m_pDisabledImage->setVisible(false);
        }
        
        if (m_pSelectedImage)
        {
            m_pNormalImage->setVisible(false);
            m_pSelectedImage->setVisible(true);
        }
        else
        {
            m_pNormalImage->setVisible(true);
        }
    }
}

void CCNodeMenuItem::unselected()
{
    CCMenuItem::unselected();
    
    if(m_pressedAction&&m_unpressedAction){
        CCAction* pressedAction = getActionByTag(123);
        CCAction* unpressedAction = getActionByTag(125);
        if(pressedAction) {
            stopActionByTag(123);
        }
        if(!unpressedAction){
            m_unpressedAction->setTag(125);
            runAction(m_unpressedAction);
        }
      
    }
    else if (m_pNormalImage)
    {
        m_pNormalImage->setVisible(true);
        
        if (m_pSelectedImage)
        {
            m_pSelectedImage->setVisible(false);
        }
        
        if (m_pDisabledImage)
        {
            m_pDisabledImage->setVisible(false);
        }
    }
}

void CCNodeMenuItem::setEnabled(bool bEnabled)
{
    if( m_bEnabled != bEnabled )
    {
        CCMenuItem::setEnabled(bEnabled);
        this->updateImagesVisibility();
    }
}

void CCNodeMenuItem::setPressAction(CCAction* pressedAction,CCAction* unpressedAction){
    m_pressedAction=pressedAction;
    m_pressedAction->retain();
    m_unpressedAction=unpressedAction;
    m_unpressedAction->retain();
}
void CCNodeMenuItem::setDelay(float delay){
    m_delay=delay;
}

// Helper
void CCNodeMenuItem::updateImagesVisibility()
{
    if (m_bEnabled)
    {
        if (m_pNormalImage)   m_pNormalImage->setVisible(true);
        if (m_pSelectedImage) m_pSelectedImage->setVisible(false);
        if (m_pDisabledImage) m_pDisabledImage->setVisible(false);
    }
    else
    {
        if (m_pDisabledImage)
        {
            if (m_pNormalImage)   m_pNormalImage->setVisible(false);
            if (m_pSelectedImage) m_pSelectedImage->setVisible(false);
            if (m_pDisabledImage) m_pDisabledImage->setVisible(true);
        }
        else
        {
            if (m_pNormalImage)   m_pNormalImage->setVisible(true);
            if (m_pSelectedImage) m_pSelectedImage->setVisible(false);
            if (m_pDisabledImage) m_pDisabledImage->setVisible(false);
        }
    }
}
NS_CC_END


/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2008-2010 Ricardo Quesada

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
#include "CCRectMenu.h"
#include "CCDirector.h"
#include "CCApplication.h"
#include "support/CCPointExtension.h"
#include "touch_dispatcher/CCTouchDispatcher.h"
#include "touch_dispatcher/CCTouch.h"
#include "CCStdC.h"
#include "cocoa/CCInteger.h"

#include <vector>
#include <stdarg.h>

using namespace std;

NS_CC_BEGIN


//
//CCMenu
//

CCRect CCRectMenu::getResponseRect(){
    return m_responseRect;
}
void CCRectMenu::setResponseRect(CCRect rect){
    m_responseRect=rect;
}

CCRectMenu* CCRectMenu::create()
{
    return CCRectMenu::create(NULL, NULL);
}

CCRectMenu* CCRectMenu::create(CCRect responseRect,CCMenuItem* item,...)
{
    va_list args;
    va_start(args,item);

    CCRectMenu *pRet = CCRectMenu::createWithItems(item, args);
    pRet->m_responseRect=responseRect;

    va_end(args);

    return pRet;
}

CCRectMenu * CCRectMenu::create(CCMenuItem* item, ...)
{
    va_list args;
    va_start(args,item);

    CCRectMenu *pRet = CCRectMenu::createWithItems(item, args);

    va_end(args);

    return pRet;
}

CCRectMenu* CCRectMenu::createWithArray(CCArray* pArrayOfItems)
{
    CCRectMenu *pRet = new CCRectMenu();
    if (pRet && pRet->initWithArray(pArrayOfItems))
    {
        pRet->autorelease();
    }
    else
    {
        CC_SAFE_DELETE(pRet);
    }

    return pRet;
}

CCRectMenu* CCRectMenu::createWithItems(CCMenuItem* item, va_list args)
{
    CCArray* pArray = NULL;
    if( item )
    {
        pArray = CCArray::create(item, NULL);
        CCMenuItem *i = va_arg(args, CCMenuItem*);
        while(i)
        {
            pArray->addObject(i);
            i = va_arg(args, CCMenuItem*);
        }
    }

    return CCRectMenu::createWithArray(pArray);
}

CCRectMenu* CCRectMenu::createWithItem(CCMenuItem* item)
{
    return CCRectMenu::create(item, NULL);
}

int CCRectMenu::ccTouchBegan(CCTouch* touch, CCEvent* event)
{
    const CCPoint pt = CCDirector::sharedDirector()->convertToGL(touch->getLocationInView());
    if(!m_responseRect.equals(CCRectZero) && !m_responseRect.containsPoint(pt)){
        return false;
    }else{
        return CCMenu::ccTouchBegan(touch, event);
    }
}


NS_CC_END

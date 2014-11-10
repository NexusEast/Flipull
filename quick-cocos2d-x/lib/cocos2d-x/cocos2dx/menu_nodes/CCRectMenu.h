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
#ifndef __CCRECTMENU_H_
#define __CCRECTMENU_H_

#include "CCMenuItem.h"
#include "CCMenu.h"
#include "layers_scenes_transitions_nodes/CCLayer.h"

NS_CC_BEGIN


/** @brief A CCMenu
*
* Features and Limitation:
*  - You can add MenuItem objects in runtime using addChild:
*  - But the only accepted children are MenuItem objects
*/
class CC_DLL CCRectMenu : public CCMenu
{
    /**
    *@yyj
    *the rect this menu can response
    */
    CCRect m_responseRect;
public:
    CCRect getResponseRect();
    void setResponseRect(CCRect rect);
public:
    /**
     *  @js ctor
     */
    CCRectMenu() :m_responseRect(CCRectZero) {}
    /**
     *  @js NA
     *  @lua NA
     */
    virtual ~CCRectMenu(){}

    /** creates an empty CCMenu */
    static CCRectMenu* create();

    static CCRectMenu* create(CCRect responseRect,CCMenuItem* item,...);

    /** creates a CCMenu with CCMenuItem objects
     * @lua NA
     */
    static CCRectMenu* create(CCMenuItem* item, ...);

    /** creates a CCMenu with a CCArray of CCMenuItem objects
     * @js NA
     */
    static CCRectMenu* createWithArray(CCArray* pArrayOfItems);

    /** creates a CCMenu with it's item, then use addChild() to add
      * other items. It is used for script, it can't init with undetermined
      * number of variables.
      * @js NA
    */
    static CCRectMenu* createWithItem(CCMenuItem* item);

    /** creates a CCMenu with CCMenuItem objects
     * @js NA
     * @lua NA
     */
    static CCRectMenu* createWithItems(CCMenuItem *firstItem, va_list args);


    /**
    @brief For phone event handle functions
    */
    virtual int ccTouchBegan(CCTouch* touch, CCEvent* event);
};

// end of GUI group
/// @}
/// @}

NS_CC_END

#endif//__CCRECTMENU_H_

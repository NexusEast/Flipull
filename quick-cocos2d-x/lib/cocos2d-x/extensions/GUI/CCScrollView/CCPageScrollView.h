/****************************************************************************
 Copyright (c) 2012 cocos2d-x.org
 Copyright (c) 2010 Sangwoo Im
 
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

#ifndef __CCPAGESCROLLVIEW_H__
#define __CCPAGESCROLLVIEW_H__

#include "cocos2d.h"
#include "ExtensionMacros.h"

NS_CC_EXT_BEGIN

/**
 * @addtogroup GUI
 * @{
 */

typedef enum {
	kCCPageScrollViewDirectionNone = -1,
    kCCPageScrollViewDirectionHorizontal = 0,
    kCCPageScrollViewDirectionVertical,
    kCCPageScrollViewDirectionBoth
} CCPageScrollViewDirection;

class CCPageScrollView;
/**
 *  @js NA
 *  @lua NA
 */
class CCPageScrollViewDelegate
{
public:
    virtual ~CCPageScrollViewDelegate() {}
    virtual void scrollViewDidScroll(CCPageScrollView* view) = 0;
    virtual void scrollViewDidZoom(CCPageScrollView* view) = 0;
};


/**
 * ScrollView support for cocos2d for iphone.
 * It provides scroll view functionalities to cocos2d projects natively.
 * @lua NA
 */
class CCPageScrollView : public CCLayer
{
public:
    /**
     *  @js ctor
     */
    CCPageScrollView();
    /**
     *  @js NA
     *  @lua NA
     */
    virtual ~CCPageScrollView();
    
    bool init();
    virtual void registerWithTouchDispatcher();
    
    /**
     * Returns an autoreleased scroll view object.
     *
     * @param size view size
     * @param container parent object
     * @return autoreleased scroll view object
     */
    static CCPageScrollView* create(CCSize size, CCNode* container = NULL);
    
    /**
     * Returns an autoreleased scroll view object.
     *
     * @param size view size
     * @param container parent object
     * @return autoreleased scroll view object
     */
    static CCPageScrollView* create();
    
    /**
     * Returns a scroll view object
     *
     * @param size view size
     * @param container parent object
     * @return scroll view object
     */
    bool initWithViewSize(CCSize size, CCNode* container = NULL);
    
    
    /**
     * Sets a new content offset. It ignores max/min offset. It just sets what's given. (just like UIKit's UIScrollView)
     *
     * @param offset new offset
     * @param If YES, the view scrolls to the new offset
     */
    void setContentOffset(CCPoint offset, bool animated = false);
    CCPoint getContentOffset();
    /**
     * Sets a new content offset. It ignores max/min offset. It just sets what's given. (just like UIKit's UIScrollView)
     * You can override the animation duration with this method.
     *
     * @param offset new offset
     * @param animation duration
     */
    void setContentOffsetInDuration(CCPoint offset, float dt);
    
    void setZoomScale(float s);
    /**
     * Sets a new scale and does that for a predefined duration.
     *
     * @param s a new scale vale
     * @param animated if YES, scaling is animated
     */
    void setZoomScale(float s, bool animated);
    
    float getZoomScale();
    
    /**
     * Sets a new scale for container in a given duration.
     *
     * @param s a new scale value
     * @param animation duration
     */
    void setZoomScaleInDuration(float s, float dt);
    /**
     * Returns the current container's minimum offset. You may want this while you animate scrolling by yourself
     */
    CCPoint minContainerOffset();
    /**
     * Returns the current container's maximum offset. You may want this while you animate scrolling by yourself
     */
    CCPoint maxContainerOffset();
    /**
     * Determines if a given node's bounding box is in visible bounds
     *
     * @return YES if it is in visible bounds
     */
    bool isNodeVisible(CCNode * node);
    /**
     * Provided to make scroll view compatible with SWLayer's pause method
     */
    void pause(CCObject* sender);
    /**
     * Provided to make scroll view compatible with SWLayer's resume method
     */
    void resume(CCObject* sender);
    
    
    bool isDragging() {return m_bDragging;}
    bool isTouchMoved() { return m_bTouchMoved; }
    bool isBounceable() { return m_bBounceable; }
    void setBounceable(bool bBounceable) { m_bBounceable = bBounceable; }
    
    /**
     * size to clip. CCNode boundingBox uses contentSize directly.
     * It's semantically different what it actually means to common scroll views.
     * Hence, this scroll view will use a separate size property.
     */
    CCSize getViewSize() { return m_tViewSize; }
    void setViewSize(CCSize size);
    
    CCNode * getContainer();
    void setContainer(CCNode * pContainer);
    
    /**
     * direction allowed to scroll. CCPageScrollViewDirectionBoth by default.
     CCPageScrollView can only be kCCPageScrollViewDirectionHorizontal
     */
    CCPageScrollViewDirection getDirection() { return m_eDirection; }
    virtual void setDirection(CCPageScrollViewDirection eDirection) { m_eDirection = eDirection; }
    
    CCPageScrollViewDelegate* getDelegate() { return m_pDelegate; }
    void setDelegate(CCPageScrollViewDelegate* pDelegate) { m_pDelegate = pDelegate; }
    
    /** override functions */
    // optional
    virtual int ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
    virtual int ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent);
    virtual void ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent);
    virtual void ccTouchCancelled(CCTouch *pTouch, CCEvent *pEvent);
    
    virtual void setContentSize(const CCSize & size);
    virtual const CCSize& getContentSize() const;
    
	void updateInset();
    /**
     * Determines whether it clips its children or not.
     */
    bool isClippingToBounds() { return m_bClippingToBounds; }
    void setClippingToBounds(bool bClippingToBounds) { m_bClippingToBounds = bClippingToBounds; }
    
    
    
    /**
     *  @js NA
     */
    virtual void visit();
    virtual void addChild(CCNode * child, int zOrder, int tag);
    virtual void addChild(CCNode * child, int zOrder);
    virtual void addChild(CCNode * child);
    void setTouchEnabled(bool e);
private:
    /**
     * Relocates the container at the proper offset, in bounds of max/min offsets.
     *
     * @param animated If YES, relocation is animated
     */
    void relocateContainer(bool animated);
    /**
     * implements auto-scrolling behavior. change SCROLL_DEACCEL_RATE as needed to choose
     * deacceleration speed. it must be less than 1.0f.
     *
     * @param dt delta
     */
    void deaccelerateScrolling(float dt);
    /**
     * This method makes sure auto scrolling causes delegate to invoke its method
     */
    void performedAnimatedScroll(float dt);
    /**
     * Expire animated scroll delegate calls
     */
    void stoppedAnimatedScroll(CCNode* node);
    /**
     * clip this view so that outside of the visible bounds can be hidden.
     */
    void beforeDraw();
    /**
     * retract what's done in beforeDraw so that there's no side effect to
     * other nodes.
     */
    void afterDraw();
    /**
     * Zoom handling
     */
    void handleZoom();
    
protected:
    CCRect getViewRect();
    
    /**
     * current zoom scale
     */
    float m_fZoomScale;
    /**
     * min zoom scale
     */
    float m_fMinZoomScale;
    /**
     * max zoom scale
     */
    float m_fMaxZoomScale;
    /**
     * scroll view delegate
     */
    CCPageScrollViewDelegate* m_pDelegate;
    
    CCPageScrollViewDirection m_eDirection;
    /**
     * If YES, the view is being dragged.
     */
    bool m_bDragging;
    
    /**
     * Content offset. Note that left-bottom point is the origin
     */
    CCPoint m_tContentOffset;
    
    /**
     * Container holds scroll view contents, Sets the scrollable container object of the scroll view
     */
    CCNode* m_pContainer;
    /**
     * Determiens whether user touch is moved after begin phase.
     */
    bool m_bTouchMoved;
    /**
     * max inset point to limit scrolling by touch
     */
    CCPoint m_fMaxInset;
    /**
     * min inset point to limit scrolling by touch
     */
    CCPoint m_fMinInset;
    /**
     * Determines whether the scroll view is allowed to bounce or not.
     */
    bool m_bBounceable;
    
    bool m_bClippingToBounds;
    
    /**
     * scroll speed
     */
    CCPoint m_tScrollDistance;
    /**
     * Touch point
     */
    CCPoint m_tTouchPoint;
    /**
     * length between two fingers
     */
    float m_fTouchLength;
    /**
     * UITouch objects to detect multitouch
     */
    CCArray* m_pTouches;
    /**
     * size to clip. CCNode boundingBox uses contentSize directly.
     * It's semantically different what it actually means to common scroll views.
     * Hence, this scroll view will use a separate size property.
     */
    CCSize m_tViewSize;
    /**
     * max and min scale
     */
    float m_fMinScale, m_fMaxScale;
    /**
     * scissor rect for parent, just for restoring GL_SCISSOR_BOX
     */
    CCRect m_tParentScissorRect;
    bool m_bScissorRestored;
    
	//Page Info
public:
	bool isPaged();
	void setPaged( bool value ){ m_bPaged = value; };
    
    /**
     *  set one page's width. should be called before calling setContainer()
     *
     *  @param width width
     */
    void setPageWidth(int width){ m_pageWidth = width; };
    int getPageWidth() { return m_pageWidth; };
    
    void endScrollToPage(float dt);//end scrolling to page and clear some values
    void setCurrPage(int page);
    int getCurrPage(){ return m_currPage; };
    void scrollToPage(int page,bool animated=true);
    bool isScrollingToPage(){ return m_bScrollingToPage; };
    float getScaleFactor() { return m_scaleFactor; };
    void setScaleFactor(float factor){ this->m_scaleFactor = factor; };
    void setMinScale(float scale ){ this->m_minScale = scale; };
    float getMinScale(){ return m_minScale;  };
    int getNumOfPages() {  return numOfPages; };
protected:
	int m_currPage;//current selected page [1,numOfPages]
    int numOfPages;//the number of pages ,will init in setContainer() method.
    int m_pageWidth;// page size's width,should be set outside
    float m_scrollDirection;// direction of scroll to ,<0 left to right ; >0 right to left
    bool m_bScrollingToPage;// true if calling method scrollToPage
    
    float m_scaleFactor;//the scale factor when selected ,default is 1.2
    float m_minScale;
    
    void __scaleCellWhenSelected();//scale cell when selected
	void __pageTouchCancel();
	void __pageClearTouch(); // clear some values
    int __getClickedPage(CCPoint location);// get clicked page index with clicked location 
private:
	bool m_bPaged;
    
public:
    enum PageScrollViewScriptEventType
    {
        kPageScrollViewScroll   = 0,
        kPageScrollViewZoom,
    };
    void registerScriptHandler(int nFunID,int nScriptEventType);
    void unregisterScriptHandler(int nScriptEventType);
    int  getScriptHandler(int nScriptEventType);
private:
    std::map<int,int> m_mapScriptHandler;
};

// end of GUI group
/// @}

NS_CC_EXT_END

#endif /* __CCPAGESCROLLVIEW_H__ */

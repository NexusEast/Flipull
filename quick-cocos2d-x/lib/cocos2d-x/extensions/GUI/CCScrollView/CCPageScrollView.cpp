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

#include "CCPageScrollView.h"

NS_CC_EXT_BEGIN

#define SCROLL_DEACCEL_RATE  0.95f
#define SCROLL_DEACCEL_DIST  1.0f
#define BOUNCE_DURATION      0.15f
#define INSET_RATIO          0.2f
#define MOVE_INCH            7.0f/160.0f

#define MIN_PAGE 2
#define TURN_PAGE_MIN_OFFSET_RATIO		0.4f

static float convertDistanceFromPointToInch(float pointDis)
{
    float factor = ( CCEGLView::sharedOpenGLView()->getScaleX() + CCEGLView::sharedOpenGLView()->getScaleY() ) / 2;
    return pointDis * factor / CCDevice::getDPI();
}

void setNodeScale(CCNode* node , float scale){
    if(node){
        node->setScale(scale);
//        CCSprite *sprite = (CCSprite*)node;
//        if(sprite){
//            sprite->setScale(scale);
//        }else{
//            CCMenu* menu = (CCMenu*)node;
//            if(menu){
//                menu->setScale(scale);
//            }else{
//                CCRectMenu* rectMenu = (CCRectMenu*)node;
//                if(rectMenu){
//                    rectMenu->setScale(scale);
//                }else{
//                    node->setScale(scale);
//                }
//            }
//            
//        }
    }
}


CCPageScrollView::CCPageScrollView()
: m_fZoomScale(0.0f)
, m_fMinZoomScale(0.0f)
, m_fMaxZoomScale(0.0f)
, m_pDelegate(NULL)
, m_eDirection(kCCPageScrollViewDirectionHorizontal)
, m_bDragging(false)
, m_pContainer(NULL)
, m_bTouchMoved(false)
, m_bBounceable(false)
, m_bClippingToBounds(false)
, m_fTouchLength(0.0f)
, m_pTouches(NULL)
, m_fMinScale(0.0f)
, m_fMaxScale(0.0f)
, m_bPaged(false)
, m_currPage(0)
{
	m_bPaged = false;
    m_bScrollingToPage = false;
    m_scrollDirection = 0;
    m_scaleFactor = 1.2f;
    m_minScale = 1;
}

CCPageScrollView::~CCPageScrollView()
{
    CC_SAFE_RELEASE(m_pTouches);
    this->unregisterScriptHandler(kPageScrollViewScroll);
    this->unregisterScriptHandler(kPageScrollViewZoom);
}

CCPageScrollView* CCPageScrollView::create(CCSize size, CCNode* container/* = NULL*/)
{
    CCPageScrollView* pRet = new CCPageScrollView();
    if (pRet && pRet->initWithViewSize(size, container))
    {
        pRet->autorelease();
    }
    else
    {
        CC_SAFE_DELETE(pRet);
    }
    return pRet;
}

CCPageScrollView* CCPageScrollView::create()
{
    CCPageScrollView* pRet = new CCPageScrollView();
    if (pRet && pRet->init())
    {
        pRet->autorelease();
    }
    else
    {
        CC_SAFE_DELETE(pRet);
    }
    return pRet;
}


bool CCPageScrollView::initWithViewSize(CCSize size, CCNode *container/* = NULL*/)
{
    if (CCLayer::init())
    {
        m_pContainer = container;
        
        if (!this->m_pContainer)
        {
            m_pContainer = CCLayer::create();
            this->m_pContainer->ignoreAnchorPointForPosition(false);
            this->m_pContainer->setAnchorPoint(ccp(0.0f, 0.0f));
        }
        
        this->setViewSize(size);
        
        setTouchEnabled(true);
        m_pTouches = new CCArray();
        m_pDelegate = NULL;
        m_bBounceable = true;
        m_bClippingToBounds = true;
        //m_pContainer->setContentSize(CCSizeZero);
        m_eDirection  = kCCPageScrollViewDirectionBoth;
        m_pContainer->setPosition(ccp(0.0f, 0.0f));
        m_fTouchLength = 0.0f;
        
        this->addChild(m_pContainer);
        m_fMinScale = m_fMaxScale = 1.0f;
        m_mapScriptHandler.clear();
        return true;
    }
    return false;
}

bool CCPageScrollView::init()
{
    return this->initWithViewSize(CCSizeMake(200, 200), NULL);
}

void CCPageScrollView::registerWithTouchDispatcher()
{
    CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, CCLayer::getTouchPriority(), false);
}

bool CCPageScrollView::isNodeVisible(CCNode* node)
{
    const CCPoint offset = this->getContentOffset();
    const CCSize  size   = this->getViewSize();
    const float   scale  = this->getZoomScale();
    
    CCRect viewRect;
    
    viewRect = CCRectMake(-offset.x/scale, -offset.y/scale, size.width/scale, size.height/scale);
    
    return viewRect.intersectsRect(node->boundingBox());
}

void CCPageScrollView::pause(CCObject* sender)
{
    m_pContainer->pauseSchedulerAndActions();
    
    CCObject* pObj = NULL;
    CCArray* pChildren = m_pContainer->getChildren();
    
    CCARRAY_FOREACH(pChildren, pObj)
    {
        CCNode* pChild = (CCNode*)pObj;
        pChild->pauseSchedulerAndActions();
    }
}

void CCPageScrollView::resume(CCObject* sender)
{
    CCObject* pObj = NULL;
    CCArray* pChildren = m_pContainer->getChildren();
    
    CCARRAY_FOREACH(pChildren, pObj)
    {
        CCNode* pChild = (CCNode*)pObj;
        pChild->resumeSchedulerAndActions();
    }
    
    m_pContainer->resumeSchedulerAndActions();
}

void CCPageScrollView::setTouchEnabled(bool e)
{
    CCLayer::setTouchEnabled(e);
    if (!e)
    {
        m_bDragging = false;
        m_bTouchMoved = false;
        m_pTouches->removeAllObjects();
    }
}

void CCPageScrollView::setContentOffset(CCPoint offset, bool animated/* = false*/)
{
    if (animated)
    { //animate scrolling
        this->setContentOffsetInDuration(offset, BOUNCE_DURATION);
    }
    else
    { //set the container position directly
        if (!m_bBounceable)
        {
            const CCPoint minOffset = this->minContainerOffset();
            const CCPoint maxOffset = this->maxContainerOffset();
            
            offset.x = MAX(minOffset.x, MIN(maxOffset.x, offset.x));
            offset.y = MAX(minOffset.y, MIN(maxOffset.y, offset.y));
        }
        
        m_pContainer->setPosition(offset);
        
        if (m_pDelegate != NULL)
        {
            m_pDelegate->scrollViewDidScroll(this);
        }
        this->__scaleCellWhenSelected();
    }
}

void CCPageScrollView::setContentOffsetInDuration(CCPoint offset, float dt)
{
    CCFiniteTimeAction *scroll, *expire;
    
    scroll = CCMoveTo::create(dt, offset);
    expire = CCCallFuncN::create(this, callfuncN_selector(CCPageScrollView::stoppedAnimatedScroll));
    m_pContainer->runAction(CCSequence::create(scroll, expire, NULL));
    this->schedule(schedule_selector(CCPageScrollView::performedAnimatedScroll));
}

CCPoint CCPageScrollView::getContentOffset()
{
    return m_pContainer->getPosition();
}

void CCPageScrollView::setZoomScale(float s)
{
    if (m_pContainer->getScale() != s)
    {
        CCPoint oldCenter, newCenter;
        CCPoint center;
        
        if (m_fTouchLength == 0.0f)
        {
            center = ccp(m_tViewSize.width*0.5f, m_tViewSize.height*0.5f);
            center = this->convertToWorldSpace(center);
        }
        else
        {
            center = m_tTouchPoint;
        }
        
        oldCenter = m_pContainer->convertToNodeSpace(center);
        m_pContainer->setScale(MAX(m_fMinScale, MIN(m_fMaxScale, s)));
        newCenter = m_pContainer->convertToWorldSpace(oldCenter);
        
        const CCPoint offset = ccpSub(center, newCenter);
        if (m_pDelegate != NULL)
        {
            m_pDelegate->scrollViewDidZoom(this);
        }
        this->setContentOffset(ccpAdd(m_pContainer->getPosition(),offset));
    }
}

float CCPageScrollView::getZoomScale()
{
    return m_pContainer->getScale();
}

void CCPageScrollView::setZoomScale(float s, bool animated)
{
    if (animated)
    {
        this->setZoomScaleInDuration(s, BOUNCE_DURATION);
    }
    else
    {
        this->setZoomScale(s);
    }
}

void CCPageScrollView::setZoomScaleInDuration(float s, float dt)
{
    if (dt > 0)
    {
        if (m_pContainer->getScale() != s)
        {
            CCActionTween *scaleAction;
            scaleAction = CCActionTween::create(dt, "zoomScale", m_pContainer->getScale(), s);
            this->runAction(scaleAction);
        }
    }
    else
    {
        this->setZoomScale(s);
    }
}

void CCPageScrollView::setViewSize(CCSize size)
{
    m_tViewSize = size;
    CCLayer::setContentSize(size);
}

CCNode * CCPageScrollView::getContainer()
{
    return this->m_pContainer;
}

void CCPageScrollView::setContainer(CCNode * pContainer)
{
    // Make sure that 'm_pContainer' has a non-NULL value since there are
    // lots of logic that use 'm_pContainer'.
    if (NULL == pContainer)
        return;
    
    this->removeAllChildrenWithCleanup(true);
    this->m_pContainer = pContainer;
    
    this->m_pContainer->ignoreAnchorPointForPosition(false);
    this->m_pContainer->setAnchorPoint(ccp(0.0f, 0.0f));
    
    this->addChild(this->m_pContainer);
    
    this->setViewSize(this->m_tViewSize);
    
    //calculate number of pages , the number of pages will not change when init
    CCArray *children = pContainer->getChildren();
    numOfPages = children?children->count()-1:0;
    
    CCObject* pObj = NULL;
    CCARRAY_FOREACH(children, pObj)
    {
        CCNode* pChild = (CCNode*)pObj;
        if(pChild->getTag()!=m_currPage) setNodeScale(pChild, m_minScale);
    }
    //defalut set the first page 1
//    scrollToPage(1);
}

void CCPageScrollView::relocateContainer(bool animated)
{
    CCPoint oldPoint, min, max;
    float newX, newY;
    
    min = this->minContainerOffset();
    max = this->maxContainerOffset();
    
    oldPoint = m_pContainer->getPosition();
    
    newX     = oldPoint.x;
    newY     = oldPoint.y;
    if (m_eDirection == kCCPageScrollViewDirectionBoth || m_eDirection == kCCPageScrollViewDirectionHorizontal)
    {
        newX     = MAX(newX, min.x);
        newX     = MIN(newX, max.x);
    }
    
    if (m_eDirection == kCCPageScrollViewDirectionBoth || m_eDirection == kCCPageScrollViewDirectionVertical)
    {
        newY     = MIN(newY, max.y);
        newY     = MAX(newY, min.y);
    }
    
    if (newY != oldPoint.y || newX != oldPoint.x)
    {
        this->setContentOffset(ccp(newX, newY), animated);
    }
}

CCPoint CCPageScrollView::maxContainerOffset()
{
    return ccp(0.0f, 0.0f);
}

CCPoint CCPageScrollView::minContainerOffset()
{
    return ccp(m_tViewSize.width - m_pContainer->getContentSize().width*m_pContainer->getScaleX(),
               m_tViewSize.height - m_pContainer->getContentSize().height*m_pContainer->getScaleY());
}

void CCPageScrollView::deaccelerateScrolling(float dt)
{
    if (m_bDragging)
    {
        this->unschedule(schedule_selector(CCPageScrollView::deaccelerateScrolling));
        return;
    }
    
    float newX, newY;
    CCPoint maxInset, minInset;
    
    m_pContainer->setPosition(ccpAdd(m_pContainer->getPosition(), m_tScrollDistance));
    
    if (m_bBounceable)
    {
        maxInset = m_fMaxInset;
        minInset = m_fMinInset;
    }
    else
    {
        maxInset = this->maxContainerOffset();
        minInset = this->minContainerOffset();
    }
    
    //check to see if offset lies within the inset bounds
    newX     = MIN(m_pContainer->getPosition().x, maxInset.x);
    newX     = MAX(newX, minInset.x);
    newY     = MIN(m_pContainer->getPosition().y, maxInset.y);
    newY     = MAX(newY, minInset.y);
    
//    newX = m_pContainer->getPosition().x;
//    newY = m_pContainer->getPosition().y;
    
    m_tScrollDistance     = ccpSub(m_tScrollDistance, ccp(newX - m_pContainer->getPosition().x, newY - m_pContainer->getPosition().y));
    m_tScrollDistance     = ccpMult(m_tScrollDistance, SCROLL_DEACCEL_RATE);
    this->setContentOffset(ccp(newX,newY));
    
    float scrollDistance = m_tScrollDistance.x;
    if(m_scrollDirection == 0){
        m_scrollDirection =  scrollDistance ;
    }
//    CCLog("m_scrollDirection:%f",m_scrollDirection);
    if(isPaged()&&fabs(scrollDistance)<40){
        //calculate the destinal page to scroll when scrollDistance reach a low level
        this->unschedule(schedule_selector(CCPageScrollView::deaccelerateScrolling));
        
        //calculate the next page index
        float page = 1;
        if(m_scrollDirection<0){
            //左往右滑动
            page = fabs(this->getContentOffset().x)/this->getPageWidth() + 2;
        }else if(m_scrollDirection>0){
            //右往左滑动
            page = fabs(this->getContentOffset().x)/this->getPageWidth() + 1;
        }else{
            page = m_currPage;
        }
        this->scrollToPage(page);
        
        return;
    }
    
    if ((fabsf(m_tScrollDistance.x) <= SCROLL_DEACCEL_DIST &&
         fabsf(m_tScrollDistance.y) <= SCROLL_DEACCEL_DIST) ||
        newY > maxInset.y || newY < minInset.y ||
        newX > maxInset.x || newX < minInset.x ||
        newX == maxInset.x || newX == minInset.x ||
        newY == maxInset.y || newY == minInset.y)
    {
//        CCLog("unschedule deaccelerScrolling");
        this->unschedule(schedule_selector(CCPageScrollView::deaccelerateScrolling));
        
        //calculate the next page index
        float page = 1;
        if(m_scrollDirection<0){
            //左往右滑动
            page = fabs(this->getContentOffset().x)/this->getPageWidth() + 2;
        }else if(m_scrollDirection>0){
            //右往左滑动
            page = fabs(this->getContentOffset().x)/this->getPageWidth() + 1;
        }else{
            page = m_currPage;
        }
        this->scrollToPage(page);
//won't do relocateContainer ontill stop scrolling
//        this->relocateContainer(true);
    }
}
int CCPageScrollView::__getClickedPage(CCPoint location){
    CCPoint pos = m_pContainer->convertToNodeSpace(location);
    for(int i=1;i<=numOfPages;i++){
        CCNode *node = m_pContainer->getChildByTag(i);
        if(node){
            if(node->boundingBox().containsPoint(pos)){
//                CCLog("clicked page %d",i);
                return i;
            }
        }
    }
    return m_currPage;
}

void CCPageScrollView::stoppedAnimatedScroll(CCNode * node)
{
    this->unschedule(schedule_selector(CCPageScrollView::performedAnimatedScroll));
    // After the animation stopped, "scrollViewDidScroll" should be invoked, this could fix the bug of lack of tableview cells.
    if (m_pDelegate != NULL)
    {
        m_pDelegate->scrollViewDidScroll(this);
    }
}

void CCPageScrollView::performedAnimatedScroll(float dt)
{
    this->__scaleCellWhenSelected();
    if (m_bDragging)
    {
        this->unschedule(schedule_selector(CCPageScrollView::performedAnimatedScroll));
        return;
    }
    
    if (m_pDelegate != NULL)
    {
        m_pDelegate->scrollViewDidScroll(this);
    }
//    CCLog("performedAnimatedScroll");
}


const CCSize& CCPageScrollView::getContentSize() const
{
	return m_pContainer->getContentSize();
}

void CCPageScrollView::setContentSize(const CCSize & size)
{
    if (this->getContainer() != NULL)
    {
        this->getContainer()->setContentSize(size);
		this->updateInset();
    }
}

void CCPageScrollView::updateInset()
{
	if (this->getContainer() != NULL)
	{
		m_fMaxInset = this->maxContainerOffset();
		m_fMaxInset = ccp(m_fMaxInset.x + m_tViewSize.width * INSET_RATIO,
                          m_fMaxInset.y + m_tViewSize.height * INSET_RATIO);
		m_fMinInset = this->minContainerOffset();
		m_fMinInset = ccp(m_fMinInset.x - m_tViewSize.width * INSET_RATIO,
                          m_fMinInset.y - m_tViewSize.height * INSET_RATIO);
	}
}

/**
 * make sure all children go to the container
 */
void CCPageScrollView::addChild(CCNode * child, int zOrder, int tag)
{
    child->ignoreAnchorPointForPosition(false);
    child->setAnchorPoint(ccp(0.0f, 0.0f));
    if (m_pContainer != child) {
        m_pContainer->addChild(child, zOrder, tag);
    } else {
        CCLayer::addChild(child, zOrder, tag);
    }
}

void CCPageScrollView::addChild(CCNode * child, int zOrder)
{
    this->addChild(child, zOrder, child->getTag());
}

void CCPageScrollView::addChild(CCNode * child)
{
    this->addChild(child, child->getZOrder(), child->getTag());
}

/**
 * clip this view so that outside of the visible bounds can be hidden.
 */
void CCPageScrollView::beforeDraw()
{
    if (m_bClippingToBounds)
    {
		m_bScissorRestored = false;
        CCRect frame = getViewRect();
        if (CCEGLView::sharedOpenGLView()->isScissorEnabled()) {
            m_bScissorRestored = true;
            m_tParentScissorRect = CCEGLView::sharedOpenGLView()->getScissorRect();
            //set the intersection of m_tParentScissorRect and frame as the new scissor rect
            if (frame.intersectsRect(m_tParentScissorRect)) {
                float x = MAX(frame.origin.x, m_tParentScissorRect.origin.x);
                float y = MAX(frame.origin.y, m_tParentScissorRect.origin.y);
                float xx = MIN(frame.origin.x+frame.size.width, m_tParentScissorRect.origin.x+m_tParentScissorRect.size.width);
                float yy = MIN(frame.origin.y+frame.size.height, m_tParentScissorRect.origin.y+m_tParentScissorRect.size.height);
                CCEGLView::sharedOpenGLView()->setScissorInPoints(x, y, xx-x, yy-y);
            }
        }
        else {
            glEnable(GL_SCISSOR_TEST);
            CCEGLView::sharedOpenGLView()->setScissorInPoints(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        }
    }
}

/**
 * retract what's done in beforeDraw so that there's no side effect to
 * other nodes.
 */
void CCPageScrollView::afterDraw()
{
    if (m_bClippingToBounds)
    {
        if (m_bScissorRestored) {//restore the parent's scissor rect
            CCEGLView::sharedOpenGLView()->setScissorInPoints(m_tParentScissorRect.origin.x, m_tParentScissorRect.origin.y, m_tParentScissorRect.size.width, m_tParentScissorRect.size.height);
        }
        else {
            glDisable(GL_SCISSOR_TEST);
        }
    }
}

void CCPageScrollView::visit()
{
	// quick return if not visible
	if (!isVisible())
    {
		return;
    }
    
	kmGLPushMatrix();
	
    if (m_pGrid && m_pGrid->isActive())
    {
        m_pGrid->beforeDraw();
        this->transformAncestors();
    }
    
	this->transform();
    this->beforeDraw();
    
	if(m_pChildren)
    {
		ccArray *arrayData = m_pChildren->data;
		unsigned int i=0;
		
		// draw children zOrder < 0
		for( ; i < arrayData->num; i++ )
        {
			CCNode *child =  (CCNode*)arrayData->arr[i];
			if ( child->getZOrder() < 0 )
            {
				child->visit();
			}
            else
            {
				break;
            }
		}
		
		// this draw
		this->draw();
		
		// draw children zOrder >= 0
		for( ; i < arrayData->num; i++ )
        {
			CCNode* child = (CCNode*)arrayData->arr[i];
			child->visit();
		}
        
	}
    else
    {
		this->draw();
    }
    
    this->afterDraw();
	if ( m_pGrid && m_pGrid->isActive())
    {
		m_pGrid->afterDraw(this);
    }
    
	kmGLPopMatrix();
}

int CCPageScrollView::ccTouchBegan(CCTouch* touch, CCEvent* event)
{
    if (!this->isVisible())
    {
        return false;
    }
    if(isPaged()){
        this->m_pContainer->stopAllActions();
        m_bScrollingToPage=false;
        this->unscheduleAllSelectors();
    }
    
    CCRect frame = getViewRect();
    
    //dispatcher does not know about clipping. reject touches outside visible bounds.
    if (m_pTouches->count() > 2 ||
        m_bTouchMoved          ||
        !frame.containsPoint(m_pContainer->convertToWorldSpace(m_pContainer->convertTouchToNodeSpace(touch))))
    {
        return false;
    }
    
    if (!m_pTouches->containsObject(touch))
    {
        m_pTouches->addObject(touch);
    }
    
    if (m_pTouches->count() == 1)
    { // scrolling
        m_tTouchPoint     = this->convertTouchToNodeSpace(touch);
        m_bTouchMoved     = false;
        m_bDragging     = true; //dragging started
        m_tScrollDistance = ccp(0.0f, 0.0f);
        m_fTouchLength    = 0.0f;
        
    }
    else if (m_pTouches->count() == 2)
    {
        m_tTouchPoint  = ccpMidpoint(this->convertTouchToNodeSpace((CCTouch*)m_pTouches->objectAtIndex(0)),
                                     this->convertTouchToNodeSpace((CCTouch*)m_pTouches->objectAtIndex(1)));
        m_fTouchLength = ccpDistance(m_pContainer->convertTouchToNodeSpace((CCTouch*)m_pTouches->objectAtIndex(0)),
                                     m_pContainer->convertTouchToNodeSpace((CCTouch*)m_pTouches->objectAtIndex(1)));
        m_bDragging  = false;
    }
    return true;
}

int CCPageScrollView::ccTouchMoved(CCTouch* touch, CCEvent* event)
{
    if (!this->isVisible())
    {
        return false;
    }
    
    
    if (m_pTouches->containsObject(touch))
    {
        if (m_pTouches->count() == 1 && m_bDragging)
        { // scrolling
            CCPoint moveDistance, newPoint, maxInset, minInset;
            CCRect  frame;
            float newX, newY;
            
            frame = getViewRect();
            
            newPoint     = this->convertTouchToNodeSpace((CCTouch*)m_pTouches->objectAtIndex(0));
            moveDistance = ccpSub(newPoint, m_tTouchPoint);
            
            float dis = 0.0f;
            if (m_eDirection == kCCPageScrollViewDirectionVertical)
            {
                dis = moveDistance.y;
            }
            else if (m_eDirection == kCCPageScrollViewDirectionHorizontal)
            {
                dis = moveDistance.x;
            }
            else
            {
                dis = sqrtf(moveDistance.x*moveDistance.x + moveDistance.y*moveDistance.y);
            }
            
            if (!m_bTouchMoved && fabs(convertDistanceFromPointToInch(dis)) < MOVE_INCH )
            {
                //CCLOG("Invalid movement, distance = [%f, %f], disInch = %f", moveDistance.x, moveDistance.y);
                return false;
            }
            
            if (!m_bTouchMoved)
            {
                moveDistance = CCPointZero;
            }
            
            m_tTouchPoint = newPoint;
            m_bTouchMoved = true;
            
            if (frame.containsPoint(this->convertToWorldSpace(newPoint)))
            {
                switch (m_eDirection)
                {
                    case kCCPageScrollViewDirectionVertical:
                        moveDistance = ccp(0.0f, moveDistance.y);
                        break;
                    case kCCPageScrollViewDirectionHorizontal:
                        moveDistance = ccp(moveDistance.x, 0.0f);
                        break;
                    default:
                        break;
                }
                
                maxInset = m_fMaxInset;
                minInset = m_fMinInset;
                
                newX     = m_pContainer->getPosition().x + moveDistance.x;
                newY     = m_pContainer->getPosition().y + moveDistance.y;
                
                m_tScrollDistance = moveDistance;
                this->setContentOffset(ccp(newX, newY));
            }
        }
        else if (m_pTouches->count() == 2 && !m_bDragging)
        {
            const float len = ccpDistance(m_pContainer->convertTouchToNodeSpace((CCTouch*)m_pTouches->objectAtIndex(0)),
                                          m_pContainer->convertTouchToNodeSpace((CCTouch*)m_pTouches->objectAtIndex(1)));
            this->setZoomScale(this->getZoomScale()*len/m_fTouchLength);
        }
    }
    return kCCTouchMoved;
}

void CCPageScrollView::ccTouchEnded(CCTouch* touch, CCEvent* event)
{
    if (!this->isVisible())
    {
        return;
    }
	
    
    if (m_pTouches->containsObject(touch))
    {
        if (m_pTouches->count() == 1 )
        {
            if(!m_bTouchMoved&&!isPaged()){
                
            }else if(!m_bTouchMoved&&isPaged()){
                int page = __getClickedPage(touch->getLocation());
                if(page == m_currPage){
//                    CCLog("go into page %d",page);
                }
                    this->scrollToPage(page);
                
            }
            else{
                this->schedule(schedule_selector(CCPageScrollView::deaccelerateScrolling));
			}
        
        }
        m_pTouches->removeObject(touch);
    }
    
    if (m_pTouches->count() == 0)
    {
        m_bDragging = false;
        m_bTouchMoved = false;
    }
}

void CCPageScrollView::ccTouchCancelled(CCTouch* touch, CCEvent* event)
{
    if (!this->isVisible())
    {
        return;
    }
    m_pTouches->removeObject(touch);
    if (m_pTouches->count() == 0)
    {
        m_bDragging = false;
        m_bTouchMoved = false;
    }
    this->__pageTouchCancel();
}

CCRect CCPageScrollView::getViewRect()
{
    CCPoint screenPos = this->convertToWorldSpace(CCPointZero);
    
    float scaleX = this->getScaleX();
    float scaleY = this->getScaleY();
    
    for (CCNode *p = m_pParent; p != NULL; p = p->getParent()) {
        scaleX *= p->getScaleX();
        scaleY *= p->getScaleY();
    }
    
    // Support negative scaling. Not doing so causes intersectsRect calls
    // (eg: to check if the touch was within the bounds) to return false.
    // Note, CCNode::getScale will assert if X and Y scales are different.
    if(scaleX<0.f) {
        screenPos.x += m_tViewSize.width*scaleX;
        scaleX = -scaleX;
    }
    if(scaleY<0.f) {
        screenPos.y += m_tViewSize.height*scaleY;
        scaleY = -scaleY;
    }
    
    return CCRectMake(screenPos.x, screenPos.y, m_tViewSize.width*scaleX, m_tViewSize.height*scaleY);
}

void CCPageScrollView::registerScriptHandler(int nFunID,int nScriptEventType)
{
    this->unregisterScriptHandler(nScriptEventType);
    m_mapScriptHandler[nScriptEventType] = nFunID;
}
void CCPageScrollView::unregisterScriptHandler(int nScriptEventType)
{
    std::map<int,int>::iterator iter = m_mapScriptHandler.find(nScriptEventType);
    
    if (m_mapScriptHandler.end() != iter)
    {
        m_mapScriptHandler.erase(iter);
    }
}
int  CCPageScrollView::getScriptHandler(int nScriptEventType)
{
    std::map<int,int>::iterator iter = m_mapScriptHandler.find(nScriptEventType);
    
    if (m_mapScriptHandler.end() != iter)
        return iter->second;
    
    return 0;
}

void CCPageScrollView::__pageTouchCancel()
{
	if( !m_bPaged ) return ;
    
	__pageClearTouch();
    
}
void CCPageScrollView::__pageClearTouch()
{
    m_scrollDirection = 0;
    m_bScrollingToPage = false;
}

void CCPageScrollView::scrollToPage(int page,bool animated){
    if(!isPaged()||m_bScrollingToPage) return;
    
    if(page<MIN_PAGE) page = MIN_PAGE;
    else if(page>numOfPages) page = numOfPages;
    
    float curOffset = this->getContentOffset().x;
	float targetOffset =  -(page-1)*this->getPageWidth();
    if(curOffset == targetOffset && m_currPage>0) return;
    m_bScrollingToPage = true;
	float pageDuration = 0.5*fabs(curOffset-targetOffset)/this->getPageWidth();
//    CCLog("scrollToPage:%d  duration:%f  ,targetOffset:%f,curOffset:%f",page,pageDuration,targetOffset,curOffset);
	CCPoint targetPointOffset =  ccp( targetOffset, getContentOffset().y );
    if(animated == false) setContentOffset(targetPointOffset);
	else {
        setContentOffsetInDuration(targetPointOffset, pageDuration);
        this->schedule(schedule_selector(CCPageScrollView::endScrollToPage), pageDuration);
    }
    m_currPage = page ;
}
void CCPageScrollView::endScrollToPage(float dt){
    this->unschedule(schedule_selector(CCPageScrollView::endScrollToPage));
    for(int i=1;i<=this->numOfPages;i++){
        CCNode *node = this->m_pContainer->getChildByTag(i);
        if(node!=NULL){
            float scale = m_minScale;
            if(i==m_currPage )
                scale = m_scaleFactor;
            setNodeScale(node, scale);
        }
    }

    this->__pageClearTouch();
    this->relocateContainer(true);
}

void CCPageScrollView::__scaleCellWhenSelected(){
    if(this->getPageWidth()==0) return;
    
    int offset = this->getContentOffset().x;
    int pageWidth2 = m_pageWidth/2;
    int prePage = fabs((float)offset)/m_pageWidth + 1;//last page index
    int nextPage = prePage + 1; //next page index
    int deltaOffset = abs(abs(offset)%m_pageWidth);
    float delta = 1- deltaOffset/(1.0f*pageWidth2);
    
    if(deltaOffset<=pageWidth2){
        float preScale = delta*(m_scaleFactor-m_minScale)+m_minScale;
        CCNode *node = this->m_pContainer->getChildByTag(prePage);
        setNodeScale(node,preScale);
//        CCLog("prePage:%d,preScale:%f",prePage,preScale);
    }else{
        float nextScale = -delta*(m_scaleFactor-m_minScale)+m_minScale;
        CCNode *node = this->m_pContainer->getChildByTag(nextPage);
        setNodeScale(node,nextScale);
//        CCLog("nextPage:%d,nextScale:%f",nextPage,nextScale);
    }
}

void CCPageScrollView::setCurrPage(int page){
    m_currPage = page;
}
bool CCPageScrollView::isPaged(){
    return m_bPaged;
}

NS_CC_EXT_END

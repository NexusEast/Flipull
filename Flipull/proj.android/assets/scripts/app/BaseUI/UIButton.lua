--
-- Author: moon
-- Date: 2014-07-31 15:51:43
--
local scheduler = require("framework.scheduler")
local UIButton = class("UIButton",
    function( )
        return display.newLayer()
        -- return display.newSprite()
end)

local tag_scheduleNode = 1120

function UIButton:setTouchTime( time )
	self.touchTime = time
end

function UIButton:setJugeMoved( isJugeMoved )
	self.isJugeMoved = isJugeMoved
end

function UIButton:setJudgeDistance( distance )
	self.judgeDistance  =  distance
end
function UIButton:setOnTimeFragment(onTimeFragment)
    self.onTimeFragment = onTimeFragment or self.onTimeFragment
end
function UIButton:setOnTouchLongEnd(onTouchLongEnd)
    self.onTouchLongEnd = onTouchLongEnd or self.onTouchLongEnd
end
function UIButton:setSelected(selected)
    self.isSelected = selected
end

function UIButton:ctor( params  )
	self.image = params.image 
	self.selectImage = params.selectImage 
    self.onClick = params.onClick 
    self.onTouchLong = params.onTouchLong    
    self.onCancel = params.onCancel          --取消回调
    self.onTimeFragment = params.onTimeFragment  --循环回调
    self.onTouchLongEnd = params.onTouchLongEnd  --长按中，手抬起时调用的方法
    self.touchPriority = params.touchPriority
    self.touchRect = params.touchRect
	self.isJugeMoved = false
	self.size = nil
	self.judgeDistance = 10 				--超出这个范围按钮就不操作
	self.beginPoint = ccp( 0, 0 )	--touch begin的位置记录
	self.beginTyime = 0 				--touch begin的时间记录
	self.touchTime = 0.2
    self.isTouchingLong = nil          --是否正在长按
    self.isSelected = nil      --是否正被选中

    echoInfo("~~~~~~~~~~~~~~ UIButton:ctor ~~~~~~~~~~~~~~" )

	if type( params.image ) == "string" then
        self.image = display.newSprite( params.image )
    end

    if type( params.selectImage ) == "string" then
        iself.selectImage = display.newSprite( params.selectImage )
    end

    self.size = self.image:getContentSize()
    if self.touchRect == nil  then
        self.touchRect = self.image:getCascadeBoundingBox()
    end
    self:setContentSize( self.size )
    self:setTouchEnabled(true) -- enable sprite touch
    self:registerScriptTouchHandler(function(event, x, y)
        -- event: began, moved, ended
        -- x, y: world coordinate
        if event == "began" then
        	-- echoInfo("########### UIButton:touch began  ############# " )
            if self.onCancel ~= nil then 
        	   self.onCancel()
            end
			self.beginPoint = ccp( x, y )
			self.beginTime = socket.gettime()
        	-- local rect = CCRect( self:getPositionX(), self:getPositionY(), self.size.width, self.size.height )
        	local rect = self.image:getCascadeBoundingBox()
            if 	self.touchRect:containsPoint( ccp( x, y )) then
            	if rect:containsPoint( ccp( x, y )) then
        		    self.image:setVisible( false )
            	    self.selectImage:setVisible( true )
                    self:setSelected(true)
        			self.beginLongTouch = function()
                        if self.onTouchLong ~= nil then
        				    local pos = ccp( self:getPositionX(), self:getPositionY() )
        				    self.onTouchLong( pos )
                            self.isTouchingLong = true
    
                            local node = display.newNode() 
                            node:setTag(tag_scheduleNode)
                            self:addChild(node)
                            node:schedule(function()
                                echoInfo("~~~~~~~~~   onTimeFragment ~~~~~~~~~~~" )
                                self.onTimeFragment()
                                end, self.touchTime)
                            echoInfo("~~~~~~~~~   onTimeFragment ~~~~~~~~~~~" )
                            -- self.onTimeFragment()
        			     end
                    end	
                    transition.execute(self, CCDelayTime:create(1), {
                            onComplete = function()
                                self.beginLongTouch()
                            end
                        })
				    return true
                else
                    return false
                end
			else
        	-- echoInfo("###########   not inRect  ############# " )
				return  false
			end
        end

      	if event == "moved" then
        	if self.isJugeMoved then
        		if math.abs(x - self.beginPoint.x) < self.judgeDistance  and  math.abs(y - self.beginPoint.y) < self.judgeDistance  then
        			echoInfo("########### UIButton:touch Move in offset ############# " )
        		else
        			echoInfo("########### UIButton:touch Move not in offset ############# " )
        			self.onCancel()
                    self:onEnded(true)
                    return false
        		end
        	end
	 	elseif event == "ended" then
            self:onEnded()
        end
    end, false, self.touchPriority, false)
	self:setPosition( self.size.width / 2, self.size.height / 2 )
	self:addChild( self.image )
	self:addChild( self.selectImage )
	self.selectImage:setVisible( false )

end

function UIButton:onEnded(isCancel)
    self:stopAllActions()
    if self:getChildByTag(tag_scheduleNode) then  self:removeChildByTag(tag_scheduleNode, true) end

    if self.image and self.isSelected then 
        if self.isTouchingLong and self.onTouchLongEnd then 
            self.onTouchLongEnd()
        elseif not isCancel then 
            self.onClick()
        end

        self.image:setVisible( true )
        self.selectImage:setVisible( false )

        self.isTouchingLong = nil 
        self:setSelected(false)
    end
end

return UIButton

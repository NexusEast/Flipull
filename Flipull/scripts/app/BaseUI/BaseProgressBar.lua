--
-- Author: moon
-- Date: 2014-06-13 11:55:34
--
local Resource = require("app.Misc.Resource")

local BaseProgressBar = class("BaseProgressBar", function( fullName, emptyName, max, min, currentValue, time )
		return display.newLayer() 
	end
	)

function BaseProgressBar:ctor( fullName, emptyName, isRight )
	self.progressBarTimer = nil
	self.progress = nil
	self.emptyProgresss = nil
	self.max = max or 100
	self.min = min or 0 
	self.currentValue =  currentValue or 0
	self.animationTime = time or 0.01

	self.progress = display.newSprite( fullName )
	self.progress:setAnchorPoint( ccp( 0,0 ))
	self.progress:setPosition( self.progress:getContentSize().width / 2, self.progress:getContentSize().height / 2 )
	self.emptyProgress  = display.newSprite( emptyName )
	self.progress:setAnchorPoint( ccp( 0,0 ))
	self:setContentSize( self.emptyProgress:getContentSize() )
	self:addChild( self.emptyProgress )

	self.progressBarTimer = display.newProgressTimer( self.progress, kCCProgressTimerTypeBar )
	self.progressBarTimer:setAnchorPoint( ccp(0.5, 0.5 ))
	self.progressBarTimer:setPosition( self.emptyProgress:getContentSize().width / 2, self.emptyProgress:getContentSize().height / 2 )
	self.progressBarTimer:setOpacity( 255 )
	if isRight then
		self.progressBarTimer:setMidpoint( ccp(1,0) )
	else
		self.progressBarTimer:setMidpoint( ccp(0,0) )
	end
	
	self.progressBarTimer:setBarChangeRate( ccp(1,0))
	self.progressBarTimer:setPosition( self.progress:getPosition() )

	self.emptyProgress:addChild( self.progressBarTimer )
	--self:setCurrentPercent( self.currentValue )
	self.progressBarTimer:setPercentage( self.currentValue )
end

function BaseProgressBar:setAnimationTime( time )
	self.animationTime = time
end

function BaseProgressBar:setScale( scale )
	self.emptyProgress:setScale( scale )
	self.progress:setScale( scale )
end

function BaseProgressBar:getScale( )
	local  scale =	self.emptyProgress:getScale()
	return scale
end


function BaseProgressBar:getCurrentPercent()
	return self.progressBarTimer:getPercentage()
end
function BaseProgressBar:setCurrentPercent( value )
	self.currentValue = value
	if self.currentValue > self.max then
		self.currentValue = self.max
	end

	if self.currentValue < self.min then
		self.currentValue = self.min
	end

	local progressPercent = 0
	if self.currentValue <= self.max then
		progressPercent = self.currentValue / self.max * 100
		if progressPercent > 100 then
			progressPercent = 100
		end
		--action
		local to = CCProgressTo:create( self.animationTime, progressPercent )
		self.progressBarTimer:runAction( to )
		-- self.progressBarTimer:setPercentage( progressPercent )
	end
end


function BaseProgressBar:setPercentage( value )
	self.progressBarTimer:setPercentage( value )
end


return BaseProgressBar




--
-- Author: yyj
-- Date: 2014-04-30 17:13:48
--
local TabButton = class("TabButton", 
	function () return display.newLayer() end)


TAG_ACTION_DOWN = 0x01
TAG_ACTION_UP = 0x02
function TabButton:ctor()
	-- echoInfo("TabButton ctor")
    self:setNodeEventEnabled(true)
	self.targetCallback= nil
	self.responseRect = nil --响应范围 相对于整个屏幕
	self.enabled = true --是否可用
	self.visible = true --是否可见
	self.selected = true --是否被选中
	self.image = nil
	self.imageSelected = nil
	self.listener = nil
	self.downAction = nil
	self.upAction = nil
	self.contentSize_ = nil

end

function TabButton:setListener(listener)
	self.listener = listener 
end
function TabButton:getUpAction()
	if self.upAction then 
		-- echoInfo("self.upAction:%s",self.upAction)
		local action =  self.upAction:copy()
		return action
	end
	return self.upAction 
end
function TabButton:getDownAction()
	if self.downAction then 
		-- echoInfo("self.downAction:%s,%s",tolua.type(self.downAction),tolua.isnull(self.downAction))

		local action = self.downAction:copy()
		return action
	end
	return self.downAction 
end
function TabButton:getContentSize()
	return contentSize
end
function TabButton:setContentSize(size)
	self.contentSize_ = size
	return self
end
function TabButton:getBoundingBox()
	if self:isSelected() and self.imageSelected  and not self.downAction  then 
		--被选中；有被选中图片；没有按下动画
		return self.imageSelected:getBoundingBox()
	else
		return self.image:getBoundingBox()
	end
end

function TabButton:isEnabled()
	return self.enabled 
end
function TabButton:setEnabled( enabled)
		self.enabled= enabled
end
function TabButton:setVisible( visible)
	self.visible= visible
end
function TabButton:isVisible()
	return self.visible
end
function TabButton:setSelected()
	if not self.selected then 
		self.selected = true
		if not self.downAction then
			if self.imageSelected and not self.imageSelected:isVisible() then 
				self.imageSelected:setVisible(true)
			end
			if self.image and self.image:isVisible() then 
				self.image:setVisible(false)
			end
		else
			if self.image  and self.downAction  then 
				if self.image:getActionByTag(TAG_ACTION_UP) then 
					self.image:stopActionByTag(TAG_ACTION_UP )
				end
				if not self.image:getActionByTag(TAG_ACTION_DOWN) then
					local action = self:getDownAction()
					self.image:runAction(action)
				end
			end
		end
	end
end
function TabButton:isSelected()
	return self.selected
end
function TabButton:unselected()
	if self.selected then 
		self.selected = false
		if not self.downAction  then --没有按下动画，则替换显示图片
			-- echoInfo("unSelected ")
			if self.imageSelected and self.imageSelected:isVisible() then 
				self.imageSelected:setVisible(false)
			end
			if self.image and not self.image:isVisible() then 
				self.image:setVisible(true)
			end
		else -- 有按下动画，则逆动画还原
			if self.image  and self.upAction  then
				if self.image:getActionByTag(TAG_ACTION_DOWN) then
					self.image:stopActionByTag(TAG_ACTION_DOWN )
				end
				if not self.image:getActionByTag(TAG_ACTION_UP ) then 
					self.image:runAction(self:getUpAction())
				end
			end
		end
	end
end

--[[
targetCallback= nil
responseRect = nil --响应范围 相对于整个屏幕
enabled = true --是否可用
visible = true --是否可见
selected = false --是否被选中
image = nil
imageSelected = nil
listener = nil
sound
downAction = CCAction 按下时的动画，若有这个则不用定义imageSelected了
upAction = CCAction 与downAction配套使用,这两个action都必须使用绝对变化，不能使用相对变化
]]
function TabButton:onExit()
	if self.downAction  and self.upAction then 
		self.downAction:release()
		self.upAction :release()
	end
end
function TabButton:initWithParams(params,touchPriority)
	assert(params.image ~= nil,
           "[app.BaseUI.TabButton] initWithParams() image cannot be nil")
	self.sound = params.sound
	self.listener  = params.listener 
	self.downAction = params.downAction 
	self.upAction = params.upAction 
	self.image = params.image
	self.imageSelected  = params.imageSelected 
	if self.downAction  and self.upAction then
		self.downAction:retain()
		self.upAction:retain()
		self.downAction:setTag(TAG_ACTION_DOWN )
		self.upAction:setTag(TAG_ACTION_UP )
	end

	local x,y = params.x or 0 ,params.y or 0

	self:setPosition(x,y)
	if self.imageSelected and not self.downAction then 
		self.imageSelected:setAnchorPoint(CCPoint(0.5, 0.5))
		self:addChild(self.imageSelected )
	end
	self.image:setAnchorPoint(CCPoint(0.5, 0.5))
	self:addChild(self.image)
	self:unselected()

	local began = false -- 是否响应了按下操作
	local function onTouch(eventType , x, y )
		if eventType == "began" then
			if not self:isEnabled() or not self:isVisible() or self:isSelected() then return false end
			if not self:getBoundingBox():containsPoint(self:convertToNodeSpace(ccp(x, y))) then 
				-- echoInfo("touchOut")
				return false
			end
			self:setSelected()
			if self.sound then 
				-- echoInfo("play sound click")
				audioex.playSound(self.sound) 
			end
			began = true
			return self:isSelected()
		elseif eventType == "moved" then 
			if not self:getBoundingBox():containsPoint(
				self:convertToNodeSpace( CCPoint(x, y))) then 
				self:unselected()
			elseif began and not self:isSelected() then 
				self:setSelected()
			end
		elseif eventType == "ended" then 
			began = false
			if self:isSelected() then 
				self.listener(self:getTag())
			end
		end
	end

	self.listener = params.listener
	self.responseRect = params.responseRect

	touchPriority = touchPriority or 0
	self:setTouchEnabled(true)
	self:registerScriptTouchHandler(onTouch, false, touchPriority, false)

	local contetSize =self.image:getContentSize()
	if self.imageSelected then 
		local size = self.imageSelected:getContentSize()
		if contetSize.width < size.width  then contetSize.width=size.width end
		if contetSize.height < size.height  then contetSize.height=size.height end
 	end
 	self:setContentSize(contetSize)
 end

function TabButton:create(params,touchPriority)
	assert(type(params) == "table",
           "[app.BaseUI.CCTabButton] create() invalid params")
	local TabButton = TabButton:new()
	if TabButton then 
		TabButton:initWithParams(params, touchPriority)
	end

	return TabButton
end


return TabButton
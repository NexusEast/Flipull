--
-- Author: yyj
-- Date: 2014-04-30 17:13:48
--
local Button = class("Button", 
	function () return display.newLayer() end)


function Button:ctor()
	self.targetCallback= nil
	self.responseRect = nil --响应范围 相对于整个屏幕
	self.enabled = true --是否可用
	self.visible = true --是否可见
	self.selected = false --是否被选中
	self.image = nil
	self.imageSelected = nil
	self.listener = nil
end

function Button:isEnabled()
	return self.enabled 
end
function Button:setEnabled( enabled)
	self.enabled= enabled
end
function Button:setVisible( visible)
	self.visible= visible
end
function Button:isVisible()
	return visible
end
function Button:setSelected()
	if not self.selected then 
		self.selected = true
		if self.imageSelected and not self.imageSelected:isVisible() then 
			self.imageSelected:setVisible(true)
		end
		if self.image and self.image:isVisible() then 
			self.image:setVisible(false)
		end
	end
end
function Button:unselected()
	if self.selected then 
		self.selected = false
		if self.imageSelected and self.imageSelected:isVisible() then 
			self.imageSelected:setVisible(false)
		end
		if self.image and not self.image:isVisible() then 
			self.image:setVisible(true)
		end
	end
end

function Button:initWithParams(params,touchPriority)
	assert(params.image ~= nil,
           "[app.BaseUI.Button] initWithParams() image cannot be nil")
	local image = params.image
	local imageSelected = params.imageSelected

	if tolua.type(image) == "CCNode" then 
		--若是自定义
	end


	--正常的 传图片路径，或者CCSprite
	--若没有传seleted 默认按下效果为变暗
	if params.imageSelected == nil then 
		if image  then 
			if type(image)=="string" then
				imageSelected = display.newSprite(image)
				image = display.newSprite(image)
			else
				imageSelected = display.newSprite(image:getDisplayFrame())
			end
			if imageSelected then
				imageSelected:setColor(ccc3(100, 100, 100))
			end
		end
	else 
		if type(imageSelected) == "string" then 
			imageSelected = display.newSprite(imageSelected)
		end
	end

	local x,y = params.x or 0 ,params.y or 0

	self:setPosition(x,y)

	self.image = image
	self.imageSelected = imageSelected
	self:addChild(self.image)
	self:addChild(self.imageSelected)
	self.imageSelected:setVisible(false)

	self:setContentSize(image:getContentSize())
	printRect(self:getBoundingBox())

	local begin = {x=0,y=0}
	local function onTouch(eventType , x, y )
		if not self:isEnabled() then return false end
		if eventType == "began" then
			echoInfo("Button onTouch began  ,%s,%s",x,y)
			begin.x=x
			begin.y=y
			echoInfo("%s",self.responseRect)
			if self.responseRect and self.responseRect:containsPoint(ccp(x, y)) then
				self:setSelected()
			end
			return self.selected
		elseif eventType == "moved" then 
			echoInfo("Button onTouch moved ,%s,%s",x,y)
			if math.abs(begin.x-x)>50 or math.abs(begin.y-y) >50 then
				--移动超过50像素，视为滑动
				self:unselected()
			end
		elseif eventType == "ended" then 
			echoInfo("Button onTouch ended  ,%s,%s",x,y)
			if self.selected then 
				echoInfo("click CCBUtton")
				self:unselected()
				self.listener()
			end
		end
	end
	self.listener = params.listener
	self.responseRect = params.responseRect
 
	self:setTouchEnabled(true)
	self:registerScriptTouchHandler(onTouch, false, touchPriority, false)
end

function Button.create(params,touchPriority)
	assert(type(params) == "table",
           "[app.BaseUI.CCButton] create() invalid params")
	local button = Button:new()
	if button then 
		button:initWithParams(params, touchPriority)
	end

	return button
end


return Button
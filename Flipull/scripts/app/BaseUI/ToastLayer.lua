--
-- Author: yyj
-- Date: 2014-06-10 19:33:41
--

ToastLayer = class("ToastLayer", function()
	return display.newNode() end
	)

tag_toast = 0x21355

ToastLayer.LEFT = 0x01
ToastLayer.CENTER = 0x02
ToastLayer.RIGHT = 0x03
--layer 加到哪一个layer上
--toastParam = {
--	pos = ccp(0,0) --相对于中心坐标的位置
--  delay = 1 --延时消失
--  align = ToastLayer.LEFT --对齐方式
--}
--param = {
--isDark = false,
--bgFile,
--offset=ccp(0,0)
--size = 字大小,
--}
--sample: ToastLayer.showToast("任务未完成")
function ToastLayer.showToast(message,layer,toastParam,param)
	toastParam = toastParam or {}
	param = param or {}
	local scene = layer or CCDirector:sharedDirector():getRunningScene()
	echoInfo("#############show toast %s############",message)
	if scene then 
		local toast = scene:getChildByTag(tag_toast)
		if toast then 
			toast:removeFromParentAndCleanup(true)
		end
		local delay = toastParam.delay or 1
		local bgFile = nil 
		local baseSize = CCSize(205,100)
		local alignX = toastParam.align or ToastLayer.CENTER
		
		toast = ToastLayer.new(message,param)
		pos = toastParam.pos 
		local algins = {toast.bg:getContentSize().width/2,0,-toast.bg:getContentSize().width/2}
		if pos then
			pos = ccp(pos.x-display.cx+algins[alignX], pos.y-display.cy) 
			toast:setPosition(pos) 
		end


		scene:addChild(toast, tag_toast , tag_toast)

		local array = CCArray:create()
		array:addObject(CCDelayTime:create(delay))
		array:addObject(CCCallFunc:create(function() toast:fadeOut(time) end))
		array:addObject(CCDelayTime:create(0.5))
		array:addObject(CCCallFunc:create(function() toast:removeFromParentAndCleanup(true) end))
		local action = CCSequence:create(array)
		toast:runAction(action)
	end
end

function ToastLayer.isToast(layer)
	local scene = layer or CCDirector:sharedDirector():getRunningScene()
	if scene then
		return scene:getChildByTag(tag_toast )
	end
	return false
end

function ToastLayer.removeToast(layer)
	local scene = layer or CCDirector:sharedDirector():getRunningScene()
	if scene then 
		if scene:getChildByTag(tag_toast) then 
			scene:removeChildByTag(tag_toast , true)
		end
	end
end

function ToastLayer:fadeOut(time)
	local array = self:getChildren()
	for i=0,array:count()-1 do
		local node = array:objectAtIndex(i)
		node:runAction(CCFadeOut:create(0.5))
	end
end

function ToastLayer:ctor(message,params)
	if not message or string.len(message)<=0 then echoInfo("invalid message") return end
	local isDark = params.isDark or false
	local baseSize = params.baseSize or CCSize(205, 100)
	local offset = params.offset or ccp(0, 0)
	local bgFile = params.bgFile or Resource.Tip.tipBg
	local size = params.size or 22
	local color = params.color or display.COLOR_RED
	local anchorpoint = params.anchorpoint 
	if isDark then
		self:setMaskColor()
	end

    local text = baseUI.newTTFLabel({
        text = message,
        color = color,
        align = ui.TEXT_ALIGN_CENTER,
        size = size,
        x = display.cx+offset.x,
        y = display.cy+offset.y,
        }):addTo(self)

    local width,height = baseSize.width or 205, baseSize.height or 100 
    if width<text:getContentSize().width then width = text:getContentSize().width+50 end
    if height < text:getContentSize().height then height = text:getContentSize().height end
    bgFile = bgFile or Resource.Tip.tipBg
    local bg = display.newScale9Sprite(bgFile, display.cx, display.cx, CCSize(width,height))
    bg:setPosition(display.cx, display.cy)
    self.bg = bg
    self:addChild(bg, -1)
end


return ToastLayer

--
-- Author: yyj
-- Date: 2014-04-24 12:42:54
--
local pub = require("app.Utitls.pub")
local BaseLayer = require("app.BaseUI.BaseLayer")
local TCPConnector = require("app.Utitls.TCPConnector")
local PushLayer = class("PushLayer", 
	function(args)
        return  BaseLayer.new(args)
	end
)

--
g_pushLayer_touchPriority =kCCMenuHandlerPriority -1
g_pushLayer_touchPriority_increment =-10 --每次push layer时的优先级增量

g_pushLayerPools = {} --pushLyaer池，记录当前注册的所有pushLayer

tag_mask = 17102 
tag_touchLayer = 17103

--获取当前pushLyaer池中的layer数量
function getPushLayerCounts()
	local removeList = {}
	for pos,value in ipairs(g_pushLayerPools) do
		local layer = tolua.cast(value, "CCLayer")
		if layer == nil then 
			-- table.remove(g_pushLayerPools,pos)
			removeList[pos] = true
		end
	end
	if #removeList > 0 then 
		for i = #g_pushLayerPools, 1, -1 do
    	    if removeList[i] then
    	        table.remove(g_pushLayerPools, i)
    	    end
    	end
    end
	local counts = table.nums(g_pushLayerPools)
	-- echoInfo("current pushLayer counts : "..counts)
	return counts
end


--一些通用的按钮设置

--设置关闭按钮
--此方法会用到self.bg
--[[params={
	pos = ccp(0,0),
    image = Resource.UIButton.close,--可选，此为默认值
    imageSelected = Resource.UIButton.closeSelected,
    callback = function() self:onClose() end,--回调，默认关闭界面
    sound = Resource.Sound.buttonTap 默认声音
}
]]
function PushLayer:setCloseBtn(params)
	params = params or {}
	local image = params.image or Resource.UIButton.close
	local imageSelected = params.imageSelected or Resource.UIButton.closeSelected
	local callback = params.callback or function() self:onClose() end
	local pos = params.pos  or ccp(self.bg:getContentSize().width-18,self.bg:getContentSize().height-11)

	 local closeItem = baseUI.newImageMenuItem({
      image = image,
      imageSelected = imageSelected,
      listener =callback,
      sound = params.sound,
      })
    closeItem:setPosition(pos)

    local menu = baseUI.newMenu({closeItem},self:getTouchPriority()):addTo(self.bg)
end

--设置返回按钮
--frameBg 要添加到的背景图片，必须传
--[[
params = {
	pos = ccp(0,0),
    image = Resource.UIButton.btnBack,--可选，此为默认值
    imageSelected = Resource.UIButton.btnBackSelect,
    callback = function() self:onClose() end,--回调，默认关闭界面
    sound = Resource.Sound.buttonTap 默认声音
}
]]
function PushLayer:setGobackBtnOnBg(frameBg,params)
	params = params or {}
	local image = params.image or Resource.UIButton.btnBack
	local imageSelected = params.imageSelected or Resource.UIButton.btnBackSelect
	local callback = params.callback or function()
        --Newbie:nextNumAndCleanByActiveItem(self.guideType,"ITEM_Close")
        self:onClose()
    end
	local pos = params.pos  or ccp(10,frameBg:getContentSize().height-10)

	local backItem = baseUI.newImageMenuItem({
        image = image,
      	imageSelected = imageSelected,
        listener =   callback,
        sound = params.sound,
        })
    backItem:setPosition(pos)
    baseUI.newMenu({backItem}, self:getTouchPriority()):addTo(frameBg)
    self.NewbieItems["ITEM_Close"] = backItem
end

--在屏幕左上角设置返回按钮
--[[
params = {
	pos = ccp(0,0),
    image = Resource.UIButton.btnBack,--可选，此为默认值
    imageSelected = Resource.UIButton.btnBackSelect,
    callback = function() self:onClose() end,--回调，默认关闭界面
    sound = Resource.Sound.buttonTap 默认声音
}
]]
function PushLayer:setGobackBtnOnLeftTop(params)
	params = params or {}
	local image = params.image or Resource.UIButton.btnBack
	local imageSelected = params.imageSelected or Resource.UIButton.btnBackSelect
	local callback = params.callback or function()
        --Newbie:nextNumAndCleanByActiveItem("ITEM_Close")
        --Newbie:nextNumAndCleanByActiveItem(self.guideType,"ITEM_Close")
        self:onClose()
    end

	local backItem = baseUI.newImageMenuItem({
        image = image,
      	imageSelected = imageSelected,
        listener =   callback,
        sound = params.sound,
        })
	local pos = params.pos  or ccp(37,display.height - 37)
	--ccp(backItem:getContentSize().width/2+2,display.height- backItem:getContentSize().height/2-2)
    backItem:setPosition(pos)
    baseUI.newMenu({backItem}, self:getTouchPriority()):addTo(self)
    self.NewbieItems["ITEM_Close"] = backItem
end

function PushLayer:ctor()
    echoInfo("PushLayer:ctor")
    self.NewbieItems = {}
    self.guideType = nil --新手指引类型
    self.tcpConnections = {}
	self.ocAnimation = nil --是否开关动画
	self.isOpen = nil 
	self.boundingbox_  = nil
    self:setNodeEventEnabled(true)
	self:setTouchPriority(self._upPriority())
	-- echoInfo("PushLayer m_touchPriority=%s",self.m_touchPriority)
	self:_pingbi()
	-- echoInfo("self.touchPriority:%s",self:getTouchPriority())
	
end

--设置开关动画默认关闭
--在addChild之前调用
--若设置为开，则关闭layer时必须调用onClose()方法
function PushLayer:setOCAnimation(enable)
	self.ocAnimation = enable
end

function PushLayer:onEnter()
	BaseLayer.onEnter(self)
	echoInfo("PushLayer onEnter touchPriority=%s , %s",self:getTouchPriority(),self)

	table.insert(g_pushLayerPools, self)

	if self.guideType ~= nil then 
		self:performWithDelay( function()
--            if not g_guideIsFresh then
--                GuideManager:begin_Guide(self.guideType)
--            else
--                FreshManCtrl:begin_Guide(self.guideType,self)
--            end
		end, 0.5)
        echoInfo("have self.guideType")
    else
        echoInfo("have no self.guideType")
	end

	if self.ocAnimation and not self.isOpen then 
		--播放弹窗弹出时的音效
        audioex.playSound(Resource.Sound.common_popup_window)
		local array = self:getChildren()
		for i=0,array:count()-1 do
			local node = array:objectAtIndex(i)
			if node:getTag()~=tag_mask then 
				--只有不是蒙层，才播放动画
				node:setScale(0)
				transition.execute(node , CCScaleTo:create(0.2, 1),
							{
   								easing = "backOut",
   								onComplete = function()
   								end,
							}
						)
			end
		end
	end
end

function PushLayer:closeAllTcpConnection()
    echoInfo("PushLayer:closeAllTcpConnection() self=%s",tostring(self))
    for i, v in ipairs(self.tcpConnections) do
        if iskindof(v,"TCPConnector") then
            v:close()
        else
            echoInfo("PushLayer:closeAllTcpConnection not iskindof TCPConnector")
        end
    end
end

function PushLayer:insertTcpConnection(var)
    if var then
        table.insert(var, self.tcpConnections)
    else
        echoError("PushLayer:addTcpConnection invalid param")
    end
end

function PushLayer:removeTcpConnection(var)
    local funcRemove = function(v)
        return (v == var)
    end
    local tblRemain, tblRemove = pub.removeElementFromTable(self.tcpConnections, funcRemove)
    self.tcpConnections = tblRemain
end


--删除当前pushLayer池中的一个pushLayer
function _removePushLayerFromePool(layer)
	for pos,value in ipairs(g_pushLayerPools) do 
		if value == layer then 
			table.remove(g_pushLayerPools,pos)
		end
	end
	-- dump(g_pushLayerPools)
end

function PushLayer:onExit()
	--BaseLayer.onExit(self)
	echoInfo("PushLayer onExit ")
    self:closeAllTcpConnection()
    BaseLayer.onExit(self)

	_removePushLayerFromePool(self)
end
function PushLayer:onClose()
	if self.ocAnimation then 
		-- local array = CCArray:create()
		-- array:addObject(CCScaleTo:create(0.2, 0))
		-- array:addObject(CCCallFunc:create(function()
		-- 	self:removeFromParentAndCleanup(true)
		-- 	end))
		-- self:runAction(CCSequence:create(array))
        audioex.playSound(Resource.Sound.common_close_popup_window)
		local array = self:getChildren()
		for i=0,array:count()-1 do
			local node = array:objectAtIndex(i)
			if node:getTag()~=tag_mask then 
				--只有不是蒙层，才播放动画
				transition.execute(node , CCScaleTo:create(0.2, 0), 
							{
   								easing = "backIn",
   								onComplete = function()
   					   				self:removeFromParentAndCleanup(true)
   								end,
							}
						)
			end
		end
	else
		self:removeFromParentAndCleanup(true)
	end
end
function PushLayer:onCleanup()
	echoInfo("PushLayer onCleanup")
    self._downPriority()
end

function PushLayer:onEnterTransitionFinish()
	-- echoInfo("PushLayer onEnterTransitionFinish()")
end

function PushLayer:onExitTransitionStart()
	-- echoInfo("PushLayer onExitTransitionStart()")
end

--设置背景蒙层颜色，有默认颜色
function PushLayer:setMaskColor(color)
	color = color or ccc4(13, 13, 25, 100)
	if self:getChildByTag(tag_mask)  then
		self:removeChildByTag(tag_mask , true)
	end
	local colorLayer = display.newColorLayer(color)
	self:addChild(colorLayer, -10, tag_mask)
end


function printRect(rect)
	echoInfo("(%s,%s,%s,%s)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height)
end

--设置是否关闭弹窗，当触摸到非弹窗区域时
--rect 弹窗区域
--isReverse 反转，即触摸到rect区域关闭弹窗
--func 自定义响应方法
function PushLayer:setTouchClosed(enable,rect,isReverse,func)
	if enable then 
		local touchLayer = self:getChildByTag(tag_touchLayer)
		if  touchLayer==nil then
			touchLayer = display.newLayer()
			self:addChild(touchLayer, -1, tag_touchLayer)
		else
			touchLayer = tolua.cast(touchLayer, "CCLayer")
		end

		self.boundingbox_ = rect or self.boundingbox_ or CCRect(display.cx-display.width/4,
											display.cy-display.height/4,
											display.width/2,
											display.width/2
											)
		LogHelper.printRect(self.boundingbox_,"rect ")
		touchLayer:setTouchEnabled(true)
		touchLayer:registerScriptTouchHandler(function(touch ,x,y)
			echoInfo("touch move")
			if touch == "began" then 
				if self.boundingbox_  then 
					if ( isReverse and self.boundingbox_:containsPoint(ccp(x, y)) )
						or (not isReverse and not self.boundingbox_:containsPoint(ccp(x, y))) then 
						-- echoInfo("touch touchLayer closed ")
						if func then 
							func()
						else
							-- self:removeFromParentAndCleanup(true)
							self:onClose()
						end
					end
				end
				return false
			end
		end, false, self:getTouchPriority(), false)
	else
		local touchLayer = self:getChildByTag(tag_touchLayer)
		if  touchLayer then
			touchLayer = tolua.cast(touchLayer, "CCLayer")
			touchLayer:setTouchEnabled(false)
		end
	end
end

--屏蔽此layer 层以下的层
function PushLayer:_pingbi(  )
	self:setTouchEnabled(true)
    self:registerScriptTouchHandler(
        function ( event,x,y )
            -- echoInfo("#################     截断触屏  %s    #######################",event)
            return true
        end,
         false, self:getTouchPriority()+2   , true)
end

--提升优先级
--与降低优先级配套使用
function PushLayer._upPriority(  )
	g_pushLayer_touchPriority = g_pushLayer_touchPriority+g_pushLayer_touchPriority_increment 
	echoInfo("pushPriority:%s",g_pushLayer_touchPriority );
	return g_pushLayer_touchPriority 
end
--降低优先级
--与提升优先级配套使用
function PushLayer._downPriority( )
	g_pushLayer_touchPriority  = g_pushLayer_touchPriority-g_pushLayer_touchPriority_increment 
	echoInfo("downPriority:%s",g_pushLayer_touchPriority );
	return g_pushLayer_touchPriority 
end

return PushLayer
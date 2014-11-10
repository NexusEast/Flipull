--
-- Author: yyj
-- Date: 2014-05-23 14:48:31
--
TabLayerDef = require("app.BaseUI.TabLayerDef")
TabButton = require("app.BaseUI.TabButton")
require("app.BaseUI.BaseUI")
local TabLayer = class("classname", function()
	return display.newLayer() end
	)
 
TabLayer.ALIGN_VERTICAL_TOP = 0x00; --默认排列顺序为顶部到底部
TabLayer.ALIGN_VERTICAL_CENTER = 0x01;
TabLayer.ALIGN_VERTICAL_BOTTOM = 0x02;
TabLayer.ALIGN_VERTICAL_TOP_BTT = 0x03;--排列顺序为底到顶部
TabLayer.ALIGN_VERTICAL_CENTER_BTT = 0x04;
TabLayer.ALIGN_VERTICAL_BOTTOM_BTT = 0x05;
TabLayer.ALIGN_HORIZONTAL_LEFT = 0x06; -- 默认排列顺序为左到右
TabLayer.ALIGN_HORIZONTAL_RIGHT = 0x07;
TabLayer.ALIGN_HORIZONTAL_CENTER = 0x08;
TabLayer.ALIGN_HORIZONTAL_LEFT_RTL = 0x09; -- 排列顺序为右到左
TabLayer.ALIGN_HORIZONTAL_RIGHT_RTL = 0x0a;
TabLayer.ALIGN_HORIZONTAL_CENTER_RTL = 0x0b;
TabLayer.ALIGN_CUSTOM = 0x0c; -- 自定义布局

--[[
params 是一个table，里面元素类型为TabLayerDef

]]
-- TabLayer.initTabIndex = 0
-- TabLayer.m_TabMenu = nil
-- TabLayer.currentSelectedTabIndex = -1
-- TabLayer.maxSizeRect = CCRect(0, 0, 0, 0)
-- TabLayer.align = ALIGN_HORIZONTAL_CENTER
-- TabLayer.LayerDefs = nil
-- TabLayer.offset = nil 
-- TabLayer.isMultipleExist 是否有标签页共存
-- TabLayer.multipleExistIndexs={{index1,index2},{index3,index4}  } 
		--multipleExistIndexs[1]和multipleExistIndexs[2]的index可以共存
-- TabLayer.currentExistIndexs={index1,index3} --当前同时存在的标签选项卡 

function TabLayer:create(LayerDefs,params,touchPriority)--background,align,offset,index)
	-- echoInfo("TabLayer create")
	local tabLayer = TabLayer.new(LayerDefs,params,touchPriority)--background,align,offset,index)
	return tabLayer
end

function TabLayer:ctor(LayerDefs,params,touchPriority)--background,align,offset,index)
	-- echoInfo("TabLayer ator")
	if touchPriority then 
		self:setTouchPriority(touchPriority)
	end
	self.initTabIndex = 1
	self.m_TabMenu = nil -- 按钮层
	self.currentSelectedTabIndex = -1 --当前显示的标签页index
	-- self.maxSizeRect = CCRect(0, 0, 0, 0)
	self.align = ALIGN_HORIZONTAL_CENTER
	self.LayerDefs = nil
	self.offset = nil 
	self.padding = nil 
	self.tabButtons = {}

	self.LayerDefs = LayerDefs
	--集中定义每个标签页相同的属性
	if params.upAction or params.downAction or params.isClearPage or params.sound then 
		for i=1,#self.LayerDefs do 
			local def = self.LayerDefs[i]
			if params.upAction then def.upAction = params.upAction end
			if params.downAction then def.downAction = params.downAction end
			if params.isClearPage then def.isClearPage = params.isClearPage end
			if params.sound then def.sound = params.sound end
		end
	end
	if params.isShareLayer then 
		local callback = params.layerSwitch
		for i=1,#self.LayerDefs do 
			local def = self.LayerDefs[i]
			def.isShareLayer = true
			def.layerSwitch= callback
			if i == 1 then
				def.originIndex = 1
				def.currentIndex = 1
			else 
				def.shareFromIndex = 1
			end
		end
	end
-- 设置可多选
	self.isMultipleExist = params.isMultipleExist
	if self.isMultipleExist then 
		self.currentExistIndexs={}
		self.multipleIndexs = {}
		self.alone = {}
		self.multipleExistIndexs = params.multipleExistIndexs
		for i = 1,#self.multipleExistIndexs do 
			for j=1,#self.multipleExistIndexs[i] do
				self.multipleIndexs[self.multipleExistIndexs[i][j]]=true
			end
		end
		for i=1,#(self.LayerDefs) do
			if not self.multipleIndexs[i] then 
				self.alone[i]=true
			end
		end
	end

	local buttons = self.tabButtons

	self.align=params.align or self.align;
	self.initTabIndex = params.index or self.initTabIndex
	offset = params.offset or CCPoint(0, 0)
	self.padding = params.padding or CCPoint(10, 10)

	-- local background = params.background
	-- if background and type(background) == "string" then 
	-- 	local bgSprite = display.newSprite(background, display.cx, display.cy):addTo(self, -1, 0)
	-- end
	
	self.m_TabMenu = display.newLayer() --ui.newRectMenu({})
	self.m_TabMenu:setPosition(0, 0);
	self:addChild(self.m_TabMenu)
	
	self.TabItemCallBack = function(tag)
		for i=1,#self.LayerDefs do 
			local layerDef = self.LayerDefs[i]
			local temp = self.m_TabMenu:getChildByTag(i)

			if  i == tag then
				echoInfo("tabItemCallback i = %s  tag = %s",i,tag)
 				if not temp:isSelected() then 
 					temp:setSelected()
 				end
 				
 				local sound = layerDef:getSound()
				-- if sound then 
				-- 	global.m.playEffect(sound)
				-- end

				--找到是否有要还原的标签页
				local indexsToUnSesected={}
				if self.isMultipleExist then
					local isFinish = false
					if self.alone[i] or self.alone[self.currentSelectedTabIndex] then 
						--是独自一人
						--当前选中的时独自一人
						indexsToUnSesected=self.currentExistIndexs
					else
						for key,indexs in ipairs(self.multipleExistIndexs) do
							for k,index in ipairs(indexs) do
								if index == i then -- 找到了当前要显示的标签页属于可共存标签页 
									for kk,indexx in ipairs(indexs) do
										if indexx ~= i and self.currentExistIndexs[indexx] then
											indexsToUnSesected[indexx]=true
										end
									end
									isFinish= true
									break
								end
							end		
							if isFinish then break end
						end
					end
				end
 
				local unSelectedNode = layerDef:getUnSelectedNode()

				if self.isMultipleExist  then 
					dump(indexsToUnSesected)
					
					for index,val in pairs(indexsToUnSesected) do
						echoInfo("index:%s",index)
						self.currentExistIndexs[index]=nil
						local lastSelectedItem = self.m_TabMenu:getChildByTag(index)
						if lastSelectedItem then lastSelectedItem:unselected() end
					end
						
					-- self.currentExistIndexs[i]=true 
				elseif not self.isMultipleExist and self.currentSelectedTabIndex ~= -1 then
					local lastSelectedItem = self.m_TabMenu:getChildByTag(self.currentSelectedTabIndex)
					lastSelectedItem:unselected()
				end

				if layerDef.isShareLayer then
					--这是共享layer
					local layer =nil
					echoInfo("shargeLayer i= %s, shareFrom:%s, originIndex:%s",
						i,layerDef.shareFromIndex,layerDef.originIndex)
					if layerDef.shareFromIndex then
						--共享于其他的标签页
						local shareLayerDef = self.LayerDefs[layerDef.shareFromIndex]
						local shareLayer = self:getChildByTag(i) or 
								self:getChildByTag(shareLayerDef.currentIndex)
						if not shareLayer then 
							echoInfo("create shareLayer %s",layerDef.shareFromIndex)
							local target = shareLayerDef:getTarget()
							local methodName = shareLayerDef:getInstantiationMethodName()
							local argObjects = shareLayerDef:getArgObjects()
							shareLayer = require(target).new(argObjects)
							self:addChild(shareLayer, 0, i)
						end
						--如果此标签页已经初始化成功
						layer = shareLayer
						layerDef.layerSwitch(layer,i,self.currentExistIndexs)
						layer:setTag(i)
						shareLayerDef.currentIndex = i
					elseif layerDef.originIndex then 
						--如果是共享出去的
						layer = self:getChildByTag(i) or self:getChildByTag(layerDef.currentIndex)
						if not layer then 
							echoInfo("create shareLayer %s",i)
							local target = layerDef:getTarget()
							local methodName = layerDef:getInstantiationMethodName()
							local argObjects = layerDef:getArgObjects()
							layer = require(target).new(argObjects)
							self:addChild(layer, 0, i)
						elseif layerDef.currentIndex ~= layerDef.originIndex then 
							layerDef.currentIndex = layerDef.originIndex
							layer:setTag(i)
						end
						layerDef.layerSwitch(layer,i,self.currentExistIndexs)
					end
					if not layer:isVisible() then 
						layer:setVisible(true)
					end
				elseif unSelectedNode and i ~= self.currentSelectedTabIndex then
					local layer = self:getChildByTag(i)

					if layer  then 
						if not layer:isVisible() then
							echoInfo( "show layer %s",i)
							layer:setVisible(true)
						end
					else
						echoInfo("init layer  %s",i)
						local target = layerDef:getTarget()
						local methodName = layerDef:getInstantiationMethodName()
						local argObjects = layerDef:getArgObjects()
						layer = require(target).new(argObjects)
						self:addChild(layer, 0, i)
					end
					
				end
				if self.currentSelectedTabIndex ~= -1  then 
					local def = self.LayerDefs[self.currentSelectedTabIndex]
					if def and def.isClearPage then 
						echoInfo( "del layer %s",self.currentSelectedTabIndex)
						self:removeChildByTag(self.currentSelectedTabIndex, true)
					else 
						local layer = self:getChildByTag(self.currentSelectedTabIndex)
						if layer then 
							echoInfo( "hide layer %s",self.currentSelectedTabIndex)
							layer:setVisible(false)
						end
					end
					if self.isMultipleExist  then 
						self.currentExistIndexs[i]=true
					end
				elseif self.currentExistIndexs then
					self.currentExistIndexs[i]=true 
				end
				
				if self.currentSelectedTabIndex ~= i then
					self.currentSelectedTabIndex = i
				end
			end
		end
	end

	local elementSize =nil
	for i,layerDef in ipairs(self.LayerDefs) do 
		-- echoInfo("i:%s",i)
		local tempItem = nil;
		local selectedNode  = layerDef:getSelectedNode()
		local unSelectedNode = layerDef:getUnSelectedNode()
		local downAction = layerDef:getDownAction()
		local upAction = layerDef:getUpAction()
		local sound = layerDef:getSound()

		if touchPriority then 
			--给每个标签页设置优先级
			if not layerDef.argObjects then layerDef.argObjects = {} end
			layerDef.argObjects.touchPriority = touchPriority
		end
		
		if unSelectedNode then
			-- echoInfo("create tempItem")
			tempItem= TabButton:create({
				sound = sound,
				image = unSelectedNode,
				imageSelected = selectedNode,
				downAction  = downAction ,
				upAction =upAction ,
				listener= self.TabItemCallBack,
				}, self:getTouchPriority())

			if not elementSize then 
				elementSize = unSelectedNode:getContentSize()
				elementSize.width = elementSize.width + self.padding.x
				elementSize.height = elementSize.height + self.padding.y
				-- echoInfo("elementSize:(%s,%s)",elementSize.width,elementSize.height)
			end
		end

		tempItem:setTag(i)
		buttons[#buttons+1]=tempItem
		self.m_TabMenu:addChild(tempItem)
		-- self.m_TabMenu:setTouchEnabled(true)
		-- self.m_TabMenu:registerScriptTouchHandler(function(touch,x,y)
		-- 	echoInfo("m_TabMenu onTouch")
		-- 	end, false, self:getTouchPriority()-100, false)
		-- self:setTouchEnabled(true)
		-- self:registerScriptTouchHandler(function(touch,x,y)
		-- 	echoInfo("tabLayer onTouch")
		-- 	if touch == "began" then return true end
		-- 	end, false, self:getTouchPriority(), false)
		local switch = {
			[TabLayer.ALIGN_HORIZONTAL_LEFT] = function()
				tempItem:setPosition(elementSize.width/2+elementSize.width*(i-1)+offset.x,
					elementSize.height/2+offset.y)
			end,
			[TabLayer.ALIGN_HORIZONTAL_CENTER] = function()
				tempItem:setPosition(elementSize.width/2+elementSize.width*(i-1)+offset.x,
					elementSize.height/2+offset.y)
				local totalWidth = (elementSize.width+offset.x)*(#LayerDefs)
				local diffs = display.width-totalWidth
				self.m_TabMenu:setPositionX(diffs/2.0)
			end,
			[TabLayer.ALIGN_HORIZONTAL_RIGHT] = function()
				tempItem:setPosition(elementSize.width/2+elementSize.width*(i-1)+offset.x,
					elementSize.height/2+offset.y)
				local totalWidth = (elementSize.width+offset.x)*#LayerDefs
				local diffs = display.width-totalWidth
				self.m_TabMenu:setPositionX(diffs)
			end,
			[TabLayer.ALIGN_HORIZONTAL_LEFT_RTL] = function()
				tempItem:setPosition(display.width- elementSize.width/2-elementSize.width*(i-1)+offset.x,
					elementSize.height/2+offset.y)
				local totalWidth = (elementSize.width+offset.x)*(#LayerDefs)
				local diffs = display.width-totalWidth
				self.m_TabMenu:setPositionX(-diffs)
			end,
			[TabLayer.ALIGN_HORIZONTAL_CENTER_RTL] = function()
				tempItem:setPosition(display.width- elementSize.width/2-elementSize.width*(i-1)+offset.x,
					elementSize.height/2+offset.y)
				local totalWidth = (elementSize.width+offset.x)*(#LayerDefs)
				local diffs = display.width-totalWidth
				self.m_TabMenu:setPositionX(-diffs/2.0)
			end,
			[TabLayer.ALIGN_HORIZONTAL_RIGHT_RTL] = function()
				tempItem:setPosition(display.width- elementSize.width/2-elementSize.width*(i-1)+offset.x,
					elementSize.height/2+offset.y)
			end,
			[TabLayer.ALIGN_VERTICAL_TOP] = function()
				tempItem:setPosition(elementSize.width/2+offset.x,
					display.height -elementSize.height/2-elementSize.height*(i-1)+offset.y)
			end,
			[TabLayer.ALIGN_VERTICAL_CENTER] = function()
				tempItem:setPosition(elementSize.width/2+offset.x,
					display.height -elementSize.height/2-elementSize.height*(i-1)+offset.y)
				local totalHeight = (elementSize.height + offset.y)*(#LayerDefs)
				local diffs = display.height - totalHeight
				self.m_TabMenu:setPositionY(-diffs/2.0)
			end,
			[TabLayer.ALIGN_VERTICAL_BOTTOM] = function()
				tempItem:setPosition(elementSize.width/2+offset.x,
					display.height -elementSize.height/2-elementSize.height*(i-1)+offset.y)
				local totalHeight = (elementSize.height + offset.y)*(#LayerDefs)
				local diffs = display.height - totalHeight
				self.m_TabMenu:setPositionY(-diffs)
			end,
			[TabLayer.ALIGN_VERTICAL_TOP_BTT] = function()
				tempItem:setPosition(elementSize.width/2+offset.x,
					elementSize.height/2+elementSize.height*(i-1)+offset.y)
				local totalHeight = (elementSize.height + offset.y)*(#LayerDefs)
				local diffs = display.height - totalHeight
				self.m_TabMenu:setPositionY(diffs)
			end,
			[TabLayer.ALIGN_VERTICAL_CENTER_BTT] = function()
				tempItem:setPosition(elementSize.width/2+offset.x,
					elementSize.height/2+elementSize.height*(i-1)+offset.y)
				local totalHeight = (elementSize.height + offset.y)*(#LayerDefs)
				local diffs = display.height - totalHeight
				self.m_TabMenu:setPositionY(diffs/2.0)
			end,
			[TabLayer.ALIGN_VERTICAL_BOTTOM_BTT] = function()
				tempItem:setPosition(elementSize.width/2+offset.x,
					elementSize.height/2+elementSize.height*(i-1)+offset.y)
			end,
			[TabLayer.ALIGN_CUSTOM] = function()
				tempItem:setPosition(layerDef:getPosition())
			end,
		}
		local func  = switch[self.align]
		if func then 
			-- echoInfo("call switch， %s",self.align)
			func()
		end
	end
	self:switchTab(self.initTabIndex)
		
end

function TabLayer:switchTab(index)
	self.TabItemCallBack(index)
end

return TabLayer
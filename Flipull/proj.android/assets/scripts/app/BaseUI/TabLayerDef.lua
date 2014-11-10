--
-- Author: yyj
-- Date: 2014-05-27 10:35:56
--
local TabLayerDef = class("TabLayerDef")
local Resource = require("app.Misc.Resource")
-- TabLayerDef={
-- 	target=nil, 目标类名 如：app.scenes.TestTabLayer1
-- 	instantiationMethodName=nil,--nil表示初始化方法为new()
-- 	argObjects={}, --初始化方法的参数

-- 	selectedNode = nil,
-- 	unSelectedNode = nil,
-- 	offset = CCPoint(0,0), -- 本标签相对于标准位置的偏移值
-- 	originalPosition = CCPoint(0, 0), --原始位置
-- 	position = CCPoint(0, 0), --最终表现出的位置
--  upAction 手指抬起时的动画
--  downAction 手指按下时的动画,与upAction配套使用
-- 	soundEffectString=nil,--点击音效文件
--  isClearPage 当切换到别的页面时是否删除此页面,若否，则setVisible(false)

--  layerSwitch() 切换时的方法
--  originIndex 此页面初始时表示的标签页index
--  currentIndex 此页面当前表示的标签页面
--  isShareLayer 是否与别的标签共享一个layer
--  shareFromIndex 此标签页共享于哪一个标签页
-- }
function TabLayerDef:ctor(params)
	echoInfo("TabLayerDef ctor")

	if params then 
		self.isClearPage = params.isClearPage or false
		self.target = params.target
		self.instantiationMethodName = params.instantiationMethodName or "new"
		self.argObjects = params.argObjects or {}
		self.selectedNode = params.selectedNode
		self.unSelectedNode = params.unSelectedNode
		self.offset = params.offset or CCPoint(0,0)
		self.originalPosition = params.originalPosition or CCPoint(0, 0)
		self.position = params.position or CCPoint(0, 0)
		self.upAction = params.upAction
		self.downAction = params.downAction
		if self.upAction  and self.downAction then 
			self.upAction:retain()
			self.downAction:retain()
		end
		self.isShareLayer = params.isShareLayer
		self.originIndex = params.originIndex
		self.currentIndex = self.originIndex
		self.shareFromIndex = params.shareFromIndex
		self.layerSwitch = params.layerSwitch

		self.sound = params.sound or Resource.Sound.buttonTap
	end
end

function TabLayerDef:getUpAction()
	return self.upAction 
end
function TabLayerDef:getDownAction()
	return self.downAction 
end
function TabLayerDef:setTarget(tar)
	if tar then 
		self.target = tar
	end
	return self
end

function TabLayerDef:setInstantiationMethodName(methodName)
	if methodName then 
		self.instantiationMethodName = methodName
	end
	return self
end
function TabLayerDef:setArgObjects(argObjects)
	if argObjects then 
		self.argObjects = argObjects
	end
	return self
end
function TabLayerDef:setSelectedNode(selectedNode)
	if selectedNode then 
		self.selectedNode = selectedNode
	end
	return self
end
function TabLayerDef:setUnSelectedNode(unSelectedNode)
	if unSelectedNode then 
		self.unSelectedNode = unSelectedNode
	end
	return self
end
function TabLayerDef:setOffset(offset)
	if offset then 
		self.offset = offset
		setPosition(ccpAdd(self.originalPosition, self.offset))
	end
	return self
end
function TabLayerDef:setOriginalPosition(originalPosition)
	if originalPosition then 
		self.originalPosition = originalPosition
		setPosition(ccpAdd(self.originalPosition, self.offset))
	end
	return self
end

function TabLayerDef:setPosition(pos)
	if pos then 
		self.position = pos
	end
	return self
end
function TabLayerDef:setSound(sound)
	if sound then 
		self.sound = sound
	end
	return self
end

function TabLayerDef:getTarget()
	return self.target
end

function TabLayerDef:getInstantiationMethodName()
	return	self.instantiationMethodName 
end
function TabLayerDef:getArgObjects()
	return	self.argObjects 
end
function TabLayerDef:getSelectedNode()
	return	self.selectedNode 
end
function TabLayerDef:getUnSelectedNode()
	return 	self.unSelectedNode 
end
function TabLayerDef:getOffset()
	return self.offset
end
function TabLayerDef:getOriginalPosition()
	return	self.originalPosition
end

function TabLayerDef:getPosition()
	return self.position
end
function TabLayerDef:getSound()
	return self.sound
end

return TabLayerDef
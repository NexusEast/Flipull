--
-- Author: wrl
-- Date: 2014-10-13 
-- 用于按下保持时，显示对话框的按钮


local Resource = require( "app.Misc.Resource" )
--local PushLayer = require("app.BaseUI.PushLayer")
--local NowLoadingScene = require("app.scenes.GameScene.NowLoadingScene")
 
--local TopFunctionMenu = require("app.scenes.MainScene.TopFunctionMenu")
--local PlayerData = require("app.Player.PlayerData")
--local SQLMethods = require("app.Utitls.SQLMethods")
--local BaseProgressBar = require("app.BaseUI.BaseProgressBar")
--require("app.BaseUI.QualityFrameItem")

local PassBtn = class( "PassBtn", function()
	local lay = display.newLayer()
	lay:setTouchEnabled(true)
	return lay
end)

-- params = {
-- 		script, 		--按钮的精灵
-- 		beginFun, 		--按下时的回调
--  	endFun,			--松开时的回调s
-- }

function PassBtn:ctor(params)
	if params == nil then
		echoInfo("ERROR : PassBtn:ctor params is nil" )
		return
	end

	if params.script == nil then
		echoInfo("ERROR : PassBtn:ctor params.script is nil" )
		return
	end

	if params.beginFun == nil then
		echoInfo("ERROR : PassBtn:ctor params.beginFun is nil" )
		return
	end
	local touchPriority = params.touchPriority or -149

	-- self.script = params.script
	-- self.beginFun = params.beginFun
	-- self.endFun = params.endFun


	self:setContentSize(params.script:getContentSize())
	--params.script:setAnchorPoint(ccp(0,0))
	self:addChild(params.script)


	self:registerScriptTouchHandler(function(touch,x,y)

			if touch == "began" then 
                local rect = params.script:getBoundingBox()
				local pos = self:convertToNodeSpace(ccp(x, y))
				
				if rect:containsPoint(pos) then 
					params.beginFun()
					return true
				end

			elseif touch == "moved" then 

			elseif touch == "ended" then 
				echoInfo("END")
				if params.endFun then
					params.endFun()
				end
			end

		end, false, touchPriority , false)

end


return PassBtn
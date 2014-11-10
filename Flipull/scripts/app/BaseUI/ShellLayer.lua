--
-- Author: yyj
-- Date: 2014-06-10 19:33:41
--

ShellLayer = class("ShellLayer", function()
	return require("app.BaseUI.PushLayer").new() end
	)

tag_Shell = 0x22315


--layer 加到哪一个layer上
--isDark 是否变暗，默认变暗
function ShellLayer.showShell(layer,isDark)
	local scene = layer or CCDirector:sharedDirector():getRunningScene()
	echoInfo("#############show Shell %s############",layer)
	if scene then 
		local Shell = scene:getChildByTag(tag_Shell)
		if not Shell then 
			Shell = ShellLayer.new(isDark)
			scene:addChild(Shell, tag_Shell , tag_Shell)
			echoInfo("#############show Shell############")
		end
	end
end

function ShellLayer.isShell(layer)
	local scene = layer or CCDirector:sharedDirector():getRunningScene()
	if scene then
		return scene:getChildByTag(tag_Shell )
	end
	return false
end

function ShellLayer.removeShell(layer)
	local scene = layer or CCDirector:sharedDirector():getRunningScene()
	if scene then 
		if scene:getChildByTag(tag_Shell) then 
			scene:removeChildByTag(tag_Shell , true)
		end
	end
end

function ShellLayer:ctor(isDark)
	if isDark~=false then
		--self:setMaskColor()
	end

	self:registerScriptTouchHandler(
        function ( event,x,y )
            echoInfo("################# ShellLayer    截断触屏  %s    #######################",tostring(event))
            return true
        end,
         false, self:getTouchPriority()-10000+1   , true)
end


return ShellLayer

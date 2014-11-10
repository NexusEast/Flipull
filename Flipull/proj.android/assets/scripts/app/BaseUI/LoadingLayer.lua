--
-- Author: yyj
-- Date: 2014-06-10 19:33:41
--

LoadingLayer = class("LoadingLayer", function()
	return require("app.BaseUI.PushLayer").new() end
	)

tag_loading = 0x21345


--layer 加到哪一个layer上
--isDark 是否变暗，默认变暗
function LoadingLayer.showLoading(layer,isDark)
	local scene = layer or CCDirector:sharedDirector():getRunningScene()
	echoInfo("#############show loading %s############",layer)
	if scene then 
		local loading = scene:getChildByTag(tag_loading)
		if not loading then 
			loading = LoadingLayer.new(isDark)
			scene:addChild(loading, tag_loading , tag_loading)
			echoInfo("#############show loading############")
		end
	end
end

function LoadingLayer.isLoading(layer)
	local scene = layer or CCDirector:sharedDirector():getRunningScene()
	if scene then
		return scene:getChildByTag(tag_loading )
	end
	return false
end

function LoadingLayer.removeLoading(layer)
	local scene = layer or CCDirector:sharedDirector():getRunningScene()
	if scene then 
		if scene:getChildByTag(tag_loading) then 
			scene:removeChildByTag(tag_loading , true)
		end
	end
end

function LoadingLayer:ctor(isDark)
	if isDark~=false then
		self:setMaskColor()
	end

    local text = baseUI.newTTFLabel({
        text = "正在加载中...",
        color = BaseFontColor.yellow,
        align = ui.TEXT_ALIGN_CENTER,
        size = 22,
        x = display.cx,
        y = display.cy,
        }):addTo(self)

	self:registerScriptTouchHandler(
        function ( event,x,y )
            -- echoInfo("#################     截断触屏  %s    #######################",event)
            return true
        end,
         false, self:getTouchPriority()-10000   , true)
end


return LoadingLayer

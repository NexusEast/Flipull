--
-- Author: yyj
-- Date: 2014-05-29 17:41:21
--
--标签页对应的layer必须继承此类，并且ctor(argObjects)第一个参数必须为表argObjects
local TabLayerBase = class("TabLayerBase", function(argObjects)
	local layer = display.newLayer()
	if argObjects and argObjects.touchPriority then 
		layer:setTouchPriority(argObjects.touchPriority)
	end
	return layer
	end
)


return TabLayerBase
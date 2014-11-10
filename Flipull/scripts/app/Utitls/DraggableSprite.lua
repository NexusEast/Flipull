--
-- Author: Wayne Dimart
-- Date: 2014-02-22 14:06:53
--
local Resource = require("app.Misc.Resource")
local params
local DraggableSprite = class("DraggableSprite", 
	function(filename, x, y,par)
		params = par
	return display.newSprite(filename, x, y)
end)

	local renderedSprite
	

	function DraggableSprite:ctor() 

		

	end

return  DraggableSprite
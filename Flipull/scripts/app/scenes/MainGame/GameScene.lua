--
-- Author: Your Name
-- Date: 2014-11-09 14:14:53
--
 
local MainBoardLayer = require("app.scenes.MainGame.MainBoardLayer")
local GameScene = class("GameScene", 
	function()
       return display.newScene("GameScene")
		end)

function GameScene:ctor()
	echoInfo("TestTabLayer")
	self:addChild(MainBoardLayer.new({size = CCSize(5,5)}))
	local layer = display.newLayer()
	layer:enableKeypad(true)
	self:addChild(layer)
	layer:onKeypad(function(arg0,arg1)
		echoInfo("EXITING...")
		os.exit()
	end)
	 

end

return GameScene
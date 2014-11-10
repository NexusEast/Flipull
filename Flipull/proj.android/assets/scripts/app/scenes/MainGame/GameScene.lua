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

	 

end

return GameScene
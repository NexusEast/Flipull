
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")
require("app.Utitls.MiscTools")
-- require("app.GameData.MessageCtrl")
 
local scheduler = require("framework.scheduler") 
MessageBox = require("app.BaseUI.MessageBox")

local MyApp = class("MyApp", cc.mvc.AppBase) 
     
function MyApp:ctor()
    MyApp.super.ctor(self) 
end

  
function MyApp:localPublicModel() 
    require("app.BaseUI.ToastLayer") 
    require("app.Misc.Resource")
    LocalSetting:init()
end
function MyApp:run() 
	CCFileUtils:sharedFileUtils():addSearchPath(require("app.Utitls.DirBase"))
 
    self:localPublicModel()
    self:enterScene( "MainGame.GameScene", nil, 'fade', 0.6, display.COLOR_BLACK )  
    -- audioex.preloadAllSounds() 

end

return MyApp

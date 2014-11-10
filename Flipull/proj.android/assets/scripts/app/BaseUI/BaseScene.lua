local pub = require("app.Utitls.pub")
local BaseScene = class("BaseScene",
    function(args)
        return display.newScene(args)
    end)

function BaseScene:ctor()
    echoInfo("BaseScene:ctor=%s",tostring(self.name or (self.__cname or "unknown")))
    self.layerCollection = {}
    self.messageEnable = false
    self.sceneTAG = tostring(args)
end

function BaseScene:onEnter()
    echoInfo("BaseScene:onEnter=%s",tostring(self.name or (self.__cname or "unknown")))
end

function BaseScene:onEnterTransitionFinish()
    echoInfo("BaseScene:onEnterTransitionFinish()=%s",tostring(self.name or (self.__cname or "unknown")))
    self.messageEnable = true
end

function BaseScene:onExitTransitionStart()
    echoInfo("BaseScene:onExitTransitionStart()=%s",tostring(self.name or (self.__cname or "unknown")))
    self.messageEnable = false
end

function BaseScene:onCleanup()
    echoInfo("BaseScene:onCleanup()=%s",tostring(self.name or (self.__cname or "unknown")))
    self.messageEnable = false
    self.layerCollection = {}
end

function BaseScene:onExit()
    echoInfo("BaseScene:onExit()=%s",tostring(self.name or (self.__cname or "unknown")))
    self.messageEnable = false
    self.layerCollection = {}
end


function BaseScene:getLayerCollection()
    return self.layerCollection
end

function BaseScene:getMessageEnable()
    return self.messageEnable
end
return BaseScene
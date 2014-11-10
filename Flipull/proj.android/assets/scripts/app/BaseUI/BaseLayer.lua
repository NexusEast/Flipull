local pub = require("app.Utitls.pub")
local BaseLayer = class("BaseLayer",
    function()
        return display.newLayer()
    end)



function BaseLayer:ctor(params)
    echoInfo("BaseLayer:ctor")
    self:setNodeEventEnabled(true)
    self.registerInfo = self.registerInfo or {}
    if params then
        pub.dump(params)
        if params.registerInfo then
            self:registerLayer(params.registerInfo)
        end
    end
end

function BaseLayer:onMessage(id, params)
    echoInfo("BaseLayer:onMessage begin")
    echoInfo("BaseLayer:onMessage end")
end

function BaseLayer:pushMessage(handler, id, params)
    echoInfo("BaseLayer:pushMessage begin")
    MessageCtrl:pushMessage(handler, id, params)
    echoInfo("BaseLayer:pushMessage end")
end



function BaseLayer:broadcastMessage(layerInfo,id, params)
    return MessageCtrl:broadcastMessage(layerInfo,id, params)
end



function BaseLayer:registerLayer(params)
    self.registerInfo = clone(params)
    self.registerInfo.handler = self
    MessageCtrl:registerLayer(self.registerInfo)
end

function BaseLayer:unRegisterLayer()
    MessageCtrl:unRegisterLayer(self.registerInfo)
end

function BaseLayer:onEnter()
    --self:registerLayer()
    echoInfo("BaseLayer:onEnter()")
end

function BaseLayer:onExit()
    echoInfo("BaseLayer:onExit()")
    self:unRegisterLayer()
end

return BaseLayer
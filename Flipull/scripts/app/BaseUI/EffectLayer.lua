local PushLayer = require("app.BaseUI.PushLayer")
local Resource = require("app.Misc.Resource")
local pub = require("app.Utitls.pub")
local EffectLayer = class("EffectLayer",
    function(args)
        return PushLayer.new(args)
    end)

EffectLayer.DEFAULT_SCALE_MINI = 0.5
EffectLayer.DEFAULT_SCALE_TIME = 0.15




function EffectLayer:isInBox(x, y)
    local bRet = false

    for i, v in ipairs(self.boxes) do
        --echoInfo("v=%s, =%s", tostring(v), tostring(tolua.cast(v, "CCNode")))
        if v and tolua.cast(v, "CCNode") and v:isVisible() then
            local parent_ = v:getParent()
            if v:getBoundingBox():containsPoint(parent_:convertToNodeSpace(ccp(x, y))) then
                bRet = true
                break
            end
        end
    end
    return bRet
end

function EffectLayer:getTouchBeganArea()
    return self.touchBeganArea
end

function EffectLayer:setTouchBeganArea(value)
    self.touchBeganArea = value
end

function EffectLayer:setBoxes(tblBoxes)
    self.boxes = tblBoxes or {}
    --dump(self.boxes)
end
function EffectLayer:setParams(params)

    self.maskLayer = params.maskLayer or display.newColorLayer(pub.COLOR_BG_GREY)

    self.handlersMessage = self.handlersMessage or {}
    if not self.maskLayer:getParent() then
        self:addChild(self.maskLayer,-1)
    end
    self.outToCloseEnable = params.outToCloseEnable
    self.closeEffectEnable = params.closeEffectEnable
    self.openEffectEnable = params.openEffectEnable
    self.elementsParent = params.elementsParent
    self.boxes = clone(params.boxes) or {}
    self.maskLayer:setTouchEnabled(true)

    self.TOUCH_AREA_INBOX = 0
    self.TOUCH_AREA_OUTOFBOX = 1
    self.touchBeganArea = self.TOUCH_AREA_INBOX
    self.AfterOpenEffectFunc = params.AfterOpenEffectFunc
    self.maskLayer:registerScriptTouchHandler(function(event, x, y)
    --echoInfo("event=%s  x=%s,y=%s",tostring(event),tostring(x),tostring(y))
        if event == "began" then
            if self:isInBox(x, y) then
                self:setTouchBeganArea(self.TOUCH_AREA_INBOX)
            else
                self:setTouchBeganArea(self.TOUCH_AREA_OUTOFBOX)
            end
        elseif event == "moved" then
        elseif event == "ended" then
            if not self:isInBox(x, y) and self:getTouchBeganArea() == self.TOUCH_AREA_OUTOFBOX then
                self:setTouchBeganArea(self.TOUCH_AREA_INBOX)
                if self.outToCloseEnable then
                    self:close()
                end
            end
        end
        return true
    end, false, self:getTouchPriority()+1, false)
end

function EffectLayer:ctor()
    echoInfo("EffectLayer:ctor()")
end

function EffectLayer:closeExcute()
    if self.closeEffectEnable then
        self:runActionCloseEffect()
    else
        self:destroy()
    end
end

function EffectLayer:close()
   echoInfo("EffectLayer:close")
   self:closeExcute()
end

function EffectLayer:destroy()
    self:removeFromParentAndCleanup(true)
end

function EffectLayer:runActionCloseEffect()
    --[[
    local arrActions = CCArray:create()
    local scaleTo = CCScaleTo:create(EffectLayer.DEFAULT_SCALE_TIME, EffectLayer.DEFAULT_SCALE_MINI)
    local hide = CCHide:create()
    local callFunc = CCCallFunc:create(function()
        self:onCloseEffectFinished()
    end)
    local callFuncDestroy = CCCallFunc:create(function()
        self:destroy()
    end)

    arrActions:addObject(scaleTo)
    arrActions:addObject(hide)
    arrActions:addObject(callFunc)
    arrActions:addObject(callFuncDestroy)

    self.elementsParent:runAction(CCSequence:create(arrActions))
    ]]--
    audioex.playSound(Resource.Sound.common_close_popup_window)
    transition.execute(self.elementsParent, CCScaleTo:create(EffectLayer.DEFAULT_SCALE_TIME, EffectLayer.DEFAULT_SCALE_MINI),
        {
            easing = "backIn",
            onComplete = function()
                self:onCloseEffectFinished()
                self:destroy()
            end,
        })
end



function EffectLayer:onOpenEffectFinished()
end

function EffectLayer:onCloseEffectFinished()
end



function EffectLayer:runActionOpenEffect()

--    local arrActions = CCArray:create()
--    local scaleToMini = CCScaleTo:create(0, EffectLayer.DEFAULT_SCALE_MINI)
--    local show = CCShow:create()
--    local scaleToDefault = CCScaleTo:create(EffectLayer.DEFAULT_SCALE_TIME, 1.0)
--    local callFunc = CCCallFunc:create(function()
--        self:onOpenEffectFinished()
--    end)
--
--    arrActions:addObject(scaleToMini)
--    arrActions:addObject(show)
--    arrActions:addObject(scaleToDefault)
--    arrActions:addObject(callFunc)
--
--
--    self.elementsParent:setVisible(false)
--    self.elementsParent:runAction(CCSequence:create(arrActions))
    audioex.playSound(Resource.Sound.common_popup_window)
    self.elementsParent:setScale(EffectLayer.DEFAULT_SCALE_MINI)
    transition.execute(self.elementsParent, CCScaleTo:create(EffectLayer.DEFAULT_SCALE_TIME, 1.0),
        {
            easing = "backOut",
            onComplete = function()
                self:onOpenEffectFinished()
            end,
        })
end


function EffectLayer:onEnter()
    --self.super:onEnter()
    PushLayer.onEnter(self)
    echoInfo("EffectLayer:onEnter")
    if self.openEffectEnable then
        self:runActionOpenEffect()
    end
end



function EffectLayer:onExit()
    echoInfo("EffectLayer:onExit = %s",tostring(self))
    PushLayer.onExit(self)
end


return EffectLayer
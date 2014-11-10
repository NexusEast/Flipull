--
-- Author: moon
-- Date: 2014-06-06 15:21:20
--
local Resource = require("app.Misc.Resource")
local PushLayer = require("app.BaseUI.PushLayer")
require("app.BaseUI.typeLabel")

local MessageBox = class( "Package", function()
	return  PushLayer.new()
end)
local tableWidth =  496
local tableHeight = 223


--function MessageBox:onEnter()
--    PushLayer.onEnter(self)
--    echoInfo("!!!!!!!!!!!!!!!!!!!!!!!   MessageBox:onEnter()  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
--    if not g_guideIsFresh then
--        GuideManager:begin_Guide(WindowType.messageBox)
--    else
--        FreshManCtrl:begin_Guide(WindowType.messageBox)
--    end
--end

function MessageBox:ctor( messageData, callBackFunc ,typeIn)
	-- local table =  display.newColorLayer(ccc4(13, 13, 25, 255 * 0.75 )) 
	-- self:addChild( table )
    self.typeIn = typeIn or "typeIn_normal"
    self.guideType = WindowType.messageBox
    self:setMaskColor(ccc4(13, 13, 25, 255 * 0.75 ))
	local blackBG = display.newScale9Sprite( Resource.Scale9Sprite.messageBoxBG, display.cx, display.cy, CCSize( tableWidth, tableHeight ) )
	self:addChild( blackBG )
	self:setOCAnimation( true )
	
	local menu = ui.newMenu( {} )
	menu:setTouchPriority( self:getTouchPriority() )
	self:addChild( menu )

	if messageData ~= nil then
		local message = baseUI.newTTFLabel({
			text = messageData,
			color = BaseFontColor.white,
			x = display.cx,
			y = display.cy * 1.1 ,
			size = 24,
			dimensions = CCSize( tableWidth - 50, tableHeight * 0.6 ),
			align = ui.TEXT_ALIGN_CENTER,
		})
		-- coinValue:setAnchorPoint( ccp( 0, 0 ))
		echoInfo("!!!!!!!!!!!!!!!  %s    !!!!!!!!!!!!!!!!!!" , messageData )
		self:addChild( message )
	end

	self.btn_cancel = baseUI.Button( menu, Resource.UIButton.btn07, Resource.UIButton.btn07Select,'取消', function()
        self:onClose()
	end )
	self.btn_cancel:setPosition(  display.cx * 0.8 , display.cy * 0.85 )
	self.btn_cancel:setFontSize( 18 )

	self.btn_confirm = baseUI.Button( menu, Resource.UIButton.btn07, Resource.UIButton.btn07Select,'确定' )
	if callBackFunc ~= nil then
		self.btn_confirm:setOnclick( function()
            if self.typeIn == "composeHero" or self.typeIn == "HeroUp" then
                Newbie:nextNumAndCleanByActiveItem(self.guideType,"ITEM_Tips")
            end
			callBackFunc()
	        self:onClose()
			end
		) 
	else
		self.btn_confirm:setOnclick( function()
	        self:onClose()
		end)
	end
	self.btn_confirm:setPosition(  display.cx * 1.2 , display.cy * 0.85 )
	self.btn_confirm:setFontSize( 18 )


    if self.typeIn == "composeHero"  or self.typeIn == "HeroUp" then
        self.NewbieItems["ITEM_Tips"] = self.btn_confirm.imageMenuItem
    end
    Newbie:startStep(self.guideType,self)
end

return MessageBox

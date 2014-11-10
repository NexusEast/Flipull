--
-- Author: moon
-- Date: 2014-02-25 13:32:49 
local pub = require("app.Utitls.pub")
require("app.Utitls.audioex")
baseUI = {}
LayerTouchProperty = kCCMenuHandlerPriority - 1 --方便各个系统使用 layer通用触碰优先级
TableViewTouchProperty = kCCMenuHandlerPriority - 2 --方便各个系统使用 layer通用触碰优先级
baseUI.DEFAULT_FONT =  Resource.Font  --"RTWSYueGoTrial-Light"

--[[
添加红点的公用方法
params = {
	node = btn ,        --要添加红点的按钮
	isOpen = true ,     --是打开还是关闭 true打开 false或者nil关闭
	tag = g_tagRedDot , --tag默认值 g_tagRedDot 
	pos = pos ,         --红点相对node的位置
	reddotFile = file , --红点图片路径,有默认
}
]]
function baseUI.setRedDot( params)
	local node = params.node 
	if node then 
		-- echoInfo("node type "..tolua.type(node))
		local isOpen = params.isOpen 
		local tag = params.tag or g_tagRedDot 
		if not isOpen then node:removeChildByTag(tag, true) 
		elseif node:getChildByTag(tag) == nil then 
			local file = params.reddotFile or Resource.Tip.reddot 
			local pos = params.pos or ccp(node:getContentSize().width*0.8, node:getContentSize().height*0.8)
			local reddot = display.newSprite(file, pos.x, pos.y)
			node:addChild(reddot, 1, tag)
		end
	end
end

--获得标题（底图+字）
function baseUI.getTitle(titleBgFile,titleFile)
	titleBg = titleBg or Resource.WipeOut.titleBG

	local titleBg = display.newSprite(titleBg)
    local title = display.newSprite(titleFile,
        titleBg:getContentSize().width/2, titleBg:getContentSize().height/2):addTo(titleBg)
	return titleBg
end
function baseUI.setBg(file,layer)
	file = file or Resource.UI.BG.bg_1
    local BGG = display.newSprite( file, display.cx, display.cy )
    layer:addChild( BGG )
end

--[[
创建文字标签时同一使用一下方法，以方便同一自定义字体
]]
function baseUI.newTTFLabel(params)
	params.font = baseUI.DEFAULT_FONT
	return ui.newTTFLabel(params)
end
function baseUI.newTTFLabelWithOutline(params)
	params.font = baseUI.DEFAULT_FONT
	return ui.newTTFLabelWithOutline(params)
end
function baseUI.newTTFLabelWithShadow(params)
	params.font = baseUI.DEFAULT_FONT
	return ui.newTTFLabelWithShadow(params)
end

function baseUI.newTTFLabelMenuItem(params)
    params.font = baseUI.DEFAULT_FONT
    return ui.newTTFLabelMenuItem(params)
end


function baseUI.newTTFLabelMenuItem(params)
    local p = clone(params)
    p.x, p.y = nil, nil
    local label = baseUI.newTTFLabel(p)

    local listener = params.listener
    local tag      = params.tag
    local x        = params.x
    local y        = params.y
    local sound    = params.sound

    local item = CCMenuItemLabel:create(label)
    if item then
        CCNodeExtend.extend(item)
        if type(listener) == "function" then
            item:registerScriptTapHandler(function(tag)
                if sound then audioex.playSound(sound) end
                listener(tag)
            end)
        end
        if x and y then item:setPosition(x, y) end
        if tag then item:setTag(tag) end
    end

    return item
end

function baseUI.newRichElements(elementsTable, touchPriority, offset )
	local obj = {}
	obj.node = display.newNode() 
	local width = 0
	local totalWidth = 0
	local totalHeight = 0
	local offset = offset or 5
	-- echoInfo("!!!!!!!!!!!!!!!!!!!!!!!!!!! offset:%d !!!!!!!!!!!!!", offset )
	-- dump( elementsTable ,"!!!!!!!!!!!ßßßßß")
	for i, item in pairs( elementsTable ) do
		local scale = item:getScale()
		local size = item:getContentSize()
		if scale ~= 1 then
			size = CCSize( size.width * scale, size.height * scale )
		end
		totableWidth = offset + totalWidth + size.width 

		if size.height > totalHeight then
			totalHeight = size.height
		end
	end
	obj.node:setContentSize( CCSize( width, totalHeight ) )
	for i, item in pairs( elementsTable ) do
		local scale = item:getScale()
		local size = item:getContentSize()
		if scale ~= 1 then
			size = CCSize( size.width * scale, size.height * scale )
		end
		width = offset + width + size.width / 2
		item:setPositionX( width ) 
		item:setPositionY( totalHeight / 2 ) 
		width = width + size.width / 2
		-- if size.height > totalHeight then
			-- totalHeight = size.height
		-- end
		obj.node:addChild( item )
	end
	return obj.node
end

function baseUI.newPushLayer()
	return require("app.BaseUI.PushLayer").new()
end

--与newMenu相比，多了一个参数responseRect,定义按钮的相应范围
--responseRect的类型为CCRect,锚点为屏幕坐标(0,0)
function baseUI.newRectMenu( menuItems, touchPriority, responseRect)
	-- echoInfo("%s,   %s",menuItems , touchPriority)
	assert(type(menuItems) == "table",
           "[app.BaseUI.BaseUI] newMenu() invalid menuItems")
	local menu = nil
	if type(menuItems) == "table" then  
		menu = ui.newRectMenu(menuItems,responseRect)
		
		if touchPriority --[[and touchPriority < 0]] then
			-- echoInfo("touchPriority=%s",touchPriority+1)
			menu:setTouchPriority(touchPriority+1)
		end
		
	end
	
	return menu
end

--CCMenu
--touchPriority 此menu的优先级
--example:baseUI.newMenu({menuitem1,menuitem2},touchPriority)
function baseUI.newMenu( menuItems ,touchPriority)
	-- echoInfo("%s,   %s",menuItems , touchPriority)
	assert(type(menuItems) == "table",
           "[app.BaseUI.BaseUI] newMenu() invalid menuItems")
	local menu = nil
	if type(menuItems) == "table" then  
		menu = ui.newMenu(menuItems)
		
		if touchPriority --[[and touchPriority < 0]] then
			--echoInfo("touchPriority=%s",touchPriority+1)
			menu:setTouchPriority(touchPriority+1)
			-- menu:setHandlerPriority(touchPriority)
		end
		
	end
	
	return menu
end

--[[
params 是一个table ，除了ui.NewImageMenuItem()的参数外，
还可以自定义以下参数，以在按钮上添加文字
	text =按钮上的文字
	textFontSize 文字大小
	textColor 文字颜色
	textOffsetX 文字在按钮上的X轴偏移
	textOffsetY 文字在按钮上的Y轴偏移
	textAlign 文字对齐方式
在按钮上添加BMLFontLabel
	text = 按钮文字
	textFont 文字坐标文件（格式是fnt）
在按钮上添加其他效果的ccnode
	textNode = 按钮上添加的node CCNode
	textNodeSelected 按下后的状态
	textOffsetX node在按钮上的X轴偏移
	textOffsetY node在按钮上的Y轴偏移

]]
function baseUI.newImageMenuItem( params )
	assert(type(params) == "table",
           "[app.BaseUI.BaseUI] newImageMenuItem() invalid params")
	local image = params.image
	local imageSelected = params.imageSelected
	if params.imageSelected == nil then 
		if image  then 
			if type(image)=="string" then
				imageSelected = display.newSprite(image)
			elseif tolua.type(image) == "CCSprite" then 
				imageSelected = display.newSprite(image:getDisplayFrame())
				imageSelected:setScale(image:getScale())
			end
			if imageSelected and params.isSelectedDark then
				imageSelected:setColor(ccc3(100, 100, 100))
			end
		end
		params.imageSelected=imageSelected
	end
	-- echoInfo("image : %s,%s",type(image),type(imageSelected) )
	if type(image)=="string" then
		image = display.newSprite(image)
	end 
	if type(imageSelected) == "string" then 
		imageSelected =display.newSprite(imageSelected)
	end 

	--若有文字，则把文字添加到CCSprite上
	local labText = nil
	local labTextSelected = nil
	if params.text then 
		local text = params.text 
		local textFontSize = params.textFontSize or 22
		local textColor = params.textColor 
		local textColorSelect = params.textColorSelect or textColor
		local textOffsetX = params.textOffsetX or 0
		local textOffsetY = params.textOffsetY or 0
		local textAlign = params.textAlign or ui.TEXT_ALIGN_CENTER
		local textFont = params.textFont

		if image and imageSelected then 
			local textParams ={
				text =text,
				color = textColor,
				size = textFontSize,
				align = textAlign,
				x = image:getContentSize().width/2 + textOffsetX,
				y = image:getContentSize().height/2 +textOffsetY,
			}
			local textSelectedParams ={
				text =text,
				color = textColorSelect,
				size = textFontSize,
				align = textAlign,
				x = imageSelected:getContentSize().width/2 + textOffsetX,
				y = imageSelected:getContentSize().height/2 +textOffsetY,
			}

			local label
			local label_selected
			--如果是BMFontLabel 则 ############### TODO未测试
			if textFont then 
				textParams.font = textFont
				textSelectedParams.font = textFont
				label = ui.newBMFontLabel(textParams)
				label_selected = ui.newBMFontLabel(textSelectedParams)
			else 
				label = baseUI.newTTFLabel(textParams)
				label_selected = baseUI.newTTFLabel(textSelectedParams)
			end
			-- label_selected:setColor(ccc3(100, 100, 100))
			image:addChild(label)
			imageSelected:addChild(label_selected)
			-- echoInfo("text:%s", textParams.text)
			labText = label
			labTextSelected = label_selected
		end
	elseif params.textNode then
		local textOffsetX = params.textOffsetX or 0
		local textOffsetY = params.textOffsetY or 0
		local textNode = params.textNode
		local textNodeSelected = params.textNodeSelected
		if image and imageSelected then 
			textNode:setPosition(image:getContentSize().width/2+textOffsetX,
				image:getContentSize().height/2 + textOffsetY)
			image:addChild(textNode)
			if textNodeSelected then 
				textNodeSelected:setPosition(imageSelected:getContentSize().width/2+textOffsetX,
					imageSelected:getContentSize().height/2 + textOffsetY)
				imageSelected:addChild(textNodeSelected)
			else 
				 echoInfo("textNodeSelected is nil")
				-- assert(textNodeSelected ~= nil,
    --        			"[app.BaseUI.BaseUI] newImageMenuItem() textNodeSelected cannot be nil")
			end
		end
	end

	params.image = image 
	params.imageSelected = imageSelected
	--设置默认的声音
	params.sound = params.sound or Resource.Sound.buttonTap 
	local menuitem = ui.newImageMenuItem(params)

    local listener = params.listener
    local sound = params.sound or Resource.Sound.buttonTap
    local tag   = params.tag
    if type(listener) == "function" then
        menuitem:registerScriptTapHandler(function(tag)
            if sound then audioex.playSound(sound) end
            listener(tag)
        end)
    end

    menuitem.setString = function (obj, str)
		labText:setString(str)
		labTextSelected:setString(str)
    end

	return menuitem
end

--[[
listener
x
y
tag
normalNode
selectedNode
pressedAction 按下动画
unpressedAction 抬起动画
delay 点击后延时响应时间
contentSize 按钮size
nodeOffsetX node相对于contentSize的X轴偏移，node的anchorPoint = (0,0)
nodeOffsetY node相对于contentSize的Y轴偏移，node的anchorPoint = (0,0)
]]
function baseUI.newNodeMenuItem(params)
	assert(type(params) == "table",
           "[app.BaseUI.BaseUI] newNodeMenuItem() invalid params")
	local normalNode = params.normalNode
	local selectedNode = params.selectedNode
	local pressedAction = params.pressedAction
	local unpressedAction = params.unpressedAction
	local delay = params.delay
	local contentSize = params.contentSize
	local x,y = params.x,params.y
	local tag = params.tag
	local listener = params.listener
	local nodeOffsetX = params.nodeOffsetX or 0
	local nodeOffsetY = params.nodeOffsetY or 0

	local item = CCNodeMenuItem:create(normalNode,selectedNode)
	if item then 
		CCNodeExtend.extend(item)
		if type(listener) == "function" then
            item:registerScriptTapHandler(function(tag)
                if sound then audioex.playSound(sound) end
                -- echoInfo("click nodeMenuItem")
                listener(tag)
            end)
        end
        if x and y then item:setPosition(x, y) end
        if tag then item:setTag(tag) end
        if pressedAction and unpressedAction then item:setPressAction(pressedAction,unpressedAction) end
        if delay then item:setDelay(delay) end
        if contentSize then item:setContentSize(contentSize) end
        normalNode:setPosition(ccp(nodeOffsetX, nodeOffsetY))
        
	end
	return item
end

function baseUI.newSpriteMenuItem(params)
    local item = ui.newImageMenuItem(params)

    local listener = params.listener
    local sound = params.sound or Resource.Sound.buttonTap
    local tag   = params.tag
    if type(listener) == "function" then
        item:registerScriptTapHandler(function(tag)
            if sound then audioex.playSound(sound) end
            listener(tag)
        end)
    end
    return item
end


--图片上加ttf文字
function baseUI.SpriteWithText( imageName, text, textOffsetX, textOffsetY )
	local obj = {}
    local textOffsetX = textOffsetX or 0
    local textOffsetY = textOffsetY or 0
    local sprite = display.newSprite( imageName )
    obj.sprite = sprite
    obj.spriteSize = sprite:getContentSize() 
    if text ~= nil then
    	local label = baseUI.newTTFLabel({
    		text = text,
    		color = ccc3(255, 255, 255),
    		x = sprite:getContentSize().width / 2 + textOffsetX,
    		y = sprite:getContentSize().height / 2 + textOffsetY,
    		size = 22,
    		align = ui.TEXT_ALIGN_CENTER,
    		})
    	obj.label = label
	    sprite:addChild( label )
    end

    function obj:getTextLabel()
    	return obj.label
    end

    function obj:setTextOffset( offsetX, offsetY )
    	if obj.label ~= nil then
    		obj.label:setPosition( obj.spriteSize.width / 2 + offsetX, obj.spriteSize.height / 2 + offsetY ) 
    	end
    end

    function obj:setVisible( isShow )
    	obj.label:setVisible( isShow )
    	obj.sprite:setVisible( isShow )
    end

    function obj:setTextColor( color )
    	if obj.label ~= nil then
    		obj.label:setColor( color )
    	end
    end

    function obj:setFontSize( size )
    	if obj.label ~= nil then
    		obj.label:setFontSize( size ) 
    	end
    end

    function obj:removeFromParentAndCleanup( bRet )
    	if obj.label ~= nil then
    		obj.label:removeFromParentAndCleanup( bRet ) 
    	end
    end

    function obj:setString(text)
    	if obj.label ~= nil then
    		obj.label:setString( text )
    	end
    end


    return obj 
end

--图片上加BM文字
function baseUI.SpriteWithBMText( imageName, text, font, textOffsetX, textOffsetY )
	local obj = {}
    local textOffsetX = textOffsetX or 0
    local textOffsetY = textOffsetY or 0
    local sprite = display.newSprite( imageName )
    obj.sprite = sprite
    obj.spriteSize = sprite:getContentSize() 
    if text ~= nil then
    	local label = ui.newBMFontLabel({
    		text = text,
			font = font,
    		color = ccc3(255, 255, 255),
    		x = obj.spriteSize.width / 2 + textOffsetX,
    		y = obj.spriteSize.height / 2 + textOffsetY,
    		size = 22,
    		align = ui.TEXT_ALIGN_CENTER,
    		})
    	obj.label = label
	    sprite:addChild( label )
    end
    function obj:getTextLabel()
    	return obj.label
    end

    function obj:setTextColor( color )
    	if obj.label ~= nil then
    		obj.label:setColor( color )
    	end
    end

    --距中心位置偏移
    function obj:setTextOffset( offsetX, offsetY )
    	if obj.label ~= nil then
    		obj.label:setPosition( obj.spriteSize.width / 2 + offsetX, obj.spriteSize.height / 2 + offsetY ) 
    	end
    end

    return obj 
end

--9ScaleSprite with font
function baseUI.Scale9SpriteWithText( imageName, text, size, pos, textOffsetX, textOffsetY  )
	local obj = {}
    local textOffsetX = textOffsetX or 0
    local textOffsetY = textOffsetY or 0
    local sprite = display.newScale9Sprite( imageName, pos.x, pos.y, size )
    obj.sprite = sprite
	echoInfo("!!!!!!!!!!!!!!!!!!!!!!! Scale9Sprite:%s !!!!!!!!!!!!!!!!!!!!!!!!!!!!!", tostring( sprite ) )
    obj.spriteSize = sprite:getContentSize() 
    if text ~= nil then
    	local label = baseUI.newTTFLabel({
    		text = text,
    		color = ccc3(200, 200, 200),
    		x = sprite:getContentSize().width / 2 + textOffsetX,
    		y = size.height / 2  or 30 + textOffsetY,
    		size = 20,
    		align = ui.TEXT_ALIGN_CENTER,
    		})
    	obj.label = label
	    sprite:addChild( label )
    end
	
	function obj:getTextLabel()
    	return obj.label
    end
    
    function obj:setTextOffset( offsetX, offsetY )
    	if obj.label ~= nil then
    		obj.label:setPosition( obj.spriteSize.width / 2 + offsetX, obj.spriteSize.height / 2 + offsetY ) 
    	end
    end

    function obj:setVisible( isShow )
    	obj.label:setVisible( isShow )
    	obj.sprite:setVisible( isShow )
    end


    function obj:setTextColor( color )
    	if obj.label ~= nil then
    		obj.label:setColor( color )
    	end
    end

    function obj:setFontSize( size )
    	if obj.label ~= nil then
    		obj.label:setFontSize( size ) 
    	end
    end

    function obj:setString(text)
    	obj.label:setString( text )
    end

    return obj 
end

-- simple button with sprite and ttflabel
function baseUI.Button( menu, normal, selected, textString , onclick, sound )
	local obj = {}

	--如果没有传递声音文件 使用默认的声音
	if sound == nil then
		sound = Resource.Sound.buttonTap
	end

	local imageMenuItem = nil	
	if  type( normal ) == "string" then
		obj.image = baseUI.SpriteWithText( normal, textString )
		obj.imageSelect = baseUI.SpriteWithText( selected or normal, textString )
		imageMenuItem = ui.newImageMenuItem({
		image = obj.image.sprite,
		imageSelected = obj.imageSelect.sprite,
		-- x = point.x,
		-- y = point.y,
		listener = function() 
			-- if sound ~= nil then 
			-- 	--audio.pauseAllSounds()
			-- 	audio.playSound(sound)
			-- end
			if sound then audioex.playSound(sound) end
			if onclick ~= nil then
				onclick() 
			end
		end,
		})
	else
		imageMenuItem = ui.newImageMenuItem({
		image = normal,
		imageSelected = selected,
		-- x = point.x,
		-- y = point.y,
		listener = function() 
			-- if sound ~= nil then 
			-- 	--audio.pauseAllSounds()
			-- 	audio.playSound(sound)
			-- end
			if sound then audioex.playSound(sound) end
			if onclick ~= nil then
				onclick() 
			end
		end,
		})
	end
	

	
	obj.imageMenuItem = imageMenuItem
	menu:addChild( imageMenuItem )

	function obj:setOnclick( onclick )
        if type( onclick ) == "function" then
            obj.imageMenuItem:registerScriptTapHandler(function(tag)
				if sound then audioex.playSound(sound) end
                onclick(tag)
            end)
        end
	end
	function obj:setTextAnchorPoint(anchorpoint)
		if obj.image and obj.image:getTextLabel() then 
			obj.image:getTextLabel():setAnchorPoint(anchorpoint)
		end
		if obj.imageSelect and obj.imageSelect:getTextLabel() then 
			obj.imageSelect:getTextLabel():setAnchorPoint(anchorpoint)
		end
	end

	function obj:setVisible( isShow ,isEnable)
		local enable = isEnable or isShow
		echoInfo("TTTTTTTTTLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLisShow:%s ,isEnable:%s",isShow, enable)
		obj.imageMenuItem:setVisible( isShow )
		obj.imageMenuItem:setEnabled( enable )
		obj.image:setVisible( isShow )
	end

	function obj:removeFromParentAndCleanup( bBool )
		obj.imageMenuItem:removeFromParentAndCleanup( bBool ) 
		obj.image:removeFromParentAndCleanup( bBool )
	end

	function obj:setScale(scale)
		obj.imageMenuItem:setScale(scale)
	end
	function obj:setOpacity(opacity)
		obj.imageMenuItem:setOpacity(opacity)
	end

	function obj:setPositionX(x)
		obj.imageMenuItem:setPositionX(x)
	end

	function obj:setPositionY(y)
		obj.imageMenuItem:setPositionY(y)
	end

	function obj:getScale()
		return obj.imageMenuItem:getScale( )
	end

	function obj:setEnabled( isEnabled )
		if obj.imageMenuItem ~= nil then
			obj.imageMenuItem:setEnabled( isEnabled )
		end
	end

	function obj:setSelected( bSelected )
		if obj.imageMenuItem ~= nil then
			if bSelected then
				obj.imageMenuItem:selected() 
			else
				obj.imageMenuItem:unselected() 
			end
		end
	end

	function obj:setScaleY( scale )
		if obj.imageMenuItem ~= nil then
				obj.imageMenuItem:setScaleY( scale) 
		end
	end

	function obj:setPosition( x, y )	
		if obj.imageMenuItem ~= nil then
			obj.imageMenuItem:setPosition( CCPoint(x,y) )
		end
	end

	function obj:setPos( pos )	
		if obj.imageMenuItem ~= nil then
			obj.imageMenuItem:setPosition( pos )
		end
	end
	
	function obj:getPosition( )	
		if obj.imageMenuItem ~= nil then
			return obj.imageMenuItem:getPosition()
		end
	end

	function obj:getPositionX( )	
		if obj.imageMenuItem ~= nil then
			return obj.imageMenuItem:getPositionX()
		end
	end

	function obj:getPositionY( )	
		if obj.imageMenuItem ~= nil then
			return obj.imageMenuItem:getPositionY()
		end
	end

	function obj:getContentSize( )	
		if obj.imageMenuItem ~= nil then
			return obj.imageMenuItem:getContentSize()
		end
	end

	function obj:addChild( node )	
		if obj.imageMenuItem ~= nil then
			return obj.imageMenuItem:addChild( node )
		end
	end

	function obj:setTextColor( color )
		if obj.image ~= nil then
			obj.image:setTextColor( color )
			obj.imageSelect:setTextColor( color )
		end
	end

	function obj:setLabelOffset( x, y )
		if obj.image ~= nil then
			obj.image:setTextOffset( x, y)
			obj.imageSelect:setTextOffset( x, y)
		end
	end

	function obj:setFontSize( size )
		if obj.image ~= nil then
			obj.image:setFontSize( size )
			obj.imageSelect:setFontSize( size )
		end
	end

	function obj:stopAllActions( )
		if obj.imageMenuItem ~= nil then
			obj.imageMenuItem:stopAllActions()
		end
	end

	function obj:runAction( action )
		if obj.imageMenuItem ~= nil then
			obj.imageMenuItem:runAction( action )
		end
	end

	
	function obj:setNormalImage( sprite )
		if obj.imageMenuItem ~= nil then
			obj.imageMenuItem:setDisabledImage( sprite )
		end
	end


	function obj:setSelectedImage( sprite )
		if obj.imageMenuItem ~= nil then
			obj.imageMenuItem:setDisabledImage( sprite )
		end
	end

	function obj:setDisabledImage( sprite )
		if obj.imageMenuItem ~= nil then
			obj.imageMenuItem:setDisabledImage( sprite )
		end
	end

	function obj:setString(text)
    	obj.image:setString( text )
    	obj.imageSelect:setString( text )
    end

    function obj:setVisible( isVisible )
    	if obj.imageMenuItem ~= nil then
    		-- echoInfo("dddddddddiiiiiiiiissssssssaaaaaaaaaaabbbbbllllllllleeeeeeeeeeee")
			obj.imageMenuItem:setVisible( isVisible )
		end
    end
    
	return obj
end

-- simple button with sprite and bmlabel 
function baseUI.BMButton( menu, spriteName , textString, font, onclick, sound )
	local obj = {}
	obj.image = baseUI.SpriteWithBMText( spriteName, textString, font )
	obj.imageSelect = baseUI.SpriteWithBMText( spriteName, textString, font )
	local imageMenuItem = ui.newImageMenuItem({
		image = obj.image.sprite,
		imageSelected = obj.imageSelect.sprite,
		-- x = point.x,
		-- y = point.y,
		listener = function() onclick() end,
		})
	obj.imageMenuItem = imageMenuItem
	menu:addChild( imageMenuItem )

	--如果没有传递声音文件 使用默认的声音
	if sound == nil then
		sound = Resource.Sound.buttonTap
	end

	function obj:setOnclick( onclick )
        if type( onclick ) == "function" then
            obj.imageMenuItem:registerScriptTapHandler(function(tag)
				if sound then audioex.playSound(sound) end
                onclick(tag)
            end)
        end
	end

	function obj:setPosition( x, y )	
		obj.imageMenuItem:setPosition( CCPoint( x, y) )
	end 

	function obj:setLabelOffset( x, y )
		if obj.image ~= nil then
			obj.image:setTextOffset( x, y)
		end
	end

	return obj
end

-- simple button with 9sprite and bmlabel 
function baseUI.Sprite9Button( menu, spriteName , textString, size, onclick,  pos )
	local obj = {}
	obj.image = baseUI.Scale9SpriteWithText( spriteName, textString, size , pos )
	obj.imageSelect = baseUI.Scale9SpriteWithText( spriteName, textString, size, pos  )
	local imageMenuItem = ui.newImageMenuItem({
		image = obj.image.sprite,
		imageSelected = obj.imageSelect.sprite,
		-- x = point.x,
		-- y = point.y,
		listener = function() 
			onclick()
		 end,
		})
	obj.imageMenuItem = imageMenuItem
	menu:addChild( imageMenuItem )
	--如果没有传递声音文件 使用默认的声音
	if sound == nil then
		sound = Resource.Sound.buttonTap
	end

	function obj:setString( text )
		obj.image:setString(text)
		obj.imageSelect:setString(text)
	end

	function obj:setOnclick( onclick )
        if type( onclick ) == "function" then
            obj.imageMenuItem:registerScriptTapHandler(function(tag)
				if sound then audioex.playSound(sound) end
                onclick(tag)
            end)
        end
	end

	function obj:setVisible( isShow )
		obj.imageMenuItem:setVisible( isShow )
		obj.imageMenuItem:setEnabled( isShow )
		obj.image:setVisible( isShow )
	end

	function obj:setPosition( x, y )	
		obj.imageMenuItem:setPosition( CCPoint( x, y) )
	end 

	function obj:setLabelOffset( x, y )
		if obj.image ~= nil then
			obj.image:setTextOffset( x, y)
			obj.imageSelect:setTextOffset( x, y)
		end
	end

	function obj:setFontSize( size )
		if obj.image ~= nil then
			obj.image:setFontSize( size )
			obj.imageSelect:setFontSize( size )
		end
	end

	function obj:setTextColor( color )
		if obj.image ~= nil then
			obj.image:setTextColor( color )
			obj.imageSelect:setTextColor( color )
		end
	end

	function obj:getContentSize()
		if obj.image ~= nil then
			return obj.image:getContentSize()
		end
	end

	return obj
end

function baseUI.createLabelSprite(params)
    local image = params.image
    local label = params.label
    local imageSub = params.imageSub
    if not image  then
        echoError("BaseUI.CreateLabelSprite invalid params")
        return nil
    end
    local sprRet
    if type(image) == "string" then
        sprRet = display.newSprite(image)
    else
        sprRet = image
    end
    local sizeSprRet = sprRet:getContentSize()
    if label then
        if type(label) == "string" then
            sprRet.label = baseUI.newTTFLabel({
                text = label,
            })
        else
           sprRet.label = label
        end
        sprRet:addChild(sprRet.label)
        sprRet.label:setPosition(sizeSprRet.width/2,sizeSprRet.height/2)
        display.align(sprRet.label,display.CENTER)
    end

    if imageSub then
        if type(imageSub) == "string" then
            sprRet.imageSub = display.newSprite(imageSub)
        else
            sprRet.imageSub = imageSub
        end
        sprRet:addChild(sprRet.imageSub)
        sprRet.imageSub:setPosition(sizeSprRet.width/2,sizeSprRet.height/2)
    end

    return sprRet
end


function baseUI.newMutliStateMenuItem(params_)
    local params = clone(params_) or {}
    local listener = params.listener
    local sound = params.sound or Resource.Sound.buttonTap
    local index = params.index
    local autoNextState = params.autoNextState or false



    if params.image then
        if type(params.image) == "string" then
            params.image = display.newSprite(params.image)
        end
    end

    if params.imageSelected then
        if type(params.imageSelected) == "string" then
            params.imageSelected = display.newSprite(params.imageSelected)
        end
    end

    if params.imageDisabled then
        if type(params.imageDisabled) == "string" then
            params.imageDisabled = display.newSprite(params.imageDisabled)
        end
    end


    local item = ui.newImageMenuItem(params)

    item.tblStateInfo = params.tblStateInfo or {}
    item.stateCurrentTag = ""
    item.stateCurrentIndex = 1
    if #item.tblStateInfo > 0 then
        item.stateCurrentTag = item.tblStateInfo[1].state
        item.stateCurrentIndex = 1
    end

    if params.image then
       for i,v in ipairs(item.tblStateInfo) do
           params.image:addChild(v.normal)
       end
    end

    if params.imageSelected then
        for i,v in ipairs(item.tblStateInfo) do
            if v.selected then
                params.imageSelected:addChild(v.selected)
            else
                --params.imageSelected:addChild(v.normal)
            end
        end
    end

    function item:setState(state)
        echoInfo("item:setState state=%s",tostring(state))
        for i,v in ipairs(item.tblStateInfo) do
            if state == v.state then
                item.stateCurrentTag = v.state
                item.stateCurrentIndex = i
                pub.setVisible(v.normal,true)
                pub.setVisible(v.selected,true)
            else
                pub.setVisible(v.normal,false)
                pub.setVisible(v.selected,false)
            end
        end
    end

    function item:getState()
        return item.tblStateInfo[item.stateCurrentIndex].state
    end

    function item:nextState()
        if item.stateCurrentIndex >= #item.tblStateInfo then
            item.stateCurrentIndex = 1
        else
            item.stateCurrentIndex = item.stateCurrentIndex+1
        end
        echoInfo("item.stateCurrentIndex=%s  item.tblStateInfo[item.stateCurrentIndex]=%s",
            tostring(item.stateCurrentIndex),tostring(item.tblStateInfo[item.stateCurrentIndex]))
        dump(item.tblStateInfo)
        item:setState(item.tblStateInfo[item.stateCurrentIndex].state)
    end


    function item:setListener( callback )
	    if type(callback) == "function" then
	        item:registerScriptTapHandler(function(tag)
	            if sound then audioex.playSound(sound) end
	            if autoNextState then
	                item:nextState()
	            end
	            callback(tag)
	        end)
	    end
    end


    item:setState(item.stateCurrentTag)
    if type(listener) == "function" then
        item:registerScriptTapHandler(function(tag)
            if sound then audioex.playSound(sound) end
            if autoNextState then
                item:nextState()
            end
            listener(tag)
        end)
    end
    return item
end


function baseUI.newImageMenuGroupItem(params)--多选1按钮组
    local listener = params.listener
    local sound = params.sound
    local index = params.index

    local item = ui.newImageMenuItem(params)

    item.index = index
    item.groupCurIndex = 1
    item.tblGroup = {}
    function item:setGroup(tblGroup)
        item.tblGroup = tblGroup
    end

    function item:flush()

        for i,v in ipairs(self.tblGroup) do
            v.groupCurIndex = self.index
            if v ~= self then
                v:unselected()
            else
                v:selected()
            end
        end
    end
    function item:getGroupCurIndex()
        return self.groupCurIndex
    end

    function item:setGroupCurIndex(value)
        for i,v in ipairs(self.tblGroup) do
            v.groupCurIndex = value
            if v.index ~= value then
                v:unselected()
            else
                v:selected()
            end
        end
    end

    if type(listener) == "function" then
        item:registerScriptTapHandler(function(tag)
            if sound then audioex.playSound(sound) end
            item:flush()
            listener(tag)
        end)
    end
    return item
end


--新解锁功能提示
--icon显示的图标（大个）
--text提示文字
function baseUI.newUnlock( iconPath, text )

	local tipLayer = require("app.BaseUI.PushLayer").new()
	tipLayer:setTouchClosed(true, CCRect(0, 0, 0, 0))
	tipLayer:setMaskColor(ccc4(13, 13, 25, 255 * 0.75 ))
	local bg = display.newSprite( Resource.NewHardBG )
	bg:setPosition(display.cx, display.cy)		--背景
	tipLayer:addChild(bg)
	local ring = display.newSprite( Resource.LuckyCard.effect )	--光圈
	tipLayer:addChild(ring)
	local icon = display.newSprite( iconPath )	--图标
	tipLayer:addChild(icon)

	local offsetX = -140
	local offsetY = 20
	ring:setPosition(display.cx + offsetX, display.cy)
	icon:setPosition(display.cx + offsetX, display.cy + offsetY)

	offsetX = 95
	local lab = baseUI.newTTFLabel({
		text =  text,
		color = BaseFontColor.dark,
		x = display.cx + offsetX,
		y = display.cy,
		size = 28,
		align = ui.TEXT_ALIGN_CENTER,
		})
	tipLayer:addChild(lab)
	ring:setScale(0.8)

	ring:runAction( CCRepeatForever:create(  CCRotateBy:create( 5, 360 ) ))

	return tipLayer

end
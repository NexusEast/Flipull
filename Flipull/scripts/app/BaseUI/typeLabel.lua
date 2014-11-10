--
-- Author: moon
-- Date: 2014-05-30 14:02:49
--
local Resource = require("app.Misc.Resource")
typeLabel = {}
typeLabel.DIRECTION_VERTICALLY = 1
typeLabel.DIRECTION_HORIZONTAL = 2

function typeLabel.newTypeItem( parent, normalNodes, selectNodes, callBack, pos, isLeft, touchPriority, direction, sound )
	local obj = {}
	obj.type = nil
	obj.type_items = {}
	--如果没有传递声音文件 使用默认的声音
	if sound == nil then
		sound = Resource.Sound.switch--buttonTap
	end
	for i = 1, #normalNodes do
		local itemNormal = normalNodes[i] 
		local itemSelect = selectNodes[i]
		if isLeft ~= nil and isLeft == true then
			itemSelect:setFlipX( true )
		end
		local item = baseUI.newImageMenuItem({
			image = itemNormal,
			imageSelected = itemSelect,
				-- text = texts[i],
				listener = function()
					if sound then audioex.playSound(sound) end
					for j = 1, #normalNodes do 
						if i ~= j then 
							obj.type_items[j]:unselected()
						else
							obj.type_items[j]:selected()
						end
					end
					-- echoInfo("+++++++++++++     btn type:%s    ++++++++++++++", btn_Types[i] )                  
					obj.type = i
					-- echoInfo("++++++++++÷+++     type:%s    ++++++++++++++", self.type )                  
					callBack( )
				end,
			}) 
		obj.type_items[i] = item
		if i == 1 then
			item:selected()
			obj.type = 1
		end
	end
	echoInfo("++++++++++÷+++     type:%s    ++++++++++++++", touchPriority )                  
	obj.typeMenu = baseUI.newMenu( obj.type_items, touchPriority or parent:getTouchPriority() ) 
	obj.typeMenu:setPosition( pos.x, pos.y )
	if direction == typeLabel.DIRECTION_VERTICALLY then
		obj.typeMenu:alignItemsHorizontally()
	else
		obj.typeMenu:alignItemsVertically()
	end
	parent:addChild( obj.typeMenu , 2 )

	function obj:setVisible( isVisible )
	    if obj.typeMenu ~= nil then
	    	obj.typeMenu:setVisible( isVisible )
    	end
    end

	return obj 
end

function typeLabel.newTypeLabel( parent, texts, normalName, selectName, callBack, pos, isLeft, touchPriority, direction )
	local obj = {}
	obj.type = nil
	obj.type_items = {}
	if sound == nil then
		sound = Resource.Sound.buttonTap
	end
	if texts ~= nil then
		for i = 1, #texts do
			local itemNormal = display.newSprite( normalName )
			local itemSelect = display.newSprite( selectName )
			if isLeft ~= nil and isLeft == true then
				itemSelect:setFlipX( true )
			end
			local item = baseUI.newImageMenuItem({
				image = itemNormal,
				imageSelected = itemSelect,
				text = texts[i],
				sound = Resource.Sound.switch,
				listener = function()
					if sound then audioex.playSound(sound) end
					for j = 1, #texts do 
						if i ~= j then 
							obj.type_items[j]:unselected()
						else
							obj.type_items[j]:selected()
						end
					end
					-- echoInfo("+++++++++++++     btn type:%s    ++++++++++++++", btn_Types[i] )                  
					obj.type = i
					-- echoInfo("++++++++++÷+++     type:%s    ++++++++++++++", self.type )                  
					callBack( i)
				end,
			}) 
			obj.type_items[i] = item
			if i == 1 then
				item:selected()
				obj.type = 1
			end
		end
				echoInfo("++++++++++÷+++     type:%s    ++++++++++++++", touchPriority )                  
		obj.typeMenu = baseUI.newMenu( obj.type_items, touchPriority or parent:getTouchPriority() ) 
		obj.typeMenu:setPosition( pos.x, pos.y )
		if direction == typeLabel.DIRECTION_VERTICALLY then
			obj.typeMenu:alignItemsHorizontally()
		else
			obj.typeMenu:alignItemsVertically()
		end
		parent:addChild( obj.typeMenu , 2 )
	end

	function obj:setVisible( isVisible )
	    if obj.typeMenu ~= nil then
	    	obj.typeMenu:setVisible( isVisible )
    	end
    end
	return obj 
end
--
-- Author: moon
-- Date: 2014-06-24 17:10:21
--
local Resource = require( "app.Misc.Resource" )
RichText = {}
	-- ,function()
	-- echoInfo("@#@#$@#%$#%#$%#$%$#" )
	-- return display.newNode() 
 -- )

function RichText.newRichElements( elementsTable, touchPriority )
	-- echoInfo("!@@@@@$$$$$$$$%T%#$$#$#" )
	local obj = {}
	obj.node = display.newNode() 
	-- local width = 0
	-- local totalWidth = 0
	-- local totalHeight = 0
	-- dump( elementsTable ,"!!!!!!!!!!!ßßßßß")
	-- for i, item in pairs( elementsTable ) do
	-- 	local size = item:getContentSize()
	-- 	item:setPositionX( 5 + width + size.width / 2 ) 
	-- 	item:setPositionY( item:getContentSize().height / 2 ) 
	-- 	width = 5 + width + size.width / 2
	-- 	totalWidth = width + size.width / 2
	-- 	if size.height > totalHeight then
	-- 		totalHeight = size.height
	-- 	end
	-- 	obj.node:addChild( item )
	-- end
	-- obj.node:setContentSize( CCSize( totalWidth, height ) )
	return obj.node
end


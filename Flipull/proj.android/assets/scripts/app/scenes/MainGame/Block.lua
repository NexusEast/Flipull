--
-- Author: Your Name
-- Date: 2014-11-09 14:30:36
--
local Block = class("Block", 
	function(param)  
       return display.newSprite( Resource.Block[param.type] )
	end)

function Block:ctor(param) 
	-- self.type = param.type 


	 

end

return Block
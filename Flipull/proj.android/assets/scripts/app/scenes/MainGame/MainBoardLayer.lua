--
-- Author: Your Name
-- Date: 2014-11-09 14:27:18
--

local Block = require("app.scenes.MainGame.Block")
local scheduler = require("framework.scheduler")
local MainBoardLayer = class("MainBoardLayer", 
	function()
       return display.newLayer()
		end)

function MainBoardLayer:generate_test_map()
	local ret =  
	{
		{2,2,2,2,3},
		{3,2,4,4,5},
		{3,2,3,2,3},
		{3,5,4,5,2},
		{2,2,3,4,5},
	} 
	return ret
end

function MainBoardLayer:dump_board(board)
	local str = "\n" .. self.cur_block_type .. "\n"
	local b = board or self.board_map
	for i=1,#b  do 
		for j=1,#b[i]   do  
			local val = tostring(b[i][j]) or "nil"
			str = str ..val .. ", "
		end
		str = str .. "\n"
	end
	echoInfo(str)
end

function MainBoardLayer:get_zored_table(size)
	local ret = {}
	for i=1,size.height do
		 local t = {}
		 for j=1,size.width do
		 	 t[j]=0
		 end
		 ret[i]=t
	end
	return ret
end

function MainBoardLayer:move_down_blocks() 
	self.last_board_state = clone(self.board_map) 
  	self.stat_table = self:get_zored_table(self.size) 
	for i=1,#self.board_map   do 
		for j=1,#self.board_map[i]   do  
			local cur_val = self.board_map[i][j]
			if cur_val == 0 then
				local cur_row = i
				while cur_row > 1 do  
					self.board_map[cur_row][j] = self.board_map[cur_row-1][j]
					self.board_map[cur_row-1][j]= 0   
					cur_row=cur_row-1    
					self.stat_table[cur_row][j] =self.stat_table[cur_row][j]+1  
				end 
			end
		end
	end

end

function MainBoardLayer:dump_block_table()
	local str = "\n"
	for i=1,self.size.height do 
		for j=1,self.size.width do 
			local b = tostring(self.block_table[i][j] or "userdata: __________")
			str = str .. b ..", "
		end
		str = str.."\n"
	end
	echoInfo(str)
end

function MainBoardLayer:update_animation_horizon(param)
	-- local done_callback = param.done_callback	
	for i=1,#self.board_map do 
		for j=1,#self.board_map[i] do  
			 local val = self.board_map[i][j]
			 if val == 0 then
			 	if self.block_table[i][j] then
			 		self.block_table[i][j]:removeFromParentAndCleanup(true)
			 		self.block_table[i][j] = nil
			 	end
			 end
		end
	end 
  	self:move_down_blocks()   
	for i=#self.stat_table,1,-1 do 
		for j=1,#self.stat_table[i] do  
			 local val = self.stat_table[i][j]
			 if val ~= 0 then  
			 	if self.last_board_state[i][j] > 0  then   
			 		local ref = self.block_table[i][j]  
			 		ref:runAction(CCMoveBy:create( 0.1,ccp(0,- val * ref:getContentSize().height))) 
			 		local temp_block = self.block_table[i+val][j]
			 		self.block_table[i+val][j] = self.block_table[i][j]
			 		self.block_table[i][j] = temp_block   

			 	end
			 end
		end
	end 

end

function  MainBoardLayer:reset_blocks_color(  )
	-- body
	for k,v in pairs(self.block_table) do
		for k1,v1 in pairs(self.block_table[k]) do
			v1:setOpacity(128)
		end
	end
end

function MainBoardLayer:are_we_game_over()
	-- local ret = false
	-- for i=1,#self.board_map do 
	-- 	for j=1,#self.board_map[i] do  
	-- 		 local val = self.board_map[i][j]
	-- 		 if val == 0 then
	-- 		 	if self.block_table[i][j] then
	-- 		 		self.block_table[i][j]:removeFromParentAndCleanup(true)
	-- 		 		self.block_table[i][j] = nil
	-- 		 	end
	-- 		 end
	-- 	end
	-- end 

	-- return ret
end

function MainBoardLayer:apply_block_action( param ) 
	local pX,pY = param.pX ,self.size.height - param.pY +1
	local direction = param.direction 

	if direction == "Horizon" then

		local got_first_block = false
		local erase_count = 0 
		if self.cur_block_type ~= 1 then got_first_block = true end
		for j=#self.board_map[pY],1,-1   do  

			if got_first_block == false then
				if self.board_map[pY][j] ~= 0 then
					got_first_block = true
					self.cur_block_type = self.board_map[pY][j] 
					-- echoInfo("GOT FIRST BLOCK:%s",self.cur_block_type)
				end
			end

			if self.board_map[pY][j] ~= self.cur_block_type and self.board_map[pY][j] ~= 0  then
				if erase_count == 0 then return end
				-- echoInfo("DIFFERENT BLOCK ENCOUNTERED!(%s)",self.board_map[pY][j])
				local temp = self.cur_block_type
				self.cur_block_type = self.board_map[pY][j]
				self.board_map[pY][j] = temp 


				local temp_pos_x , temp_pos_y = self.block_table[pY][j]:getPosition()
				-- echoInfo("SWAP POSITION:(%s,%s)",temp_pos_x , temp_pos_y)
				self.block_table[pY][j]:removeFromParentAndCleanup(true)
				self.block_table[pY][j] = Block.new({type = temp})
				self.block_table[pY][j]:setOpacity(128)
				self.block_table[pY][j]:setAnchorPoint(ccp(0,0))
				self.block_table[pY][j]:setPosition(temp_pos_x , temp_pos_y)
				self:addChild(self.block_table[pY][j])
				self:update_cur_block()
				self:update_animation_horizon()

				return
			end
			-- echoInfo("self.board_map[%d][%d]:%s , erase_count:%s",pY,j,self.board_map[pY][j],erase_count)
			if self.board_map[pY][j] ~= 0 then
				erase_count=erase_count+1
			end
			self.board_map[pY][j] = 0 
			if self.block_table[pY][j] then
				self.block_table[pY][j]:removeFromParentAndCleanup(true)
				self.block_table[pY][j] = nil
			end
		end  
 
		while pY < #self.board_map do
			pY = pY + 1

			if self.board_map[pY][1] ~= 0 then
				-- echoInfo("pY:%s",pY)
				if self.board_map[pY][1] == self.cur_block_type then 
					-- echoInfo("ERASEING:%s,CUR:%s",self.board_map[pY][1],self.cur_block_type)
					self.board_map[pY][1] = 0 
					if self.block_table[pY][1] then
						self.block_table[pY][1]:removeFromParentAndCleanup(true)
						self.block_table[pY][1] = nil
					end
				else

					if erase_count == 0 then break end
					local temp = self.cur_block_type
					self.cur_block_type = self.board_map[pY][1]
					self.board_map[pY][1] = temp 
					-- self:dump_board()
	
	
					local temp_pos_x , temp_pos_y = self.block_table[pY][1]:getPosition()
					-- echoInfo("SWAP POSITION:(%s,%s)",temp_pos_x , temp_pos_y)
					self.block_table[pY][1]:removeFromParentAndCleanup(true)
					self.block_table[pY][1] = Block.new({type = temp})
					self.block_table[pY][1]:setOpacity(128)
					self.block_table[pY][1]:setAnchorPoint(ccp(0,0))
					self.block_table[pY][1]:setPosition(temp_pos_x , temp_pos_y)
					self:addChild(self.block_table[pY][1])
					break
				end
			end
 
		end
		self:update_cur_block()
		self:update_animation_horizon()



	elseif direction == "Vertical" then
		local got_first_block = false
		local erase_count = 0 
		if self.cur_block_type ~= 1 then got_first_block = true end
		for j=1,#self.board_map   do    
			if got_first_block == false then
				if self.board_map[j][pX] ~= 0 then
					got_first_block = true
					self.cur_block_type = self.board_map[j][pX]
					-- echoInfo("GOT FIRST BLOCK:%s",self.cur_block_type)
				end
			end

			if self.board_map[j][pX] ~= self.cur_block_type and self.board_map[j][pX] ~= 0  then
				if erase_count == 0 then return end
				-- echoInfo("DIFFERENT BLOCK ENCOUNTERED!(%s)",self.board_map[pY][j])
				local temp = self.cur_block_type
				self.cur_block_type = self.board_map[j][pX]
				self.board_map[j][pX] = temp 


				local temp_pos_x , temp_pos_y = self.block_table[j][pX]:getPosition()
				-- echoInfo("SWAP POSITION:(%s,%s)",temp_pos_x , temp_pos_y)
				self.block_table[j][pX]:removeFromParentAndCleanup(true)
				self.block_table[j][pX] = Block.new({type = temp})
				self.block_table[j][pX]:setOpacity(128)
				self.block_table[j][pX]:setAnchorPoint(ccp(0,0))
				self.block_table[j][pX]:setPosition(temp_pos_x , temp_pos_y)
				self:addChild(self.block_table[j][pX])
				self:update_cur_block()
				self:update_animation_horizon()

				return
			end
			-- echoInfo("self.board_map[%d][%d]:%s , erase_count:%s",pY,j,self.board_map[pY][j],erase_count)
			if self.board_map[j][pX] ~= 0 then
				erase_count=erase_count+1
			end
			self.board_map[j][pX] = 0 
			if self.block_table[j][pX] then
				self.block_table[j][pX]:removeFromParentAndCleanup(true)
				self.block_table[j][pX] = nil
			end
		end  
 
		-- while pY < #self.board_map do
		-- 	pY = pY + 1

		-- 	if self.board_map[pY][1] ~= 0 then
		-- 		-- echoInfo("pY:%s",pY)
		-- 		if self.board_map[pY][1] == self.cur_block_type then 
		-- 			-- echoInfo("ERASEING:%s,CUR:%s",self.board_map[pY][1],self.cur_block_type)
		-- 			self.board_map[pY][1] = 0 
		-- 			if self.block_table[pY][1] then
		-- 				self.block_table[pY][1]:removeFromParentAndCleanup(true)
		-- 				self.block_table[pY][1] = nil
		-- 			end
		-- 		else

		-- 			if erase_count == 0 then break end
		-- 			local temp = self.cur_block_type
		-- 			self.cur_block_type = self.board_map[pY][1]
		-- 			self.board_map[pY][1] = temp 
		-- 			-- self:dump_board()
	
	
		-- 			local temp_pos_x , temp_pos_y = self.block_table[pY][1]:getPosition()
		-- 			-- echoInfo("SWAP POSITION:(%s,%s)",temp_pos_x , temp_pos_y)
		-- 			self.block_table[pY][1]:removeFromParentAndCleanup(true)
		-- 			self.block_table[pY][1] = Block.new({type = temp})
		-- 			self.block_table[pY][1]:setOpacity(128)
		-- 			self.block_table[pY][1]:setAnchorPoint(ccp(0,0))
		-- 			self.block_table[pY][1]:setPosition(temp_pos_x , temp_pos_y)
		-- 			self:addChild(self.block_table[pY][1])
		-- 			break
		-- 		end
		-- 	end
 
		-- end
		self:update_cur_block()
		self:update_animation_horizon()


	end
end

function MainBoardLayer:update_cur_block()
	local block_type = self.cur_block_type
	if self.cur_block then
		self.cur_block:removeFromParentAndCleanup(true)
	end
	self.cur_block = Block.new({type = block_type})
	self:addChild(self.cur_block)
	self.cur_block:setPosition(display.cx,display.top - 100)

end

function MainBoardLayer:setup_board()
	self.stat_table = {}
	self.block_table = {}
	for i=1,#self.board_map   do 
		local row = {} 
		self.stat_table[i]={}
		self.block_table[i] = {}
		for j=1,#self.board_map[i]   do  

			self.stat_table[i][j]=0 
			local block_type = self.board_map[i][j]
			local temp_block = nil
			if block_type >0 then
				temp_block = Block.new({type = block_type})
				self:addChild(temp_block)
				temp_block:setAnchorPoint(ccp(0,0))
				temp_block:setOpacity(128)
				temp_block:setPosition((j-1)*temp_block:getContentSize().width,(#self.board_map - i)*temp_block:getContentSize().height)
				temp_block:setTag(block_type) 
			end
			self.block_table[i][j]=temp_block 

		end 
	end    
end

function MainBoardLayer:setup_controller()
	
	local start_point = ccp(0,0)
	local height = 38
	local width = 78
	local block_size_width = Block.new({type = 1}):getContentSize().width
	local block_size_height = Block.new({type = 1}):getContentSize().height
	local start_grid = ccp(0,0)
	local selected_type = "NONE"
	local function onTouchEvent(event,x,y) 
		if event == "began" then
			start_point = ccp(x,y)  
			self.line = display.newScale9Sprite(Resource.MainBoardLayer.line , x, y, CCSize(100,height),0)
			self:addChild(self.line)
			self.line:setVisible(false)
			self.line:setAnchorPoint(ccp(0,0.5)) 
			start_grid.x = math.ceil( x / block_size_width )
			start_grid.y =  math.ceil( y / block_size_height ) 
		elseif event == "moved" then

			self.line:setVisible(true)
			local new_width = ccpDistance(ccp(x,y) ,start_point )
				if new_width < width then new_width = width end
			self.line:setContentSize(CCSize(new_width,height))
			self.line:setRotation(MiscTools.Lookat(start_point, ccp(x,y))  -90) 
			selected_type = "NONE"
			for i=1,#self.block_table do 	
				for j=1,#self.block_table[i] do  
					 if self.block_table[i][j] then
					 	local r = math.abs(self.line:getRotation())

					 		-- selected_type = "NONE"
					 	if ( #self.block_table - i +1) == start_grid.y    and ( (r >= 0 and r < 45) or ( r > 135 and  r <= 180) ) then 
					 		self.block_table[i][j]:setOpacity(255)
					 		selected_type = "Horizon"
					 	elseif ( j )  ==  start_grid.x     and r <= 135 and r >= 45 then
					 		self.block_table[i][j]:setOpacity(255) 
					 		selected_type = "Vertical"
					 	else 
					 		self.block_table[i][j]:setOpacity(128) 
					 	end

					 end 
				end
			end
				--todo


		elseif event == "ended" then
			self.line:removeFromParentAndCleanup(true)

			if selected_type ~= "NONE" then
				self:apply_block_action( {
					pX =  math.ceil( x / block_size_width ),
					pY = math.ceil( y / block_size_height ),
					direction = selected_type

					} ) 
				self:reset_blocks_color()
				self:dump_board()
				echoInfo("selected_type:%s",selected_type)
			end

		end
		return true
			--todo
	end
		self:setTouchEnabled( true )
		self:registerScriptTouchHandler( onTouchEvent ,false,kCCMenuHandlerPriority, false )

end

function MainBoardLayer:setup_current_block()
	self.cur_block = Block.new({type = self.cur_block_type})
	self:addChild(self.cur_block)
	self.cur_block:setPosition(display.cx,display.top - 100)
	-- body
end

function MainBoardLayer:ctor(param) 
	self.size = param.size
	self.cur_block_type = param.starting_block or 1
	self.block_table = {}
	self.board_map = param.board_map or self:generate_test_map()
	self:setup_board()
	self:setup_controller()
	self:setup_current_block()
	self:dump_block_table()
	scheduler.performWithDelayGlobal(function() 
		self:update_animation_horizon()    
	end, 1)


end

return MainBoardLayer
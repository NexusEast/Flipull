--
-- Author: yyj
-- Date: 2014-05-06 17:15:51
--
local Resource = require("app.Misc.Resource")
local ScrollView = require("app.BaseUI.ScrollView")
local ScrollTableView = class("classname", function(touchPriority)
	return ScrollView.new(nil,touchPriority) end
	)

ScrollTableView.kAlignLeft = 0x1 --左对齐
ScrollTableView.kAlignRight = 0x2 -- 右对齐
ScrollTableView.kAlignCenter = 0x3 -- 居中对齐


--[[
使用例子
local buttons = {}
    local viewSize = CCSize(500, 500)
    require("app.BaseUI.BaseUI")
    for i=1,51 do
        local file = Resource.UIButton.close
        if i == 10  then file =Resource.login_title end
        local item = baseUI.newImageMenuItem({
                image = file,
                text = "按钮",
                textFontSize =20,
                x=0,y=0,
                listener = function()
                    echoInfo("click menu %s",i)
                end
            })
        local menu = baseUI.newRectMenu({item},nil,CCRect(300,30, viewSize.width,viewSize.height))
        
        menu:setContentSize(item:getContentSize()) //非常重要
        buttons[#buttons+1]=menu
    end
    local ScrollTableView=require("app.BaseUI.ScrollTableView")
    local params={
    elements = buttons,
    contentSize = CCSize(520, 500),
    viewSize = viewSize,
    padding = ccp(20, 10),
    kAlignment = ScrollTableView.kAlignCenter,
    scrollDirection = kCCScrollViewDirectionVertical,
    pos = ccp(300, 30),
    }
    local scrollTableView = ScrollTableView:create(params)
    self:addChild(scrollTableView)
]]

--[[
params 参数table
{
	elements table 等待排列的元素 类型为CCNode
		注意：这里的元素若为CCLayer或者CCMenu，则必须限制其contentSize为其内容的大小
	contentSize scrollView 的 内容范围
	viewSize scrollView 的视图范围
	padding 元素之间的间隔，类型为CCPoint 默认为ccp(10,10)
	tbOffset 顶端和底的顶端的间隔 = 底端和底的底端的间隔
	kAlignment 元素每行的排列方式分别有kAlignLeft,kAlignRight,kAlignCenter 默认为kAlignLeft
	customConfig = { {index = offset } index 第几个元素 offset偏移point
	scrollDirection scrollView的滑动模式 kCCScrollViewDirectionVertical等
	pos 此scrollView的位置
}
]]
function ScrollTableView:create(params,touchPriority)
	assert(type(params) == "table",
           "[app.BaseUI.BaseUI] crreate params must be type table")
	local scrollTableView = ScrollTableView.new(touchPriority)
	if scrollTableView then 
		scrollTableView:setParams(params)
	end
	return scrollTableView
end
function ScrollTableView:ctor(touchPriority)
	-- echoInfo("ScrollTableView ctor  viewSize:%s  ,  touchPriority:%s",viewSize,touchPriority)
	
	self.params = nil
	self.containerLayer = nil 
end

-- return table elements
function ScrollTableView:getElements()
 	return self.params.elements
end
--return element by index [1-#elements]
function ScrollTableView:getElementByIndex(index)
	if not self.params or not self.params.elements then return nil end
	return self.params.elements[index]
end
--更换显示元素
function ScrollTableView:setElements(elements)
	assert(type(elements) == "table",
           "[app.BaseUI.BaseUI] setElements elements must be type table")
	if self.params then 
		self.params.elements = elements
		self:setParams(self.params)
	end
end
--更换所有参数，会更新视图
function ScrollTableView:setParams(params)
	self:initWithParams(params)
	self:layout()
end

--刷新显示，把不可见的元素隐藏后 重新排列
--注意：此方法仅在需要更新视图时使用
--不要与 setParams(params) 或者 setElement(elements) 配合使用
--isShowBottom 是否显示底部
function ScrollTableView:updateView(isShowBottom,animated)
	-- local params = self:initWithParams(self.params)
	-- self.params = params
	-- echoInfo("ScrollTableView updateView")
	-- dump( self.params )
	local lastContentSize = self.params.contentSize
	local lastOffset = self:getContentOffset()
	local layer = self.containerLayer --视图层
    if layer ==nil then return end

	local params = calculateLayouts(self.params,self)

	local contentSize = params.contentSize
	local direction = params.scrollDirection or kCCScrollViewDirectionVertical
	local kAlignment = params.kAlignment or ScrollTableView.kAlignLeft 
	local padding = params.padding
	local tbOffset = params.tbOffset or 0
	self:setContentSize(contentSize)
    self:setDirection(direction)
    
    layer:setContentSize(contentSize)

    local posY = contentSize.height - padding.y - tbOffset
    for key,value in ipairs(params.layoutTable) do 
    	posY = posY - value.rowHeight/2
    	for k,v in ipairs(value) do
    		local cell = v.cell
    		local pos = ccp(v.posX, posY)

    		if kAlignment == ScrollTableView.kAlignRight then 
    			pos.x = v.posX+value.blankSpaceX
    		elseif kAlignment == ScrollTableView.kAlignCenter then 
    			pos.x = v.posX+value.blankSpaceX/2
    		end
    		cell:setPosition(pos)
    		-- layer:addChild(cell)
    	end
    	posY = posY - value.rowHeight/2 - padding.y

    end

    -- self:setContainer(layer)
    -- echoInfo("%s,%s,%s",lastOffset.y,lastContentSize.height,params.contentSize.height)
    self:setContentOffset(ccp(0, lastOffset.y+lastContentSize.height-params.contentSize.height))
    if isShowBottom and self:getViewSize().height<=params.contentSize.height then 
    	self:setContentOffset(ccp(0, 0),animated)
    else
    	self:setContentOffset(ccp(0, self:getViewSize().height-params.contentSize.height),animated)
    end
end

--计算布局位置
 function calculateLayouts(params,self)
	local elements = params.elements or {}
	local contentSize = params.contentSize 
	local padding =  params.padding or ccp(10, 10)
	local tbOffset = params.tbOffset or 0
	params.tbOffset = tbOffset
	params.padding = padding
	local layoutTable = {} --每个元素都为一个rowTable

	local edgePadding = params.edgePadding or ccp(0, 0)
	params.edgePadding = edgePadding
	local countWidth = padding.x + edgePadding.x -- 计算当前行已经占据的长度
	local countHeight = padding.y + edgePadding.y + tbOffset -- 计算当前已经占据的高度
	local maxHeight = 0 --当前行元素的最高高度
	local countRows =1  --计算总行数
	local countCols = 1 --计算当前行列数
	local rowTable = {} -- 一行的元素表
	-- echoInfo("nums:%s",#elements)
	local index = 1 
	local customConfig = params.customConfig or {}
	for key,value in ipairs(elements) do
		-- echoInfo("key12222222:%s,%s",key,tolua.type(value))
		if value:isVisible() == true then 
		local cellSize = value:getBoundingBox().size
		value:setAnchorPoint(ccp(0.5, 0.5))
		local cOffset = customConfig[index] or ccp(0, 0)
		index = index + 1
		if contentSize.width -countWidth - edgePadding.x  < 
			cellSize.width+padding.x and countWidth>padding.x then
			
			rowTable.rowHeight = maxHeight
			rowTable.blankSpaceX = contentSize.width - countWidth --当前行空出的长度
			layoutTable[#layoutTable+1]=rowTable

			-- echoInfo("maxHeight:%s",maxHeight)
			--生成一行元素表后重置临时变量
			rowTable={}
			countWidth= padding.x + edgePadding.x
			countHeight = countHeight +maxHeight+padding.y
			maxHeight=0
			countCols=1
			countRows=countRows+1;
			-- echoInfo("countHeight:%s",countHeight)
		end

		--计算一行的最高高度
		if maxHeight< cellSize.height then maxHeight =cellSize.height end

		local cell = {
			posX = countWidth+cellSize.width/2 + cOffset.x,
			cell = value,
			row = countRows,
			col = countCols,
		}
		if tolua.type(value) == "CCRectMenu" then 
			value:setTouchPriority(self:getTouchPriority()+1)
		end

		countWidth = countWidth+cellSize.width+padding.x + cOffset.x
		countCols =countCols+1
		rowTable[#rowTable+1]= cell
		-- echoInfo("countWidth：%s ,%s,%s,%s,%s",key,countWidth,countHeight,cellSize.width,value)
		end
	end

	if countWidth>padding.x then 
		rowTable.rowHeight = maxHeight
		rowTable.blankSpaceX = contentSize.width - countWidth --当前行空出的长度
		layoutTable[#layoutTable+1]=rowTable
		countHeight = countHeight +maxHeight+padding.y+edgePadding.y
	end

	params.padding = padding
	params.contentSize=CCSize(contentSize.width, countHeight+ tbOffset )-- 内容高度自适应
	-- dump(layoutTable)
	params.layoutTable=layoutTable
    
    return params
end

function ScrollTableView:initWithParams(params)
	self.params = calculateLayouts(params,self)
	local viewSize = self.params.viewSize
	local pos = self.params.pos

	--把所有的元素都加成child，避免被析构
	self.containerLayer = display.newLayer()
	for i =1 ,# self.params.elements do
		self.containerLayer:addChild(self.params.elements[i])

	end

	if viewSize and tolua.type(viewSize) == "CCSize" then self:setViewSize(viewSize) end

    if pos and tolua.type(pos) == "CCPoint" then self:setPosition(pos) end
end

--布局
function ScrollTableView:layout()
	local params = self.params
	local contentSize = params.contentSize
	local direction = params.scrollDirection or kCCScrollViewDirectionVertical
	local kAlignment = params.kAlignment or ScrollTableView.kAlignLeft 
	local padding = params.padding
	self:setContentSize(contentSize)
    self:setDirection(direction)

 --    local layer  = display.newLayer()
	-- self.containerLayer = layer
	local layer = self.containerLayer
    layer:setContentSize(contentSize)

    local posY = contentSize.height - padding.y - params.edgePadding.y - params.tbOffset
    for key,value in ipairs(params.layoutTable) do 
    	posY = posY - value.rowHeight/2
    	for k,v in ipairs(value) do
    		local cell = v.cell
    		local pos = ccp(v.posX, posY)

    		if kAlignment == ScrollTableView.kAlignRight then 
    			pos.x = v.posX+value.blankSpaceX
    		elseif kAlignment == ScrollTableView.kAlignCenter then 
    			pos.x = v.posX+value.blankSpaceX/2
    		end
    		cell:setPosition(pos)
    		-- layer:addChild(cell)
    	end
    	posY = posY - value.rowHeight/2 - padding.y

    end

    self:setContainer(layer)
    self:setContentOffset(ccp(0, self:getViewSize().height-params.contentSize.height))
end

--滚动至底部
function ScrollTableView:scrollToBottom(animated)
	-- echoInfo("aabbcc")
	-- echoInfo(self:getViewSize().height..","..self.params.contentSize.height)
	if self:getViewSize().height <= self.params.contentSize.height then 
		self:scrollToPos(ccp(0, 0), animated)
	else 
	    self:setContentOffset(ccp(0, self:getViewSize().height-self.params.contentSize.height))
	end
end
--滚动至顶部
function ScrollTableView:scrollToTop(animated)
	self:scrollToPos(ccp(0, self:getViewSize().height-self.params.contentSize.height), animated)
end

--滚动至指定位置
function ScrollTableView:scrollToPos(pos,animated)
	--if animated == nil then animated = true end
    self:setContentOffset(pos,animated)--self:getViewSize().height-self.params.contentSize.height))
end

--滚动至指定索引位置 index = 1 , 2 ,3 ...
function ScrollTableView:scrollToPosByIndex(index,animated)
	local position = nil 
	local posY = self.params.contentSize.height
	local count = 0
	 for key,value in ipairs(self.params.layoutTable) do 
    	for k,v in ipairs(value) do
    		count = count + 1 
    		if count == index then 
    			-- echoInfo("index "..index)
    			local offsetY = self:getViewSize().height - posY
    			local minY = self:getViewSize().height-self.params.contentSize.height
    			local maxY = self:getViewSize().height-self.params.contentSize.height
    			if maxY < 0 then maxY = 0 end

    			if offsetY < minY then 
    				offsetY = minY 
    			elseif offsetY > maxY then 
    				offsetY = maxY 
    			end

    			self:scrollToPos(ccp(0, offsetY ), animated)

    			return 
    		end
    	end
    	posY = posY - value.rowHeight - self.params.padding.y 
    	if key == 1 then 
    		posY = posY - self.params.edgePadding.y - self.params.tbOffset 
    	end
    end
    self:scrollToBottom(animated)
end

--滚动至指定位置
function ScrollTableView:scrollToPosEX(pos,animated)
    local posFinal = clone(pos)


    local yMin,yMax = 0,0
    local yMaxOffset = self:getViewSize().height-self.params.contentSize.height
    if yMaxOffset >=0 then
        yMin,yMax = 0,yMaxOffset
        posFinal.y =  yMaxOffset
    else
        yMin,yMax = yMaxOffset,0
        if posFinal.y < yMin  then
            posFinal.y = yMin
        end
        if posFinal.y > yMax then
            posFinal.y = yMax
        end
    end
    self:setContentOffset(posFinal,animated)
end

return ScrollTableView


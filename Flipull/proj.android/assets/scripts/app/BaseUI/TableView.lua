--
-- Author: yyj
-- Date: 2014-04-28 10:23:57
--
local TableView = class("TableView",
	function(viewSize,touchPriority)
		local tableView = nil
		if viewSize then
			tableView = CCTableView:create(viewSize)
		else 
			tableView = CCTaleView:create()
		end
		echoInfo("默认的tableView的touchPriority：%s",tableView:getTouchPriority())
		if touchPriority then 
			tableView:setTouchPriority(touchPriority)
			tableView.m_touchPriority=touchPriority
		end
		tableView:setTouchEnabled(true)
		return tableView
	end) 

function TableView:ctor(viewSize , touchPriority)
	echoInfo("TableView ctor  viewSize:%s  ,  touchPriority:%s",viewSize,touchPriority)
end

return TableView
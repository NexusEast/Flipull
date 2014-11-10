--
-- Author: yyj
-- Date: 2014-04-28 13:39:52
--
local ScrollView = class("ScrollView",
	function(viewSize,touchPriority)
		local scrollView = nil
		if viewSize then
			scrollView = CCScrollView:create(viewSize)
		else 
			scrollView = CCScrollView:create()
		end
		echoInfo("默认的scrollView的touchPriority：%s ,当前:%s",scrollView:getTouchPriority(),touchPriority)
		if touchPriority then 
			scrollView:setTouchPriority(touchPriority)
			scrollView.m_touchPriority=touchPriority
		end
		scrollView:setTouchEnabled(true)
		return scrollView
	end) 

function ScrollView:ctor(viewSize , touchPriority)
	echoInfo("ScrollView ctor  viewSize:%s  ,  touchPriority:%s",viewSize,touchPriority)
end

return ScrollView

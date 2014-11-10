--
-- Author: yyj
-- Date: 2014-09-02 14:27:41
--

local Timer = require("framework.api.Timer")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

--倒计时的控件
local CountDownTimer = class("CountDownTimer")

CountDownTimer.index = 1         --统计现在正在使用的倒计时数量


--[[
params = {
	countDownTime = 倒计时时间
	delay = 间隔
	callback = 每delay时间调用一次回调
}
]]
--创建一个倒计时对象，需addchild
function CountDownTimer.createTimer(params)
	return CountDownTimer.new(params)
end
function CountDownTimer:ctor(params)
	local countDownTime = params.countDownTime or 0 
	local delay = params.delay or 1 
	local callback = params.callback

	self.endTime = countDownTime + os.time()
	self.restTime = countDownTime
	self.timer = scheduler.scheduleGlobal(function()
   		local curTime = os.time()
   		self.restTime = self.endTime - curTime --剩余时间
   		if callback then 
   			echoInfo("倒计时 "..self.restTime)
   			callback()
   		end	
   		if self.restTime <= 0 then 
   			--倒计时结束
   			-- echoInfo("倒计时结束")
   			scheduler.unscheduleGlobal(self.timer)
   		end
   	end,delay)
end

function CountDownTimer:getRestTime()
	return self.restTime 
end

function CountDownTimer:stop()
	if self.timer then 
		self:unschedule(self.timer)
		self.timer = nil 
	end
end

return CountDownTimer
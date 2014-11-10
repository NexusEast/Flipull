--
-- Author: Wayne Dimart
-- Date: 2014-04-23 10:20:47
--

local SocketTCP = require("app.Utitls.SocketTCP") 
  
		local ByteArray = require("app.Utitls.ByteArray")
local MsgPack = require("msgpack")
local TCPConnector = class("TCPConnector")

	function TCPConnector:connect()
		 self.socket:connect()
	end

	function TCPConnector:disconnect()
		self.socket:disconnect()
	end

	function TCPConnector:close()
		self.socket:close()
	end

	function TCPConnector:getSocket()
		return self.socket
	end

	function TCPConnector:sendTable(__tab,isProclaimed)
		local blah = {} 
		for k,v in pairs(__tab) do
			local _i = tonumber(k)
			blah[string.char(_i+34)] = v
			-- echoInfo("k:%s,v:%s", k,v)
		end
		local packed = MsgPack.pack(blah)

		-- MiscTools.DumpMsgPack(packed)
		local packByte = ByteArray.new(ByteArray.ENDIAN_BIG)
            :writeShort(
                ByteArray.new()
                :writeString(packed)
                :getLen()+2)
            :writeString(packed)
            
		-- MiscTools.DumpMsgPack(packByte:getPack())
		self.socket:send(packByte:getPack())
	end

	function TCPConnector:status(__event)

		-- echoInfo("status")
		if self.listenerTable.status then
			 self.listenerTable.status(__event)
		end
		 
	end


	function TCPConnector:readShort(str)
		return ByteArray.new(ByteArray.ENDIAN_BIG):writeStringBytes(str):setPos(1):readShort()
	end

	function TCPConnector:unpackAndSendDataToCaller(__event)
		self.isReceivingData = nil
		__event.data = self.data
		local dataBody = string.sub(__event.data,3,self.headLen)   
		if not self.dontUnpackMsg then 
			__event.unpacked = MsgPack.unpack(dataBody) 
		else
			__event.rawdata = dataBody
		end 
 		if self.listenerTable.data then
			 self.listenerTable.data(__event)
		end
		self.headLen = nil
		self.recvLen = nil
		self.data = nil
	end

	function TCPConnector:onData(__event)
        echoInfo("ONDATAAAAAAAAAAAAAA")

        if  self.isReceivingData == nil then
        	self.isReceivingData = true 
        	self.headLen = self:readShort(string.sub(__event.data,1,2)) 
        	self.recvLen = string.len(__event.data)
            echoInfo("ONDATAAAAAAAAAAAAAA1111")
            echoInfo("first self.headLen = %s self.recvLen=%s",tostring(self.headLen),tostring(self.recvLen))
        	self.data = __event.data   
        else --receiving data
            echoInfo("ONDATAAAAAAAAAAAAAA2222")
            echoInfo("string.len(__event.data)=%s",tostring(string.len(__event.data)))
        	self.recvLen = string.len(__event.data) + self.recvLen 
        	self.data = self.data .. __event.data  
        end

        if self.headLen <= self.recvLen then -- we have receive enought data.
        	self:unpackAndSendDataToCaller(__event) 
        end
 

	end

	function TCPConnector:setListeners(listenerTable)

		self.listenerTable = listenerTable 
        self.socket:addEventListener(SocketTCP.EVENT_CONNECTED, handler(self,self.status))
        self.socket:addEventListener(SocketTCP.EVENT_CLOSE, handler(self,self.status))
        self.socket:addEventListener(SocketTCP.EVENT_CLOSED, handler(self,self.status))
        self.socket:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE, handler(self,self.status))
        self.socket:addEventListener(SocketTCP.EVENT_DATA, handler(self,self.onData))
	end
	function TCPConnector:ctor(ip,port,retryConnectWhenFailure,dontUnpackMsg) 
		self.dontUnpackMsg = dontUnpackMsg 
		self.ip = ip
		self.port = port
		self.retryIfFailure = retryConnectWhenFailure		
		self.socket = SocketTCP.new(ip,port,retryConnectWhenFailure) 


	end


return TCPConnector
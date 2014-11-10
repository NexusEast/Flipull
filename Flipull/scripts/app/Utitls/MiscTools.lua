--
-- Author: Wayne Dimart
-- Date: 2014-02-18 16:15:51
--


 MiscTools = {}
 
function MiscTools.dump (tbl,hstr) 
  local _str = hstr or "<var>"
   local str = require("app.Utitls.inspect").inspect(tbl) 
   local traceback = string.split(debug.traceback("", 2), "\n")
    -- echo("dump from: " .. string.trim(traceback[3]))
   echoInfo("DUMPING FROM:[%s]",traceback[3])
   echoInfo("%s = %s",_str,str)
end
 

function MiscTools.dumpStr (tbl) 
   return require("app.Utitls.inspect").inspect(tbl) 
end


function MiscTools.generateMaskLayer(_param)
  local pos = _param.pos or ccp(display.cx, display.cy)
  local size = _param.size or CCSize(128, 128) 
  local opacity = _param.opacity or 255 

  local bg = display.newColorLayer(ccc4(0, 0, 0, 255))  
  local mask = display.newSprite(MiscTools.parseResourceName("asss.png"), pos.x, pos.y)
  bg:addChild(mask)
  -- mask:setOpacity(12)
  local scaleX , scaleY  =  (size.width / mask:getContentSize().width),(size.height / mask:getContentSize().height)
 
  mask:setScaleY(scaleY)
  mask:setScaleX(scaleX)

  local rt = CCRenderTexture:create(display.width ,display.height,kCCTexture2DPixelFormat_RGBA8888); 
      rt:beginWithClear(0,0,0,0) 
      bg:visit() 
      rt:endToLua()   
  local final = CCNodeExtend.extend(CCSprite:createWithTexture(rt:getSprite():getTexture()) )
 
  final:setPosition(display.cx, display.cy)

  local blendFunc = ccBlendFunc()
  blendFunc.src = GL_DST_COLOR
  blendFunc.dst = GL_SRC_ALPHA
  final:setScaleY(-1)
  final:setBlendFunc(blendFunc)
  final:setOpacity( 255 - opacity ) 

  return final


end

 function MiscTools.shuffle(t)
  local n = #t
 
  while n >= 2 do
    -- n is now the last pertinent index
    local k = math.random(n) -- 1 <= k <= n
    -- Quick swap
    t[n], t[k] = t[k], t[n]
    n = n - 1
  end
 
  return t
end
local clock = os.clock
function MiscTools.sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end
function MiscTools.debugPosition(src,offset,parent)
  if not offset then offset = ccp(0, 0) end
  echoInfo("%.2f,%.2f", offset.x,offset.y)
  local tempSprite = display.newSprite(require("app.Misc.Resource").login_btnStart,0,0)
  tempSprite:addTo(parent or src:getParent()) 
   tempSprite:setTouchEnabled(true)
      tempSprite:registerScriptTouchHandler(function(e,x,y) 

         tempSprite:setPosition(offset.x+x,offset.y+y)
         src:setPosition(offset.x+x,offset.y+y)
         echoInfo("%s,%s,%s",e,offset.x+x,offset.y+y)
         return true
      end
         , false, -100000, true)
end
 function MiscTools.DumpMsgPack(src)
   local ByteArray = require("app.Utitls.ByteArray")
            local pack = ByteArray.new() 
            :writeString(src)
            echoInfo("%s", pack:toString(16," "))
 end

 function MiscTools.HTTPRequest(paraLable)

      local ByteArray = require("app.Utitls.ByteArray")
   local _mp = true
   -- if paraLable.isMsgPackFmt then
      if paraLable.isMsgPackFmt == false then _mp = false end 
   -- end

   local m =require("msgpack")
   local _method = paraLable.method or kCCHTTPRequestMethodPOST
   local client = CCHTTPRequest:createWithUrl(function(arg1)
      --dump(arg1)

      if paraLable.onRequestOver then
          paraLable.onRequestOver()
      end

      local bConnectSuccess = false
      if arg1.name == "completed" then
          if arg1.request:getResponseStatusCode() == 200 then
              bConnectSuccess = true
          end
      end

      if not bConnectSuccess then
          LoadingLayer.removeLoading()
          if paraLable.isCallbackWhenTimeout then 
            local  messageBox =  require("app.BaseUI.MessageBox").new("连接超时，请重试",
                function()
                    paraLable.timeoutCallback()
                end)
                local mainScene = display.getRunningScene()
                if mainScene ~= nil then
                    mainScene:addChild(messageBox,100000)
                end
          else
            ToastLayer.showToast("连接服务器失败")
          end
      else
          local unpacked = nil
          if paraLable.isRespondIsString then
              unpacked = arg1.request:getResponseString()
          else
              local arr = arg1.request:getResponseByteArray()
              local packed = ByteArray.new()

              local packedStr = ""


              for i=0,arr:count()-1 do
                  local integer = arr:objectAtIndex(i)
                  --echoInfo("%s", integer:getValue())
                  packedStr = packedStr .. string.char(integer:getValue())
                  -- packed:writeByte(integer:getValue())

              end
              --echoInfo("%s", packed:toString(16,","))
              unpacked = m.unpack(packedStr)
          end
          if paraLable.callbackFunc then
              if unpacked.Ret == -1 then
                  local  messageBox =  require("app.BaseUI.MessageBox").new(unpacked.desc)
                  local mainScene = display.getRunningScene()
                  if mainScene ~= nil then
                      mainScene:addChild(messageBox,100000)
                  end
                  if paraLable.forceCallRequestCallback then 
                      paraLable.callbackFunc(unpacked)
                  end
              elseif unpacked.Ret == 302 then
                  local  messageBox =  require("app.BaseUI.MessageBox").new("您的账号已在另一台设备登陆，被迫下线",
                    function()
                        CCDirector:sharedDirector():endToLua()
                        os.exit()
                      end)
                  local mainScene = display.getRunningScene()
                  if mainScene ~= nil then
                      mainScene:addChild(messageBox,100000)
                  end
              else
                  paraLable.callbackFunc(unpacked)
              end
          end
      end




   end 
   ,paraLable.url, _method)  

   if _mp then
      local packed = m.pack(paraLable.data) 
            local pack = ByteArray.new() 
            :writeString(packed)
      client:setPOSTDataLua(pack:toCCArray())
   else
      client:setPOSTData(paraLable.data)
   end 
   client:start()  
 end

--[[
yyj 添加一个参数 forceCallRequestCallback 为true时强制必须调用回调函数
--2014.10.8 参数改为table
{
  msgId, 
  requestData, 
  requestCallback, 
  isMsgPack, 
  isRespondString,
  isMask ,                        --是否显示进度条，默认不显示
  forceCallRequestCallback,
  isCallbackWhenTimeout ,         --请求超时是是否回调，默认为false
  timeoutCallback ,           --请求超时时回调函数
}
]]
function MiscTools.Request( params ) 
  --msgId, requestData, requestCallback, isMsgPack, isRespondString,isMask ,forceCallRequestCallback)
    if params.timeoutCallback then params.isCallbackWhenTimeout = true end
    local requestParam = 
        {
            callbackFunc            = params.requestCallback,                        --回调方法. 请求返回之后要调用的方法.
            isMsgPackFmt            = params.isMsgPack or true,                     --请求数据格式. 是否使用msgPack打包发送.设为否则只能发送字符串
            method                  = kCCHTTPRequestMethodPOST,              --请求方法
            isRespondIsString       = params.isRespondString or false,              --返回的数据是否为字符串.设为否则是msgPack格式
            url                     = getURL( params.msgId ),                        --请求的url
            data                    = params.requestData,                                 --请求的数据.
            isMask                  = params.isMask,                                --是否需要载入动画
            forceCallRequestCallback= params.forceCallRequestCallback,              --当ret~=0 时也要调用回调函数
            isCallbackWhenTimeout   = params.isCallbackWhenTimeout,
            timeoutCallback         = params.timeoutCallback,
        } 
        --echoInfo("!!!!!!!  Request  !!!!!!!")
        --echoInfo("!!!!!!!  Request url:%s !!!!!!!", requestParam.url)
        --dump(requestParam)

        if params.isMask then
            LoadingLayer.showLoading(nil,false)
            requestParam.callbackFunc = function(unpacked)
                if params.requestCallback then
                    params.requestCallback(unpacked)
                end
            end
            requestParam.onRequestOver = function()
                LoadingLayer.removeLoading()
            end
        end
        if params.isCallbackWhenTimeout and not params.timeoutCallback then 
          requestParam.timeoutCallback = function()
            if params.isMask then 
              LoadingLayer.showLoading(nil,false)
            end
            MiscTools.HTTPRequest( requestParam )
          end
        end
        MiscTools.HTTPRequest( requestParam )
end

function MiscTools.unrequire(m)
	package.loaded[m] = nil
	_G[m] = nil
	end

function MiscTools.Lookat(from,to) 

   local o = to.x - from.x;
      local a = to.y - from.y;

      local at =  math.atan(o/a)* 57.29577951;


      if  a < 0 then
          
         if   o < 0 then
            at = 180 + math.abs(at);
         else
            at = 180 - math.abs(at);  
            end  
      end
      return at;
end

   -- declare local variables
   --// exportstring( string )
   --// returns a "Lua" portable version of the string
   local function exportstring( s )
      return string.format("%q", s)
   end

   function MiscTools.FormatSeconds( totalSecs ) 
      -- local hour = totalSecs/3600
      local minute = totalSecs/60%60
      local seconds = totalSecs%60  
      return string.format("%d:%02d", minute,seconds)
   end
   --// The Save Function
   function MiscTools.saveTableToFile(  tbl,filename )
      local charS,charE = "   ","\n"
      local retStr = ""
      local file,err = io.open( filename, "wb" )
      if err then return err end

      -- initiate variables for save procedure
      local tables,lookup = { tbl },{ [tbl] = 1 }
      file:write( "return {"..charE )
      retStr = retStr ..  "return {"..charE 

      for idx,t in ipairs( tables ) do
         file:write( "-- Table: {"..idx.."}"..charE )
         file:write( "{"..charE )


          retStr = retStr ..  "-- Table: {"..idx.."}"..charE 
          retStr = retStr ..  "{"..charE  

         local thandled = {}

         for i,v in ipairs( t ) do
            thandled[i] = true
            local stype = type( v )
            -- only handle value
            if stype == "table" then
               if not lookup[v] then
                  table.insert( tables, v )
                  lookup[v] = #tables
               end
               file:write( charS.."{"..lookup[v].."},"..charE ) 
               retStr = retStr ..  charS.."{"..lookup[v].."},"..charE  
            elseif stype == "string" then
               file:write(  charS..exportstring( v )..","..charE )
               retStr = retStr ..   charS..exportstring( v )..","..charE
            elseif stype == "number" then
               file:write(  charS..tostring( v )..","..charE ) 
               retStr = retStr ..   charS..tostring( v )..","..charE
            end
         end

         for i,v in pairs( t ) do
            -- escape handled values
            if (not thandled[i]) then
            
               local str = ""
               local stype = type( i )
               -- handle index
               if stype == "table" then
                  if not lookup[i] then
                     table.insert( tables,i )
                     lookup[i] = #tables
                  end
                  str = charS.."[{"..lookup[i].."}]="
               elseif stype == "string" then
                  str = charS.."["..exportstring( i ).."]="
               elseif stype == "number" then
                  str = charS.."["..tostring( i ).."]="
               end
            
               if str ~= "" then
                  stype = type( v )
                  -- handle value
                  if stype == "table" then
                     if not lookup[v] then
                        table.insert( tables,v )
                        lookup[v] = #tables
                     end
                     file:write( str.."{"..lookup[v].."},"..charE )
                     retStr = retStr ..   str.."{"..lookup[v].."},"..charE
                  elseif stype == "string" then
                     file:write( str..exportstring( v )..","..charE )
                     retStr = retStr ..   str..exportstring( v )..","..charE
                  elseif stype == "number" then
                     file:write( str..tostring( v )..","..charE )
                     retStr = retStr ..  str..tostring( v )..","..charE 
                  end
               end
            end
         end

         file:write( "},"..charE )
         retStr = retStr ..  "},"..charE  
      end
      file:write( "}" ) 
      retStr = retStr ..  "}"  
      file:close()

      return retStr
   end
   

   function MiscTools.saveTableToStr(  tbl )
      local charS,charE = "   ","\n"
      local retStr = "" 

      -- initiate variables for save procedure
      local tables,lookup = { tbl },{ [tbl] = 1 }
      -- file:write( "return {"..charE )
      retStr = retStr ..  "return {"..charE 

      for idx,t in ipairs( tables ) do
         -- file:write( "-- Table: {"..idx.."}"..charE )
         -- file:write( "{"..charE )


          retStr = retStr ..  "-- Table: {"..idx.."}"..charE 
          retStr = retStr ..  "{"..charE  

         local thandled = {}

         for i,v in ipairs( t ) do
            thandled[i] = true
            local stype = type( v )
            -- only handle value
            if stype == "table" then
               if not lookup[v] then
                  table.insert( tables, v )
                  lookup[v] = #tables
               end
               -- file:write( charS.."{"..lookup[v].."},"..charE ) 
               retStr = retStr ..  charS.."{"..lookup[v].."},"..charE  
            elseif stype == "string" then
               -- file:write(  charS..exportstring( v )..","..charE )
               retStr = retStr ..   charS..exportstring( v )..","..charE
            elseif stype == "number" then
               -- file:write(  charS..tostring( v )..","..charE ) 
               retStr = retStr ..   charS..tostring( v )..","..charE
            end
         end

         for i,v in pairs( t ) do
            -- escape handled values
            if (not thandled[i]) then
            
               local str = ""
               local stype = type( i )
               -- handle index
               if stype == "table" then
                  if not lookup[i] then
                     table.insert( tables,i )
                     lookup[i] = #tables
                  end
                  str = charS.."[{"..lookup[i].."}]="
               elseif stype == "string" then
                  str = charS.."["..exportstring( i ).."]="
               elseif stype == "number" then
                  str = charS.."["..tostring( i ).."]="
               end
            
               if str ~= "" then
                  stype = type( v )
                  -- handle value
                  if stype == "table" then
                     if not lookup[v] then
                        table.insert( tables,v )
                        lookup[v] = #tables
                     end
                     -- file:write( str.."{"..lookup[v].."},"..charE )
                     retStr = retStr ..   str.."{"..lookup[v].."},"..charE
                  elseif stype == "string" then
                     -- file:write( str..exportstring( v )..","..charE )
                     retStr = retStr ..   str..exportstring( v )..","..charE
                  elseif stype == "number" then
                     -- file:write( str..tostring( v )..","..charE )
                     retStr = retStr ..  str..tostring( v )..","..charE 
                  end
               end
            end
         end

         -- file:write( "},"..charE )
         retStr = retStr ..  "},"..charE  
      end
      -- file:write( "}" ) 
      retStr = retStr ..  "}"  
      -- file:close()

      return retStr
   end
   

   
   --// The Load Function
   function MiscTools.loadTableFromStr( str )
      local ftables = loadstring(str) 
      local tables = ftables()
      for idx = 1,#tables do
         local tolinki = {}
         for i,v in pairs( tables[idx] ) do
            if type( v ) == "table" then
               tables[idx][i] = tables[v[1]]
            end
            if type( i ) == "table" and tables[i[1]] then
               table.insert( tolinki,{ i,tables[i[1]] } )
            end
         end
         -- link indices
         for _,v in ipairs( tolinki ) do
            tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
         end
      end
      return tables[1]
   end
   --// The Load Function
   function MiscTools.loadTableFromFile( sfile )
      local ftables,err = loadfile( sfile )
      if err then return _,err end
      local tables = ftables()
      for idx = 1,#tables do
         local tolinki = {}
         for i,v in pairs( tables[idx] ) do
            if type( v ) == "table" then
               tables[idx][i] = tables[v[1]]
            end
            if type( i ) == "table" and tables[i[1]] then
               table.insert( tolinki,{ i,tables[i[1]] } )
            end
         end
         -- link indices
         for _,v in ipairs( tolinki ) do
            tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
         end
      end
      return tables[1]
   end


	function MiscTools.parseResourceName(filename,path)
        local _filename = filename or ""
        local _path = path or ""
        if(filename == nil) then
            echoError("error from Resource.parseResourceName: arg filename can't be nil")
            return _filename
        end

        local retString = device.writablePath..require("app.Utitls.DirBase").._path..filename

        --echoInfo("filePath=%s",retString)

        return retString

	end

  function MiscTools.createARMATURESnapshot(node,rect,X,Y)
    local size = rect or node:getContentSize() 
    local x = X or node:getPositionX()
    local y = X or node:getPositionY()

    local _x =   node:getPositionX()
    local _y =   node:getPositionY()

    rt = CCRenderTexture:create(size.width,size.height,kCCTexture2DPixelFormat_RGBA8888);
    node:setScaleY(node:getScaleY()* -1)
    node:setPosition(x,y) 
      rt:beginWithClear(0, 0, 0, 0) 
      node:visit() 
      rt:endToLua()  
      node:setScaleY(node:getScaleY()* -1)
    node:setPosition(_x,_y)  
      return CCSprite:createWithTexture(rt:getSprite():getTexture()) 
          
  end
	function MiscTools.createNodeSnapshot(node)
		local size = node:getContentSize() 
		local x = node:getPositionX()
		local y = node:getPositionY()
		rt = CCRenderTexture:create(size.width,size.height,kCCTexture2DPixelFormat_RGBA8888);
		node:setScaleY(-1)
		node:setPosition(0 ,node:getContentSize().height) 
    	rt:beginWithClear(0, 0, 0, 0) 
    	node:visit() 
    	rt:endToLua()  
    	node:setScaleY(1)
		node:setPosition(x,y)  
    	return CCSprite:createWithTexture(rt:getSprite():getTexture()) 
    	    
	end
	function MiscTools.createColorSprite(size,color)
		local rt = CCRenderTexture:create(size.width, size.height)
		rt:beginWithClear(color.r, color.g, color.b, color.a)
		rt:endToLua()
		return CCSprite:createWithTexture(rt:getSprite():getTexture())
	end

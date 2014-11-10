--
-- Author: Omicron_NEGA
-- Date: 2013-12-17 18:05:36
--
------------------------------------------------------------------------------
--Load origin framework
------------------------------------------------------------------------------
local function getDirBase()
    local retDir = "res/"
    local sharedApplication = CCApplication:sharedApplication()
    local target = sharedApplication:getTargetPlatform()
    if target == kTargetAndroid or target == kTargetIphone or target == kTargetIpad then
        retDir = "res_phone/"
    end
    return retDir
end

CCLuaLoadChunksFromZIP(getDirBase().."framework_precompiled.zip")

------------------------------------------------------------------------------
--If you would update the modoules which have been require here,
--you can reset them, and require them again in modoule "appentry"
------------------------------------------------------------------------------
require("config")
require("framework.init")

------------------------------------------------------------------------------
--define UpdateScene
------------------------------------------------------------------------------
local UpdateScene = class("UpdateScene", function()
    return display.newScene("UpdateScene")
end)

--local server = "http://192.168.19.139:8088/"
local server = "http://192.168.123.1/files/"
local param = "?dev="..device.platform
local list_filename = "flist"
local downList = {}

local function hex(s)
 s=string.gsub(s,"(.)",function (x) return string.format("%02X",string.byte(x)) end)
 return s
end

local function readFile(path)
    local file = io.open(path, "rb")
    if file then
        local content = file:read("*all")
        io.close(file)
        return content
    end
    return nil
end

local function removeFile(path)
    os.remove(path)-- writefile(path, "")
   -- os.remove
end

local function checkFile(fileName, cryptoCode)
    print("checkFile:", fileName)
    print("cryptoCode:", cryptoCode)

    if not io.exists(fileName) then
        return false
    end

    local data=readFile(fileName)
    if data==nil then
        return false
    end

    if cryptoCode==nil then
        return true
    end

    local ms = crypto.md5(hex(data))
    print("file cryptoCode:", ms)
    if ms==cryptoCode then
        return true
    end

    return false
end

local function checkDirOK( path )
        require "lfs"
        local oldpath = lfs.currentdir()
        CCLuaLog("old path------> "..oldpath)

         if lfs.chdir(path) then
            lfs.chdir(oldpath)
            CCLuaLog("path check OK------> "..path)
            return true
         end

         if lfs.mkdir(path) then
            CCLuaLog("path create OK------> "..path)
            return true
         end
end

function UpdateScene:ctor()
        self.path = device.writablePath
        --if device.platform == "android" then
        --    self.path = "/mnt/sdcard/quick_x_update/"
        --end
require("app.BaseUI.BaseUI")
    local label = baseUI.newTTFLabel({
        text = "Now Loading ..... _(:3」∠)_",
        size = 64,
        x = display.cx,
        y = display.cy,
        align = ui.TEXT_ALIGN_CENTER
    })
    self:addChild(label)
end

function UpdateScene:updateFiles()
    local data = readFile(self.newListFile)
    io.writefile(self.curListFile, data)
    self.fileList = dofile(self.curListFile)
    if self.fileList==nil then
        self:endProcess()
        return
    end

    for i,v in ipairs(downList) do
        print(i,v)
        local data=readFile(v)
        local fn = string.sub(v, 1, -5)
        print("fn: ", fn)
        io.writefile(fn, data)
        removeFile(v)
    end
    self:endProcess()
end

function UpdateScene:CreatePaths(path)
    if path then
        local pathNames = string.split(path, "/")
        local curPath = pathNames[2]
        for i=3,table.maxn(pathNames) do
            CCLuaLog("curPath:"..curPath)
            require "lfs"
            lfs.mkdir(curPath .. "/" .. pathNames[i])
            curPath = curPath .. "/" .. pathNames[i] 
        end
        return curPath
    end 
end

function UpdateScene:reqNextFile()
    self.numFileCheck = self.numFileCheck+1
    self.curStageFile = self.fileListNew.stage[self.numFileCheck]
    if self.curStageFile and self.curStageFile.name then
        local fn = ""
        if self.curStageFile.path ~= nil then 
            self:CreatePaths(self.path..self.curStageFile.path) 
            fn = self.path..self.curStageFile.path..self.curStageFile.name
        else
            fn = self.path..self.curStageFile.name
        end

        if checkFile(fn, self.curStageFile.code) then
            self:reqNextFile()
            return
        end
        fn = fn..".upd"
        if checkFile(fn, self.curStageFile.code) then
            table.insert(downList, fn)
            self:reqNextFile()
            return
        end
        self:requestFromServer(self.curStageFile.name)
        return
    end

    self:updateFiles()
end

function UpdateScene:onEnterFrame(dt)
	if self.dataRecv then
		if self.requesting == list_filename then
			io.writefile(self.newListFile, self.dataRecv)
			self.dataRecv = nil

			self.fileListNew = dofile(self.newListFile)
			if self.fileListNew==nil then
				CCLuaLog(self.newListFile..": Open Error!")
				self:endProcess()
				return
			end

			CCLuaLog("new ver :::::::::" .. self.fileListNew.ver.." cur verrrrrrrrr"..self.fileList.ver)
			if self.fileListNew.ver==self.fileList.ver then
				self:endProcess()
				return
			end

                                    self.numFileCheck = 0
                                    self.requesting = "files"
                                    self:reqNextFile()
                                    return
		end

                        if self.requesting == "files" then 
                            local fn = ""
                            if self.curStageFile.path ~= nil then 
                                require "lfs"
                                local ret = lfs.mkdir(self.path..self.curStageFile.path)
                                CCLuaLog("pathhhhhhhhhhhh:"..self.path..self.curStageFile.path)
                                fn = self.path..self.curStageFile.path..self.curStageFile.name..".upd"
                            else
                            fn = self.path..self.curStageFile.name..".upd"
                            end

                            io.writefile(fn, self.dataRecv)
                            self.dataRecv = nil
                            if checkFile(fn, self.curStageFile.code) then
                                table.insert(downList, fn)
                                self:reqNextFile()
                            else
                                self:endProcess()
                            end
                            return
                        end

                        return
	end

end

function UpdateScene:onEnter()
        if not checkDirOK(self.path) or true then
            require("app.Misc.Appentry")
            return
        end

              self.curListFile =  self.path..list_filename               
	self.fileList = nil
	if io.exists(self.curListFile) then
		self.fileList = dofile(self.curListFile)
	end
	if self.fileList==nil then
		self.fileList = {
			ver = "1.0.0",
			stage = {},
			remove = {},
		}
	end

	self.requestCount = 0
	self.requesting = list_filename
             self.newListFile = self.curListFile..".upd"
	self.dataRecv = nil
	self:requestFromServer(self.requesting)

    self:scheduleUpdate(function(dt) self:onEnterFrame(dt) end)

    print("device.platform", device.platform)
    if device.platform ~= "android" then return end

    -- avoid unmeant back
    self:performWithDelay(function()
        -- keypad layer, for android
        local layer = display.newLayer()
        layer:addKeypadEventListener(function(event)
            if event == "back" then game.exit() end
        end)
        self:addChild(layer)

        layer:setKeypadEnabled(true)
    end, 0.5)
end

function UpdateScene:onExit()
end

function UpdateScene:endProcess()
	CCLuaLog("----------------------------------------UpdateScene:endProcess")

            if self.fileList and self.fileList.stage then
                local checkOK = true
                for i,v in ipairs(self.fileList.stage) do
                    if not checkFile(self.path..v.name, v.code) then
                        CCLuaLog("----------------------------------------Check Files Error")
                        checkOK = false
                        break
                    end
                end

                if checkOK then
                    for i,v in ipairs(self.fileList.stage) do
                        if v.act=="load" then
                            CCLuaLoadChunksFromZIP(self.path..v.name)
                        end
                    end
                    for i,v in ipairs(self.fileList.remove) do
                        removeFile(self.path..v)
                    end
                else
                    removeFile(self.curListFile)
                end
              end

            require("app.Misc.Appentry")
end

function UpdateScene:requestFromServer(filename, waittime)
    local url = server..filename..param
    self.requestCount = self.requestCount + 1
    local index = self.requestCount
    local request = network.createHTTPRequest(function(event)
        self:onResponse(event, index)
    end, url, "GET")
    if request then
        request:setTimeout(waittime or 30)
        request:start()
    else
        self:endProcess()
    end
end

function UpdateScene:onResponse(event, index, dumpResponse)
    local request = event.request
    printf("REQUEST %d - event.name = %s", index, event.name)
    if event.name == "completed" then
        printf("REQUEST %d - getResponseStatusCode() = %d", index, request:getResponseStatusCode())
        --printf("REQUEST %d - getResponseHeadersString() =\n%s", index, request:getResponseHeadersString())

        if request:getResponseStatusCode() ~= 200 then
        	self:endProcess()
        else
            printf("REQUEST %d - getResponseDataLength() = %d", index, request:getResponseDataLength())
            if dumpResponse then
                printf("REQUEST %d - getResponseString() =\n%s", index, request:getResponseString())
            end
            self.dataRecv = request:getResponseData()
        end
    else
        printf("REQUEST %d - getErrorCode() = %d, getErrorMessage() = %s", index, request:getErrorCode(), request:getErrorMessage())
        self:endProcess()
    end

    print("----------------------------------------")
end

local upd = UpdateScene.new()
display.replaceScene(upd)
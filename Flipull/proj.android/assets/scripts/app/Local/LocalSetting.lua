
local pub = require("app.Utitls.pub")
LocalSetting = class("LocalSetting")
LocalSetting.__index = LocalSetting


LocalSetting.s_file = Resource.LocalData.LocalSettingFile
LocalSetting.s_init = false
LocalSetting.KEY_VOL_MUSIC = "vol_music"
LocalSetting.KEY_VOL_EFFECT = "vol_effect"
LocalSetting.KEY_STAMIA_12 = "stamia_12"
LocalSetting.KEY_UPDATE_STORE = "update_store"
LocalSetting.KEY_STAMIA_18 = "stamia_18"
LocalSetting.KEY_COLLECT_BASE = "collect_base"
LocalSetting.KEY_STAMIA_FULL = "stamia_full"
LocalSetting.KEY_ACTIVITY_EARLY = "activity_early"
LocalSetting.KEY_SKILLPOINT_FULL = "skillpoint_full"
LocalSetting.KEY_EMAIL_NEW = "email_new"
LocalSetting.KEY_AUTO_ULTRA = "auto_ultra"

LocalSetting.tblDefault = {
    [LocalSetting.KEY_VOL_MUSIC] = {value="on"},
    [LocalSetting.KEY_VOL_EFFECT] = {value="on"},
    [LocalSetting.KEY_STAMIA_12] = {value="on"},
    [LocalSetting.KEY_UPDATE_STORE] = {value="on"},
    [LocalSetting.KEY_STAMIA_18] = {value="on"},
    [LocalSetting.KEY_COLLECT_BASE] = {value="on"},
    [LocalSetting.KEY_STAMIA_FULL] = {value="on"},
    [LocalSetting.KEY_ACTIVITY_EARLY] = {value="on"},
    [LocalSetting.KEY_SKILLPOINT_FULL] = {value="on"},
    [LocalSetting.KEY_EMAIL_NEW] = {value="on"},
    [LocalSetting.KEY_AUTO_ULTRA] = {value="off"},
}
LocalSetting.tbl = {}

function LocalSetting:init()
    if not self.s_init then
        self.s_init = true
        if not io.exists(self.s_file) then
            self.tbl = clone(self.tblDefault)
            pub.writeTableToFile(self.s_file, self.tbl)
        else
            self.tbl = pub.readFileFromTable(self.s_file)
        end
    end
end


function LocalSetting:setValue(key,value)
    --self:init()
    if not key or not value then
        echoError("LocalSetting:setValue Invalid params")
        return
    end

    if  not self.tbl[key] then
        if self.tblDefault[key] then
            self.tbl[key] = self.tblDefault[key]
        else
            echoError("self.tblDefault dont exist the key =%s",tostring(key))
        end
    else
       self.tbl[key].value = value
    end

end

function LocalSetting:getValue(key)
    --self:init()
    if not key then
        echoError("LocalSetting:getValue Invalid params")
        return nil
    end
    if not self.tbl[key] then
        echoError("LocalSetting:getValue not exist the key=%s",tostring(key))
        return nil
    else
        return self.tbl[key].value
    end
end
function LocalSetting:getSettings()
    --self:init()
    return self.tbl
end


function LocalSetting:flush()
    --self:init()
    pub.dump(self.tbl,self.s_file)
    pub.writeTableToFile(self.s_file, self.tbl)
end

function LocalSetting:getMusicEnabled()
    --self:init()
    local bRet = true
    if self.tbl[self.KEY_VOL_MUSIC].value == "off" then
        bRet = false
    end
    return bRet
end

function LocalSetting:getEffectEnabled()
    --self:init()
    local bRet = true
    if self.tbl[self.KEY_VOL_EFFECT].value == "off" then
        bRet = false
    end
    return bRet
end

--return LocalSetting

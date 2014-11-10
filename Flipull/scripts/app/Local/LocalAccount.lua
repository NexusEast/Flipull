local Resource = require("app.Misc.Resource")
local pub = require("app.Utitls.pub")
LocalAccount = class("LocalAccount")
LocalAccount.__index = LocalAccount


LocalAccount.s_file = Resource.LocalData.LocalAccountFile
LocalAccount.s_init = false
LocalAccount.KEY_LAST_ACCOUNT_SID = "KEY_LAST_ACCOUNT_SID"
LocalAccount.KEY_IS_SHOW_GUIDE = "KEY_IS_SHOW_GUIDE"
LocalAccount.KEY_IS_DEBUG_MODE = "KEY_IS_DEBUG_MODE"

LocalAccount.tblDefault = {
    [LocalAccount.KEY_LAST_ACCOUNT_SID] = {value=-1},
    [LocalAccount.KEY_IS_SHOW_GUIDE] = {value=true},
    [LocalAccount.KEY_IS_DEBUG_MODE] = {value=false},
}
LocalAccount.tbl = {}

function LocalAccount:init()
    if not self.s_init then
        self.s_init = true
        if not io.exists(self.s_file) then
            self.tbl = clone(self.tblDefault)
            pub.writeTableToFile(self.s_file, self.tbl)
        else
            self.tbl = pub.readFileFromTable(self.s_file)
            for k,v in pairs(self.tblDefault) do
                if not self.tbl[k] then
                    self.tbl[k] = clone(v)
                end
            end

--            table.merge(self.tbl,self.tblDefault)
        end
    end
end


function LocalAccount:getTable()
    self:init()
    return self.tbl
end

function LocalAccount:changeLastAccount(var)
    self:init()
    self.tbl[LocalAccount.KEY_LAST_ACCOUNT_SID].value = tonumber(var)
    self:flush()
end

function LocalAccount:changeShowGuide(var)
    self:init()
    self.tbl[LocalAccount.KEY_IS_SHOW_GUIDE].value = var
    self:flush()
end

function LocalAccount:changeDebugMode(var)
    self:init()
    self.tbl[LocalAccount.KEY_IS_DEBUG_MODE].value = var
    self:flush()
end

function LocalAccount:setTable(var)
    self:init()
    self.tbl = var or {}
    self:flush()
end

function LocalAccount:getLastAccount()
    self:init()
    if self.tbl and self.tbl[LocalAccount.KEY_LAST_ACCOUNT_SID] then
        return self.tbl[LocalAccount.KEY_LAST_ACCOUNT_SID].value
    else
        return nil
    end
end

function LocalAccount:getIsShowGuide()
    self:init()
    if self.tbl and self.tbl[LocalAccount.KEY_IS_SHOW_GUIDE] then
        return self.tbl[LocalAccount.KEY_IS_SHOW_GUIDE].value
    else
        return true
    end
end

function LocalAccount:getIsDebugMode()
    self:init()
    if self.tbl and self.tbl[LocalAccount.KEY_IS_DEBUG_MODE] then
        return self.tbl[LocalAccount.KEY_IS_DEBUG_MODE].value
    else
        return false
    end
end

function LocalAccount:flush()
    self:init()
    pub.dump(self.tbl,self.s_file)
    pub.writeTableToFile(self.s_file, self.tbl)
end



--return LocalAccount

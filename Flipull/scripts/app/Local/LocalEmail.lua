local Resource = require("app.Misc.Resource")
local pub = require("app.Utitls.pub")
LocalEmail = class("LocalEmail")
 LocalEmail.__index = LocalEmail


LocalEmail.s_file = Resource.LocalData.LocalEmailFile
LocalEmail.s_init = false



LocalEmail.tblDefault = {}
LocalEmail.tbl = {}
function LocalEmail:init()
    LocalEmail.s_file = Resource.LocalData.LocalEmailFile
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



function LocalEmail:getTable()
    --self:init()
    return self.tbl
end

function LocalEmail:setTable(tblNew)
    local bRet = false
    --self:init()
    if tblNew and type(tblNew) == "table" then
        bRet = true
        self.tbl = tblNew
    else
        echoError("LocalEmail:setTable invalid params")
    end
    return bRet
end


function LocalEmail:flush()
    --self:init()
    pub.writeTableToFile(self.s_file, self.tbl)
end


--return LocalEmail

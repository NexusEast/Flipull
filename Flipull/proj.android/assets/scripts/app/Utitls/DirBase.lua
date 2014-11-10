local function getDirBase()
    local retDir = "res/"
    local sharedApplication = CCApplication:sharedApplication()
    local target = sharedApplication:getTargetPlatform()
    if target == kTargetAndroid or target == kTargetIphone or target == kTargetIpad then
        retDir = "res_phone/"
    end
    return retDir
end
local DirBase = getDirBase()
return DirBase
require("app.Local.LocalSetting")
local Resource = require("app.Misc.Resource")
audioex = class("audioex")
audioex.__index = audioex

local hasPreloadedSounds = false --是否已经预加载音效文件


function audioex.playSound(filename, isLoop)
    if LocalSetting:getEffectEnabled() then
        return audio.playSound(filename, isLoop)
    else
        -- echoInfo("Effect forbidden")
        return false
    end
end

function audioex.playBackgroundMusic(filename, isLoop)
    if LocalSetting:getMusicEnabled() then
        return audio.playBackgroundMusic(filename, isLoop)
    else
        -- echoInfo("BackgroundMusic forbidden")
        return false
    end
end

function audioex.stopBackgroundMusic()
    return audio.stopBackgroundMusic()
end

--预加载所有音效i文件
function audioex.preloadAllSounds()
    if hasPreloadedSounds == true then return end
    local tbl = Resource.Sound
    local keys = table.keys(tbl)
    for i,k in ipairs(keys) do 
        if k and tbl[k] then 
            audio.preloadSound(tbl[k])
        end
    end
    hasPreloadedSounds = true
end

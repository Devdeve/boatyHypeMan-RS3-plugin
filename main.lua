local Settings = require("settings")

local settingsView = require("interface/settings")
local contentView = require("interface/content")

log("Boaty Hype Man plugin initialised")

function PluginShutdown()
    Event.SettingsLayerReady.Unsubscribe("boaty-hype-man-settings-pane")
    if settingsView then
        settingsView:Destroy()
        settingsView = nil
    end
    Event.ContentLayerReady.Unsubscribe("boaty-hype-man-content-pane")
    if contentView then
        contentView:Destroy()
        contentView = nil
    end
end

-- Sound Params
local soundParams = audio.SoundPlaybackParams.new()
soundParams.type = audio.SoundType.SCRIPT
soundParams.audioBus = audio.AudioBus.MASTER -- Makes it play despite audio settings
soundParams.volume = 0.2 -- 20%
soundParams.delayTick = 0

-- Level ups
function skillTransmitFunc(skillTransmitEvent)
    if Settings.get("enableLevelUps") then
        if skillTransmitEvent.newGameplayLevel > skillTransmitEvent.oldGameplayLevel then
            sound = math.random(4)
            if sound == 1 then
                local playLevelupSound = audio.Play(Plugin.resources.sounds.level_up.levelup, soundParams)
            end 
            if sound == 2 then
                local playLevelupSound = audio.Play(Plugin.resources.sounds.level_up.levelup1, soundParams)
            end 
            if sound == 3 then
                local playLevelupSound = audio.Play(Plugin.resources.sounds.level_up.levelup2, soundParams)
            end 
            if sound == 4 then
                local playLevelupSound = audio.Play(Plugin.resources.sounds.level_up.levelup3, soundParams)
            end
        end
    end
end
Event.SkillTransmit.Subscribe("myEvent", skillTransmitFunc)

-- TODO GE PRICE? (currently uses cost * 0.6 which is high alch value)
function announceDrop(item_cost)
    if item_cost * 0.6 >= var.VarPlayer.LOOT_BEAM.value then
        sound = math.random(4)
        if sound == 1 then
            local playLevelupSound = audio.Play(Plugin.resources.sounds.money.money1, soundParams)
        end 
        if sound == 2 then
            local playLevelupSound = audio.Play(Plugin.resources.sounds.money.money2, soundParams)
        end 
        if sound == 3 then
            local playLevelupSound = audio.Play(Plugin.resources.sounds.money.money3, soundParams)
        end 
        if sound == 4 then
            local playLevelupSound = audio.Play(Plugin.resources.sounds.money.money4, soundParams)
        end
    end
end

-- whe nan item is dropped in a fresh stack call annoucneDrop
function objStackAddedFunc(objStackEntityAddedEvent)
    if Settings.get("enableExpensiveDrops") then
        announceDrop(objStackEntityAddedEvent.objType.cost)
    end
end
Event.ObjStackEntityAdded.Subscribe("myEvent", objStackAddedFunc)


-- CHANGED ITEM STACK
function objStackChangedFunc(objStackEntityChangedEvent)
    if objStackEntityChangedEvent.oldCount > objStackEntityChangedEvent.newCount then 
        do return end
    end
    if Settings.get("enableExpensiveDrops") then
        announceDrop(objStackEntityChangedEvent.objType.cost)
    end
end
Event.ObjStackEntityChanged.Subscribe("myEvent", objStackChangedFunc)



--CLOG
function announceClog()
    sound = math.random(2)
    if sound == 1 then
        local playClogSound = audio.Play(Plugin.resources.sounds.collection_log.colllog1, soundParams)
    end 
    if sound == 2 then
        local playClogSound = audio.Play(Plugin.resources.sounds.collection_log.colllog2, soundParams)
    end 
end

--Death
function announceDeath()
    sound = math.random(2)
    if sound == 1 then
        local playDeathSound = audio.Play(Plugin.resources.sounds.death.death1, soundParams)
    end 
    if sound == 2 then
        local playDeathSound = audio.Play(Plugin.resources.sounds.death.death2, soundParams)
    end 
end

--Pets
function announcePet()
    local playPetSound = audio.Play(Plugin.resources.sounds.pet.pet, soundParams)
end

--Quest
function announceQuest()
    sound = math.random(2)
    if sound == 1 then
        local playQuestSound = audio.Play(Plugin.resources.sounds.quest.quest1, soundParams)
    end 
    if sound == 2 then
        local playQuestSound = audio.Play(Plugin.resources.sounds.quest.quest2, soundParams)
    end 
end

function messageFunc(chatMessageEvent)
    -- Clogs, Clogging, Collection Log
    if string.find(chatMessageEvent.chatMessage, "New collection log entry") then
        if Settings.get("enableCollectionLogs") then
            announceClog()
        end
    end
    
    -- Death
    if string.find(chatMessageEvent.chatMessage, "Oh dear, you are dead!") then
        if Settings.get("enableDeaths") then
            announceDeath()
        end
    end
    
    -- Pet Drops (Boss)
    if string.find(chatMessageEvent.chatMessage, Player.GetEntity().displayName .. " has received .* pet drop .*", 1) then
        if Settings.get("enablePetDrops") then
            announcePet()
        end
    end
    -- Pet drops (XP/Skilling)
    if string.find(chatMessageEvent.chatMessage, Player.GetEntity().displayName .. " has received .* at .*!", 1) then
        if Settings.get("enablePetDrops") then
            announcePet()
        end
    end


    -- Quest
    if string.find(chatMessageEvent.chatMessage, "Congratulations! You have completed:", 1) then
        if Settings.get("enableQuestCompletions") then
            announceQuest()
        end
    end

end
Event.ChatMessage.Subscribe("myEvent", messageFunc)

--Combat Task
function announceCombatTask()
    sound = math.random(2)
    if sound == 1 then
        local playLevelupSound = audio.Play(Plugin.resources.sounds.combat_task.combat_task1, soundParams)
    end 
    if sound == 2 then
        local playLevelupSound = audio.Play(Plugin.resources.sounds.combat_task.combat_task2, soundParams)
    end 
end

local function varEventTransmitted(varTransmitEvent)
    local lvar = varTransmitEvent.var
    if lvar.typeName == "VarPlayer" and lvar.valueType == 131 and lvar.configName == "CHEEVO_RECENT_COMPLETE_1" then
        if var.value.category == id.Category.COMBAT then
            announceCombatTask()
        end
    end
end
Event.VarTransmit.Subscribe("achievementTracker", varEventTransmitted)
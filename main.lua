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


function skillTransmitFunc(skillTransmitEvent)
    if Settings.get("enableLevelUps") then
        if skillTransmitEvent.newGameplayLevel > skillTransmitEvent.oldGameplayLevel then
            sound = math.random(4)
            if sound == 1 then
                local playLevelupSound = audio.Play(Plugin.resources.sounds.level_up.levelup)
            end 
            if sound == 2 then
                local playLevelupSound = audio.Play(Plugin.resources.sounds.level_up.levelup1)
            end 
            if sound == 3 then
                local playLevelupSound = audio.Play(Plugin.resources.sounds.level_up.levelup2)
            end 
            if sound == 4 then
                local playLevelupSound = audio.Play(Plugin.resources.sounds.level_up.levelup3)
            end
        end
    end
end
Event.SkillTransmit.Subscribe("myEvent", skillTransmitFunc)

-- TODO Combat Achievs

-- EXPENSIVE DROPS
-- TODO GE PRICE?

function announceDrop(item_cost)
    if item_cost * 0.6 >= var.VarPlayer.LOOT_BEAM.value then
        sound = math.random(4)
        if sound == 1 then
            local playLevelupSound = audio.Play(Plugin.resources.sounds.money.money1)
        end 
        if sound == 2 then
            local playLevelupSound = audio.Play(Plugin.resources.sounds.money.money2)
        end 
        if sound == 3 then
            local playLevelupSound = audio.Play(Plugin.resources.sounds.money.money3)
        end 
        if sound == 4 then
            local playLevelupSound = audio.Play(Plugin.resources.sounds.money.money4)
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
        local playLevelupSound = audio.Play(Plugin.resources.sounds.collection_log.colllog1)
    end 
    if sound == 2 then
        local playLevelupSound = audio.Play(Plugin.resources.sounds.collection_log.colllog2)
    end 
end

--Death
function announceDeath()
    sound = math.random(2)
    if sound == 1 then
        local playLevelupSound = audio.Play(Plugin.resources.sounds.death.death1)
    end 
    if sound == 2 then
        local playLevelupSound = audio.Play(Plugin.resources.sounds.death.death2)
    end 
end

--Pets
function announcePet()
    local playLevelupSound = audio.Play(Plugin.resources.sounds.pet.pet)
end

--Quest
function announcePet()
    sound = math.random(2)
    if sound == 1 then
        local playLevelupSound = audio.Play(Plugin.resources.sounds.quest.quest1)
    end 
    if sound == 2 then
        local playLevelupSound = audio.Play(Plugin.resources.sounds.quest.quest2)
    end 
end

function messageFunc(chatMessageEvent)
    -- TODO CLOGS TEST
    if string.find(chatMessageEvent.chatMessage, "New collection log entry") then
        if Settings.get("enableCollectionLogs") then
            announceClog()
        end
    end
    if string.find(chatMessageEvent.chatMessage, "Oh dear, you are dead!") then
        if Settings.get("enableDeaths") then
            announceDeath()
        end
    end
    
    -- TODO Pet Drops
    if string.find(chatMessageEvent.chatMessage, Player.GetEntity().displayName .. " has received .* pet drop .*", 1) then
        if Settings.get("enablePetDrops") then
            announcePet()
        end
    end
    -- TODO TEST
    if string.find(chatMessageEvent.chatMessage, Player.GetEntity().displayName .. " has received .* at .*!", 1) then
        if Settings.get("enablePetDrops") then
            announcePet()
        end
    end


    -- TODO TEST
    if string.find(chatMessageEvent.chatMessage, "Congratulations! You have completed:", 1) then
        if Settings.get("enableQuestCompletions") then
            announceQuest()
        end
    end

end
Event.ChatMessage.Subscribe("myEvent", messageFunc)
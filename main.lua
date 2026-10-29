local Settings = require("settings")
local Content = require("interface/content")

local sounds = Plugin.resources.sounds
local settingForTrigger = {
    levelUp = "enableLevelUps",
    questCompletion = "enableQuestCompletions",
    collectionLog = "enableCollectionLogs",
    achievement = "enableAchievements",
    death = "enableDeaths",
    petDrop = "enablePetDrops",
    expensiveDrop = "enableExpensiveDrops",
}

local soundOptions = {
    sounds = {
        levelUp = {
            sounds.level_up.levelup, sounds.level_up.levelup1,
            sounds.level_up.levelup2, sounds.level_up.levelup3,
        },
        questCompletion = { sounds.quest.quest1, sounds.quest.quest2 },
        collectionLog = { sounds.collection_log.colllog1, sounds.collection_log.colllog2 },
        achievement = { sounds.achievement.achievement1, sounds.achievement.achievement2 },
        death = { sounds.death.death1, sounds.death.death2 },
        petDrop = sounds.pet.pet,
        expensiveDrop = { sounds.money.money1, sounds.money.money2, sounds.money.money3, sounds.money.money4 },
    },
    enabled = function(trigger)
        return Settings.get(settingForTrigger[trigger])
    end,
}

for _, resources in pairs(soundOptions.sounds) do
    if type(resources) ~= "table" then resources = { resources } end
    for _, resource in ipairs(resources) do
        if type(resource) == "userdata" and not resource.loaded then
            resource:Load()
        end
    end
end

soundOptions.volume = Settings.get("volume") / 100
local soundRegistration = event_sound_library.new(soundOptions)
Settings.subscribe("boaty-hype-man-volume", function(name, value)
    if name == "volume" then
        soundRegistration:setVolume(value / 100)
    end
end)

function PluginShutdown()
    Settings.unsubscribe("boaty-hype-man-volume")
    soundRegistration:dispose()
    Content.shutdown()
end

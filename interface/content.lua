local contentView
local Settings = require("settings")
local UIUtils = require("interface/ui_utils")
Event.ContentLayerReady.Subscribe("boaty-hype-man-content-pane", function(event)
    if contentView then contentView:Destroy() end

    local parent = event.component
    contentView = prettyui.SimpleView.new(parent, {
        width = parent.width,
        height = parent.height,
    })

    contentView:AddTitle("Global Toggle")
    contentView:AddCheckboxButton({
        { text = "Enable Plugin", value = "enabled", selected = Settings.get("enabled") },
    }, {
        onChange = function(_, _, changedValue, selected)
            UIUtils.updateSettings(changedValue, selected)
        end,
    })

    contentView:AddTitle("Toggle Options")
    contentView:AddCheckboxButton({
        { text = "Enable Level ups", value = "enableLevelUps",  selected = Settings.get("enableLevelUps") },
        { text = "Enable Quest Completions", value = "enableQuestCompletions", selected = Settings.get("enableQuestCompletions") },
        { text = "Enable Collection Logs", value = "enableCollectionLogs",      selected = Settings.get("enableCollectionLogs") },
        { text = "Enable Combat Achievements", value = "enableCombatAchievements",     selected = Settings.get("enableCombatAchievements") },
        { text = "Enable Deaths", value = "enableDeaths", selected = Settings.get("enableDeaths") },
        { text = "Enable Pet Drops", value = "enablePetDrops",    selected = Settings.get("enablePetDrops") },
        { text = "Enable Expensive drops", value = "enableExpensiveDrops", selected = Settings.get("enableExpensiveDrops") },
    }, {
        onChange = function(_, _, changedValue, selected)
            UIUtils.updateSettings(changedValue, selected)
        end,
    })
end)
return contentView




local contentView
local Content = {}
local Settings = require("settings")
Event.ContentLayerReady.Subscribe("boaty-hype-man-content-pane", function(event)
    if contentView then contentView:Destroy() end

    local parent = event.component
    contentView = prettyui.SimpleView.new(parent, {
        width = parent.width,
        height = parent.height,
    })
    local volume = Settings.get("volume")
    local volumeLabel = contentView:AddText("Volume: " .. volume .. "%")
    contentView:AddSlider({
        min = 0,
        max = 100,
        step = 1,
        value = volume,
        onChange = function(_, value)
            Settings.update("volume", value)
            volumeLabel.content = "Volume: " .. value .. "%"
        end,
    })
    contentView:AddTitle("Toggle Options")
    contentView:AddCheckboxButton({
        { text = "Enable Level ups", value = "enableLevelUps",  selected = Settings.get("enableLevelUps") },
        { text = "Enable Quest Completions", value = "enableQuestCompletions", selected = Settings.get("enableQuestCompletions") },
        { text = "Enable Collection Logs", value = "enableCollectionLogs",      selected = Settings.get("enableCollectionLogs") },
        { text = "Enable Achievements", value = "enableAchievements",     selected = Settings.get("enableAchievements") },
        { text = "Enable Deaths", value = "enableDeaths", selected = Settings.get("enableDeaths") },
        { text = "Enable Pet Drops", value = "enablePetDrops",    selected = Settings.get("enablePetDrops") },
        { text = "Enable Expensive drops", value = "enableExpensiveDrops", selected = Settings.get("enableExpensiveDrops") },
    }, {
        onChange = function(_, _, changedValue, selected)
            Settings.update(changedValue, selected)
        end,
    })
end)

function Content.shutdown()
    Event.ContentLayerReady.Unsubscribe("boaty-hype-man-content-pane")
    if contentView then
        contentView:Destroy()
        contentView = nil
    end
end

return Content

local settingsView
local Settings = require("settings")
local UIUtils = require("interface/ui_utils")

Event.SettingsLayerReady.Subscribe("boaty-hype-man-settings-pane", function(event)
    if settingsView then settingsView:Destroy() end

    local parent = event.component
    settingsView = prettyui.SimpleView.new(parent, {
        width = parent.width,
        height = parent.height,
    })
end)
return settingsView
local Settings = {}

local PLUGIN_DB_PREFIX = "BoatyHypeMan_"

local CachedSettings = {}
local listeners = {}

local ValidSettings = {
    volume = {
        default = 20,
        type = "integer"
    },
    enableLevelUps = {
        default = true,
        type = "boolean"
    },
    enableQuestCompletions = {
        default = true,
        type = "boolean"
    },
    enableCollectionLogs = {
        default = true,
        type = "boolean"
    },
    enableAchievements = {
        default = true,
        type = "boolean"
    },
    enableDeaths = {
        default = true,
        type = "boolean"
    },
    enablePetDrops = {
        default = true,
        type = "boolean"
    },
    enableExpensiveDrops = {
        default = true,
        type = "boolean"
    }
}

local function assertValidSetting(settingName)
    if ValidSettings[settingName] == nil then
        error("Unknown setting: " .. tostring(settingName))
    end
end

local function makeKey(settingName)
    return PLUGIN_DB_PREFIX .. settingName
end

function Settings.subscribe(name, callback)
    assert(type(callback) == "function", "Setting listener must be a function")
    listeners[name] = callback
end

function Settings.unsubscribe(name)
    listeners[name] = nil
end

function Settings.update(settingName, value)
    assertValidSetting(settingName)

    local setting = ValidSettings[settingName]

    if setting.type == "integer" then
        assert(type(value) == "number" and value % 1 == 0 and value >= 0 and value <= 100,
            "Volume must be an integer between 0 and 100")
    end

    if setting.type == "boolean" then
        PersistentDB:SetBool(makeKey(settingName), value)
    elseif setting.type == "integer" then
        PersistentDB:SetInt(makeKey(settingName), value)
    end

    CachedSettings[settingName] = value
    for _, callback in pairs(listeners) do callback(settingName, value) end
end

function Settings.get(settingName)
    assertValidSetting(settingName)

    if CachedSettings[settingName] ~= nil then
        return CachedSettings[settingName]
    end

    local setting = ValidSettings[settingName]
    local value

    if setting.type == "boolean" then
        value = PersistentDB:GetBool(makeKey(settingName))
    elseif setting.type == "integer" then
        value = PersistentDB:GetInt(makeKey(settingName))
    end

    if value == nil then
        value = setting.default

        if setting.type == "boolean" then
            PersistentDB:SetBool(makeKey(settingName), value)
        elseif setting.type == "integer" then
            PersistentDB:SetInt(makeKey(settingName), value)
        end
    end

    CachedSettings[settingName] = value
    return value
end

return Settings

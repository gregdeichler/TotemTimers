local addonName, addon = ...

TotemTimers = CreateFrame("Frame", "TotemTimersFrame", UIParent)
TotemTimersDB = TotemTimersDB or {}

local defaults = {
    locked   = false,
    compact  = false,
    vertical = false,
    scale    = 1.0,
}

local function TT_LoadDB()
    for k, v in pairs(defaults) do
        if TotemTimersDB[k] == nil then
            TotemTimersDB[k] = v
        end
    end
end

addon.TOTEMS = {
    Earth = {
        ["Strength of Earth Totem"] = 120,
        ["Stoneskin Totem"]          = 120,
        -- ["Tremor Totem"]         = 120,   -- uncomment if you want it
    },
    Fire = {
        ["Searing Totem"] = 30,
        ["Magma Totem"]   = 20,
        -- ["Fire Nova Totem"] = 5,   -- duration is cast time + 5s, usually not tracked this way
    },
    Water = {
        ["Healing Stream Totem"] = 60,
        ["Mana Spring Totem"]    = 60,
    },
    Air = {
        ["Windfury Totem"]   = 120,
        ["Grace of Air Totem"] = 120,
        -- ["Tranquil Air Totem"] = 120,
        -- ["Grounding Totem"]    = 45,    -- short duration, often not worth tracking
    },
}

addon.ACTIVE = {}

function addon.StartTimer(spellName)
    if not spellName then return end

    for element, list in pairs(addon.TOTEMS) do
        for name, duration in pairs(list) do
            if spellName == name then
                addon.ACTIVE[element] = {
                    name     = name,
                    start    = GetTime(),
                    duration = duration,
                }
                return   -- first match wins
            end
        end
    end
end

function addon.StopTotem(element)
    addon.ACTIVE[element] = nil
    addon.UpdateButton(element, nil)
end

function addon.UpdateTimers()
    local now = GetTime()
    for element, data in pairs(addon.ACTIVE) do
        local remain = data.duration - (now - data.start)
        if remain <= 0 then
            addon.StopTotem(element)
        else
            addon.UpdateButton(element, remain, data.name)
        end
    end
end

-- Events
TotemTimers:RegisterEvent("PLAYER_ENTERING_WORLD")
TotemTimers:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

TotemTimers:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        TT_LoadDB()
        TT_CreateAnchor()
        TT_InitUI()
        TT_ApplyLayout()

        -- hide all buttons on login
        for _, e in ipairs({"Earth","Fire","Water","Air"}) do
            local btn = _G["TotemTimers_"..e]
            if btn then btn:Hide() end
        end

    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unit, spellName = ...
        if unit == "player" and spellName then
            addon.StartTimer(spellName)
        end
    end
end)

TotemTimers:SetScript("OnUpdate", function()
    addon.UpdateTimers()
end)
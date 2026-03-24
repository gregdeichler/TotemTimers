local TT = _G.TotemTimersAddon or {}
_G.TotemTimersAddon = TT

local ELEMENTS = { "Earth", "Fire", "Water", "Air" }
TT.ELEMENTS = ELEMENTS

TT.frame = CreateFrame("Frame", "TotemTimersFrame", UIParent)
TotemTimersDB = TotemTimersDB or {}

local defaults = {
    locked = false,
    compact = false,
    vertical = false,
    scale = 1,
    anchor = {
        point = "CENTER",
        x = 0,
        y = 100,
    },
    twistThreshold = 10,
}

local function CopyDefaults(dst, src)
    for key, value in pairs(src) do
        if type(value) == "table" then
            if type(dst[key]) ~= "table" then
                dst[key] = {}
            end
            CopyDefaults(dst[key], value)
        elseif dst[key] == nil then
            dst[key] = value
        end
    end
end

function TT.LoadDB()
    CopyDefaults(TotemTimersDB, defaults)
end

TT.TOTEMS = {
    Earth = {
        ["Earthbind Totem"] = 45,
        ["Stoneclaw Totem"] = 15,
        ["Stoneskin Totem"] = 120,
        ["Strength of Earth Totem"] = 120,
        ["Tremor Totem"] = 120,
    },
    Fire = {
        ["Fire Nova Totem"] = 5,
        ["Flametongue Totem"] = 120,
        ["Frost Resistance Totem"] = 120,
        ["Magma Totem"] = 20,
        ["Searing Totem"] = 30,
    },
    Water = {
        ["Disease Cleansing Totem"] = 120,
        ["Fire Resistance Totem"] = 120,
        ["Healing Stream Totem"] = 60,
        ["Mana Spring Totem"] = 60,
        ["Mana Tide Totem"] = 12,
        ["Poison Cleansing Totem"] = 120,
    },
    Air = {
        ["Grace of Air Totem"] = 120,
        ["Grounding Totem"] = 45,
        ["Nature Resistance Totem"] = 120,
        ["Sentry Totem"] = 300,
        ["Tranquil Air Totem"] = 120,
        ["Windfury Totem"] = 120,
        ["Windwall Totem"] = 120,
    },
}

TT.ACTIVE = TT.ACTIVE or {}
TT.GCD = TT.GCD or { start = 0, duration = 1.5 }

function TT.GetButton(element)
    return _G["TotemTimers_" .. element]
end

function TT.GetTotemInfo(spellName)
    local element, duration
    for e, list in pairs(TT.TOTEMS) do
        duration = list[spellName]
        if duration then
            element = e
            break
        end
    end

    if element then
        return element, duration
    end
end

function TT.StartGCD()
    TT.GCD.start = GetTime()
end

function TT.StartTimer(spellName)
    local element, duration = TT.GetTotemInfo(spellName)
    if not element then
        return
    end

    TT.ACTIVE[element] = {
        element = element,
        name = spellName,
        start = GetTime(),
        duration = duration,
    }

    TT.UpdateButton(element, duration, spellName)
    TT.UpdateTwistHelper()
end

function TT.StopTotem(element)
    TT.ACTIVE[element] = nil
    TT.UpdateButton(element, nil)
    TT.UpdateTwistHelper()
end

function TT.UpdateTimers()
    local now = GetTime()

    for _, element in ipairs(ELEMENTS) do
        local data = TT.ACTIVE[element]
        if data then
            local remain = data.duration - (now - data.start)
            if remain <= 0 then
                TT.ACTIVE[element] = nil
                TT.UpdateButton(element, nil)
            else
                TT.UpdateButton(element, remain, data.name)
            end
        end
    end
    TT.UpdateTwistHelper()
end

TT.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
TT.frame:RegisterEvent("UNIT_SPELLCAST_SENT")
TT.frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

TT.frame:SetScript("OnEvent", function()
    local event = event
    if event == "PLAYER_ENTERING_WORLD" then
        TT.LoadDB()
        TT.CreateAnchor()
        TT.InitUI()
        TT.ApplyLayout()
        TT.UpdateAnchorState()
        TT.UpdateTwistHelper()
    elseif event == "UNIT_SPELLCAST_SENT" then
        local unit = arg1
        local spellName = arg2
        if unit == "player" then
            if spellName and TT.GetTotemInfo(spellName) then
                TT.StartGCD()
            end
        end
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unit = arg1
        local spellName = arg2
        if unit == "player" and spellName and TT.GetTotemInfo(spellName) then
            TT.StartGCD()
            TT.StartTimer(spellName)
        end
    end
end)

TT.frame:SetScript("OnUpdate", function()
    TT.UpdateTimers()
end)

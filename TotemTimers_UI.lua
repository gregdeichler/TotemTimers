local TT = _G.TotemTimersAddon

local NORMAL_SIZE = 36
local COMPACT_SIZE = 28

function TT.FormatTime(timeLeft)
    if timeLeft >= 60 then
        return string.format("%d:%02d", math.floor(timeLeft / 60), math.floor(math.mod(timeLeft, 60)))
    end

    return tostring(math.ceil(timeLeft))
end

local function CreateBackdrop(frame)
    frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    frame:SetBackdropColor(0.04, 0.04, 0.04, 0.85)
    frame:SetBackdropBorderColor(0.35, 0.35, 0.35, 1)
end

function TT.CreateButton(element)
    local btn = CreateFrame("Button", "TotemTimers_" .. element, UIParent)
    btn.element = element

    btn.icon = btn:CreateTexture(nil, "ARTWORK")
    btn.icon:SetPoint("TOPLEFT", btn, "TOPLEFT", 2, -2)
    btn.icon:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -2, 2)

    btn.cooldown = btn:CreateTexture(nil, "OVERLAY")
    btn.cooldown:SetTexture(0, 0, 0, 0.58)
    btn.cooldown:SetPoint("BOTTOMLEFT", btn.icon, "BOTTOMLEFT")
    btn.cooldown:SetPoint("BOTTOMRIGHT", btn.icon, "BOTTOMRIGHT")

    btn.gcd = btn:CreateTexture(nil, "OVERLAY")
    btn.gcd:SetTexture(1, 1, 1, 0.18)
    btn.gcd:SetAllPoints(btn.icon)
    btn.gcd:Hide()

    btn.time = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    btn.time:SetPoint("CENTER", btn, "CENTER", 0, 0)
    btn.time:SetJustifyH("CENTER")

    btn.label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    btn.label:SetPoint("BOTTOM", btn, "TOP", 0, 3)
    btn.label:SetText(element)
    btn.label:SetTextColor(0.85, 0.82, 0.64)

    CreateBackdrop(btn)

    btn:EnableMouse(true)
    btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    btn:SetScript("OnClick", function()
        if arg1 == "RightButton" then
            TT.StopTotem(element)
        end
    end)

    btn:Hide()
    return btn
end

local function UpdateTimerVisual(btn, remaining, duration)
    local pct = remaining / duration
    if pct < 0 then pct = 0 end
    if pct > 1 then pct = 1 end

    btn.time:SetText(TT.FormatTime(remaining))
    btn.cooldown:SetHeight(btn.icon:GetHeight() * pct)
end

local function UpdateGCDOverlay(btn)
    local remaining = TT.GetGCDRemaining()
    if remaining > 0 then
        local alpha = 0.08 + (remaining / TT.GCD.duration) * 0.25
        btn.gcd:SetTexture(1, 1, 1, alpha)
        btn.gcd:Show()
    else
        btn.gcd:Hide()
    end
end

function TT.UpdateButton(element, timeLeft, name)
    local btn = TT.GetButton(element)
    if not btn then
        return
    end

    if not timeLeft or timeLeft <= 0 then
        btn:Hide()
        return
    end

    local data = TT.ACTIVE[element]
    if not data then
        btn:Hide()
        return
    end

    btn:Show()

    if name then
        local texture = GetSpellTexture(name)
        if texture then
            btn.icon:SetTexture(texture)
        end
    end

    UpdateTimerVisual(btn, timeLeft, data.duration)
    UpdateGCDOverlay(btn)

    if TT.ApplyAdvancedVisuals then
        TT.ApplyAdvancedVisuals(btn, timeLeft, data.duration, element)
    end
end

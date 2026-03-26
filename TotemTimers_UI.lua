local TT = _G.TotemTimersAddon

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
    frame:SetBackdropColor(0.05, 0.05, 0.05, 0.88)
    frame:SetBackdropBorderColor(0.42, 0.39, 0.3, 1)
end

local function GetSpellTextureByName(spellName)
    local index = TT.GetSpellbookSlot(spellName)
    if index then
        return GetSpellTexture(index, BOOKTYPE_SPELL)
    end

    return "Interface\\Icons\\Spell_Nature_EarthBindTotem"
end

local function HideOtherMenus(activeElement)
    local index
    for index = 1, table.getn(TT.ELEMENTS) do
        local element = TT.ELEMENTS[index]
        if element ~= activeElement then
            local btn = TT.GetButton(element)
            if btn and btn.menu then
                btn.menu:Hide()
            end
        end
    end
end

local function IsMouseOverFrame(frame)
    if not frame or not frame:IsShown() then
        return false
    end

    local scale = frame:GetEffectiveScale()
    local left = frame:GetLeft()
    local right = frame:GetRight()
    local top = frame:GetTop()
    local bottom = frame:GetBottom()
    local x, y = GetCursorPosition()

    if not left or not right or not top or not bottom then
        return false
    end

    x = x / scale
    y = y / scale

    return x >= left and x <= right and y >= bottom and y <= top
end

local function ScheduleMenuHide(btn)
    if not btn then
        return
    end

    btn.hideMenuAt = GetTime() + 0.12
    btn:SetScript("OnUpdate", function()
        if not this.hideMenuAt or GetTime() < this.hideMenuAt then
            return
        end

        if IsMouseOverFrame(this) or IsMouseOverFrame(this.menu) then
            this.hideMenuAt = nil
            return
        end

        if this.menu then
            this.menu:Hide()
        end
        this.hideMenuAt = nil
        this:SetScript("OnUpdate", nil)
    end)
end

local function CreateMenuButton(parent, index)
    local item = CreateFrame("Button", nil, parent)
    item:SetWidth(32)
    item:SetHeight(32)
    item:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    item:SetBackdropColor(0.03, 0.03, 0.03, 0.96)
    item:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

    item.icon = item:CreateTexture(nil, "ARTWORK")
    item.icon:SetPoint("TOPLEFT", item, "TOPLEFT", 2, -2)
    item.icon:SetPoint("BOTTOMRIGHT", item, "BOTTOMRIGHT", -2, 2)

    item:SetScript("OnEnter", function()
        if this.spellName then
            GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
            GameTooltip:SetText(this.spellName)
            GameTooltip:Show()
        end
    end)
    item:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    item:SetScript("OnClick", function()
        if not this.spellName then
            return
        end

        TT.SetSelectedSpell(this.element, this.spellName)
        CastSpellByName(this.spellName)
        parent:Hide()
    end)

    if index == 1 then
        item:SetPoint("TOPLEFT", parent, "TOPLEFT", 4, -4)
    end

    return item
end

local function CreateSpellMenu(btn)
    local menu = CreateFrame("Frame", nil, btn)
    menu:SetWidth(40)
    menu:SetHeight(40)
    menu:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    menu:SetBackdropColor(0.02, 0.02, 0.02, 0.95)
    menu:SetBackdropBorderColor(0.75, 0.64, 0.22, 1)
    menu:SetFrameStrata("DIALOG")
    menu:EnableMouse(true)
    menu:Hide()

    menu.buttons = {}
    menu.owner = btn
    menu:SetScript("OnEnter", function()
        this.owner.hideMenuAt = nil
    end)
    menu:SetScript("OnLeave", function()
        ScheduleMenuHide(this.owner)
    end)

    btn.menu = menu
    return menu
end

function TT.UpdateSpellMenu(element)
    local btn = TT.GetButton(element)
    local spells
    local index
    local item
    local menuWidth
    local menuHeight

    if not btn or not btn.menu then
        return
    end

    spells = TT.GetKnownTotems(element)
    menuWidth = 40
    menuHeight = (table.getn(spells) * 36) + 8
    if table.getn(spells) < 1 then
        menuWidth = 40
        menuHeight = 40
    end

    btn.menu:ClearAllPoints()
    btn.menu:SetPoint("BOTTOM", btn, "TOP", 0, 6)
    btn.menu:SetWidth(menuWidth)
    btn.menu:SetHeight(menuHeight)

    for index = 1, table.getn(spells) do
        item = btn.menu.buttons[index]
        if not item then
            item = CreateMenuButton(btn.menu, index)
            btn.menu.buttons[index] = item
        end

        item.element = element
        item.spellName = spells[index]
        item.icon:SetTexture(GetSpellTextureByName(spells[index]))
        item:ClearAllPoints()
        item:SetPoint("TOPLEFT", btn.menu, "TOPLEFT", 4, -4 - ((index - 1) * 36))

        if TotemTimersDB.selected[element] == spells[index] then
            item:SetBackdropBorderColor(1, 0.82, 0.25, 1)
        else
            item:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
        end

        item:Show()
    end

    for index = table.getn(spells) + 1, table.getn(btn.menu.buttons) do
        btn.menu.buttons[index]:Hide()
    end

    if table.getn(spells) < 2 then
        btn.menu:Hide()
    end
end

function TT.CreateButton(element)
    local btn = CreateFrame("Button", "TotemTimers_" .. element, UIParent)
    btn.element = element
    btn:RegisterForDrag("LeftButton")

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
    btn.label:SetTextColor(0.9, 0.84, 0.58)

    CreateBackdrop(btn)
    CreateSpellMenu(btn)

    btn:EnableMouse(true)
    btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    btn:SetScript("OnDragStart", function()
        TT.StartMovingAnchor()
    end)
    btn:SetScript("OnDragStop", function()
        TT.StopMovingAnchor()
    end)
    btn:SetScript("OnClick", function()
        if arg1 == "RightButton" then
            TT.StopTotem(element)
        else
            TT.CastSelectedSpell(element)
        end
    end)
    btn:SetScript("OnEnter", function()
        this.hideMenuAt = nil
        HideOtherMenus(element)
        TT.UpdateSpellMenu(element)
        if table.getn(TT.GetKnownTotems(element)) > 1 then
            this.menu:Show()
        end
    end)
    btn:SetScript("OnLeave", function()
        ScheduleMenuHide(this)
    end)

    TT.UpdateSpellMenu(element)
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
    local spellName
    local texture

    if not btn then
        return
    end

    if not TT.HasKnownTotems(element) then
        btn:Hide()
        if btn.menu then
            btn.menu:Hide()
        end
        return
    end

    btn:Show()
    spellName = name or TT.GetSelectedSpell(element)
    texture = spellName and GetSpellTextureByName(spellName) or "Interface\\Icons\\INV_Misc_QuestionMark"
    btn.icon:SetTexture(texture)

    local data = TT.ACTIVE[element]
    if timeLeft and timeLeft > 0 and data then
        UpdateTimerVisual(btn, timeLeft, data.duration)
        UpdateGCDOverlay(btn)

        if TT.ApplyAdvancedVisuals then
            TT.ApplyAdvancedVisuals(btn, timeLeft, data.duration, element)
        end
    else
        btn.time:SetText("")
        btn.cooldown:SetHeight(0)
        btn.gcd:Hide()
        btn:SetBackdropBorderColor(0.42, 0.39, 0.3, 1)
        if btn.glow then
            btn.glow:Hide()
        end
    end

    TT.UpdateSpellMenu(element)
end

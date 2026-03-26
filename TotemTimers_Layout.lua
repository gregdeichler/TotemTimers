local TT = _G.TotemTimersAddon

local function GetButtonSize()
    if TotemTimersDB.compact then
        return 28
    end

    return 36
end

function TT.SaveAnchorPosition(frame)
    local point, _, _, x, y = frame:GetPoint(1)
    TotemTimersDB.anchor.point = point or "CENTER"
    TotemTimersDB.anchor.x = x or 0
    TotemTimersDB.anchor.y = y or 100
end

function TT.UpdateAnchorState()
    local anchor = TT.ANCHOR
    if not anchor then
        return
    end

    if TotemTimersDB.locked then
        anchor:SetBackdropColor(0, 0, 0, 0)
        anchor:SetBackdropBorderColor(0, 0, 0, 0)
        anchor.text:Hide()
        anchor:EnableMouse(false)
    else
        anchor:SetBackdropColor(0, 0, 0, 0.45)
        anchor:SetBackdropBorderColor(0.95, 0.82, 0.25, 0.85)
        anchor.text:Show()
        anchor:EnableMouse(true)
    end
end

function TT.CreateAnchor()
    if TT.ANCHOR then
        return
    end

    local anchor = CreateFrame("Frame", "TT_Anchor", UIParent)
    anchor:SetWidth(220)
    anchor:SetHeight(72)
    anchor:SetMovable(true)
    anchor:EnableMouse(true)
    anchor:RegisterForDrag("LeftButton")
    anchor:SetClampedToScreen(true)
    anchor:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 14,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    anchor:SetBackdropColor(0, 0, 0, 0.45)
    anchor:SetBackdropBorderColor(0.95, 0.82, 0.25, 0.85)

    anchor.text = anchor:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    anchor.text:SetPoint("CENTER", anchor, "CENTER", 0, 0)
    anchor.text:SetText("TotemTimers\nDrag while unlocked")
    anchor.text:SetJustifyH("CENTER")

    anchor.twist = anchor:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    anchor.twist:SetPoint("TOP", anchor, "BOTTOM", 0, -6)
    anchor.twist:SetTextColor(1, 0.82, 0.36)
    anchor.twist:SetJustifyH("CENTER")

    anchor:SetScript("OnDragStart", function()
        if not TotemTimersDB.locked then
            this:StartMoving()
        end
    end)
    anchor:SetScript("OnDragStop", function()
        this:StopMovingOrSizing()
        TT.SaveAnchorPosition(this)
    end)

    anchor:ClearAllPoints()
    anchor:SetPoint(
        TotemTimersDB.anchor.point or "CENTER",
        UIParent,
        TotemTimersDB.anchor.point or "CENTER",
        TotemTimersDB.anchor.x or 0,
        TotemTimersDB.anchor.y or 100
    )

    TT.ANCHOR = anchor
end

function TT.UpdateTwistHelper()
    local anchor = TT.ANCHOR
    if not anchor or not anchor.twist then
        return
    end

    local threshold = TotemTimersDB.twistThreshold or 10
    local message = ""
    local priority = { "Air", "Fire", "Earth", "Water" }
    local index

    for index = 1, table.getn(priority) do
        local element = priority[index]
        local data = TT.ACTIVE[element]
        if data then
            local remaining = data.duration - (GetTime() - data.start)
            if remaining <= threshold then
                message = string.format("Twist soon: %s (%ss)", data.name, math.ceil(remaining))
                break
            end
        end
    end

    anchor.twist:SetText(message)
    if message == "" and TotemTimersDB.locked then
        anchor.twist:Hide()
    else
        anchor.twist:Show()
    end
end

function TT.ApplyLayout()
    local last
    local index
    local size = GetButtonSize()
    local spacing = TotemTimersDB.compact and 4 or 6
    local anchorWidth = TotemTimersDB.vertical and size + 20 or (size * 4) + (spacing * 3) + 20
    local anchorHeight = TotemTimersDB.vertical and (size * 4) + (spacing * 3) + 20 or size + 28

    if TT.ANCHOR then
        TT.ANCHOR:SetWidth(anchorWidth)
        TT.ANCHOR:SetHeight(anchorHeight)
    end

    for index = 1, table.getn(TT.ELEMENTS) do
        local element = TT.ELEMENTS[index]
        local btn = TT.GetButton(element)
        if btn then
            btn:SetWidth(size)
            btn:SetHeight(size)
            if TotemTimersDB.compact then
                btn.label:Hide()
            else
                btn.label:Show()
            end

            btn:ClearAllPoints()
            if not last then
                btn:SetPoint("TOPLEFT", TT.ANCHOR, "TOPLEFT", 10, -10)
            elseif TotemTimersDB.vertical then
                btn:SetPoint("TOP", last, "BOTTOM", 0, -spacing)
            else
                btn:SetPoint("LEFT", last, "RIGHT", spacing, 0)
            end

            last = btn
        end
    end

    TT.UpdateAnchorState()
    TT.UpdateTwistHelper()
    for index = 1, table.getn(TT.ELEMENTS) do
        TT.UpdateButton(TT.ELEMENTS[index])
    end
end

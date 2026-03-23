function TT_CreateAnchor()
    local a = CreateFrame("Frame", "TT_Anchor", UIParent)
    a:SetWidth(200)
    a:SetHeight(50)
    a:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
    a:SetMovable(true)
    a:EnableMouse(true)
    a:RegisterForDrag("LeftButton")
    a:SetScript("OnDragStart", function(self)
        if not TotemTimersDB.locked then
            self:StartMoving()
        end
    end)
    a:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    -- optional: visual feedback when unlocked
    a:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile     = true, tileSize = 16, edgeSize = 16,
        insets   = {left = 4, right = 4, top = 4, bottom = 4}
    })
    a:SetBackdropColor(0, 0, 0, 0.4)
    a:SetBackdropBorderColor(1, 1, 0, 0.8)

    addon.ANCHOR = a
end

function TT_ApplyLayout()
    local last
    for _, e in ipairs({"Earth", "Fire", "Water", "Air"}) do
        local btn = _G["TotemTimers_"..e]
        if not btn then goto continue end

        btn:ClearAllPoints()
        if not last then
            btn:SetPoint("CENTER", addon.ANCHOR, "CENTER")
        else
            if TotemTimersDB.vertical then
                btn:SetPoint("TOP", last, "BOTTOM", 0, -6)
            else
                btn:SetPoint("LEFT", last, "RIGHT", 6, 0)
            end
        end
        last = btn

        ::continue::
    end
end
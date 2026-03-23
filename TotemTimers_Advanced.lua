addon.GCD = { start = 0, duration = 1.5 }

function addon.GetGCDRemaining()
    local r = addon.GCD.duration - (GetTime() - addon.GCD.start)
    return r > 0 and r or 0
end

function addon.ApplyAdvancedVisuals(btn, remaining, duration)
    local pct = remaining / duration

    -- red → green border
    btn.border:SetBackdropBorderColor(1 - pct, pct, 0)

    -- glow when low
    if pct < 0.2 then
        if not btn.glow then
            btn.glow = btn:CreateTexture(nil, "OVERLAY")
            btn.glow:SetAllPoints()
            btn.glow:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
            btn.glow:SetBlendMode("ADD")
            btn.glow:SetVertexColor(1, 0.8, 0.4)
        end
        btn.glow:Show()
    elseif btn.glow then
        btn.glow:Hide()
    end
end
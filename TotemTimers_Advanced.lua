TT_GCD={start=0,duration=1.5}
function TT_GetGCDRemaining()
 local r=TT_GCD.duration-(GetTime()-TT_GCD.start)
 return r>0 and r or 0
end

function TT_ApplyAdvancedVisuals(btn,remaining,duration)
 local pct=remaining/duration
 btn.border:SetBackdropBorderColor(1-pct,pct,0)

 if pct<0.2 then
  if not btn.glow then
   btn.glow=btn:CreateTexture(nil,"OVERLAY")
   btn.glow:SetAllPoints()
   btn.glow:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
   btn.glow:SetBlendMode("ADD")
  end
  btn.glow:Show()
 elseif btn.glow then
  btn.glow:Hide()
 end
end

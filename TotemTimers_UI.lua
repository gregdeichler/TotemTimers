function TT_FormatTime(t)
 if t>=60 then return string.format("%d:%02d",math.floor(t/60),math.floor(t%60))
 else return tostring(math.ceil(t)) end
end

function TT_CreateButton(element)
 local btn=CreateFrame("Button","TotemTimers_"..element,UIParent)
 btn:SetWidth(36) btn:SetHeight(36)

 btn.icon=btn:CreateTexture(nil,"ARTWORK")
 btn.icon:SetAllPoints()

 btn.cooldown=btn:CreateTexture(nil,"OVERLAY")
 btn.cooldown:SetTexture(0,0,0,0.5)
 btn.cooldown:SetPoint("BOTTOMLEFT")
 btn.cooldown:SetPoint("BOTTOMRIGHT")

 btn.time=btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
 btn.time:SetPoint("CENTER")

 btn.border=CreateFrame("Frame",nil,btn)
 btn.border:SetAllPoints()
 btn.border:SetBackdrop({edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",edgeSize=12})

 btn:EnableMouse(true)
 btn:RegisterForClicks("LeftButtonUp","RightButtonUp")

 btn:SetScript("OnClick",function()
  if arg1=="RightButton" then TT_StopTotem(element) end
 end)

 return btn
end

function TT_UpdateVisual(btn,remaining,duration)
 btn.time:SetText(TT_FormatTime(remaining))
 local pct=remaining/duration
 btn.cooldown:SetHeight(btn:GetHeight()*pct)
end

function TT_UpdateButton(element,timeLeft,name)
 local btn=_G["TotemTimers_"..element]
 if not btn then return end

 if not timeLeft then btn:Hide() return end
 btn:Show()

 local tex=GetSpellTexture(name)
 if tex then btn.icon:SetTexture(tex) end

 local data=TT_ACTIVE[element]
 if data then
  TT_UpdateVisual(btn,timeLeft,data.duration)
  if TT_ApplyAdvancedVisuals then
   TT_ApplyAdvancedVisuals(btn,timeLeft,data.duration,element)
  end
 end
end

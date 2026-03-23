function TT_CreateAnchor()
 local a=CreateFrame("Frame","TT_Anchor",UIParent)
 a:SetWidth(200) a:SetHeight(50)
 a:SetPoint("CENTER",UIParent,"CENTER",0,0)
 a:SetMovable(true)
 a:RegisterForDrag("LeftButton")
 a:SetScript("OnDragStart",function()
  if not TotemTimersDB.locked then this:StartMoving() end
 end)
 a:SetScript("OnDragStop",function() this:StopMovingOrSizing() end)
 TT_ANCHOR=a
end

function TT_ApplyLayout()
 local last
 for _,e in ipairs({"Earth","Fire","Water","Air"}) do
  local btn=_G["TotemTimers_"..e]
  btn:ClearAllPoints()
  if not last then
   btn:SetPoint("CENTER",TT_ANCHOR,"CENTER")
  else
   if TotemTimersDB.vertical then
    btn:SetPoint("TOP",last,"BOTTOM",0,-6)
   else
    btn:SetPoint("LEFT",last,"RIGHT",6,0)
   end
  end
  last=btn
 end
end

TotemTimers = CreateFrame("Frame","TotemTimersFrame",UIParent)
TotemTimersDB = TotemTimersDB or {}

local defaults = { locked=false, compact=false, vertical=false, scale=1.0 }

local function TT_LoadDB()
 for k,v in pairs(defaults) do
  if TotemTimersDB[k]==nil then TotemTimersDB[k]=v end
 end
end

TT_TOTEMS = {
 Earth = {["Strength of Earth Totem"]=120,["Stoneskin Totem"]=120},
 Fire = {["Searing Totem"]=30,["Magma Totem"]=20},
 Water = {["Healing Stream Totem"]=60,["Mana Spring Totem"]=60},
 Air = {["Windfury Totem"]=120,["Grace of Air Totem"]=120},
}

TT_ACTIVE = {}

function TT_StartTimer(spell)
 for element,list in pairs(TT_TOTEMS) do
  for name,duration in pairs(list) do
   if string.find(spell,name) then
    TT_ACTIVE[element]={name=name,start=GetTime(),duration=duration}
   end
  end
 end
end

function TT_StopTotem(element)
 TT_ACTIVE[element]=nil
 TT_UpdateButton(element,nil)
end

function TT_UpdateTimers()
 local now=GetTime()
 for element,data in pairs(TT_ACTIVE) do
  local remain=data.duration-(now-data.start)
  if remain<=0 then TT_StopTotem(element)
  else TT_UpdateButton(element,remain,data.name) end
 end
end

TotemTimers:RegisterEvent("PLAYER_ENTERING_WORLD")
TotemTimers:RegisterEvent("SPELLCAST_STOP")

TotemTimers:SetScript("OnEvent",function()
 if event=="PLAYER_ENTERING_WORLD" then
  TT_LoadDB()
  TT_CreateAnchor()
  TT_InitUI()
  TT_ApplyLayout()
 end
 if event=="SPELLCAST_STOP" then
  local spell=UnitCastingInfo and UnitCastingInfo("player")
  if spell then TT_StartTimer(spell) end
 end
end)

TotemTimers:SetScript("OnUpdate",function() TT_UpdateTimers() end)

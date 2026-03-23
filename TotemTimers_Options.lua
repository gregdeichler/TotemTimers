local panel=CreateFrame("Frame","TotemTimersOptions",UIParent)
panel.name="TotemTimers"
local title=panel:CreateFontString(nil,"ARTWORK","GameFontNormalLarge")
title:SetPoint("TOPLEFT",16,-16)
title:SetText("TotemTimers")
InterfaceOptions_AddCategory(panel)

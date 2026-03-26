local TT = _G.TotemTimersAddon

SLASH_TOTEMTIMERS1 = "/tt"
SlashCmdList["TOTEMTIMERS"] = function(msg)
    msg = string.lower(msg or "")

    if msg == "lock" then
        TotemTimersDB.locked = not TotemTimersDB.locked
        TT.UpdateAnchorState()
        print("TotemTimers anchor " .. (TotemTimersDB.locked and "locked" or "unlocked"))
    elseif msg == "compact" then
        TotemTimersDB.compact = not TotemTimersDB.compact
        TT.ApplyLayout()
        print("TotemTimers compact mode " .. (TotemTimersDB.compact and "enabled" or "disabled"))
    elseif msg == "vertical" then
        TotemTimersDB.vertical = not TotemTimersDB.vertical
        TT.ApplyLayout()
        print("TotemTimers vertical layout " .. (TotemTimersDB.vertical and "enabled" or "disabled"))
    elseif msg == "reset" then
        TT.ResetAnchorPosition()
        TT.ApplyLayout()
        print("TotemTimers position reset")
    elseif msg == "test" then
        TT.ACTIVE.Fire = {
            element = "Fire",
            name = "Searing Totem",
            start = GetTime(),
            duration = 30,
        }
        TT.UpdateButton("Fire", 30, "Searing Totem")
        TT.UpdateTwistHelper()
        print("TotemTimers test timer started")
    else
        print("/tt lock | compact | vertical | reset | test")
    end
end

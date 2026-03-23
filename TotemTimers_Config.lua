SLASH_TOTEMTIMERS1="/tt"
SlashCmdList["TOTEMTIMERS"]=function(msg)
 msg=string.lower(msg or "")
 if msg=="lock" then
  TotemTimersDB.locked=not TotemTimersDB.locked
 elseif msg=="compact" then
  TotemTimersDB.compact=not TotemTimersDB.compact
 elseif msg=="vertical" then
  TotemTimersDB.vertical=not TotemTimersDB.vertical
  TT_ApplyLayout()
 else
  print("/tt lock | compact | vertical")
 end
end

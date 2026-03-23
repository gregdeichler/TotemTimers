local elements={"Earth","Fire","Water","Air"}
function TT_InitUI()
 for _,e in ipairs(elements) do TT_CreateButton(e) end
end

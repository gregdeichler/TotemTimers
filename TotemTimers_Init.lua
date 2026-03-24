local TT = _G.TotemTimersAddon

function TT.InitUI()
    local index
    for index, element in ipairs(TT.ELEMENTS) do
        if not TT.GetButton(element) then
            TT.CreateButton(element)
        end
    end
end

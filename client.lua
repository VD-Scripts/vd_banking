local banks = {
    {149.96476745605,-1040.75390625,29.374092102051},
    {237.21691894531,217.67002868652,106.28681945801}
}
local display = false
local hard = false
local inPos = false
local bx,by,bz = 0

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(1000)

--         if(not inPos)then

--             for k,v in pairs(banks) do
--                 if(#(GetEntityCoords(PlayerPedId()) - vector3(v[1],v[2],v[3])) <= 1.5)then
--                     inPos = true
--                     bx,by,bz = v[1], v[2], v[3]
--                 end
--             end

--         end
--     end
-- end)

local function drawTxt(text, x,y, scale, r, g, b)
    SetTextDropShadow(1, 5, 5, 5, 255)
    SetTextFont(fontId)
    SetTextProportional(0)
    SetTextScale(0.25, 0.25)
    SetTextColour(r, g, b, 255)
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x,y)
end


Citizen.CreateThread(function()
    while true do
        for k,v in pairs(banks) do
            if #(GetEntityCoords(PlayerPedId()) - vector3(v[1],v[2],v[3])) <= 1.5 then
                drawTxt("APASA [~r~E~w~] CA SA PORNESTI MENIUL", 0.4883, 0.95, 0.0, 255, 255, 255)
                DrawMarker(29, v[1],v[2],v[3], 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 50, false, true, 2, nil, nil, false)
            end
        end
        Citizen.Wait(1)
    end
end)

RegisterCommand("+openBankingMenu", function()

    Citizen.CreateThread(function()

        for k,v in pairs(banks) do
            if(#(GetEntityCoords(PlayerPedId()) - vector3(v[1],v[2],v[3])) <= 1.5)then
                TriggerServerEvent("vd:showData")
                openUi()
            end
        end
    
    end)

end)

RegisterKeyMapping("+openBankingMenu", "Porneste meniul de banking", "keyboard", "E")

function openUi()
    display = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type="ui",
    })
end

RegisterNUICallback('exit', function(data)
    display = false
    SetNuiFocus(false, false)
end)


RegisterNetEvent("cData")
AddEventHandler("cData", function(balanta, name)
    SendNUIMessage({
        type = "cData",
        bani = balanta,
        nume = name,
    })
end)


RegisterNUICallback("getBalanta", function()
    TriggerServerEvent("vd:balanta")
end)

RegisterNUICallback("error", function(data)
    TriggerEvent("notify", 1, "INFO", data.error, 5000)
end)

RegisterNUICallback("withdraw", function(data)
    TriggerServerEvent("vd:retrage", tonumber(data.text))
end)

RegisterNUICallback("deposit", function(data)
    TriggerServerEvent("vd:depozit", tonumber(data.text))
end)

RegisterNUICallback("transfer", function(data)
    TriggerServerEvent("vd:transfer", tonumber(data.id), tonumber(data.value))
end)
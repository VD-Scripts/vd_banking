local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "vd_banking")

local taxa = 1000

local banks = {
    {149.96476745605,-1040.75390625,29.374092102051},
    {237.21691894531,217.67002868652,106.28681945801}
}

RegisterServerEvent("vd:showData")
AddEventHandler("vd:showData", function()
    thePlayer = source
    local user_id = vRP.getUserId({thePlayer})
    local money = vRP.getBankMoney({user_id})
    local name = GetPlayerName(thePlayer)

    TriggerClientEvent("cData", thePlayer, money, name)
end)

RegisterServerEvent("vd:retrage")
AddEventHandler("vd:retrage", function(data)
    thePlayer = source
    local user_id = vRP.getUserId({thePlayer})
    local b = vRP.getBankMoney({user_id})
    
    --print(data)

    if(data ~= nil and data)then
        if(data > b)then
            TriggerClientEvent('chatMessage', thePlayer, "^2Banking^0 Nu ai acea suma in banca!")
        else
            local salutfrate = b - data
            vRP.setBankMoney({user_id,salutfrate})

            vRP.giveMoney({user_id,data})

            vRPclient.notify(thePlayer, {"[BCR] Ai scos din banca "..data.."$"})
        end
    else
        TriggerClientEvent('chatMessage', thePlayer, "^2Anti-Nebuni:^0 Cf nebunule?")
    end

end)


RegisterServerEvent("vd:depozit")
AddEventHandler("vd:depozit", function(data)
    thePlayer = source
    local user_id = vRP.getUserId({thePlayer})

    if(data ~= nil and data)then
        if(vRP.tryPayment({user_id,data}))then

            vRP.giveBankMoney({user_id,data})
            vRPclient.notify(thePlayer,{"[BCR] Ai bagat "..data.."$ in contul tau bancar\nTaxe: "..taxa.."$"})
        
        else
            TriggerClientEvent('chatMessage', thePlayer, "^2Banking:^0 Nu ai acea suma in portofel")
        end
    else
        TriggerClientEvent('chatMessage', thePlayer, "^2Anti-Nebuni:^0 Cf nebunule?")
    end
end)


RegisterServerEvent("vd:transfer")
AddEventHandler("vd:transfer", function(id, value)
    thePlayer = source
    local user_id = vRP.getUserId({thePlayer})
    local target_src = vRP.getUserSource({id})
    
    if(id ~= nil and value ~= nil)then

        if(id ~= user_id)then
            if(vRP.tryFullPayment({user_id,value}))then
            
                vRP.giveBankMoney({id,value})
                vRPclient.notify(thePlayer,{"[BCR] Ai transferat lui "..GetPlayerName(target_src).." suma de "..value.."$ in contul sau bancar"})
                vRPclient.notify(target_src,{"[BCR] Ai primit "..value.."$ de la "..GetPlayerName(thePlayer)})
    
            else
                TriggerClientEvent('chatMessage', thePlayer, "^2Banking:^0 Nu ai destui bani")
            end
        else
            TriggerClientEvent('chatMessage', thePlayer, "^2Banking:^0 Nu iti poti transfera bani tie")
        end

    else
        TriggerClientEvent("chatMessage", thePlayer, "^2Anti-Nebuni:^0 Cf nebunule?")
    end
end)


AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
		for k,v in pairs(banks) do
            vRPclient.addBlip(source,{v[1],v[2],v[3],272,1,"BCR"})
        end
	end
end)
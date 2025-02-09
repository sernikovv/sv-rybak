ESX = exports.es_extended.getSharedObject()
local ryby = {
    'fish_sum',
    'fish_okon',
    'fish_mintaj',
    'fish_losos',
    'fish_szczupak',
    'fish_jesiotr'
}

ESX.RegisterServerCallback('sv-rybak:giveFish', function(source, cb, fish, nearWater)
    if nearWater then
        if lib.table.contains(ryby, fish) then
            exports.ox_inventory:AddItem(source, fish, 1)
            cb(true)
        else
            DropPlayer(source, '[SV-AC] Trigger event exploit')
            cb(false)
        end
    else
        DropPlayer(source, '[SV-AC] Trigger event exploit')
        cb(false)
    end
end)

RegisterNetEvent('sv-rybak:shop', function(fish, mode)
    if mode == 'sell' then
        local fishData = Config.Fishes[fish]

        local count = exports.ox_inventory:Search(source, 'count', fish)
    
        if count and count > 0 then
            exports.ox_inventory:RemoveItem(source, fish, count)
            exports.ox_inventory:AddItem(source, 'money', fishData.price * count)
    
            TriggerClientEvent('esx:showNotification', source, 'Pomyślnie sprzedano '..count..' sztuk '..fishData.label..' za '..fishData.price * count..'$')
        else
            TriggerClientEvent('esx:showNotification', source, 'Nie posiadasz '..fishData.label)
        end
    elseif mode == 'buy' then
        if fish == 'wedka' then
            local fishData = Config.Fishes[fish]

            exports.ox_inventory:RemoveItem(source, 'money', fishData.price)
            exports.ox_inventory:AddItem(source, 'wedka', 1)
        end
    else
        DropPlayer(source, '[SV-AC] Trigger event exploit')
    end
end)

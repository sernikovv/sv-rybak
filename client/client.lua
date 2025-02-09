ESX = exports.es_extended.getSharedObject()
local rodProp = nil
local disableX = false

startMinigame = function (shakeIntensity)
    if not shakeIntensity then shakeIntensity = 6 end

    SetNuiFocus(true, false)
    SendNUIMessage({
        action = "showGame",
        shakeIntensity = shakeIntensity
    })

    local success = nil
    RegisterNUICallback('gameResult', function(result, cb)
        success = result
        SetNuiFocus(false, false)
        cb('ok')
    end)

    while success == nil do
        Citizen.Wait(0)
    end

    TriggerEvent('sv-hud:hide', true)
    return success
end

exports('wedka', function ()
    if IsPedInAnyVehicle(PlayerPedId(), true) then
		ESX.ShowNotification('Nie możesz być w pojeździe!')

        return
    end

    if IsPedSwimming(PlayerPedId()) then
		ESX.ShowNotification('Nie możesz być w wodzie!')
        return
    end


    if not IsNearWater() then
		ESX.ShowNotification('Jesteś za daleko od wody!')
        return
    end
    
    anim(true)
    
    ESX.ShowNotification('Zaczynasz łowienie, poczekaj aż ryby zaczną brać!')
    local random = math.random(1000,50000)
    Wait(random)
    startFishing()
end)

function anim(toggle)
    disableX = toggle
    FreezeEntityPosition(PlayerPedId(), toggle)

    if toggle == true then
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_FISHING", 0, true)
    elseif toggle == false then
        for k, v in pairs(GetGamePool('CObject')) do
            if IsEntityAttachedToEntity(PlayerPedId(), v) then
                SetEntityAsMissionEntity(v, true, true)
                DeleteObject(v)
                DeleteEntity(v)
                ClearPedTasks(PlayerPedId())
            end
        end
    end
end

function startFishing()
    local minigame = startMinigame(math.random(5, 10))

    if minigame then
        ESX.TriggerServerCallback('sv-rybak:giveFish', function (success)
            anim(false)
            
            if success then
                ESX.ShowNotification('Złowiłeś rybę!')
            end
        end, GetRandomFish(), IsNearWater())
    else
	anim(false)
        ESX.ShowNotification('Nie złowiłeś ryby!')
    end
end

function GetRandomFish()
    local totalChances = 0

    for _, fish in pairs(Config.Fishes) do
        if type(fish.chances) == "number" then
            totalChances = totalChances + fish.chances
        end
    end

    local randomNumber = math.random(1, totalChances)
    local cumulative = 0

    for _, fish in pairs(Config.Fishes) do
        if type(fish.chances) == "number" then
            cumulative = cumulative + fish.chances
            if randomNumber <= cumulative then
                return fish.item
            end
        end
    end
end

function IsNearWater()
	local coords, forward = GetEntityCoords(PlayerPedId()), GetEntityForwardVector(PlayerPedId())
	local npcCoords = (coords + forward * 1.0)
	local x, y, z = table.unpack(npcCoords)
	local npc = CreatePed(1, `mp_m_freemode_01`, x, y, z - 9.0, 0.0, false, false)
	SetPedDefaultComponentVariation(npc)
	SetEntityVisible(npc, true)
	SetEntityInvincible(npc, true)
	SetEntityAsMissionEntity(npc, true, true)
	local waitCheck = true

	Citizen.CreateThread(function()
		while waitCheck do
			Citizen.Wait(5)
			if not IsPedStill(npc) then
				ClearPedTasksImmediately(npc)
			end
		end
	end)
	Wait(500)
	waitCheck = false

	if IsPedSwimming(npc) or IsPedSwimmingUnderWater(npc) then
		DeletePed(npc)
		return true
	else
		DeletePed(npc)
		DeleteEntity(rodProp)
		rodProp = nil
		return false
	end

    return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if disableX then
            DisableControlAction(0, 73, true)
        end
    end
end)

lib.registerContext({
    id = 'sklep',
    title = 'Sklep Wędkarski',
    options = {
        {
            title = 'Kup',
            description = 'Możesz tutaj kupić wędkę',
            menu = 'sklep_kup',
            icon = 'bars'
        },
        {
            title = 'Sprzedaj',
            description = 'Możesz tutaj sprzedawać ryby',
            menu = 'sklep_sprzedaj',
            icon = 'bars'
        },
    }
})

lib.registerContext({
    id = 'sklep_kup',
    title = 'Sklep Wędkarski',
    options = {
        {
            title = 'Wędka',
            description = 'Zwykła wędka',
            onSelect = function()
                TriggerServerEvent('sv-rybak:shop', 'wedka', 'buy')
            end,
            icon = 'fishing-rod'
        },
    }
})

lib.registerContext({
    id = 'sklep_sprzedaj',
    title = 'Sklep Wędkarski',
    options = {
        {
            title = 'Sum',
            onSelect = function()
                TriggerServerEvent('sv-rybak:shop', 'fish_sum', 'sell')
            end,
            icon = 'hand',
        },
        {
            title = 'Okoń',
            onSelect = function()
                TriggerServerEvent('sv-rybak:shop', 'fish_okon', 'sell')
            end,
            icon = 'hand',
        },
        {
            title = 'Mintaj',
            onSelect = function()
                TriggerServerEvent('sv-rybak:shop', 'fish_mintaj', 'sell')
            end,
            icon = 'hand',
        },
        {
            title = 'Łosoś',
            onSelect = function()
                TriggerServerEvent('sv-rybak:shop', 'fish_losos', 'sell')
            end,
            icon = 'hand',
        },
        {
            title = 'Szczupak',
            onSelect = function()
                TriggerServerEvent('sv-rybak:shop', 'fish_szczupak', 'sell')
            end,
            icon = 'hand',
        },
        {
            title = 'Jesiotr',
            onSelect = function()
                TriggerServerEvent('sv-rybak:shop', 'fish_jesiotr', 'sell')
            end,
            icon = 'hand',
        },
    }
})

exports.ox_target:addBoxZone({
    coords = vec3(-1819.9423, -1220.6349, 13.0174),
    size = vec3(1.5, 1.5, 2),
    rotation = 30,
    drawSprite = false,
    options = {
        {
            name = 'shop',
            onSelect = function ()
                lib.showContext('sklep')
            end,
            icon = 'fas fa-fish',
            label = 'Otwórz sklep wędkarski',
        }
    }
})

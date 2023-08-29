
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("t3_lockpick",cRP)

Promise = nil

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
    if Promise then
        Promise:resolve(false)
    end
end)

RegisterNUICallback('succeed', function()
    SetNuiFocus(false, false)
    Promise:resolve(true)
end)

RegisterNUICallback('failed', function()
    SetNuiFocus(false, false)
    Promise:resolve(false)
end)

function startLockpick(strength, difficulty, pins)
    if type(strength) ~= "number" then
        strength = Config.LockpickStrength[strength]
    end
    if not difficulty or type(difficulty) ~= "number" then
        difficulty = Config.DefaultDifficulty
    elseif difficulty > 7 then
        difficulty = 7
    end
    if not pins or type(pins) ~= "number" then
        pins = Config.DefaultPinAmount
    elseif pins > 9 then
        pins = 9
    end
    print(strength)
    print(difficulty)
    print(pins)
    SendNUIMessage({
        action = "startLockpick",
        data = {strength = strength, difficulty = difficulty, pins = pins},
    })
    SetNuiFocus(true, true)

    Promise = promise.new()

    local result = Citizen.Await(Promise)
    return result
end

function cRP.lockpick(strength, difficulty, pins)
    print("start")
	return startLockpick(strength, difficulty, pins)
end

-- exports("startLockpick", startLockpick)
-- exports("startLockpick",function(Name)
-- 	print("Entrou no export")
-- 	return Propertys[Name]
-- end)
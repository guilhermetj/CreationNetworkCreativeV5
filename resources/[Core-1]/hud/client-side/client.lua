-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
vSERVER = Tunnel.getInterface("hud")
vRPS = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Experience = 0
local showHud = false
local clientStress = 0
local showMovie = false
local Compass = true
local pauseBreak = false
local clientHunger = 100
local clientThirst = 100
local homeInterior = false
local updateFoods = GetGameTimer()
local wantedTimer = GetGameTimer()
local reposeTimer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- NITRO
-----------------------------------------------------------------------------------------------------------------------------------------
local nitroFuel = 0
local nitroActive = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- Lights Car
-----------------------------------------------------------------------------------------------------------------------------------------
local lightState = "off"
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
local beltSpeed = 0
local beltLock = false
local beltVelocity = vector3(0,0,0)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIVINABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local divingMask = nil
local divingTank = nil
local clientOxigen = 100
local divingTimers = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Mumble = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLECONNECTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("mumbleConnected",function()
	if not Mumble then
		SendNUIMessage({ mumble = false })
		Mumble = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLEDISCONNECTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("mumbleDisconnected",function()
	if Mumble then
		SendNUIMessage({ mumble = true })
		Mumble = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:WANTEDCLIENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:wantedClient")
AddEventHandler("hud:wantedClient",function(Seconds)
	wantedTimer = GetGameTimer() + (Seconds * 1000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REPOSECLIENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:reposeClient")
AddEventHandler("hud:reposeClient",function(Seconds)
	reposeTimer = GetGameTimer() + (Seconds * 1000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:EXP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Exp")
AddEventHandler("hud:Exp",function(Amount)
	Experience = Amount
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCIRCLE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	DisplayRadar(false)

	RequestStreamedTextureDict("circlemap",false)
	while not HasStreamedTextureDictLoaded("circlemap") do
		Citizen.Wait(100)
	end

	AddReplaceTexture("platform:/textures/graphics","radarmasksm","circlemap","radarmasksm")

	SetMinimapClipType(1)
	SetMinimapComponentPosition("minimap","L","B",0.009,-0.0125,0.16,0.28)
	SetMinimapComponentPosition("minimap_mask","L","B",0.155,0.12,0.080,0.15)
	SetMinimapComponentPosition("minimap_blur","L","B",0.0095,0.015,0.229,0.311)

	SetBigmapActive(true,false)

	Citizen.Wait(5000)

	SetBigmapActive(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	DisplayRadar(false)

	while true do
		if LocalPlayer["state"]["Active"] then
			if divingMask ~= nil then
				if GetGameTimer() >= divingTimers then
					SendNUIMessage({ oxigen = clientOxigen - 1, oxigenShow = divingMask })
					divingTimers = GetGameTimer() + 30000
					clientOxigen = clientOxigen - 1
					vRPS.clientOxigen()

					if clientOxigen <= 0 then
						local ped = PlayerPedId()
						local health = GetEntityHealth(ped)
					
						SetEntityHealth(ped,health - 50)
					end
				end
			end
		end

		Citizen.Wait(5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFOODS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if LocalPlayer["state"]["Active"] then
			local ped = PlayerPedId()
			if GetGameTimer() >= updateFoods and GetEntityHealth(ped) > 101 then
				SendNUIMessage({ thirst = clientThirst - 1 })
				SendNUIMessage({ hunger = clientHunger - 1 })
				updateFoods = GetGameTimer() + 90000
				clientThirst = clientThirst - 1
				clientHunger = clientHunger - 1
				vRPS.clientFoods()
			end
		end

		Citizen.Wait(30000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if homeInterior then
			SetWeatherTypeNow("CLEAR")
			SetWeatherTypePersist("CLEAR")
			SetWeatherTypeNowPersist("CLEAR")
			NetworkOverrideClockTime(00,00,00)
		else
			SetWeatherTypeNow(GlobalState["Weather"])
			SetWeatherTypePersist(GlobalState["Weather"])
			SetWeatherTypeNowPersist(GlobalState["Weather"])
			NetworkOverrideClockTime(GlobalState["Hours"],GlobalState["Minutes"],00)
		end

		Citizen.Wait(1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROGRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Progress")
AddEventHandler("Progress",function(progressTimer)
	SendNUIMessage({ progress = true, progressTimer = progressTimer })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHUD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		if LocalPlayer["state"]["Active"] then
			if IsPauseMenuActive() then
				SendNUIMessage({ hud = false })
				pauseBreak = true
			else
				if showHud then
					if pauseBreak then
						SendNUIMessage({ hud = true })
						pauseBreak = false
						displayHud()
					else
						displayHud()

						local ped = PlayerPedId()
						if IsPedInAnyVehicle(ped) then
							timeDistance = 500
						end
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPLAYHUD
-----------------------------------------------------------------------------------------------------------------------------------------
function displayHud()
	local pid = PlayerId()
	local ped = PlayerPedId()
	local armour = GetPedArmour(ped)
	local coords = GetEntityCoords(ped)
	local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords["x"],coords["y"],coords["z"]))

	if IsPedInAnyVehicle(ped) then
		if not IsMinimapRendering() then
			DisplayRadar(true)
		end

		local vehicle = GetVehiclePedIsUsing(ped)
		local fuel = GetVehicleFuelLevel(vehicle)
		local speed = GetEntitySpeed(vehicle) * 3.6
		local vehPlate = GetVehicleNumberPlateText(vehicle)

		local nitroShow = 0
		if nitroActive then
			nitroShow = nitroFuel
		else
			nitroShow = GlobalState["Nitro"][vehPlate] or 0
		end

		SendNUIMessage({ vehicle = true, timer = GetGameTimer(), wanted = wantedTimer, repose = reposeTimer, talking = MumbleIsPlayerTalking(pid), nitro = nitroShow, health = GetEntityHealth(ped), armour = armour, street = streetName, fuel = fuel, speed = speed, belt = beltLock, locked = GetVehicleDoorLockStatus(vehicle) , lightState = lightState, gear = vehicleGear })
	else
		if IsMinimapRendering() then
			DisplayRadar(false)
		end

		SendNUIMessage({ vehicle = false, timer = GetGameTimer(), wanted = wantedTimer, repose = reposeTimer, talking = MumbleIsPlayerTalking(pid), health = GetEntityHealth(ped), armour = armour, street = streetName })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hud",function(source,args,rawCommand)
	if exports["chat"]:statusChat() and MumbleIsConnected() then
		showHud = not showHud

		displayHud()
		SendNUIMessage({ hud = showHud })

		if IsMinimapRendering() and not showHud then
			DisplayRadar(false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPASS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("compass",function(source,args,rawCommand)
	if exports["chat"]:statusChat() and MumbleIsConnected() then
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			Compass = not Compass
			SendNUIMessage({ compass = Compass, vehicle = 1 })

			if Compass then
				TriggerEvent("Notify","verde","Compasso ativado.",3000)
			else
				TriggerEvent("Notify","verde","Compasso desativado.",3000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOVIE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("movie",function(source,args,rawCommand)
	if exports["chat"]:statusChat() and MumbleIsConnected() then
		showMovie = not showMovie

		displayHud()
		SendNUIMessage({ movie = showMovie })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:TOGGLEHOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:toggleHood")
AddEventHandler("hud:toggleHood",function()
	showHood = not showHood

	if showHood then
		SetPedComponentVariation(PlayerPedId(),1,69,0,1)
	else
		SetPedComponentVariation(PlayerPedId(),1,0,0,1)
	end

	SendNUIMessage({ hood = showHood })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REMOVEHOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:RemoveHood")
AddEventHandler("hud:RemoveHood",function()
	if showHood then
		showHood = false
		SendNUIMessage({ hood = showHood })
		SetPedComponentVariation(PlayerPedId(),1,0,0,1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:HUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Hunger")
AddEventHandler("hud:Hunger",function(number)
	SendNUIMessage({ hunger = number })
	clientHunger = number
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:THIRST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Thirst")
AddEventHandler("hud:Thirst",function(number)
	SendNUIMessage({ thirst = number })
	clientThirst = number
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:STRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Stress")
AddEventHandler("hud:Stress",function(number)
	SendNUIMessage({ stress = number })
	clientStress = number
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:OXIGEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Oxigen")
AddEventHandler("hud:Oxigen",function(number)
	SendNUIMessage({ oxigen = number, oxigenShow = divingMask })
	clientOxigen = number
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECHARGEOXIGEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:rechargeOxigen")
AddEventHandler("hud:rechargeOxigen",function()
	TriggerEvent("Notify","verde","Reabastecimento concluído.",3000)
	SendNUIMessage({ oxigen = 100, oxigenShow = divingMask })
	vRPS.rechargeOxigen()
	clientOxigen = 100
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Active")
AddEventHandler("hud:Active",function(status)
	showHud = status

	displayHud()

	SendNUIMessage({ hud = showHud })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:RADIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Radio")
AddEventHandler("hud:Radio",function(number)
	if number <= 0 then
		SendNUIMessage({ radio = "" })
	else
		SendNUIMessage({ radio = "<text>"..parseInt(number).." Mhz</text>" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOIP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Voip")
AddEventHandler("hud:Voip",function(number)
	local Number = tonumber(number)
	local voiceTarget = { "Baixo","Médio","Alto","Muito Alto" }

	SendNUIMessage({ voice = voiceTarget[Number] })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOWARDPED
-----------------------------------------------------------------------------------------------------------------------------------------
function fowardPed(ped)
	local heading = GetEntityHeading(ped) + 90.0
	if heading < 0.0 then
		heading = 360.0 + heading
	end

	heading = heading * 0.0174533

	return { x = math.cos(heading) * 2.0, y = math.sin(heading) * 2.0 }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("seatbelt",function(source,args,rawCommand)
	if MumbleIsConnected() then
		local jota = 1000
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			if not IsPedOnAnyBike(ped) then
				if beltLock then
					TriggerEvent("sounds:source","unbelt",0.5)
					SendNUIMessage({ seatbelt = false })
					beltLock = false
				else
					TriggerEvent("sounds:source","belt",0.5)
					SendNUIMessage({ seatbelt = true })
					beltLock = true
				end
			end
		end
	end
end)
RegisterCommand('+indicatorlights',function(source,args)
	local ped = PlayerPedId()
	local isIn = IsPedInAnyVehicle(ped,false)
	if isIn then
	local vehicle = GetVehiclePedIsIn(ped, false)
	local lights = GetVehicleIndicatorLights(vehicle)
			if args[1] == 'up' then
				lightState = 'up'
				SetVehicleIndicatorLights(vehicle,0,true)
				SetVehicleIndicatorLights(vehicle,1,true)
			elseif args[1] == 'left' then
				lightState = 'left'
				SetVehicleIndicatorLights(vehicle,1,true)
				SetVehicleIndicatorLights(vehicle,0,false)
			elseif args[1] == 'right' then
				lightState = 'right'
				SetVehicleIndicatorLights(vehicle,0,true)
				SetVehicleIndicatorLights(vehicle,1,false)
			elseif args[1] == 'off' and lights >= 0 then
				lightState = 'off'
				SetVehicleIndicatorLights(vehicle,0,false)
				SetVehicleIndicatorLights(vehicle,1,false)
			
		end
		Wait(jota)
	end
end)

RegisterKeyMapping("+indicatorlights up","Ambas setas.","keyboard","UP")
RegisterKeyMapping("+indicatorlights left","Seta para esquerda.","keyboard","LEFT")
RegisterKeyMapping("+indicatorlights right","Seta para direita.","keyboard","RIGHT")
RegisterKeyMapping("+indicatorlights off","Desligar setas.","keyboard","BACK")

-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("seatbelt","Colocar/Retirar o cinto.","keyboard","G")
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMES:HOURS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("homes:Hours")
AddEventHandler("homes:Hours",function(status)
	homeInterior = status
end)
Citizen.CreateThread(function()
	local foodTimers = GetGameTimer()

	while true do
		if LocalPlayer["state"]["Active"] then
			if GetGameTimer() >= foodTimers then
				foodTimers = GetGameTimer() + 10000

				local ped = PlayerPedId()
				local health = GetEntityHealth(ped)
				if health > 101 then
					if clientHunger >= 10 and clientHunger <= 20 then
						SetEntityHealth(ped,health - 1)
						TriggerEvent("Notify","hunger","Sofrendo com a fome.",3000)
					elseif clientHunger <= 9 then
						SetEntityHealth(ped,health - 2)
						TriggerEvent("Notify","hunger","Sofrendo com a fome.",3000)
					end

					if clientThirst >= 10 and clientThirst <= 20 then
						SetEntityHealth(ped,health - 1)
						TriggerEvent("Notify","thirst","Sofrendo com a sede.",3000)
					elseif clientThirst <= 9 then
						SetEntityHealth(ped,health - 2)
						TriggerEvent("Notify","thirst","Sofrendo com a sede.",3000)
					end
				end
			end
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSHAKESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local jota = 1000
		if LocalPlayer["state"]["Active"] then
			local ped = PlayerPedId()
			if GetEntityHealth(ped) > 101 then
				if clientStress >= 99 then
					jota = 2000
					ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.75)
				elseif clientStress >= 80 and clientStress <= 98 then
					jota = 4500
					ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.50)
				elseif clientStress >= 60 and clientStress <= 79 then
					jota = 6500
					ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.25)
				elseif clientStress >= 40 and clientStress <= 59 then
					jota = 7500
					ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.05)
				end
			end
		end

		Citizen.Wait(jota)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REMOVESCUBA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:RemoveScuba")
AddEventHandler("hud:RemoveScuba",function()
	local ped = PlayerPedId()
	if DoesEntityExist(divingMask) or DoesEntityExist(divingTank) then
		if DoesEntityExist(divingMask) then
			SendNUIMessage({ oxigen = clientOxigen, oxigenShow = nil })
			TriggerServerEvent("tryDeleteObject",ObjToNet(divingMask))
			divingMask = nil
		end

		if DoesEntityExist(divingTank) then
			TriggerServerEvent("tryDeleteObject",ObjToNet(divingTank))
			divingTank = nil
		end

		SetEnableScuba(ped,false)
		SetPedMaxTimeUnderwater(ped,10.0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:DIVING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Diving")
AddEventHandler("hud:Diving",function()
	local ped = PlayerPedId()

	if DoesEntityExist(divingMask) or DoesEntityExist(divingTank) then
		if DoesEntityExist(divingMask) then
			SendNUIMessage({ oxigen = clientOxigen, oxigenShow = nil })
			TriggerServerEvent("tryDeleteObject",ObjToNet(divingMask))
			divingMask = nil
		end

		if DoesEntityExist(divingTank) then
			TriggerServerEvent("tryDeleteObject",ObjToNet(divingTank))
			divingTank = nil
		end

		SetEnableScuba(ped,false)
		SetPedMaxTimeUnderwater(ped,10.0)
	else
		local coords = GetEntityCoords(ped)
		local myObject,objNet = vRPS.CreateObject("p_s_scuba_tank_s",coords["x"],coords["y"],coords["z"])
		if myObject then
			local spawnObjects = 0
			divingTank = NetworkGetEntityFromNetworkId(objNet)
			while not DoesEntityExist(divingTank) and spawnObjects <= 1000 do
				divingTank = NetworkGetEntityFromNetworkId(objNet)
				spawnObjects = spawnObjects + 1
				Citizen.Wait(1)
			end

			spawnObjects = 0
			local objectControl = NetworkRequestControlOfEntity(divingTank)
			while not objectControl and spawnObjects <= 1000 do
				objectControl = NetworkRequestControlOfEntity(divingTank)
				spawnObjects = spawnObjects + 1
				Citizen.Wait(1)
			end

			AttachEntityToEntity(divingTank,ped,GetPedBoneIndex(ped,24818),-0.28,-0.24,0.0,180.0,90.0,0.0,1,1,0,0,2,1)
	
			SetEntityAsNoLongerNeeded(divingTank)
		end

		local myObject,objNet = vRPS.CreateObject("p_s_scuba_mask_s",coords["x"],coords["y"],coords["z"])
		if myObject then
			local spawnObjects = 0
			divingMask = NetworkGetEntityFromNetworkId(objNet)
			while not DoesEntityExist(divingMask) and spawnObjects <= 1000 do
				divingMask = NetworkGetEntityFromNetworkId(objNet)
				spawnObjects = spawnObjects + 1
				Citizen.Wait(1)
			end

			spawnObjects = 0
			local objectControl = NetworkRequestControlOfEntity(divingMask)
			while not objectControl and spawnObjects <= 1000 do
				objectControl = NetworkRequestControlOfEntity(divingMask)
				spawnObjects = spawnObjects + 1
				Citizen.Wait(1)
			end

			AttachEntityToEntity(divingMask,ped,GetPedBoneIndex(ped,12844),0.0,0.0,0.0,180.0,90.0,0.0,1,1,0,0,2,1)
	
			SetEntityAsNoLongerNeeded(divingMask)
		end

		SetEnableScuba(ped,true)
		SetPedMaxTimeUnderwater(ped,2000.0)
	end
end)
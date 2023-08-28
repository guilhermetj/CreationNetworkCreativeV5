-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Flexin = {}
Tunnel.bindInterface("speedometer",Flexin)
vSERVER = Tunnel.getInterface("speedometer")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local ActualVehicle = nil
local disabled = GetResourceKvpInt("speedometer_disabled") == 1
local metric = GetResourceKvpInt("speedometer_metric") == 1
local last_disabled
-----------------------------------------------------------------------------------------------------------------------------------------
-- NITRO
-----------------------------------------------------------------------------------------------------------------------------------------
local NitroFuel = 0
local PurgeFuel = 0
local NitroFlame = false
local NitroButton = GetGameTimer()
LocalPlayer["state"]["Nitro"] = false
local engineNew = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIGHTTRAILS
-----------------------------------------------------------------------------------------------------------------------------------------
local LightTrails = {}
local LightParticles = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PURGESPRAYS
-----------------------------------------------------------------------------------------------------------------------------------------
local PurgeSprays = {}
local PurgeParticles = {}
local PurgeActive = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
local SeatbeltSpeed = 0
local SeatbeltLock = false
local SeatbeltVelocity = vec3(0,0,0)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBELT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local jota = 1000
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) then
			if not IsPedOnAnyBike(Ped) and not IsPedInAnyHeli(Ped) and not IsPedInAnyPlane(Ped) then
				TimeDistance = 1
				jota = 1

				local Vehicle = GetVehiclePedIsUsing(Ped)
				local Speed = GetEntitySpeed(Vehicle) * 3.6
				if GetVehicleDoorLockStatus(Vehicle) == 2 or SeatbeltLock then
					DisableControlAction(1,75,true)
				end

				if Speed ~= SeatbeltSpeed then
					if (SeatbeltSpeed - Speed) >= 60 and not SeatbeltLock then
						SmashVehicleWindow(Vehicle,6)
						SetEntityNoCollisionEntity(Ped,Vehicle,false)
						SetEntityNoCollisionEntity(Vehicle,Ped,false)
						TriggerServerEvent("speedometer:VehicleEject",SeatbeltVelocity)

						Wait(500)

						SetEntityNoCollisionEntity(Ped,Vehicle,true)
						SetEntityNoCollisionEntity(Vehicle,Ped,true)
					end

					SeatbeltVelocity = GetEntityVelocity(Vehicle)
					SeatbeltSpeed = Speed
				end
			end
		else
			if SeatbeltSpeed ~= 0 then
				SeatbeltSpeed = 0
			end

			if SeatbeltLock then
				SeatbeltLock = false
			end
		end

		Wait(timeDistance)
		Wait(jota)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("Beltz",function(source)
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		if not IsPedOnAnyBike(Ped) and not IsPedInAnyHeli(Ped) and not IsPedInAnyPlane(Ped) then
			if SeatbeltLock then
				TriggerEvent("sounds:Private","unbelt",0.5)
				SendNUIMessage({ Action = "Seatbelt", Status = false })
				SeatbeltLock = false
			else
				TriggerEvent("sounds:Private","belt",0.5)
				SendNUIMessage({ Action = "Seatbelt", Status = true })
				SeatbeltLock = true
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("Beltz","Colocar/Retirar o cinto.","keyboard","G")
-----------------------------------------------------------------------------------------------------------------------------------------
-- NITROENABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function NitroEnable()
	if GetGameTimer() >= NitroButton and not IsPauseMenuActive() then
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) then
			NitroButton = GetGameTimer() + 1000

			local Vehicle = GetVehiclePedIsUsing(Ped)
			if GetPedInVehicleSeat(Vehicle,-1) == Ped then
				if GetVehicleTopSpeedModifier(Vehicle) < 20.0 then
					local Plate = GetVehicleNumberPlateText(Vehicle)
					NitroFuel = GlobalState["Nitro"][Plate] or 0
					PurgeFuel = GlobalState["Purge"][Plate] or 0

					if NitroFuel >= 1 then
						if GetIsVehicleEngineRunning(Vehicle) then
							if IsControlPressed(1,32) then
								LocalPlayer["state"]["Nitro"] = true

								while LocalPlayer["state"]["Nitro"] do
									if NitroFuel >= 1 then
										NitroFuel = NitroFuel - 1
										if PurgeFuel < 25 then
											PurgeFuel = PurgeFuel + 1 
										end

										if PurgeFuel >= 25 then
											local engineCurrent = GetVehicleEngineHealth(Vehicle)
											engineNew = engineCurrent - 5.0

											if engineNew ~= engineCurrent then
												SetVehicleEngineHealth(Vehicle,engineNew)
											end
										end

										if not NitroFlame then
											vSERVER.ActiveNitro(VehToNet(Vehicle),true)
											SetVehicleCheatPowerIncrease(Vehicle,5.0)
											SetVehicleRocketBoostActive(Vehicle,true)
											SetVehicleBoostActive(Vehicle,true)
											ModifyVehicleTopSpeed(Vehicle,20.0)
											SetLightTrail(Vehicle,true)
											NitroFlame = Plate
										end
									else
										if NitroFlame then
											vSERVER.ActiveNitro(VehToNet(Vehicle),false)
											SetVehicleCheatPowerIncrease(Vehicle,0.0)
											SetVehicleRocketBoostActive(Vehicle,false)
											vSERVER.UpdateNitro(NitroFlame,NitroFuel)
											vSERVER.UpdatePurge(NitroFlame,PurgeFuel)
											SetVehicleBoostActive(Vehicle,false)
											ModifyVehicleTopSpeed(Vehicle,0.0)
											SetLightTrail(Vehicle,false)
											NitroFlame = false

											LocalPlayer["state"]["Nitro"] = false
										end
									end

									Wait(100)
								end
							else
								SetPurgeSprays(Vehicle,true)
								PurgeActive = true

								while PurgeActive do
									if IsControlPressed(1,32) then
										SetPurgeSprays(Vehicle,false)
									end
									
									if PurgeFuel > 0 then
										PurgeFuel = PurgeFuel - 1
									end

									Wait(100)
								end
							end
						else
							SetPurgeSprays(Vehicle,true)
							PurgeActive = true

							while PurgeActive do
								if PurgeFuel > 0 then
									PurgeFuel = PurgeFuel - 1
								end

								Wait(100)
							end
						end
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NITRODISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function NitroDisable()
	local Vehicle = GetLastDrivenVehicle()
	local Plate = GetVehicleNumberPlateText(Vehicle)

	if NitroFlame then
		vSERVER.ActiveNitro(VehToNet(Vehicle),false)
		SetVehicleCheatPowerIncrease(Vehicle,0.0)
		SetVehicleRocketBoostActive(Vehicle,false)
		vSERVER.UpdateNitro(NitroFlame,NitroFuel)
		vSERVER.UpdatePurge(NitroFlame,PurgeFuel)
		SetVehicleBoostActive(Vehicle,false)
		ModifyVehicleTopSpeed(Vehicle,0.0)
		SetLightTrail(Vehicle,false)
		NitroFlame = false

		LocalPlayer["state"]["Nitro"] = false
	else
		vSERVER.UpdatePurge(Plate,PurgeFuel)
	end

	if PurgeActive then
		SetPurgeSprays(Vehicle,false)
		PurgeActive = false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVENITRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("+activeNitro",NitroEnable)
RegisterCommand("-activeNitro",NitroDisable)
RegisterKeyMapping("+activeNitro","Ativação do nitro.","keyboard","LMENU")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETLIGHTTRAIL
-----------------------------------------------------------------------------------------------------------------------------------------
function SetLightTrail(Vehicle,Enable)
	if LightTrails[Vehicle] == Enable then
		return
	end

	if Enable then
		local Particles = {}
		local LeftTrail = CreateLightTrail(Vehicle,GetEntityBoneIndexByName(Vehicle,"taillight_l"))
		local RightTrail = CreateLightTrail(Vehicle,GetEntityBoneIndexByName(Vehicle,"taillight_r"))

		Particles[#Particles + 1] = LeftTrail
		Particles[#Particles + 1] = RightTrail

		LightTrails[Vehicle] = true
		LightParticles[Vehicle] = Particles
	else
		if LightParticles[Vehicle] and #LightParticles[Vehicle] > 0 then
			for _,v in ipairs(LightParticles[Vehicle]) do
				StopLightTrail(v)
			end
		end

		LightTrails[Vehicle] = nil
		LightParticles[Vehicle] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATELIGHTTRAIL
-----------------------------------------------------------------------------------------------------------------------------------------
function CreateLightTrail(Vehicle,Bone)
	UseParticleFxAssetNextCall("core")
	local Particle = StartParticleFxLoopedOnEntityBone("veh_light_red_trail",Vehicle,0.0,0.0,0.0,0.0,0.0,0.0,Bone,1.0,false,false,false)
	SetParticleFxLoopedEvolution(Particle,"speed",1.0,false)

	return Particle
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPLIGHTTRAIL
-----------------------------------------------------------------------------------------------------------------------------------------
function StopLightTrail(Particle)
	CreateThread(function()
		local jota = 1000
		local endTime = GetGameTimer() + 500
		while GetGameTimer() < endTime do 
			Wait(1)
			local now = GetGameTimer()
			local Scale = (endTime - now) / 500
			SetParticleFxLoopedScale(Particle,Scale)
			SetParticleFxLoopedAlpha(Particle,Scale)
		end
		 Wait(jota)

		StopParticleFxLooped(Particle)
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETPURGESPRAYS
-----------------------------------------------------------------------------------------------------------------------------------------
function SetPurgeSprays(Vehicle,Enable)
	if PurgeSprays[Vehicle] == Enable then
		return
	end

	if Enable then
		SetVehicleBoostActive(Vehicle,true)
		
		local Particles = {}
		local Bone = GetEntityBoneIndexByName(Vehicle,"bonnet")
		local Position = GetWorldPositionOfEntityBone(Vehicle,Bone)
		local Offset = GetOffsetFromEntityGivenWorldCoords(Vehicle,Position["x"],Position["y"],Position["z"])

		for i = 0,3 do
			local LeftPurge = CreatePurgeSprays(Vehicle,Offset["x"] - 0.5,Offset["y"] + 0.05,Offset["z"],40.0,-20.0,0.0,0.5)
			local RightPurge = CreatePurgeSprays(Vehicle,Offset["x"] + 0.5,Offset["y"] + 0.05,Offset["z"],40.0,20.0,0.0,0.5)

			Particles[#Particles + 1] = LeftPurge
			Particles[#Particles + 1] = RightPurge
		end

		PurgeSprays[Vehicle] = true
		PurgeParticles[Vehicle] = Particles
	else
		if PurgeParticles[Vehicle] then
			RemoveParticleFxFromEntity(Vehicle)
		end

		PurgeSprays[Vehicle] = nil
		PurgeParticles[Vehicle] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEPURGESPRAYS
-----------------------------------------------------------------------------------------------------------------------------------------
function CreatePurgeSprays(Vehicle,xOffset,yOffset,zOffset,xRot,yRot)
	UseParticleFxAssetNextCall("core")
	return StartNetworkedParticleFxNonLoopedOnEntity("ent_sht_steam",Vehicle,xOffset,yOffset,zOffset,xRot,yRot,0.0,0.5,false,false,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPEEDOMETER:NITRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("speedometer:Nitro")
AddEventHandler("speedometer:Nitro",function(Network,Status,nitroColor)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			fireExaust(Vehicle,Status,nitroColor)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIREEXAUST
-----------------------------------------------------------------------------------------------------------------------------------------
local exhausts = { "exhaust" }
for i = 0,30 do
    exhausts[#exhausts + 1] = "exhaust_"..i
end

function SetNitroBoostScreenEffectsEnabled(enabled)
    if enabled then
        ---SetTimecycleModifier("rply_motionblur")
        ShakeGameplayCam("SKY_DIVING_SHAKE",0.25)
    else
        StopGameplayCamShaking(true)
        ---SetTransitionTimecycleModifier("default",0.35)
    end
end

local particles = {}
function IsVehicleNitroBoostEnabled(vehicle)
    return particles[vehicle] ~= nil
end

local function RemoveParticles(vehicle,force)
    if particles[vehicle] then
        for _,p in ipairs(particles[vehicle]) do
            CreateThread(function()

                if not force then
                    for i = 0,1.25,0.125 do
                        local scale = 1.25 - i
                        SetParticleFxLoopedScale(p,scale)
                        Wait(1)
                    end
                end

                RemoveParticleFx(p)
            end)
        end

        particles[vehicle] = nil
    end
end

CreateThread(function()
	local jota = 1000
    while true do
        for vehicle,_ in pairs(particles) do
            if (not DoesEntityExist(vehicle)) then
                RemoveParticles(vehicle)
            end
        end

        Wait(5000)
        Wait(jota)
    end
end)

local particleDictBlue = "veh_xs_vehicle_mods"
local particleDictRed = "veh_xs_vehicle_mods_red"
function fireExaust(vehicle,enabled,nitroColor)
    local pitch = GetEntityPitch(vehicle)

    if nitroColor then
		RequestNamedPtfxAsset(particleDictBlue)
		while not HasNamedPtfxAssetLoaded(particleDictBlue) do
			Wait(1)
		end
	else
		RequestNamedPtfxAsset(particleDictRed)
		while not HasNamedPtfxAssetLoaded(particleDictRed) do
			Wait(1)
		end
	end

    if IsVehicleNitroBoostEnabled(vehicle) == enabled then
        return
    end

    if IsPedInVehicle(PlayerPedId(),vehicle) or not enabled then
        SetNitroBoostScreenEffectsEnabled(enabled)
    end

    RemoveParticles(vehicle)

    if enabled then
        particles[vehicle] = {}

        for i_,exhaust in ipairs(exhausts) do
            local boneIndex = GetEntityBoneIndexByName(vehicle,exhaust)

            if boneIndex ~= -1 then
				if nitroColor then
                	UseParticleFxAssetNextCall(particleDictBlue)
				else
					UseParticleFxAssetNextCall(particleDictRed)
				end

                local bonePosition = GetWorldPositionOfEntityBone(vehicle,boneIndex)
                local boneOffset = GetOffsetFromEntityGivenWorldCoords(vehicle,bonePosition.x,bonePosition.y,bonePosition.z)

                local particle = StartNetworkedParticleFxLoopedOnEntity("veh_nitrous",vehicle,boneOffset.x,boneOffset.y,boneOffset.z,0.0,pitch,0.0,1.0,false,false,false)

                SetParticleFxLoopedAlpha(p,50)

                particles[vehicle][#particles[vehicle] + 1] = particle

                CreateThread(function()
                    for i = 0,1.25,0.05 do
                        SetParticleFxLoopedScale(particle,i)
                        Wait(1)
                    end
                end)
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPEEDOMETER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ready",function(data,cb)
	RequestNamedPtfxAsset(particleDictBlue)
	RequestNamedPtfxAsset(particleDictRed)

	SendNUIMessage({ type = "updateMetric", metric = metric and "mph" or "kmh" })

	if (disabled ~= last_disabled) then
		SendNUIMessage({ type = "setEnabled", enabled = not disabled })

		last_disabled = disabled
	end

	CreateThread(function()
		local jota = 1000
		while true do
			local TimeDistance = 999
			if not disabled then
				local Ped = PlayerPedId()
				if IsPedInAnyVehicle(Ped) then
					if not IsPauseMenuActive() then
						TimeDistance = 50
						jota = 1
	
						local Vehicle = GetVehiclePedIsUsing(Ped)
						if ActualVehicle ~= Vehicle then
							SendNUIMessage({ type = "setVisible", visible = true })
	
							ActualVehicle = Vehicle
							Plate = GetVehicleNumberPlateText(Vehicle)
						end
	
						local carRPM = GetVehicleCurrentRpm(Vehicle)
						local carGear = GetVehicleCurrentGear(Vehicle)
						local carVelocity = GetEntitySpeed(Vehicle)
						local carHandbrake = GetVehicleHandbrake(Vehicle)
						local carFuel = GetVehicleFuelLevel(Vehicle)
						local carDamage = GetVehicleEngineHealth(Vehicle)
						local carLocked = GetVehicleDoorLockStatus(Vehicle)
	
						if LocalPlayer["state"]["Nitro"] then
							Nitro = NitroFuel
						else
							if (GlobalState["Nitro"][Plate] or 0) ~= Nitro then
								Nitro = GlobalState["Nitro"][Plate] or 0
							end
						end
	
						SendNUIMessage({ type = "updateData", RPM = carRPM, gear = carGear, velocity = carVelocity, handbrake = carHandbrake, nitro = Nitro, fuel = carFuel, damage = carDamage, seatbelt = SeatbeltLock, locked = carLocked })
					else
						if ActualVehicle then
							ActualVehicle = nil
						
							SendNUIMessage({ type = "setVisible", visible = false })
						end
					end
				else
					if ActualVehicle then
						ActualVehicle = nil
						
						SendNUIMessage({ type = "setVisible", visible = false })
					end
				end
			end

			Wait(TimeDistance)
		    Wait(jota)
		end
	end)

	cb("ok")
end)

RegisterCommand("speedometer",function(source,args)
	if (args[1] == "toggle") then
		disabled = not disabled
		SetResourceKvpInt("speedometer_disabled",disabled)

		if (disabled ~= last_disabled) then
			SendNUIMessage({ type = "setEnabled", enabled = not disabled })
	
			last_disabled = disabled
		end
	elseif (args[1] == "metric") then
		metric = not metric
		SetResourceKvpInt("speedometer_metric",metric)

		SendNUIMessage({ type = "updateMetric", metric = metric and "kmh" or "mph" })
	end
end)

exports("IsEnabled",function()
	return not disabled
end)

exports("GetMetric",function()
	return metric
end)

exports("GetMetricText",function()
	return metric and "KMH" or "MPH"
end)
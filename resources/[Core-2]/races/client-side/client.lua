-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("races")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Races = {}
local Selected = 1
local checkpointflare = {}
local savePoints = 0
local racePoints = 0
local Checkpoints = 1
local CheckBlip = nil
local Progress = false
local ExplodeTimers = 0
local ExplodeRace = false
local inativeRaces = false
local displayRanking = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRACES
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		if not inativeRaces then
			local ped = PlayerPedId()

			if IsPedInAnyVehicle(ped) then
				if Progress then
					timeDistance = 100
					racePoints = (GetGameTimer() - savePoints)

					SendNUIMessage({ Points = racePoints, Explosive = (ExplodeTimers - GetGameTimer()) })

					local vehicle = GetVehiclePedIsUsing(ped)
					if GetPedInVehicleSeat(vehicle,-1) ~= ped then
						leaveRace()
					end

					if ExplodeRace and GetGameTimer() >= ExplodeTimers then
						leaveRace()
					end

					local coords = GetEntityCoords(ped)
					local distance = #(coords - vector3(Races[Selected]["coords"][Checkpoints][1][1],Races[Selected]["coords"][Checkpoints][1][2],Races[Selected]["coords"][Checkpoints][1][3]))
					if distance <= 20 then
						if Checkpoints >= #Races[Selected]["coords"] then
							PlaySoundFrontend(-1,"CHECKPOINT_UNDER_THE_BRIDGE","HUD_MINI_GAME_SOUNDSET",false)
							vSERVER.finishRace(Selected,racePoints)
							checkpointflare = StopParticleFxLooped(checkpointflare, false)
							SendNUIMessage({ show = false })
							Progress = false
							cleanBlips()

							Selected = 1
							checkpointflare = {}
							savePoints = 0
							racePoints = 0
							Checkpoints = 1
							CheckBlip = nil
							ExplodeTimers = 0
							ExplodeRace = false
							displayRanking = false
						else
							SendNUIMessage({ upCheckpoint = true })
							Checkpoints = Checkpoints + 1
							checkpointflareBlips()
							makeBlips()
						end
					end
				else
					local coords = GetEntityCoords(ped)
					for k,v in pairs(Races) do
						local distance = #(coords - vector3(v["init"][1],v["init"][2],v["init"][3]))
						if distance <= 25 then
							local vehicle = GetVehiclePedIsUsing(ped)
							if GetPedInVehicleSeat(vehicle,-1) == ped then
								DrawMarker(23,v["init"][1],v["init"][2],v["init"][3] - 0.36,0.0,0.0,0.0,0.0,0.0,0.0,10.0,10.0,0.0,40,137,182,100,0,0,0,0)
								timeDistance = 1

								if distance <= 5 then
									if IsControlJustPressed(1,47) then
										if not displayRanking then
											SendNUIMessage({ ranking = vSERVER.requestRanking(k) })
											displayRanking = true
										else
											SendNUIMessage({ ranking = false })
											displayRanking = false
										end
									end

									if IsControlJustPressed(1,38) then
										local raceStatus,raceExplosive = vSERVER.checkPermission()
										if raceStatus then
											if displayRanking then
												SendNUIMessage({ ranking = false })
												displayRanking = false
											end

											SendNUIMessage({ show = true, maxCheckpoint = #Races[k]["coords"] })
											savePoints = GetGameTimer()
											Checkpoints = 1
											racePoints = 0
											Selected = k

											checkpointflareBlips()
											makeBlips()

											if raceExplosive then
												ExplodeTimers = GetGameTimer() + (v["explode"] * 1000)
												ExplodeRace = true
											end

											Progress = true
										end
									end
								else
									if displayRanking then
										SendNUIMessage({ ranking = false })
										displayRanking = false
									end
								end
							end
						end
					end
				end
			else
				if Progress then
					leaveRace()
				end

				if displayRanking then
					SendNUIMessage({ ranking = false })
					displayRanking = false
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function makeBlips()
	if DoesBlipExist(CheckBlip) then
		RemoveBlip(CheckBlip)
		CheckBlip = nil
	end
	CheckBlip = AddBlipForCoord(Races[Selected]["coords"][Checkpoints][1][1],Races[Selected]["coords"][Checkpoints][1][2],Races[Selected]["coords"][Checkpoints][1][3])
	SetBlipSprite(CheckBlip,1)
	SetBlipAsShortRange(CheckBlip,true)
	SetBlipScale(CheckBlip,0.5)
	SetBlipColour(CheckBlip,38)
	SetBlipRoute(CheckBlip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Checkpoint")
	EndTextCommandSetBlipName(CheckBlip)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function checkpointflareBlips()
	if DoesBlipExist(CheckBlip) then
		RemoveBlip(CheckBlip)
		CheckBlip = nil
		checkpointflare = StopParticleFxLooped(checkpointflare, false)
	end
	if Checkpoint == #Races[Selected]["coords"] then
		local particleDictionary = "scr_ba_bb"
		local particleName = "scr_ba_bb_package_flare"
		RequestNamedPtfxAsset(particleDictionary)
		HasNamedPtfxAssetLoaded(particleDictionary)
		SetPtfxAssetNextCall(particleDictionary)
		checkpointflare = StartParticleFxLoopedAtCoord(particleName,Races[Selected]["coords"][Checkpoints][1][1],Races[Selected]["coords"][Checkpoints][1][2],Races[Selected]["coords"][Checkpoints][1][3]-1, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
		SetParticleFxLoopedAlpha(checkpointflare, 1.0)
		SetParticleFxLoopedColour(checkpointflare, 0.12, 0.42, 0.88, 0)

		local sound = PlaySoundFrontend(-1, "CHECKPOINT_AHEAD", "HUD_MINI_GAME_SOUNDSET", true)

	else
		local particleDictionary = "scr_ba_bb"
		local particleName = "scr_ba_bb_package_flare"
		RequestNamedPtfxAsset(particleDictionary)
		HasNamedPtfxAssetLoaded(particleDictionary)
		SetPtfxAssetNextCall(particleDictionary)

		checkpointflare = StartParticleFxLoopedAtCoord(particleName,Races[Selected]["coords"][Checkpoints][1][1],Races[Selected]["coords"][Checkpoints][1][2],Races[Selected]["coords"][Checkpoints][1][3]-1, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
		SetParticleFxLoopedAlpha(checkpointflare, 1.0)
		SetParticleFxLoopedColour(checkpointflare, 0.12, 0.42, 0.88, 0)

		local sound = PlaySoundFrontend(-1, "CHECKPOINT_AHEAD", "HUD_MINI_GAME_SOUNDSET", true)
	end	
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function cleanBlips()
	if DoesBlipExist(CheckBlip) then
		RemoveBlip(CheckBlip)
		CheckBlip = nil
		checkpointflare = StopParticleFxLooped(checkpointflare, false)

	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LEAVERACE
-----------------------------------------------------------------------------------------------------------------------------------------
function leaveRace()
	Progress = false
	SendNUIMessage({ show = false })
	cleanBlips()
	checkpointflare = StopParticleFxLooped(checkpointflare, false)

	Selected = 1
	checkpointflare = {}
	savePoints = 0
	racePoints = 0
	Checkpoints = 1
	CheckBlip = nil
	displayRanking = false

	if ExplodeRace then
		Citizen.Wait(3000)

		local vehicle = GetPlayersLastVehicle()
		local coords = GetEntityCoords(vehicle)
		AddExplosion(coords,2,1.0,true,true,true)
		vSERVER.exitRace()
	end

	ExplodeTimers = 0
	ExplodeRace = false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACES:INATIVERACES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("races:insertList")
AddEventHandler("races:insertList",function(status)
	inativeRaces = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACES:TABLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("races:Table")
AddEventHandler("races:Table",function(table)
	Races = table

	for _,v in pairs(Races) do
		local blip = AddBlipForRadius(v["init"][1],v["init"][2],v["init"][3],10.0)
		SetBlipAlpha(blip,200)
		SetBlipColour(blip,38)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local HomesTheft = {
	["Open"] = "",
	["Theft"] = "",
	["InternTheft"] = {},
	["CurrentTheft"] = {},
	["Called"] = false,
	["TheftCoords"] = {},
	["locker"] = nil,
	["Police"] = GetGameTimer()
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer["state"]["TheftName"] = 0
LocalPlayer["state"]["Theft"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:UPDATECALLED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:UpdateCalled")
AddEventHandler("propertys:UpdateCalled",function()
	HomesTheft["Called"] = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GRIDCHUNK
-----------------------------------------------------------------------------------------------------------------------------------------
function gridChunk(x)
	return math.floor((x + 8192) / 128)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOCHANNEL
-----------------------------------------------------------------------------------------------------------------------------------------
function toChannel(v)
	return (v["x"] << 8) | v["y"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETGRIDZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function getGridzone(x,y)
	local gridChunk = vector2(gridChunk(x),gridChunk(y))
	return toChannel(gridChunk)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCKERCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local lockerCoords = {
	["ThreeFloors"] = { 128.14,-120.54,-28.4,280.63 }, --OK
	["TwoFloors"] = { 144.18,-148.68,-25.0,34.02 }, --OK
	["Square"] = { 62.76,79.35,-25.6,0.0}, --OK
	["Middle"] = { 106.26,-99.78,-25.2,226.78 }, --OK
	["Motel"] = { 54.33,-45.94,-25.0,229.61 }, --ok
	["Beach"] = { 294.69,-293.68,-24.99,48.19 } --ok
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THEFTCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local TheftCoords = {
	["Beach"] = {
		["MOBILE01"] = { 299.52,-300.98,-23.99,51.03 },
		["MOBILE02"] = { 301.76,-299.67,-23.99,323.15 },
		["MOBILE03"] = { 300.62,-304.89,-23.99,138.9 },
		["MOBILE04"] = { 305.89,-306.5,-23.99,323.15 },
		["MOBILE05"] = { 304.62,-308.13,-23.99,138.9 },
		["MOBILE06"] = { 305.24,-300.89,-23.99,53.86 },
		["MOBILE07"] = { 306.56,-301.62,-23.99,323.15 },
		["MOBILE08"] = { 306.07,-304.18,-23.99,144.57 },
		["MOBILE09"] = { 308.67,-303.38,-23.99,323.15 },
		["MOBILE10"] = { 298.08,-299.85,-23.99,232.45 },
		["MOBILE11"] = { 296.14,-300.98,-23.99,141.74 },
		["MOBILE12"] = { 293.94,-299.51,-23.99,141.74 },
		["MOBILE13"] = { 296.04,-292.86,-23.99,348.67 },
		["MOBILE14"] = { 298.92,-295.06,-23.99,320.32 },
		["LOCKER"] = { 294.69,-293.68,-23.99,48.19 }
	},
	["Middle"] = {
		["MOBILE01"] = { 94.66,-99.23,-24.2,320.32 },
		["MOBILE02"] = { 103.77,-97.16,-24.2,317.49 },
		["MOBILE03"] = { 99.53,-103.18,-24.2,130.4 },
		["MOBILE04"] = { 96.24,-95.47,-24.2,45.36 },
		["MOBILE05"] = { 97.06,-94.19,-24.2,42.52 },
		["MOBILE06"] = { 98.38,-93.2,-24.2,45.36 },
		["MOBILE07"] = { 102.51,-99.54,-24.2,127.56 },
		["MOBILE08"] = { 92.6,-104.65,-24.2,45.36 },
		["MOBILE09"] = { 92.51,-105.44,-24.2,130.4 },
		["MOBILE10"] = { 97.01,-108.4,-24.2,229.61 },
		["MOBILE11"] = { 97.32,-106.37,-24.2,323.15 },
		["MOBILE12"] = { 99.17,-105.46,-24.2,323.15 },
		["LOCKER"] = { 106.26,-99.78,-25.2,226.78 }
	},
	["Motel"] = {
		["MOBILE01"] = { 46.82,-44.94,-24.01,51.03 },
		["MOBILE02"] = { 45.79,-49.21,-24.01,141.74 },
		["MOBILE03"] = { 52.71,-52.69,-24.01,235.28 },
		["MOBILE04"] = { 51.46,-53.39,-24.01,189.93 },
		["MOBILE05"] = { 47.36,-50.51,-24.01,51.03 },
		["MOBILE06"] = { 54.44,-45.08,-24.01,325.99 },
		["MOBILE07"] = { 52.37,-45.44,-24.01,141.74 },
		["LOCKER"] = { 54.33,-45.94,-24.01,229.61 }
	},
	["Square"] = {
		["MOBILE01"] = { 83.99,83.45,-24.01,274.97 },
		["MOBILE02"] = { 71.57,84.59,-24.2,2.84 },
		["MOBILE03"] = { 67.15,81.68,-24.2,93.55 },
		["MOBILE04"] = { 90.61,70.77,-24.01,181.42 },
		["MOBILE05"] = { 88.25,70.03,-24.01,175.75 },
		["MOBILE06"] = { 86.67,72.26,-24.01,90.71 },
		["MOBILE07"] = { 62.58,74.22,-24.6,184.26 },
		["MOBILE08"] = { 63.75,77.62,-24.57,272.13 },
		["MOBILE09"] = { 61.17,70.45,-24.6,274.97 },
		["MOBILE10"] = { 59.07,70.17,-24.6,90.71 },
		["MOBILE11"] = { 55.4,73.88,-24.6,181.42 },
		["LOCKER"] = { 62.76,79.35,-24.6,0.0 }
	},
	["ThreeFloors"] = {
		["MOBILE01"] = { 125.56,-109.76,-23.59,2.84 },
		["MOBILE02"] = { 125.79,-112.12,-23.59,201.26 },
		["MOBILE03"] = { 120.41,-119.23,-23.81,99.22 },
		["MOBILE04"] = { 120.73,-123.52,-23.99,99.22 },
		["MOBILE05"] = { 128.96,-124.18,-24.01,280.63 },
		["MOBILE06"] = { 120.9,-124.41,-27.4,90.71 },
		["MOBILE07"] = { 124.45,-118.37,-27.4,8.51 },
		["MOBILE08"] = { 126.99,-110.82,-27.38,5.67 },
		["MOBILE09"] = { 120.06,-105.46,-31.21,5.67 },
		["MOBILE10"] = { 117.99,-110.33,-31.21,187.09 },
		["MOBILE11"] = { 116.87,-116.05,-31.21,96.38 },
		["MOBILE12"] = { 115.94,-113.74,-31.21,96.38 },
		["MOBILE13"] = { 117.97,-111.98,-31.21,5.67 },
		["LOCKER"] = { 120.06,-122.07,-27.4,280.63 }
	},
	["TwoFloors"] = {
		["MOBILE01"] = { 161.82,-153.82,-17.79,124.73 },
		["MOBILE02"] = { 159.91,-152.22,-17.79,121.89 },
		["MOBILE03"] = { 160.73,-149.65,-17.79,34.02 },
		["MOBILE04"] = { 149.39,-146.54,-19.19,306.15 },
		["MOBILE05"] = { 146.26,-152.24,-19.19,121.89 },
		["MOBILE06"] = { 139.23,-152.49,-19.19,34.02 },
		["MOBILE07"] = { 148.33,-165.83,-19.19,218.27 },
		["MOBILE08"] = { 154.11,-156.47,-19.19,39.69 },
		["MOBILE09"] = { 158.96,-154.89,-19.19,308.98 },
		["MOBILE10"] = { 148.58,-153.96,-24.01,218.27 },
		["MOBILE11"] = { 144.3,-151.02,-24.01,124.73 },
		["MOBILE12"] = { 156.26,-151.34,-24.01,31.19 },
		["MOBILE13"] = { 150.97,-158.78,-24.01,212.6 },
		["MOBILE14"] = { 149.4,-156.3,-24.01,39.69 },
		["LOCKER"] = { 144.18,-148.68,-24.01,34.02 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTRANCEHOMES
-----------------------------------------------------------------------------------------------------------------------------------------
function Xurupita.entranceHomes(TheftName,v,Interior,Theft)
	DoScreenFadeOut(0)

	HomesTheft["CurrentTheft"] = v
	HomesTheft["Open"] = TheftName
	LocalPlayer["state"]["TheftName"] = TheftName
	TriggerEvent("sounds:source","enterhouse",0.7)

	local ped = PlayerPedId()

	if Interior == "Beach" then
		SetEntityCoords(ped,298.05,-303.34,-23.99,1,0,0,0)
		table.insert(HomesTheft["InternTheft"],{ 298.05,-303.34,-23.99,"exit","Saída" })
	elseif Interior == "Middle" then
		SetEntityCoords(ped,86.41,-91.47,-24.2,1,0,0,0)
		table.insert(HomesTheft["InternTheft"],{ 86.41,-91.47,-24.2,"exit","Saída" })
	elseif Interior == "Motel" then
		SetEntityCoords(ped,51.61,-39.05,-25.86,1,0,0,0)
		table.insert(HomesTheft["InternTheft"],{ 51.61,-39.05,-25.86,"exit","Saída" })
	elseif Interior == "Square" then
		SetEntityCoords(ped,68.64,67.3,-23.4,1,0,0,0)
		table.insert(HomesTheft["InternTheft"],{ 68.64,67.3,-23.4,"exit","Saída" })
	elseif Interior == "ThreeFloors" then
		SetEntityCoords(ped,118.4,-108.39,-23.57,1,0,0,0)
		table.insert(HomesTheft["InternTheft"],{ 118.4,-108.39,-23.57,"exit","Saída" })
	elseif Interior == "TwoFloors" then
		SetEntityCoords(ped,166.78,-144.32,-17.79,1,0,0,0)
		table.insert(HomesTheft["InternTheft"],{ 166.78,-144.32,-17.79,"exit","Saída" })
	end

	FreezeEntityPosition(ped,true)
	Wait(1000)
	FreezeEntityPosition(ped,false)
	DoScreenFadeIn(1000)

	if Theft then
		HomesTheft["Theft"] = Interior
		LocalPlayer["state"]["Theft"] = true
		HomesTheft["Police"] = GetGameTimer() + 15000

		if math.random(100) >= 95 then
			HomesTheft["Police"] = GetGameTimer() + 15000
			HomesTheft["Called"] = true
			vSERVER.callPolice(HomesTheft["CurrentTheft"][1],HomesTheft["CurrentTheft"][2],HomesTheft["CurrentTheft"][3])
		end
		if math.random(100) >= 80 then
			if DoesEntityExist(HomesTheft["locker"]) then
				print("existe locker")
				DeleteEntity(HomesTheft["locker"])
				HomesTheft["locker"] = nil
			end
			local mHash = GetHashKey("prop_ld_int_safe_01")

			RequestModel(mHash)
			while not HasModelLoaded(mHash) do
				Wait(1)
			end

			if HasModelLoaded(mHash) then
				HomesTheft["locker"] = CreateObject(mHash,lockerCoords[Interior][1],lockerCoords[Interior][2],lockerCoords[Interior][3])
				SetEntityHeading(HomesTheft["locker"],lockerCoords[Interior][4])
				FreezeEntityPosition(HomesTheft["locker"],true)
			end
		else
			HomesTheft["TheftCoords"]["LOCKER"] = true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADROBBERYS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		local innerTable = {}
		local timeDistance = 999
		if HomesTheft["Theft"] ~= "" and HomesTheft["Open"] ~= "" then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local speed = GetEntitySpeed(ped)
				local coords = GetEntityCoords(ped)

				if speed > 2 and GetGameTimer() >= HomesTheft["Police"] and not HomesTheft["Called"] then
					HomesTheft["Police"] = GetGameTimer() + 15000
					for k,v in pairs(HomesTheft["InternTheft"]) do
						vSERVER.callPolice(HomesTheft["CurrentTheft"][1],HomesTheft["CurrentTheft"][2],HomesTheft["CurrentTheft"][3])
					end
				end

				if TheftCoords[HomesTheft["Theft"]] then
					for k,v in pairs(TheftCoords[HomesTheft["Theft"]]) do
						if not HomesTheft["TheftCoords"][k] then
							local distance = #(coords - vector3(v[1],v[2],v[3]))

							if distance <= 1.25 then
								timeDistance = 1
								-- table.insert(innerTable,{ v[1],v[2],v[3],1.25,"E","Vasculhar","Pressione para vasculhar" })
								DrawText3D(v[1],v[2],v[3],"~g~E~w~   VASCULHAR")
								if IsControlJustPressed(1,38) and MumbleIsConnected() then
									print(k)
									if k == "LOCKER" then
										local safeCracking = exports["safecrack"]:safeCraking(2)
										if safeCracking then
											vSERVER.paymentTheft("LOCKER")
										end

										HomesTheft["TheftCoords"][k] = true
									else
										LocalPlayer["state"]["Cancel"] = true
										vRP.playAnim(false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

										local taskBar = exports["taskbar"]:taskThree()
										if taskBar then
											LocalPlayer["state"]["Commands"] = true
											vRP.playAnim(false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

											TriggerEvent("Progress",10000)
											Citizen.Wait(10000)

											LocalPlayer["state"]["Commands"] = false
											vSERVER.paymentTheft("MOBILE")
											HomesTheft["TheftCoords"][k] = true
										end

										LocalPlayer["state"]["Cancel"] = false
										vRP.removeObjects()
									end
								end
							end
						end
					end
				end
			end
		end

		TriggerEvent("hoverfy:Insert",innerTable)

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINTERN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local innerTable = {}
		local timeDistance = 999
		if HomesTheft["Open"] ~= "" then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local coords = GetEntityCoords(ped)

				for k,v in pairs(HomesTheft["InternTheft"]) do
					if coords[3] <= -1450 and v[4] == "exit" then
						SetEntityCoords(ped,v[1],v[2],v[3],1,0,0,0)
					end

					local distance = #(coords - vec3(v[1],v[2],v[3]))
					if distance <= 1.25 then
						timeDistance = 1.25
						DrawText3D(v[1],v[2],v[3],"~g~E~w~   "..v[5])
						if IsControlJustPressed(1,38) and MumbleIsConnected() then
							if v[4] == "exit" then
								if distance <= 1 then
									DoScreenFadeOut(0)

									SetEntityCoords(ped,HomesTheft["CurrentTheft"][1],HomesTheft["CurrentTheft"][2],HomesTheft["CurrentTheft"][3] - 0.75,1,0,0,0)

									TriggerEvent("sounds:source","outhouse",0.5)
									vSERVER.removeNetwork(HomesTheft["Open"])
									LocalPlayer["state"]["Theft"] = false
									LocalPlayer["state"]["TheftName"] = 0
									HomesTheft["TheftCoords"] = {}
									HomesTheft["Called"] = false
									HomesTheft["InternTheft"] = {}
									HomesTheft["Theft"] = ""
									HomesTheft["Open"] = ""

									if DoesEntityExist(HomesTheft["locker"]) then
										DeleteEntity(HomesTheft["locker"])
										HomesTheft["locker"] = nil
									end

									FreezeEntityPosition(ped,true)
									Wait(1000)
									FreezeEntityPosition(ped,false)
									DoScreenFadeIn(1000)
								end
							end
						end
					end
				end
			end
		end

		TriggerEvent("hoverfy:Insert",innerTable)

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:INVADEPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:invadePolice")
AddEventHandler("propertys:invadePolice",function()
	LocalPlayer["state"]["Theft"] = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = string.len(text) / 160 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,15,15,15,175)
	end
end
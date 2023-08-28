-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Flexin = {}
Tunnel.bindInterface("speedometer",Flexin)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Nitro"] = {}
GlobalState["Purge"] = {}
local nitroColor = true
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATENITRO
-----------------------------------------------------------------------------------------------------------------------------------------
function Flexin.UpdateNitro(Plate,Fuel)
	if GlobalState["Nitro"][Plate] then
		local Nitro = GlobalState["Nitro"]
		Nitro[Plate] = Fuel
		GlobalState:set("Nitro",Nitro,true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPURGE
-----------------------------------------------------------------------------------------------------------------------------------------
function Flexin.UpdatePurge(Plate,Fuel)
	if GlobalState["Purge"][Plate] then
		local Purge = GlobalState["Purge"]
		Purge[Plate] = Fuel
		GlobalState:set("Purge",Purge,true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NITROCOLOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("speedometer:nitroColor")
AddEventHandler("speedometer:nitroColor",function()
	if nitroColor == true then
		nitroColor = false
	else
		nitroColor = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVENITRO
-----------------------------------------------------------------------------------------------------------------------------------------
function Flexin.ActiveNitro(Net,Status)
	local source = source
	local Players = vRPC.nearestPlayers(source,50)
	for _,v in pairs(Players) do
		async(function()
			TriggerClientEvent("speedometer:Nitro",v[2],Net,Status,nitroColor)
		end)
	end
	TriggerClientEvent("speedometer:Nitro",source,Net,Status,nitroColor)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPEEDOMETER:VEHICLEEJECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("speedometer:VehicleEject")
AddEventHandler("speedometer:VehicleEject",function(Velocity)
	local source = source
	local Ped = GetPlayerPed(source)
	local Coords = GetEntityCoords(Ped)

	SetEntityCoords(Ped,Coords["x"],Coords["y"],Coords["z"] - 0.5,true,true,true)
	SetEntityVelocity(Ped,Velocity)

	Wait(1)

	SetPedToRagdoll(Ped,5000,5000,0,0,0,0)
end)
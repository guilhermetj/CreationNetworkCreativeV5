-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
 -----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("GroupFac",cRP)
vSERVER = Tunnel.getInterface("GroupFac")

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- system
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("groupsystem",function(source,args)
    local ped = PlayerPedId()
    -- if not IsPauseMenuActive() and not exports["inventory"]:blockInvents() and not exports["player"]:blockCommands() and not exports["player"]:handCuff() and GetEntityHealth(ped) > 101 and not IsEntityInWater(ped) then
        if vSERVER.checkLider() then
            local groupContext = vSERVER.getOrganizacao()
            SetNuiFocus(true,true)
            SetCursorLocation(0.5,0.5)
            SendNUIMessage({ action = "openSystem", group = groupContext })
            if not IsPedInAnyVehicle(PlayerPedId()) then
                vRP.removeObjects()
                vRP.createObjects("amb@code_human_in_bus_passenger_idles@female@tablet@base","base","prop_cs_tablet",50,28422)
            end
        end
    -- end
end) 


RegisterKeyMapping("groupsystem","Abrir menu de grupos.","keyboard","F11")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeSystem",function(data)
	vRP.removeObjects()
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "closeSystem" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESts
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestMembers",function(data,cb)
	cb({ result = vSERVER.requestMembers(data["group"])})
end)

RegisterNUICallback("requestupdateMembers",function(data,cb)
	cb({ result = vSERVER.updateMember(data["id"],data["set"])})
end)

RegisterNUICallback("requestdeleteMembers",function(data,cb)
	cb({ result = vSERVER.deleteMember(data["id"],data["group"])})
end)

RegisterNUICallback("requestMembersOn",function(data,cb)
    cb({ result = vSERVER.requestMembersOn(data["group"])})
end)

RegisterNUICallback("requestMembersMax",function(data,cb)
    cb({ result = vSERVER.requestMembersMax(data["group"])})
end)

RegisterNUICallback("requestgroupMensage",function(data,cb)
    cb({ result = vSERVER.requestgroupMensage(data["group"])})
end)

RegisterNUICallback("requestSetGroupMensage",function(data,cb)
    vSERVER.requestSetGroupMensage(data["mensage"],data["group"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTsetGroup
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestSetGroup",function(data,cb)
    --VOU USAR O DATA AQUI
	vSERVER.requestSetGroup(data["id"],data["set"],data["group"])
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- system:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("system:Update")
AddEventHandler("system:Update",function(action)
	SendNUIMessage({ action = action })
end)
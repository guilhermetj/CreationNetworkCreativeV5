local oRP = {}
Tunnel.bindInterface("RKG_Store:Desmanche", oRP)
local vCLIENT = Tunnel.getInterface("RKG_Store:Desmanche")

local vehicle_dismantle = {}
local webhook = ''

function oRP.CheckPerm(org_name) 
	local source = source
	local user_id = vRP.getUserId(source)
	local org_perm = Config_Desmanche[org_name].Permission
	if user_id then
		if vRP.hasGroup(user_id,org_perm) then
			return true
		end
		return false
	end
end

function oRP.checkVehIsDismantled(veh_plate,veh_name)
    local consult = vRP.userPlate(veh_plate)
    if consult.user_id then
        return true
    end
    return false
end

function oRP.setVehicleDismantle(data)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vehicle_dismantle[source] then
			vehicle_dismantle[source] = { veh = data.veh, veh_plate = data.veh_plate }
		end
	end
end

function oRP.dismantleVehicle(vehicle,veh_plate,veh_name)
	local source = source
    local user_id = vRP.getUserId(source)
    local consult = vRP.userPlate(veh_plate)
    if consult.user_id then
		if vehicle and veh_plate then
			local identity = vRP.userIdentity(user_id)
			local n_identity = vRP.userIdentity(consult.user_id)

			local price_veh = vehiclePrice(veh_name) / 5 -- Preço que o cara vai receber em dinheiro sujo.
			local price_fines = vehiclePrice(veh_name) / 15 -- Preço da multa que o dono do carro vai receber.

			vRP.giveInventoryItem(user_id,"dollars2",parseInt(price_veh),true)

			PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
				username = "Sistema de Log",
				embeds = {
					{     ------------------------------------------------------------
						title = "REGISTRO DE LOGS",
						fields = {
							{ 
								name = "Informações:", 
								value = " \n Passaporte: "..user_id.." Desmanchou: "..vehicle.." placa: "..veh_plate.." "
							},
						}, 
						footer = { 
							text = os.date('[Dia:] %d-%m-%Y - [Horas:] %H:%M:%S')
						},
						color = 3092790
					}
				}
			}), { ['Content-Type'] = 'application/json' })
			
			TriggerClientEvent("garages:Delete",source)
			vehicle_dismantle[source] = nil
			if n_identity then
				vRP.addFines(parseInt(consult.user_id),parseInt(price_fines))
			end
		else
			TriggerClientEvent("Notify",source,"denied","Veiculo incorreto!")
		end
    end
end

function tD(n)
	n = math.ceil(n * 100) / 100
	return n
end
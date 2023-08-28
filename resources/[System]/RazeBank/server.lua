-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("RazeBank",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERINFO
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.GetPlayerInfo()
    local source = source
    local user_id = vRP.getUserId(source)
    local identity = vRP.userIdentity(user_id)
    local sex = vRPclient.getModelPlayer(source)
	if tostring(sex) == "mp_m_freemode_01" then
        sex = "m"
    else
        sex = "f"
    end
    local data = {
        playerName = identity.name .. " " .. identity.name2,
        playerBankMoney = vRP.getBank(user_id),
        walletMoney = vRP.getInventoryItemAmount(user_id,"dollars") or 0,
        sex = sex,
    }
    return data
end

function cRP.finish_robbery()
	local source = source
	local user_id = vRP.getUserId(source)
	TriggerEvent("Wanted",source,user_id,180)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTWANTED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestWanted()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["hud"]:Wanted(user_id,source) then
			return false
		end
	end

	return true
end

function cRP.paymentSystems()
	local source = source
	local user_id = vRP.getUserId(source)
	local rand = math.random(25,65)
	vRP.generateItem(user_id,"dollarsroll",rand,true)
end

local atmTimers = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSYSTEMS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkSystems()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local policeResult = vRP.numPermission("Police")
		if parseInt(#policeResult) < 2 or os.time() < atmTimers then
			TriggerClientEvent("Notify",source,"amarelo","Sistema indisponível no momento.",5000)
			return false
		else
			local consultItem = vRP.getInventoryItemAmount(user_id,"floppy")
			if consultItem[1] <= 0 then
				TriggerClientEvent("Notify",source,"amarelo","Necessário possuir um <b>Disquete</b>.",5000)
				return false
			end

			vRP.upgradeStress(user_id,10)

			atmTimers = os.time() + 1200
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			TriggerClientEvent("player:applyGsr",source)

			for k,v in pairs(policeResult) do
				async(function()
					vRPclient.playSound(v,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
					TriggerClientEvent("NotifyPush",v,{ code = 20, title = "Caixa Eletrônico", x = coords["x"], y = coords["y"], z = coords["z"], criminal = "Alarme de segurança", time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
				end)
			end
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPIN
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.GetPIN()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.query("characters/getUsers",{ id = user_id })
	
	return identity[1]["pincode"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPOSITMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("RazeBank:DepositMoney")
AddEventHandler("RazeBank:DepositMoney", function(amount)
	local source = source
	local user_id = vRP.getUserId(source)

	if vRP.tryGetInventoryItem(user_id,"dollars", amount) then 
		vRP.addBank(user_id,amount,"Private")

		TriggerEvent('RazeBank:AddDepositTransaction', amount, source)
		TriggerClientEvent('RazeBank:updateTransactions', source, vRP.getBank(user_id), vRP.getInventoryItemAmount(user_id,"dollars"))
		TriggerClientEvent("Notify",source,"verde","Você depositou $"..amount,5000)
	else
		TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente.",5000)
	end
end)

AddEventHandler('smartphone:paypal_deposit', function(user_id, value)
	local source = source
    if vRP.tryGetInventoryItem(user_id,"dollars", amount) then 
		vRP.addBank(user_id,amount,"Private")

		TriggerEvent('RazeBank:AddDepositTransaction', amount, source)
		TriggerClientEvent('RazeBank:updateTransactions', source, vRP.getBank(user_id), vRP.getInventoryItemAmount(user_id,"dollars"))
		TriggerClientEvent("Notify",source,"verde","Você depositou $"..amount,5000)
	else
		TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente.",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAWMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("RazeBank:WithdrawMoney")
AddEventHandler("RazeBank:WithdrawMoney", function(amount)
	local source = source
	local user_id = vRP.getUserId(source)

	if vRP.paymentBank(user_id,amount) then
		vRP.giveInventoryItem(user_id,"dollars",amount,true)
		TriggerEvent('RazeBank:AddWithdrawTransaction', amount, source)
		TriggerClientEvent('RazeBank:updateTransactions', source, vRP.getBank(user_id), vRP.getInventoryItemAmount(user_id,"dollars"))
		TriggerClientEvent("Notify",source,"verde","Você sacou $"..amount,5000)
	else
		TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente.",5000)
	end
end)

AddEventHandler('smartphone:paypal_withdraw', function(user_id, value)
	local source = source
	if vRP.paymentBank(user_id,amount) then
		vRP.giveInventoryItem(user_id,"dollars",amount,true)
		TriggerEvent('RazeBank:AddWithdrawTransaction', amount, source)
		TriggerClientEvent('RazeBank:updateTransactions', source, vRP.getBank(user_id), vRP.getInventoryItemAmount(user_id,"dollars"))
		TriggerClientEvent("Notify",source,"verde","Você sacou $"..amount,5000)
	else
		TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente.",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("RazeBank:TransferMoney")
AddEventHandler("RazeBank:TransferMoney", function(amount, nuser_id)
    local source = source
    local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
    if user_id ~= nuser_id then
        if vRP.paymentBank(user_id,amount) then
            if nuser_id ~= nil then
                vRP.addBank(nuser_id, amount)

                for i=1, #vRP.getUsers(), 1 do
                    local xForPlayer = vRP.getUserId(vRP.getUsers()[i])
                    if xForPlayer == nuser_id then
						local identity2 = vRP.userIdentity(xForPlayer)
                        TriggerClientEvent('RazeBank:updateTransactions', vRP.getUsers()[i], vRP.getBank(nuser_id), vRP.getInventoryItemAmount(nuser_id,"dollars"))
                        TriggerClientEvent('okokNotify:Alert', vRP.getUsers()[i], "BANK", "Você recebeu $"..amount.." from "..identity2.name .. " " .. identity2.name2, 5000, 'success')
                    end
                end
                TriggerEvent('RazeBank:AddTransferTransaction', amount, nuser_id, source)
				TriggerClientEvent('RazeBank:updateTransactions', source, vRP.getBank(user_id), vRP.getInventoryItemAmount(user_id,"dollars"))
				TriggerClientEvent("Notify",source,"verde","Você transferiu $"..amount.." para "..identity.name .. " " .. identity.name2,5000)
            end
        else
			TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente.",5000)
        end
    else
		TriggerClientEvent("Notify",source,"vermelho","Você não pode transferir para si mesmo.",5000)
    end
end)


AddEventHandler('smartphone:paypal_send', function(user_id, nuser_id, value)
    local source = source
	local identity = vRP.userIdentity(user_id)
    if user_id ~= nuser_id then
        if vRP.paymentBank(user_id,amount) then
            if nuser_id ~= nil then
                vRP.addBank(nuser_id, amount)

                for i=1, #vRP.getUsers(), 1 do
                    local xForPlayer = vRP.getUserId(vRP.getUsers()[i])
                    if xForPlayer == nuser_id then
						local identity2 = vRP.userIdentity(xForPlayer)
                        TriggerClientEvent('RazeBank:updateTransactions', vRP.getUsers()[i], vRP.getBank(nuser_id), vRP.getInventoryItemAmount(nuser_id,"dollars"))
                        TriggerClientEvent('okokNotify:Alert', vRP.getUsers()[i], "BANK", "Você recebeu $"..amount.." from "..identity2.name .. " " .. identity2.name2, 5000, 'success')
                    end
                end
                TriggerEvent('RazeBank:AddTransferTransaction', amount, nuser_id, source)
				TriggerClientEvent('RazeBank:updateTransactions', source, vRP.getBank(user_id), vRP.getInventoryItemAmount(user_id,"dollars"))
				TriggerClientEvent("Notify",source,"verde","Você transferiu $"..amount.." para "..identity.name .. " " .. identity.name2,5000)
            end
        else
			TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente.",5000)
        end
    else
		TriggerClientEvent("Notify",source,"vermelho","Você não pode transferir para si mesmo.",5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETOVERVIEWTRANSACTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.GetOverviewTransactions()
	local source = source
	local user_id = vRP.getUserId(source)
	local playerIdentifier = user_id
	local allDays = {}
	local income = 0
	local outcome = 0
	local totalIncome = 0
	local day1_total, day2_total, day3_total, day4_total, day5_total, day6_total, day7_total = 0, 0, 0, 0, 0, 0, 0

	local result = vRP.query("vRP/Get_Transactions", { identifier = playerIdentifier })

	local result2 = vRP.query("vRP/Transactions", { })
	for k, v in pairs(result2) do
		local type = v.type
		local receiver_identifier = v.receiver_identifier
		local sender_identifier = v.sender_identifier
		local value = tonumber(v.value)

		if v.day1 == 1 then
			if value ~= nil then
				if type == "deposit" then
					day1_total = day1_total + value
					income = income + value
				elseif type == "withdraw" then
					day1_total = day1_total - value
					outcome = outcome - value
				elseif type == "transfer" and receiver_identifier == playerIdentifier then
					day1_total = day1_total + value
					income = income + value
				elseif type == "transfer" and sender_identifier == playerIdentifier then
					day1_total = day1_total - value
					outcome = outcome - value
				end
			end
			
		elseif v.day2 == 1 then
			if value ~= nil then
				if type == "deposit" then
					day2_total = day2_total + value
					income = income + value
				elseif type == "withdraw" then
					day2_total = day2_total - value
					outcome = outcome - value
				elseif type == "transfer" and receiver_identifier == playerIdentifier then
					day2_total = day2_total + value
					income = income + value
				elseif type == "transfer" and sender_identifier == playerIdentifier then
					day2_total = day2_total - value
					outcome = outcome - value
				end
			end

		elseif v.day3 == 1 then
			if value ~= nil then
				if type == "deposit" then
					day3_total = day3_total + value
					income = income + value
				elseif type == "withdraw" then
					day3_total = day3_total - value
					outcome = outcome - value
				elseif type == "transfer" and receiver_identifier == playerIdentifier then
					day3_total = day3_total + value
					income = income + value
				elseif type == "transfer" and sender_identifier == playerIdentifier then
					day3_total = day3_total - value
					outcome = outcome - value
				end
			end

		elseif v.day4 == 1 then
			if value ~= nil then
				if type == "deposit" then
					day4_total = day4_total + value
					income = income + value
				elseif type == "withdraw" then
					day4_total = day4_total - value
					outcome = outcome - value
				elseif type == "transfer" and receiver_identifier == playerIdentifier then
					day4_total = day4_total + value
					income = income + value
				elseif type == "transfer" and sender_identifier == playerIdentifier then
					day4_total = day4_total - value
					outcome = outcome - value
				end
			end

		elseif v.day5 == 1 then
			if value ~= nil then
				if type == "deposit" then
					day5_total = day5_total + value
					income = income + value
				elseif type == "withdraw" then
					day5_total = day5_total - value
					outcome = outcome - value
				elseif type == "transfer" and receiver_identifier == playerIdentifier then
					day5_total = day5_total + value
					income = income + value
				elseif type == "transfer" and sender_identifier == playerIdentifier then
					day5_total = day5_total - value
					outcome = outcome - value
				end
			end

		elseif v.day6 == 1 then
			if value ~= nil then
				if type == "deposit" then
					day6_total = day6_total + value
					income = income + value
				elseif type == "withdraw" then
					day6_total = day6_total - value
					outcome = outcome - value
				elseif type == "transfer" and receiver_identifier == playerIdentifier then
					day6_total = day6_total + value
					income = income + value
				elseif type == "transfer" and sender_identifier == playerIdentifier then
					day6_total = day6_total - value
					outcome = outcome - value
				end
			end

		elseif v.day7 == 1 then
			if value ~= nil then
				if type == "deposit" then
					day7_total = day7_total + value
					income = income + value
				elseif type == "withdraw" then
					day7_total = day7_total - value
					outcome = outcome - value
				elseif type == "transfer" and receiver_identifier == playerIdentifier then
					day7_total = day7_total + value
					income = income + value
				elseif type == "transfer" and sender_identifier == playerIdentifier then
					day7_total = day7_total - value
					outcome = outcome - value
				end
			end

		end
	end

	totalIncome = day1_total + day2_total + day3_total + day4_total + day5_total + day6_total + day7_total

	table.remove(allDays)
	table.insert(allDays, day1_total)
	table.insert(allDays, day2_total)
	table.insert(allDays, day3_total)
	table.insert(allDays, day4_total)
	table.insert(allDays, day5_total)
	table.insert(allDays, day6_total)
	table.insert(allDays, day7_total)
	table.insert(allDays, income)
	table.insert(allDays, outcome)
	table.insert(allDays, totalIncome)

	return result, playerIdentifier, allDays
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDDEPOSITTRANSACTION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("RazeBank:AddDepositTransaction")
AddEventHandler("RazeBank:AddDepositTransaction", function(amount, source_)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local user_id = vRP.getUserId(_source)
	local identity = vRP.userIdentity(user_id)
	local result = vRP.query("vRP/AddDepositTransaction", { receiver_identifier = "bank",receiver_name = "Bank Account",sender_identifier = tostring(user_id),sender_name = identity.name .. " " .. identity.name2, value = tonumber(amount), type = "deposit"})

	return result
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSALARI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("RazeBank:AddSalaryTransaction")
AddEventHandler("RazeBank:AddSalaryTransaction", function(amount, source_)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local user_id = vRP.getUserId(_source)
	local identity = vRP.userIdentity(user_id)
	local result = vRP.query("vRP/AddSalaryTransaction", { receiver_identifier = "bank",receiver_name = "Pagamento",sender_identifier = tostring(user_id),sender_name = identity.name .. " " .. identity.name2, value = tonumber(amount), type = "salary"})

	return result
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDWITHDRAWTRANSACTION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("RazeBank:AddWithdrawTransaction")
AddEventHandler("RazeBank:AddWithdrawTransaction", function(amount, source_)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local user_id = vRP.getUserId(_source)
	local identity = vRP.userIdentity(user_id)
	local result = vRP.query("vRP/AddWithdrawTransaction", { 
		receiver_identifier = tostring(user_id),
		receiver_name = identity.name .. " " .. identity.name2,
		sender_identifier = "bank",
		sender_name = "Bank Account", 
		value = tonumber(amount), 
		type = "withdraw"
	})
	return result
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDTRANSFERTRANSACTION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("RazeBank:AddTransferTransaction")
AddEventHandler("RazeBank:AddTransferTransaction", function(amount, xTarget, source_, targetName, targetIdentifier)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local user_id = vRP.getUserId(_source)
	local identity = vRP.userIdentity(user_id)
	local identity2 = vRP.userIdentity(xTarget)
	if targetName == nil then
		local result = vRP.query("vRP/AddTransferTransaction", { 
			receiver_identifier = tostring(xTarget),
			receiver_name = identity2.name .. " " .. identity2.name2,
			sender_identifier = tostring(user_id),
			sender_name = identity.name .. " " .. identity.name2,
			value = tonumber(amount), 
			type = "trasnfer"
		})
		return result
	elseif targetName ~= nil and targetIdentifier ~= nil then
		local result = vRP.query("vRP/AddTransferTransaction", { 
			receiver_identifier = tostring(targetIdentifier),
			receiver_name = tostring(targetName),
			sender_identifier = tostring(user_id),
			sender_name = identity.name .. " " .. identity.name2,
			value = tonumber(amount), 
			type = "trasnfer"
		})
		return result
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPINDB
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("RazeBank:UpdatePINDB")
AddEventHandler("RazeBank:UpdatePINDB", function(pin, amount)
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.paymentBank(user_id,1000) then
		vRP.query("vRP/UpdatePINDB", { 
			pin = pin,
			identifier = user_id,
		})
		vRP.updateUserPincode(user_id, pin)
        TriggerClientEvent('RazeBank:updateIbanPinChange', source)
		TriggerClientEvent('RazeBank:updateMoney',source, vRP.getBank(user_id), vRP.getInventoryItemAmount(user_id,"dollars"))
		TriggerClientEvent("Notify",source,"verde","PIN trocado com sucesso para "..pin,5000)
    else
		TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente.",5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINESPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.finesPayment(id,price)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.paymentBank(user_id,parseInt(price)) then
            vRP.delFines(user_id,parseInt(price))
        else
            TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente na sua conta bancária.",5000)
        end
    end
end
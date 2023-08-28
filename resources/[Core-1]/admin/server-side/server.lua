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
cRP = {}
Tunnel.bindInterface("admin",cRP)
vCLIENT = Tunnel.getInterface("admin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookgod = ""
local webhookkick = ""
local webhookkickall = ""
local webhookgive = ""
local webhookban = "https://ptb.discord.com/api/webhooks/1085724312096481360/5WoCZepU-ZOauQ74kPTSm0Bn6rfB8xINsSwib5xS9O0o3FOld-afWGQa0LQ0d5qivFHt"
local webhookunban = ""
local webhookaddcar = "https://ptb.discord.com/api/webhooks/1085724312096481360/5WoCZepU-ZOauQ74kPTSm0Bn6rfB8xINsSwib5xS9O0o3FOld-afWGQa0LQ0d5qivFHt"
local webhookremcar = ""
local webhookadminaddgroup = ""
local webhookadminremgroup = ""
local webhooknc = ""
local webhookfix = ""
local webhookannounce = ""
local webhookteleport = ""
local webhookpriority = ""
local webhookdelete = ""
local webhookgems = ""
local webhookitemall = ""

function logs(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM				/item NOMEDOITEM ID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("item",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			if args[1] and args[2] and itemBody(args[1]) ~= nil then
				vRP.generateItem(user_id,args[1],parseInt(args[2]),true)
				logs(webhookgive,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.." \n[PEGOU]: "..args[1].." \n[QUANTIDADE]: "..parseInt(args[2]).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLINDADO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("blindado",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
            local vehicle,vehNet = vRPclient.vehList(source,1)
            if vehicle then
                TriggerClientEvent("admin:armored",-1,vehNet,true)
                TriggerClientEvent("Notify",source,"sucesso","Você tornou este veículo blindado.",3000)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDCAR			/addcar ID NOMEDOVEICULO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("addcar",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		if vRP.hasGroup(user_id,"Admin")  and args[1] and args[2] then
			logs(webhookaddcar,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.." \n[ADICIONOU]: "..args[2].." \n[PARA O ID]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```") 
			vRP.execute("vehicles/addVehicles",{ user_id = parseInt(args[1]), vehicle = args[2], plate = vRP.generatePlate(), work = tostring(false) })
			TriggerClientEvent("Notify",args[1],"azul","Voce recebeu <b>"..args[2].."</b> em sua garagem.",10000)
			TriggerClientEvent("Notify",source,"azul","Adicionou o veiculo: <b>"..args[2].."</b> no ID: <b>"..args[1].."</b.",10000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- IMORTAL
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.isAdmin()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id, "Admin") then
            return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMCAR			/remcar ID NOMEDOVEICULO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("remcar",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		if vRP.hasGroup(user_id,"Admin")  and args[1] and args[2] then
			logs(webhookremcar,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.." \n[REMOVEU]: "..args[2].." \n[DO ID]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```") 
			vRP.execute("vehicles/removeVehicles",{ user_id = parseInt(args[1]), vehicle = args[2], plate = vRP.generatePlate(), work = tostring(false) })
			TriggerClientEvent("Notify",args[1],"azul","Foi Removido <b>"..args[2].."</b> Da Sua Garagem.",10000)
			TriggerClientEvent("Notify",source,"azul","Você Removeu: <b>"..args[2].."</b> do ID: <b>"..args[1].."</b.",10000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD REVIVER			/god ID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("god",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			if args[1] then
				local nuser_id = parseInt(args[1])
				local otherPlayer = vRP.userSource(nuser_id)
				if otherPlayer then
					logs(webhookgod,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.." \n[USOU GOD NO ID]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```") 
					vRP.upgradeThirst(nuser_id,50)
					vRP.upgradeHunger(nuser_id,50)
					vRP.downgradeStress(nuser_id,50)
					vRPC.revivePlayer(otherPlayer,200)
					TriggerClientEvent("resetBleeding",source)
					TriggerClientEvent("resetDiagnostic",source)
				end
			else
				logs(webhookgod,"```[NOME]: "..identity.name.." "..identity.name2.." \n[USOU GOD EM SI]: "..user_id.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```") 
				vRPC.revivePlayer(source,200)
				vRP.upgradeThirst(user_id,50)
				vRP.upgradeHunger(user_id,50)
				vRP.downgradeStress(user_id,50)
				TriggerClientEvent("resetHandcuff",source)
				TriggerClientEvent("resetBleeding",source)
				TriggerClientEvent("resetDiagnostic",source)
			end
			
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOOD	COLETE			/good ID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("good",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		if vRP.hasGroup(user_id,"Admin")  then
			if args[1] then
				local nuser_id = parseInt(args[1])
				local otherPlayer = vRP.userSource(nuser_id)
				if otherPlayer then
					logs(webhookgod,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.." \n[USOU GOOD NO ID]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```") 
					vRP.setArmour(otherPlayer,100)
					vRP.upgradeThirst(nuser_id,100)
					vRP.upgradeHunger(nuser_id,100)
					vRP.downgradeStress(nuser_id,100)
					vRPC.revivePlayer(otherPlayer,200)
				end
			else
				logs(webhookgod,"```[NOME]: "..identity.name.." "..identity.name2.." \n[USOU GOOD EM SI]: "..user_id.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				vRP.setArmour(source,100)
				vRPC.revivePlayer(source,200)
				vRP.upgradeThirst(user_id,100)
				vRP.upgradeHunger(user_id,100)
				vRP.downgradeStress(user_id,100)
				TriggerClientEvent("resetHandcuff",source)
				TriggerClientEvent("resetBleeding",source)
				TriggerClientEvent("resetDiagnostic",source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRIORITY			/priority ID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("priority",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(args[1]) > 0 then
		if vRP.hasGroup(user_id,"Admin")  then
			local nuser_id = parseInt(args[1])
			local identity = vRP.userIdentity(nuser_id)
			if identity then
				TriggerClientEvent("Notify",source,"verde","Prioridade adicionada.",5000)
				vRP.execute("accounts/setPriority",{ steam = identity["steam"], priority = 99 })
				logs(webhookpriority,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.." \n[DEU PRIORIDADE]: "..identity["steam"].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETE			/delete ID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("delete",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and args[1] then
		if vRP.hasGroup(user_id,"Admin")  then
			local nuser_id = parseInt(args[1])
			vRP.execute("characters/removeCharacters",{ id = nuser_id })
			logs(webhookdelete,"``` \n[ID]: "..user_id.." \n[DELETOU PERSONAGEM DO ID]: "..nuser_id.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			TriggerClientEvent("Notify",source,"verde","Personagem <b>"..nuser_id.."</b> deletado.",5000)
			vRP.kick(args[1],"Sua história terminou, crie uma nova.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC			/nc
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("nc",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		if vRP.hasGroup(user_id,"Admin")  then
			vRPC.noClip(source)
			logs(webhooknc,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.." \n[UTILIZOU O NOCLIP] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC2			APERTE LETRA O PARA FICAR INVISIVEL
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.enablaNoclip()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		if vRP.hasGroup(user_id,"Admin")  then
			vRPC.noClip(source)
			logs(webhooknc,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.." \n[UTILIZOU O NOCLIP] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK			/kick ID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kick",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") and parseInt(args[1]) > 0 then
			TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..args[1].."</b> expulso.",5000)
			vRP.kick(args[1],"Você foi expulso da cidade.")
			logs(webhookkick,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.." \n[KICKOU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICKALL			/kickall
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kickall",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		if vRP.hasGroup(user_id,"Admin")  then
			local playerList = vRP.userList()
			for k,v in pairs(playerList) do
				vRP.kick(k,"Desconectado, a cidade vai reiniciar.")
				Citizen.Wait(100)
			end
		end
		TriggerEvent("admin:KickAll")
		logs(webhookkickall,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.." \n[KICKOU TODOS PLAYERS]: "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AVISO PREFEITURA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("anunciar",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Moderator") then
            local message = vRP.prompt(source,"Mensagem:","")
            if message == "" then
                return
            end
			
            TriggerClientEvent("Notify",-1,"vermelho",message,15000,"<br><b>Mensagem enviada pela Prefeitura</b>")
            TriggerClientEvent("sounds:source",-1,"notification",0.5)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AVISOMEC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("mec",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"Mechanic") or vRP.hasPermission(user_id,"Admin") then
            local message = vRP.prompt(source,"Mensagem:","")
            if message == "" then
                return
            end
			
            TriggerClientEvent("Notify",-1,"amarelo",message,15000,"<br><b>Mensagem enviada pelo Mecânico</b>")
            TriggerClientEvent("sounds:source",-1,"notification",0.5)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AVISOMED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("med",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"Paramedic") or vRP.hasPermission(user_id,"Admin") then
            local message = vRP.prompt(source,"Mensagem:","")
            if message == "" then
                return
            end
			
            TriggerClientEvent("Notify",-1,"amarelo",message,15000,"<br><b>Mensagem enviada por Paramedico</b>")
            TriggerClientEvent("sounds:source",-1,"notification",0.5)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AVISOPO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cop",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"Policia") or vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"PoliciaCivil") then
            local message = vRP.prompt(source,"Mensagem:","")
            if message == "" then
                return
            end
			
            TriggerClientEvent("Notify",-1,"azul",message,15000,"<br><b>Mensagem enviada pela Policia</b>")
            TriggerClientEvent("sounds:source",-1,"notification",0.5)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("wl",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			vRP.execute("accounts/infosWhitelist",{ steam = tostring(args[1]), whitelist = 1 })
			TriggerClientEvent("Notify",source,"verde","Você aprovou a Hex "..args[1]..".",5000)
			TriggerEvent("discordLogs","Wl","**ID:** "..user_id.."\n**Aprovou:** "..args[1].." \n**Horário:** "..os.date("%H:%M:%S"),3092790)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WL retirar
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unwl",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			vRP.execute("accounts/infosUnwhitelist",{ steam = tostring(args[1]), whitelist = 1 })
			TriggerClientEvent("Notify",source,"verde","Você removeu a Hex "..args[1]..".",5000)
			TriggerEvent("discordLogs","Wl","**ID:** "..user_id.."\n**Removeu:** "..args[1].." \n**Horário:** "..os.date("%H:%M:%S"),3092790)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
local Spectate = false
RegisterCommand("spectate",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			if Spectate then
				Spectate = false
				TriggerClientEvent("admin:resetSpectate",source)
				TriggerClientEvent("Notify",source,"amarelo","Desativado.",5000)
			else
				Spectate = true
				TriggerClientEvent("admin:initSpectate",source)
				TriggerClientEvent("Notify",source,"verde","Ativado.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("pon",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    
    if vRP.hasGroup(user_id, "Admin") then
        local users = vRP.userList()
        local players = ""
        local quantidade = 0
        for k,v in pairs(users) do
            if k ~= #users then
                players = players..", "
            end
            players = players..k
            quantidade = quantidade + 1
        end
        TriggerClientEvent('chatMessage',source,"TOTAL ONLINE",{1, 136, 0},quantidade)
        TriggerClientEvent('chatMessage',source,"ID's ONLINE",{1, 136, 0},players)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ban",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") or vRP.hasGroup(user_id,"Moderator") and parseInt(args[1]) > 0 and parseInt(args[2]) > 0 then
			local time = parseInt(args[2])
			local nuser_id = parseInt(args[1])
			local identity = vRP.userIdentity(nuser_id)
			if identity then
				vRP.kick(nuser_id,"Banido.")
				vRP.execute("banneds/insertBanned",{ steam = identity["steam"], time = time })
				TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..nuser_id.."</b> banido por <b>"..time.." dias.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unban",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") and parseInt(args[1]) > 0 then
			local nuser_id = parseInt(args[1])
			local identity = vRP.userIdentity(nuser_id)
			if identity then
				vRP.execute("banneds/removeBanned",{ steam = identity["steam"] })
				TriggerClientEvent("Notify",source,"verde","Passaporte <b>"..nuser_id.."</b> desbanido.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpcds",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin")  then
			local fcoords = vRP.prompt(source,"Cordenadas:","")
			if fcoords == "" then
				return
			end

			local coords = {}
			for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
				table.insert(coords,parseInt(coord))
			end

			vRP.teleport(source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cds",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin")  then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)

			vRP.prompt(source,"Cordenadas:",mathLegth(coords["x"])..","..mathLegth(coords["y"])..","..mathLegth(coords["z"])..","..mathLegth(heading))
		end
	end
end)

RegisterCommand('cds2',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasGroup(user_id,"Admin") then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)

			vRP.prompt(source,"Cordenadas:","x = "..mathLegth(coords.x)..", y = "..mathLegth(coords.y)..", z = "..mathLegth(coords.z))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.buttonTxt()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin")  then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)

			vRP.updateTxt(user_id..".txt",mathLegth(coords.x)..","..mathLegth(coords.y)..","..mathLegth(coords.z)..","..mathLegth(heading))
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP			/group ID NOMEDASETAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("group",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		--if vRP.hasGroup(user_id,"Admin")  and parseInt(args[1]) > 0 and args[2] then
			TriggerClientEvent("Notify",source,"verde","Adicionado <b>"..args[2].."</b> ao passaporte <b>"..args[1].."</b>.",5000)
			vRP.setPermission(args[1],args[2])
			logs(webhookadminaddgroup,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.." \n[ADICIONOU]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		--end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP			/ungroup ID NOMEDASETAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ungroup",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		--if vRP.hasGroup(user_id,"Admin")  and parseInt(args[1]) > 0 and args[2] then
			TriggerClientEvent("Notify",source,"verde","Removido <b>"..args[2].."</b> ao passaporte <b>"..args[1].."</b>.",5000)
			vRP.remPermission(args[1],args[2])
			logs(webhookadminremgroup,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.." \n[REMOVEU]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		--end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tptome",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") and parseInt(args[1]) > 0 then
			local otherPlayer = vRP.userSource(args[1])
			if otherPlayer then
				local ped = GetPlayerPed(source)
				local coords = GetEntityCoords(ped)

				vRP.teleport(otherPlayer,coords["x"],coords["y"],coords["z"])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpto",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") and parseInt(args[1]) > 0 then
			local otherPlayer = vRP.userSource(args[1])
			if otherPlayer then
				local ped = GetPlayerPed(otherPlayer)
				local coords = GetEntityCoords(ped)
				vRP.teleport(source,coords["x"],coords["y"],coords["z"])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpway",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		if vRP.hasGroup(user_id,"Admin")  then
			vCLIENT.teleportWay(source)
			logs(webhookteleport,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.." \n[UTILIZOU O TPWAY] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMBO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limbo",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and vRP.getHealth(source) <= 101 then
			vCLIENT.teleportLimbo(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hash",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			local vehicle = vRPC.vehicleHash(source)
			if vehicle then
				print(vehicle)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tuning",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		if vRP.hasGroup(user_id,"Admin")  then
			TriggerClientEvent("admin:vehicleTuning",source)
			logs(webhookfix,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.." \n[UTILIZOU O FIX] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fix",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		if vRP.hasGroup(user_id,"Admin")  then
			local vehicle,vehNet,vehPlate = vRPC.vehList(source,10)
			if vehicle then
				local activePlayers = vRPC.activePlayers(source)
				for _,v in ipairs(activePlayers) do
					async(function()
						TriggerClientEvent("inventory:repairAdmin",v,vehNet,vehPlate)
						logs(webhookfix,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.." \n[UTILIZOU O FIX] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limparea",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin")  then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)

			local activePlayers = vRPC.activePlayers(source)
			for _,v in ipairs(activePlayers) do
				async(function()
					TriggerClientEvent("syncarea",v,coords["x"],coords["y"],coords["z"],100)
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("status",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin")  then
			TriggerClientEvent("Notify",source,"azul","<b>Jogadores Conectados:</b> "..GetNumPlayerIndices(),5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("anuncio",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		if vRP.hasGroup(user_id,"Admin")  then
			local message = vRP.prompt(source,"Mensagem:","")
			if message == "" then
				return
			end
			---TriggerClientEvent("Notify",-1,"amarelo",message.."<br><b>Mensagem enviada por:</b> Governador",20000)
			TriggerClientEvent("smartphone:createSMS",-1,"Governador",message)
			logs(webhookannounce,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.." \n[MENSAGEM]: "..message.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("announce",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") or vRP.hasGroup(user_id,"Corrections") or vRP.hasGroup(user_id,"Paramedic") or vRP.hasGroup(user_id,"Mechanic") or vRP.hasGroup(user_id,"Moderator") or vRP.hasGroup(user_id,"Suporte") and args[1] then
			TriggerClientEvent("chatME",-1,"^6ALERTA^9AVISO^0"..rawCommand:sub(9))
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSOLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("console",function(source,args,rawCommand)
	if source == 0 then
		TriggerClientEvent("chatME",-1,"^6ALERTA^9Governador^0"..rawCommand:sub(9))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("itemall",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			local playerList = vRP.userList()
			for k,v in pairs(playerList) do
				async(function()
					vRP.generateItem(k,tostring(args[1]),parseInt(args[2]),true)
				end)
			end

			TriggerClientEvent("Notify",source,"verde","Envio concluído.",10000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG 2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("debug2",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			TriggerClientEvent("ToggleDebug",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACECOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local checkPoints = 0
function cRP.raceCoords(vehCoords,leftCoords,rightCoords)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		checkPoints = checkPoints + 1

		vRP.updateTxt("races.txt","["..checkPoints.."] = {")

		vRP.updateTxt("races.txt","{ "..mathLegth(vehCoords["x"])..","..mathLegth(vehCoords["y"])..","..mathLegth(vehCoords["z"]).." },")
		vRP.updateTxt("races.txt","{ "..mathLegth(leftCoords["x"])..","..mathLegth(leftCoords["y"])..","..mathLegth(leftCoords["z"]).." },")
		vRP.updateTxt("races.txt","{ "..mathLegth(rightCoords["x"])..","..mathLegth(rightCoords["y"])..","..mathLegth(rightCoords["z"]).." }")

		vRP.updateTxt("races.txt","},")
	end
end



-----------------------------------------------------------------------------------------------------------------------------------------
-- GEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("gem",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") and parseInt(args[1]) > 0 and parseInt(args[2]) > 0 then
			local ID = parseInt(args[1])
			local Amount = parseInt(args[2])
			local identity = vRP.userIdentity(ID)
			if identity then
				vRP.execute("accounts/infosUpdategems",{ steam = identity["steam"], gems = Amount })
				TriggerEvent("discordLogs","Gemstones","**Passaporte:** "..ID.."\n**Recebeu:** "..Amount.." Gemas\n**Horário:** "..os.date("%H:%M:%S"),3092790)
				logs(webhookgems,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..user_id.."  \n[ENVIOU GEMS PARA]: "..args[1].." \n[QUANTIDADE]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				TriggerClientEvent("Notify",source,"verde","ID <b>"..args[1].."</b> recebeu <b>"..args[2].." Gemas</b>.",5000)
			end
		end
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("blips",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			vRPC.blipsAdmin(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("save",function(source)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			return
		end
	end

	TriggerEvent("admin:KickAll")
end)
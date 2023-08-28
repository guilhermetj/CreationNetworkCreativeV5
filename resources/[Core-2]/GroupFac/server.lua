-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("GroupFac", cRP)
vCLIENT = Tunnel.getInterface("GroupFac")



RegisterCommand("addLider",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	local name1 = vRP.userIdentity(args[1])
	if user_id then
		if vRP.hasGroup(user_id,"Admin") or vRP.hasGroup(user_id,"Moderador") then
			vRP.setPermission(args[1],args[2])
			if args[2] == "Policia" then 
				vRP.setPermission(args[1],"Police")
				vRP.setPermission(args[1],"PoliceLider")
				vRP.execute("groupSystem/setData", { user_id = parseInt(args[1]), name = name1["name"].." "..name1["name2"],cargo = "Coronel", status = "on", organizacao = args[2] })
				TriggerClientEvent("system:Update", source, "updateData")
				TriggerClientEvent("Notify",source,"verde","O "..name1["name"].." "..name1["name2"].." foi adicionado como lider do grupo "..args[2],8000)
			else
				vRP.setPermission(args[1],args[2].."Lider")
				vRP.execute("groupSystem/setData", { user_id = parseInt(args[1]), name = name1["name"].." "..name1["name2"],cargo = "Lider", status = "on", organizacao = args[2] })
				TriggerClientEvent("system:Update", source, "updateData")
				TriggerClientEvent("Notify",source,"verde","O "..name1["name"].." "..name1["name2"].." foi adicionado como lider do grupo "..args[2],8000)
			end
		end
	end
end)
RegisterCommand("remLider",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	local name1 = vRP.userIdentity(args[1])
	if user_id then
		if vRP.hasGroup(user_id,"Admin") or vRP.hasGroup(user_id,"Moderador") then
			cRP.deleteMember(userid,args[2])
		end
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTMEMBERS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestMembers(group)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local query = vRP.query("groupSystem/membersData",{organizacao = group})
		local list = {}
		for k, v in pairs(query) do
			-- table.insert(rankList,{ name = v["nameCorredor"], pontos = v["pontos"],veiculo = v["veiculo"],raceName = v["raceName"]})
			table.insert(list, { id = v["user_id"],name = v["name"],cargo = v["cargo"],status = v["status"]})
		end
		
		return list
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- AttData
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.AttData(group)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local qtdMembers = vRP.query("groupSystem/membersQtd",{organizacao = group})
		local qtdMaxMembers = vRP.execute("groupSystem/updateDataMembers",{membros = qtdMembers,organizacao = group})	
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSETGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestSetGroup(userid,set,group)
	local source = source
	local user_id = vRP.getUserId(source)
	local name1 = vRP.userIdentity(userid)
	if user_id then
		if not cRP.checkMaxGroup(group) then
			if group == "Policia" then
				vRP.setPermission(userid,"Police")
			end

			if set == "Gerente" then
				vRP.setPermission(userid,group.."Lider")
			elseif set == "Tenente Coronel" or  set == "Major" or  set == "Capitao" or  set == "Tenente" then
				vRP.setPermission(userid,group.."Lider")
				vRP.setPermission(userid,"PoliceLider")
			end
				cRP.AttData(group)
				vRP.setPermission(userid,group)
				vRP.execute("groupSystem/setData", { user_id = parseInt(userid), name = name1["name"].." "..name1["name2"],cargo = set, status = "off", organizacao = group })
				TriggerClientEvent("system:Update", source, "updateData")
		else
			TriggerClientEvent("system:Update", source, "updateData")
			TriggerClientEvent("Notify",source,"vermelho","Seu grupo está cheio, não foi possivel adicionar o novo membro",8000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateMember(userid,set)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("groupSystem/updateData", { cargo = set ,user_id = parseInt(userid)})
		TriggerClientEvent("system:Update", source, "updateData")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTDELETE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.deleteMember(userid,group)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.remPermission(userid,group)
		vRP.remPermission(userid,group.."Lider")
		vRP.remPermission(userid,"PoliceLider")
		vRP.remPermission(userid,"Police")
		vRP.remPermission(userid,"waitPolicia")
		vRP.remPermission(userid,"waitParamedic")
		
		vRP.execute("groupSystem/deleteData", { user_id = parseInt(userid)})
		TriggerClientEvent("system:Update", source, "updateData")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTMemberOn
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestMembersOn(group)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local qtdOns = vRP.query("groupSystem/HowStatus",{status = "on",organizacao = group})
		local ons = qtdOns[1]["count(status)"]
		local list ={}
		table.insert(list,{ qtdOn = ons})
		return list
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTMemberMax
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestMembersMax(group)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local orgQtd = vRP.query("groupSystem/orgQtd",{organizacao = group})
		local qtdMembers = vRP.query("groupSystem/membersQtd",{organizacao = group})
		local ons = qtdMembers[1]["count(user_id)"]
		local list ={}
		table.insert(list,{ qtd = ons,maxQtd = orgQtd[1]["membros"]})
		return list
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTGroupMensage
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestgroupMensage(group)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local mensagem = vRP.query("groupSystem/groupMensage",{organizacao = group})
		
		local list ={}
		table.insert(list,{ msg = mensagem[1]["mensagem"]})
		return list
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSETGroupMensage
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestSetGroupMensage(mensagem,group)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("groupSystem/setMensage",{mensagem = mensagem ,organizacao = group})
		TriggerClientEvent("system:Update", source, "updateData")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------


function cRP.getOrganizacao()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local query = vRP.query("groupSystem/checkData",{user_id = parseInt(user_id)})
		return query[1]["organizacao"]
	end
end

function cRP.checkLider()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local query = vRP.query("groupSystem/checkData",{user_id = parseInt(user_id)})
		if query[1]["cargo"] == "Lider" or query[1]["cargo"] == "Gerente" or query[1]["cargo"] == "Coronel" or query[1]["cargo"] == "Tentente Coronel"  or query[1]["cargo"] == "Major" or  query[1]["cargo"] == "Capitão" or query[1]["cargo"] == "Tentente" then
			return true
		end
		return false
	end
end

function cRP.checkExists()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		
	end
end

function cRP.checkMaxGroup(group)
	
	local orgQtd = vRP.query("groupSystem/orgQtd",{organizacao = group})
	local qtdMembers = vRP.query("groupSystem/membersQtd",{organizacao = group})
	-- se for maior que zero significa que ainda nao atingiu o maximo
	if (parseInt(qtdMembers[1]["count(user_id)"]) - parseInt(orgQtd[1]["membros"])) > 0 then
		return false
	elseif (parseInt(qtdMembers[1]["count(user_id)"]) - parseInt(orgQtd[1]["membros"])) == 0 then
		return true
	end
end


-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerConnect", function(user_id, source)
	vRP.execute("groupSystem/updateStatus", { status = "on" ,user_id = parseInt(user_id)})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDisconnect", function(user_id)
	vRP.execute("groupSystem/updateStatus", { status = "off" ,user_id = parseInt(user_id)})
end)

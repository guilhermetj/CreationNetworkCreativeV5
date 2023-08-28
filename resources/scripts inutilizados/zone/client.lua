
local zones = {
	{ ['x'] = 176.27, ['y'] = -983.4, ['z'] = 30.09 }, 
	{ ['x'] = -453.34, ['y'] = -338.65, ['z'] = 34.36 }
	-- { ['x'] = -204.87, ['y'] = -1319.96, ['z'] = 30.9 }, 
	-- { ['x'] = -1261.54, ['y'] = -359.88, ['z'] = 36.9  } 
}

local notifIn = false
local notifOut = false
local closestZone = 1


--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
----------------------------Criando Blips nos locais.-------------
------- Você pode comentar esta seção se não quiser nenhuma mensagem mostrando as zonas no mapa.--------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #zones, 1 do
		local szBlip = AddBlipForCoord(zones[i].x, zones[i].y, zones[i].z)
		SetBlipAsShortRange(szBlip, true)
		SetBlipColour(szBlip, 2)  --Mudar a cor do blip: https://gtaforums.com/topic/864881-all-blip-color-ids-pictured/
		SetBlipSprite(szBlip, 161) -- Mudar o próprio blip: https://marekkraus.sk/gtav/blips/list.html
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Zona Segura") -- O que ele dirá quando você passar o mouse sobre a mancha em seu mapa.
		EndTextCommandSetBlipName(szBlip)
	end
end)

--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
----------------   Obtendo sua distância de qualquer um dos locais  --------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		local playerPed = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistance = 100000
		for i = 1, #zones, 1 do
			dist = Vdist(zones[i].x, zones[i].y, zones[i].z, x, y, z)
			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end
		Citizen.Wait(15000)
	end
end)

--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
---------   Ativando e desativando fogo amigo, desativando suas armas e enviando pNoty   -----------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local dist = Vdist(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z, x, y, z)
	
		if dist <= 50.0 then  -- Aqui você pode alterar o RAIO da Zona de Segurança. Lembre-se, tudo o que você colocar aqui DOBRARÁ porque 
			if not notifIn then	-- é uma esfera. Portanto, 50 resultará em um diâmetro de 100. Presumo que sejam metros. Nenhuma pista para ser honesto.																		  
				NetworkSetFriendlyFireOption(false)
				ClearPlayerWantedLevel(PlayerId())
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)
				TriggerEvent('Notify','verde',"<b>Você está em uma SafeZone</b>",10000)
				notifIn = true
				notifOut = false
			end
		else
			if not notifOut then
				NetworkSetFriendlyFireOption(true)
				TriggerEvent('Notify','amarelo',"<b>Você NÃO ESTÁ MAIS numa SafeZone</b>",10000)
				notifOut = true
				notifIn = false
				local vehicle = GetVehiclePedIsIn(player)
				if vehicle ~= 0 then
					SetNetworkVehicleAsGhost(VehToNet(vehicle),false)
					SetEntityAlpha(vehicle,255, false)
					SetEntityNoCollisionEntity(vehicle,player,true)
				end
				SetGhostedEntityAlpha(128)
				SetLocalPlayerAsGhost(false)
				SetEntityAlpha(player,255, false)
			end
		end
		if notifIn then
			DisableControlAction(2, 37, true) -- desabilitar roda de arma (Tab)
			DisablePlayerFiring(player,true) -- Desativa o disparo todos juntos se, de alguma forma, ignorarem inzone Mouse Disable
			local vehicle = GetVehiclePedIsIn(player)
			if vehicle ~= 0 then
				SetEntityNoCollisionEntity(vehicle,player,false)
				SetNetworkVehicleAsGhost(VehToNet(vehicle),true)
				SetGhostedEntityAlpha(254)
				SetLocalPlayerAsGhost(true)
			end
      		DisableControlAction(0, 106, true) -- Desative os controles do mouse no jogo
			if IsDisabledControlJustPressed(2, 37) then --se Tab for pressionado, enviar mensagem de erro
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true) -- se a guia for pressionada, eles serão desarmados (isso é para cobrir a falha do veículo até que eu resolva tudo)
			end
			if IsDisabledControlJustPressed(0, 106) then --se o botão esquerdo for pressionado, enviar mensagem de erro
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true) -- Se eles clicarem, serão desarmados
			end
		end
		-- Comente as linhas 142 - 145 se você não quiser um marcador.
	 	--if DoesEntityExist(player) then	      --The -1.0001 will place it on the ground flush		-- SIZING CIRCLE |  x    y    z | R   G    B   alpha| *more alpha more transparent*
	 	--	DrawMarker(1, zones[closestZone].x, zones[closestZone].y, zones[closestZone].z-1.0001, 0, 0, 0, 0, 0, 0, 100.0, 100.0, 2.0, 13, 232, 255, 155, 0, 0, 2, 0, 0, 0, 0) -- heres what all these numbers are. Honestly you dont really need to mess with any other than what isnt 0.
	 		--DrawMarker(type, float posX, float posY, float posZ, float dirX, float dirY, float dirZ, float rotX, float rotY, float rotZ, float scaleX, float scaleY, float scaleZ, int red, int green, int blue, int alpha, BOOL bobUpAndDown, BOOL faceCamera, int p19(LEAVE AS 2), BOOL rotate, char* textureDict, char* textureName, BOOL drawOnEnts)
	 	--end
	end
end)
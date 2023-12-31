Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1) 
		
        for ped in EnumeratePeds() do
            if DoesEntityExist(ped) then
				for i,model in pairs(cfg.peds) do
					if (GetEntityModel(ped) == GetHashKey(model)) then
						veh = GetVehiclePedIsIn(ped, false)
						SetEntityAsNoLongerNeeded(ped)
						SetEntityCoords(ped,10000,10000,10000,1,0,0,1)
						if veh ~= nil then
							SetEntityAsNoLongerNeeded(veh)
							SetEntityCoords(veh,10000,10000,10000,9,0,0,9)
						end
					end
				end
				for i,model in pairs(cfg.noguns) do
					if (GetEntityModel(ped) == GetHashKey(model)) then
						RemoveAllPedWeapons(ped, true)
					end
				end
				for i,model in pairs(cfg.nodrops) do
					if (GetEntityModel(ped) == GetHashKey(model)) then
						SetPedDropsWeaponsWhenDead(ped,false) 
					end
				end
			end
		end
		-- WORK IN PROGESS // DOES NOT WORK
        for veh in EnumerateVehicles() do
            if DoesEntityExist(veh) then
				for i,model in pairs(cfg.vehs) do
					if (GetEntityModel(veh) == GetHashKey(model)) then
						SetEntityAsNoLongerNeeded(veh)
						SetEntityCoords(veh,10000,10000,10000,2,0,0,2)
					end
				end
			end
		end
		
    end
end)

Citizen.CreateThread(function()
    while true 
        do
         -- These natives has to be called every frame.
        SetPedDensityMultiplierThisFrame(cfg.density.peds)
        SetScenarioPedDensityMultiplierThisFrame(cfg.density.peds, cfg.density.peds)
        SetVehicleDensityMultiplierThisFrame(cfg.density.vehicles)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)
        Citizen.Wait(0)
    end
end)

local oRP = {}
Tunnel.bindInterface("RKG_Store:Desmanche", oRP)
local vSERVER = Tunnel.getInterface("RKG_Store:Desmanche")

local in_service = false
local dismantling_stage = 0
local veh_type = nil
local veh_parts = {}
local veh_parts_count = 1 
local removed_pars = {}
local removed_pars_count = 1
local take_pneu = false
local take_body = false
local time_seconds = 0

Citizen.CreateThread(function()
    while true do
        local RKG = 1000
        if not in_service then
            for k,v in pairs(Config_Desmanche) do
                local ped = PlayerPedId()
                local ped_coords = GetEntityCoords(ped)
                local distance_init = #(ped_coords - v.Locations.Init)
                if distance_init <= 5 then
                    RKG = 0
                    if IsControlJustPressed(1,38) and vSERVER.CheckPerm(k) and GetEntityHealth(ped) > 101 and IsPedInAnyVehicle(ped) then
                        -- vehicle,vehNet,vehPlate,vehList[vehModel][1],vehList[vehModel][2],vehHealth,vehClass,vehBody,vehEngine
                        local veh,vehNet,veh_plate,vehName,vehLock,vehHealth,vehClass,vehBody,vehEngine = vRP.vehList(3)
                        if not vehLock then
                            -- local check_veh_is_dismantled = vSERVER.checkVehIsDismantled(veh_plate,veh_name)
                            -- if check_veh_is_dismantled then
                                vSERVER.setVehicleDismantle({ veh = veh, veh_plate = veh_plate })
                                removed_pars = {}
                                veh_parts = {}
                                FreezeEntityPosition(veh,true)
                                SetVehicleFixed(veh)
                                SetVehicleDeformationFixed(veh)
                                in_service = true
                                dismantling_stage = 1

                                if vehClass == 8 then
                                    veh_type = "bikes"
                                  
                                    all_bones = {"wheel_lf","wheel_lr","chassis_dummy"}
                                else
                                    veh_type = "cars"
             
                                    all_bones = {"handle_dside_f","handle_pside_f","wheel_lf","wheel_rf","wheel_lr","wheel_rr","bumper_f"}
                                end

                                for k,v in pairs(all_bones) do
                                    local bone = GetEntityBoneIndexByName(veh,v)
                                    if bone ~= -1 then
                                        local bone_coords = GetWorldPositionOfEntityBone(veh,bone)
                                        
                                        if bone_coords then
                                           
                                            veh_parts[v] = bone_coords
                                            veh_parts_count = veh_parts_count + 1
                                        end
                                    end
                                end

                                TriggerEvent("Notify","verde","Iniciando desmanche.",5000)
                            -- end
                        else
                            TriggerEvent("Notify","verde","Você não pode desmanchar esse veículo.",5000)
                        end
                    end
                end
            end
        end
        Citizen.Wait(RKG)
    end
end)

Citizen.CreateThread(function()
    while true do
        local RKG = 1000
        local ped = PlayerPedId()
        local ped_coords = GetEntityCoords(ped)
        local veh = GetPlayersLastVehicle(ped)
        if in_service then
            for k,v in pairs(Config_Desmanche) do
                if dismantling_stage == 1 then
                    if not take_pneu and not take_body then
                        if removed_pars_count == veh_parts_count then
                            dismantling_stage = 2
                            TriggerEvent("Notify","verde","Desmanche concluído. Entre no carro e aperte [E]",5000)
                        end
                    end
                    local distance_init = #(ped_coords - v.Locations.Init)
                    local distance_tire = #(ped_coords - v.Locations.Tire)
                    local distance_body = #(ped_coords - v.Locations.Body)
                    if distance_init <= 15 then
                        RKG = 0
                    
                        for k2,v2 in pairs(veh_parts) do
                            
                            local x,y,z = table.unpack(v2)
                            if not removed_pars[k2] then
                                local distance_parts = Vdist(ped_coords, x,y,z)
                                if distance_parts <= 10.0 then
                                    DrawMarker(21,x,y,z + 1,0,0,0,180.0,0,0,0.4,0.4,0.4,207,158,25,150,0,0,0,1)
                                    if distance_parts <= 1.0 then
                                        -- text3D(x,y,z + 0.5,'~y~[E] ~w~PARA DESMANCHAR')
                                        if not take_pneu and not take_body then
                                            if IsControlJustPressed(0, 38) and time_seconds == 0 then
                                                time_seconds = 3
                                                removed_pars[k2] = true
                                                removed_pars_count = removed_pars_count + 1
                                                if veh_type == 'cars' then
                                                    if k2 == 'wheel_lf' then
                                                        vRP.playAnim(false,{"amb@medic@standing@tendtodead@idle_a","idle_a"},true)
                                                        SetVehicleTyreBurst(veh,0,true,1000)
                                                        Wait(5000)
                                                        ClearPedTasks(ped)
                                                        vRP.stopAnim(true)
                                                        vRP.stopAnim()
                                                        vRP.removeObjects()
                                                        vRP.createObjects("anim@heists@box_carry@","idle","prop_rub_tyre_01",50,28422,0.0,-0.1,0.218,0.0)
                                                        take_pneu = true
                                                    elseif k2 == 'wheel_rf' then
                                                        vRP.playAnim(false,{"amb@medic@standing@tendtodead@idle_a","idle_a"},true)
                                                        SetVehicleTyreBurst(veh,1,true,1000)
                                                        Wait(5000)
                                                        ClearPedTasks(ped)
                                                        vRP.stopAnim(true)
                                                        vRP.stopAnim()
                                                        vRP.removeObjects()
                                                        vRP.createObjects("anim@heists@box_carry@","idle","prop_rub_tyre_01",50,28422,0.0,-0.1,0.218,0.0)
                                                        take_pneu = true
                                                    elseif k2 == 'wheel_lr' then
                                                        vRP.playAnim(false,{"amb@medic@standing@tendtodead@idle_a","idle_a"},true)
                                                        SetVehicleTyreBurst(veh,4,true,1000)
                                                        Wait(5000)
                                                        ClearPedTasks(ped)
                                                        vRP.stopAnim(true)
                                                        vRP.stopAnim()
                                                        vRP.removeObjects()
                                                        vRP.createObjects("anim@heists@box_carry@","idle","prop_rub_tyre_01",50,28422,0.0,-0.1,0.218,0.0)
                                                        take_pneu = true
                                                    elseif k2 == 'wheel_rr' then
                                                        vRP.playAnim(false,{"amb@medic@standing@tendtodead@idle_a","idle_a"},true)
                                                        SetVehicleTyreBurst(veh,5,true,1000)
                                                        Wait(5000)
                                                        ClearPedTasks(ped)
                                                        vRP.stopAnim(true)
                                                        vRP.stopAnim()
                                                        vRP.removeObjects()
                                                        vRP.createObjects("anim@heists@box_carry@","idle","prop_rub_tyre_01",50,28422,0.0,-0.1,0.218,0.0)
                                                        take_pneu = true
                                                    elseif k2 == 'handle_dside_f' then
                                                        vRP._playAnim(false,{task='WORLD_HUMAN_WELDING'},true)
                                                        SetVehicleDoorBroken(veh,0,true)
                                                        Wait(5000)
                                                        ClearPedTasks(ped)
                                                        vRP.stopAnim(true)
                                                        vRP.stopAnim()
                                                        vRP.removeObjects()
                                                        vRP.createObjects("anim@heists@box_carry@","idle","prop_car_door_01",50,28422,0.0,-0.08,-0.13,-1.0)
                                                        take_body = true
                                                    elseif k2 == 'handle_pside_f' then
                                                        SetVehicleDoorBroken(veh,1,true)
                                                        vRP._playAnim(false,{task='WORLD_HUMAN_WELDING'},true)
                                                        Wait(5000)
                                                        ClearPedTasks(ped)
                                                        vRP.stopAnim(true)
                                                        vRP.stopAnim()
                                                        vRP.removeObjects()
                                                        vRP.createObjects("anim@heists@box_carry@","idle","prop_car_door_01",50,28422,0.0,-0.08,-0.13,-1.0)
                                                        take_body = true
                                                    elseif k2 == 'bumper_f' then
                                                        vRP.playAnim(false,{"mini@repair","fixing_a_player"},true)
                                                        Wait(5000)
                                                        ClearPedTasks(ped)
                                                        vRP.stopAnim(true)
                                                        vRP.stopAnim()
                                                        vRP.removeObjects()
                                                        SetVehicleDoorBroken(veh,4,true)
                                                        vRP.createObjects("anim@heists@box_carry@","idle","prop_car_door_01",50,28422,0.0,-0.08,-0.13,-1.0)
                                                        take_body = true
                                                    end
                                                else
                                                    if k2 == 'wheel_lf' then
                                                        SetVehicleTyreBurst(veh,0,true,1000)
                                                    elseif k2 == 'wheel_lr' then
                                                        SetVehicleTyreBurst(veh,4,true,1000)
                                                    elseif k2 == 'chassis_dummy' then
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if take_pneu then
                        if distance_tire <= 15.0 then
                            RKG = 0
                            if distance_tire <= 5.0 then
                                DrawMarker(21,v.Locations.Tire,0,0,0,180.0,0,0,0.4,0.4,0.4,0,204,255,150,0,0,0,1)
                                if distance_tire <= 2.0 then
                                    if IsControlJustPressed(0,38) and time_seconds == 0 then
                                        time_seconds = 3
                                        take_pneu = false
                                        vRP.removeObjects()
                                    end
                                end
                            end
                        end
                    end
                    if take_body then
                        if distance_body <= 15.0 then
                            RKG = 0
                            if distance_body <= 5.0 then
                                DrawMarker(21,v.Locations.Body,0,0,0,180.0,0,0,0.4,0.4,0.4,0,204,255,150,0,0,0,1)
                                if distance_body <= 2.0 then
                                    if IsControlJustPressed(0,38) and time_seconds == 0 then
                                        time_seconds = 3
                                        take_body = false
                                        vRP.removeObjects()
                                    end
                                end
                            end
                        end
                    end
                elseif dismantling_stage == 2 then
                    RKG = 0
                    if IsControlJustPressed(1,38) and GetEntityHealth(ped) > 101 and IsPedInAnyVehicle(ped) and time_seconds == 0 then
                        time_seconds = 3
                        local veh,vehNet,veh_plate,vehName,vehLock,vehBlock,vehHealth,vehModel,vehClass = vRP.vehList(3)
                        vSERVER.dismantleVehicle(veh,veh_plate,vehName)
                        in_service = false
                        veh_parts = nil
                        removed_pars = nil
                    end
                end
            end
        end
        Citizen.Wait(RKG)
    end
end)

Citizen.CreateThread(function()
    while true do
        if in_service then
            if time_seconds > 0 then
                time_seconds = time_seconds - 1
            end
        end
        Citizen.Wait(1000)
    end
end)


function text3D(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end
--string "h = {1616963738,{"21085","9111148","909928","..."]:1: local isPlayingAnim, forceStop = false, false
local spawnedProps = {}
function PlayAnim(playerPed, animDict, animName, flag)
    LoadAnimDict(animDict)
    TaskPlayAnim(playerPed, animDict, animName, 2.0, 2.5, -1, flag, 0.0, false, false, false)
    RemoveAnimDict(animDict)
end
function IsDead(playerPed)
	return (GetEntityHealth(playerPed) <= 100 or IsPedRagdoll(playerPed))
end
function CanPlayAnim(playerPed)
	return (not IsDead(playerPed) and not IsPedInAnyVehicle(playerPed, true))
end
function GetPlayersInArea(playerPos)
    local playersInArea = {}
    for k,target in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(target)
        if DoesEntityExist(targetPed) then
            local targetPos = GetEntityCoords(targetPed)
            if #(playerPos - targetPos) <= 100 then
                local targetId = GetPlayerServerId(target)
                if targetId ~= -1 then
                    table.insert(playersInArea, targetId)
                end
            end
        end
    end
    return playersInArea
end
function LoadModel(modelHash)
    modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))
    if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(100)
        end
    end
end
function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(100)
        end
    end
end
function ShowNotification(g)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(g)
    DrawNotification(false, false)
end
function AttachProp(playerPed, modelHash, boneId, offsetPos, offsetRot)
    LoadModel(modelHash)
    local coords = GetEntityCoords(playerPed)
    local object = CreateObject(modelHash, coords, true, true, true)
    SetModelAsNoLongerNeeded(modelHash)
    AttachEntityToEntity(object, playerPed, GetPedBoneIndex(playerPed, boneId), offsetPos, offsetRot, true, true, false, true, 1, true)
    table.insert(spawnedProps, object)
end
function AttachDefibrillator(playerPed)
	local playerPos = GetEntityCoords(playerPed)
	local modelHash = `ajna_defibrillator_01`
	local offset_1 = {pos = vector3(0.05, 0.02, -0.055), rot = vector3(0.0, 0.0, 90.0)}
	local offset_2 = {pos = vector3(0.05, 0.02, 0.055), rot = vector3(180.0, 0.0, -90.0)}
	LoadModel(modelHash)
	local object_1 = CreateObject(modelHash, playerPos, true, true, true)
	AttachEntityToEntity(object_1, playerPed, GetPedBoneIndex(playerPed, 28422), offset_1.pos, offset_1.rot, true, true, false, true, 1, true)
	table.insert(spawnedProps, object_1)
	local object_2 = CreateObject(modelHash, playerPos, true, true, true)
	AttachEntityToEntity(object_2, playerPed, GetPedBoneIndex(playerPed, 60309), offset_2.pos, offset_2.rot, true, true, false, true, 1, true)
	table.insert(spawnedProps, object_2)
	SetModelAsNoLongerNeeded(modelHash)
end
function PlayDefibAnim(playerPed, changeFlag)
	local dict  = 'mini@cpr@char_a@cpr_str'
	local intro = 'cpr_cpr_to_kol'
	local anim  = 'cpr_kol_idle'
	local flag  = 1
	local exit  = 'cpr_success'
	if changeFlag then
		intro = nil
		flag  = 48
	end
	LoadAnimDict(dict)
	if intro then
		TaskPlayAnim(playerPed, dict, intro, 2.0, 2.5, -1, 0, 0.0, false, false, false)
		while IsEntityPlayingAnim(playerPed, dict, intro, 3) do
	        Wait(0)
	    end
	end
	if forceStop then return end
	local playerPos     = GetEntityCoords(playerPed)
	local playersInArea = GetPlayersInArea(playerPos)
	local playSound 	= (#playersInArea > 0 and true or false)
	local soundDuration	= (Config.SoundDuration or 3)*1000
	local times = 3
	while times > 0 do
		if forceStop then break end
		ClearPedSecondaryTask(playerPed)
		Wait(200)
		if playSound then
			TriggerServerEvent('ajnaems:playSound', playersInArea, playerPos)
		end
		TaskPlayAnim(playerPed, dict, anim, 2.0, 2.5, -1, flag, 0.0, false, false, false)
		times = times - 1
		local timeout = (GetGameTimer() + soundDuration)
		repeat
			Wait(250)
		until ((GetGameTimer() > timeout) or forceStop)
		Wait(1500)
	end
	if not forceStop then
		playerPed = PlayerPedId()
		TaskPlayAnim(playerPed, dict, exit, 2.0, 2.5, -1, flag, 0.0, false, false, false)
		Wait(1500)
	    StopAnim()
	end
	RemoveAnimDict(dict)
end
function Defibrillator(playerPed)
	AttachDefibrillator(playerPed)
	PlayDefibAnim(playerPed, false)
end
function Defibrillator2(playerPed)
	AttachDefibrillator(playerPed)
	PlayDefibAnim(playerPed, true)
end
function MedBox(playerPed)
	local animDict, animName = 'anim@heists@box_carry@', 'idle'
	local modelHash = `xm_prop_smug_crate_s_medical`
	local boneIndex = 28422
	local offsetPos = vector3(0.0, -0.1, -0.1)
	local offsetRot = vector3(0.0, 0.0, 0.0)
	AttachProp(playerPed, modelHash, boneIndex, offsetPos, offsetRot)
	PlayAnim(playerPed, animDict, animName, 51)
end
function MedBag(playerPed)
	local animDict, animName = 'missheistdocksprep1hold_cellphone', 'hold_cellphone'
	local modelHash = `xm_prop_x17_bag_med_01a`
	local boneIndex = 57005
	local offsetPos = vector3(0.4, -0.01, 0.06)
	local offsetRot = vector3(0.0, -105.0, 70.0)
	AttachProp(playerPed, modelHash, boneIndex, offsetPos, offsetRot)
	PlayAnim(playerPed, animDict, animName, 50)
end
function Thermometer(playerPed)
	local animDict, animName = 'cellphone@', 'cellphone_email_read_base'
	local modelHash = `ajna_thermometer_01`
	local boneIndex = 28422
	local offsetPos = vector3(0.0, -0.02, -0.06)
	local offsetRot = vector3(37.0, -20.0, 90.0)
	AttachProp(playerPed, modelHash, boneIndex, offsetPos, offsetRot)
	PlayAnim(playerPed, animDict, animName, 50)
end
function Thermometer2(playerPed)
	local animDict, animName = 'cellphone@', 'cellphone_text_read_base_cover_low'
	local modelHash = `ajna_thermometer_01`
	local boneIndex = 28422
	local offsetPos = vector3(0.0, 0.0, -0.06)
	local offsetRot = vector3(37.0, -20.0, 90.0)
	AttachProp(playerPed, modelHash, boneIndex, offsetPos, offsetRot)
	PlayAnim(playerPed, animDict, animName, 50)
end
function Scalpel(playerPed)
	local modelHash = `bkr_prop_fakeid_scalpel_03a`
	local boneIndex = 60309
	local offsetPos = vector3(0.07, 0.05, 0.0)
	local offsetRot = vector3(-15.0, 170.0, 180.0)
	AttachProp(playerPed, modelHash, boneIndex, offsetPos, offsetRot)
end
function Scalpel2(playerPed)
	local animDict, animName = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer'
	local modelHash = `bkr_prop_fakeid_scalpel_03a`
	local boneIndex = 60309
	local offsetPos = vector3(0.07, 0.05, 0.0)
	local offsetRot = vector3(-15.0, 170.0, 180.0)
	AttachProp(playerPed, modelHash, boneIndex, offsetPos, offsetRot)
	PlayAnim(playerPed, animDict, animName, 50)
end
function RemoveObjects()
	local props = {}
    for k,prop in pairs(spawnedProps) do
        if DoesEntityExist(prop) then
            table.insert(props, NetworkGetNetworkIdFromEntity(prop))
        end
    end
    if #props > 0 then
        TriggerServerEvent('ajnaems:deleteObjects', props)
    end
    spawnedProps = {}
end
function StopAnim()
	local playerPed = PlayerPedId()
	ClearPedTasks(playerPed)
	RemoveObjects()
	isPlayingAnim = false
	forceStop = true
end
ANIMS = {
	[1] = {start = Defibrillator},
	[2] = {start = Defibrillator2},
	[3] = {start = MedBox},
	[4] = {start = MedBag},
	[5] = {start = Scalpel},
	[6] = {start = Thermometer},
	[7] = {start = Thermometer2}
}
RegisterCommand(Config.CommandName, function(source, args)
	if isPlayingAnim then
		StopAnim()
		Wait(1000)
		return
	end
	local index = tonumber(args[1])
	if not index then
        ShowNotification(_s('invalid_command', Config.CommandName))
        return
    end
    local anim = ANIMS[index]
    if not anim then
        ShowNotification(_s('invalid_command_2', index))
        return 
    end
	local playerPed = PlayerPedId()
	if CanPlayAnim(playerPed) then
		isPlayingAnim = true
		forceStop = false
		SetCurrentPedWeapon(playerPed, `weapon_unarmed`, true)
		anim.start(playerPed)
	else
		ShowNotification(_s('cant_use_command'))
	end
end)
RegisterCommand('+ajnaems', function()
    if isPlayingAnim then StopAnim() end
end)
RegisterKeyMapping('+ajnaems', _s('keymapping_hint'), 'keyboard', 'f6')
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if isPlayingAnim then StopAnim() end
        RemoveObjects()
    end
end)

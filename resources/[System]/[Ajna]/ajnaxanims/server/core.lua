RegisterNetEvent('ajnafetish:sendRequest')
AddEventHandler('ajnafetish:sendRequest', function(targetId, action)
	TriggerClientEvent('ajnafetish:receiveRequest', targetId, source, action)
end)

RegisterNetEvent('ajnafetish:cancelRequest')
AddEventHandler('ajnafetish:cancelRequest', function(sourceId)
	TriggerClientEvent('ajnafetish:requestDeclined', sourceId)
end)

RegisterNetEvent('ajnafetish:acceptRequest')
AddEventHandler('ajnafetish:acceptRequest', function(sourceId)
	local targetId = source
	TriggerClientEvent('ajnafetish:requestAccepted', sourceId, targetId)
	TriggerClientEvent('ajnafetish:requestAccepted', targetId, sourceId)
end)

RegisterNetEvent('ajnafetish:syncStopAnim')
AddEventHandler('ajnafetish:syncStopAnim', function(playerId, action)
	if playerId == nil or action == nil then return end
	TriggerClientEvent('ajnafetish:stopAnim', playerId, action)
end)
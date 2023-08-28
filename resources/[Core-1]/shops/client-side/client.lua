-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("shops",cRP)
vSERVER = Tunnel.getInterface("shops")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(data)
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "hideNUI" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestShop",function(data,cb)
	local inventoryShop,inventoryUser,invPeso,invMaxpeso,shopSlots = vSERVER.requestShop(data["shop"])
	if inventoryShop then
		cb({ inventoryShop = inventoryShop, inventoryUser = inventoryUser, invPeso = invPeso, invMaxpeso = invMaxpeso, shopSlots = shopSlots })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("functionShops",function(data)
	if MumbleIsConnected() then
		vSERVER.functionShops(data["shop"],data["item"],data["amount"],data["slot"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("populateSlot",function(data)
	if MumbleIsConnected() then
		TriggerServerEvent("shops:populateSlot",data["item"],data["slot"],data["target"],data["amount"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlot",function(data)
	if MumbleIsConnected() then
		TriggerServerEvent("shops:updateSlot",data["item"],data["slot"],data["target"],data["amount"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKCHEST:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateShops(action)
	SendNUIMessage({ action = action })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local shopList = {
	{ -551.1,-191.07,38.22,"identityStore",false },
	{ -553.3,-192.34,38.22,"identityStore",false },
	{ -544.33,-185.59,52.2,"fidentityStore",false },
	{ 24.9,-1346.8,29.49,"departamentStore",true },
	{ 2556.74,381.24,108.61,"departamentStore",true },
	{ 1164.82,-323.65,69.2,"departamentStore",true },
	{ -706.15,-914.53,19.21,"departamentStore",true },
	{ -47.38,-1758.68,29.42,"departamentStore",true },
	{ 373.1,326.81,103.56,"departamentStore",true },
	{ -3242.75,1000.46,12.82,"departamentStore",true },
	{ 1728.47,6415.46,35.03,"departamentStore",true },
	{ 1960.2,3740.68,32.33,"departamentStore",true },
	{ 2677.8,3280.04,55.23,"departamentStore",true },
	{ 1697.31,4923.49,42.06,"departamentStore",true },
	{ -1819.52,793.48,138.08,"departamentStore",true },
	{ 1391.69,3605.97,34.98,"departamentStore",true },
	{ -2966.41,391.55,15.05,"departamentStore",true },
	{ -3039.54,584.79,7.9,"departamentStore",true },
	{ 1134.33,-983.11,46.4,"departamentStore",true },
	{ 1165.28,2710.77,38.15,"departamentStore",true },
	{ -1486.72,-377.55,40.15,"departamentStore",true },
	{ -1221.45,-907.92,12.32,"departamentStore",true },
	{ 161.2,6641.66,31.69,"departamentStore",true },
	{ -160.62,6320.93,31.58,"departamentStore",true },
	{ 548.7,2670.73,42.16,"departamentStore",true },
	{ -548.96,-584.26,34.68,"departamentStore",true },
	{ 1693.2,3760.13,34.69,"ammunationStore",true,false }, 
	{ -543.58,-584.47,34.68,"ammunationStore",true,false },
	{ 252.61,-50.12,69.94,"ammunationStore",true,false },
	{ 842.37,-1034.01,28.19,"ammunationStore",true,false },
	{ -330.71,6084.1,31.46,"ammunationStore",true,false },
	{ -662.28,-934.85,21.82,"ammunationStore",true,false },
	{ -1305.36,-394.36,36.7,"ammunationStore",true,false },
	{ -1118.1,2698.84,18.55,"ammunationStore",true,false },
	{ 2567.9,293.86,108.73,"ammunationStore",true,false },
	{ -3172.39,1087.88,20.84,"ammunationStore",true,false },
	{ 22.17,-1106.71,29.79,"ammunationStore",true,false },
	{ 810.18,-2157.77,29.62,"ammunationStore",true,false },
	{ -1082.25,-247.52,37.76,"premiumStore",false },
	{ 1524.77,3783.84,34.49,"fishingSell",false },
	{ -695.56,5802.12,17.32,"huntingSell",false },
	{ -679.13,5839.52,17.32,"huntingStore",false },
	{ -840.18,5399.16,34.61,"lenhadorSell",false },
	{ -172.5,6380.98,31.48,"pharmacyStore",false },
	{ 1690.07,3581.68,35.62,"pharmacyStore",false },
	{ 326.5,-1074.43,29.47,"pharmacyStore",false },
	{ 114.62,-5.3,67.82,"pharmacyStore",false },
	{ -453.61,-308.39,34.91,"pharmacyParamedic",false },
	{ 1831.1,3678.56,34.27,"pharmacyParamedic",false },
	{ -254.64,6326.95,32.82,"pharmacyParamedic",false },
	{ -528.18,-582.72,34.68,"mercadoCentral",false },
	{ 2747.81,3472.91,55.67,"mercadoCentral",false },
	{ -656.91,-857.94,25.29,"digitalDean",false }, 
	{ -428.57,-1728.35,19.78,"recyclingSell",false },
	{ 180.55,2793.45,45.65,"recyclingSell",false },
	{ -195.79,6264.95,31.49,"recyclingSell",false },
	{ -2304.4,338.81,174.6,"policeStore",false },
	{ 1862.95,3690.21,34.74,"policeStore",false },
	{ -948.0,-2040.47,9.4,"policeStore",false },
	{ -628.41,-238.36,38.05,"minerShop",false },
	{ 475.1,3555.28,33.23,"ilegalHouse",false },
	{ 112.41,3373.68,35.25,"ilegalCosmetics",false },
	{ 2013.95,4990.88,41.21,"ilegalToys",false },
	{ 203.54,-1494.23,35.82,"ilegalCriminal",false },
	{ -653.12,-1502.67,5.22,"ilegalHouse",false },
	{ 389.71,-942.61,29.42,"ilegalCosmetics",false },
	{ 154.98,-1472.47,29.35,"ilegalToys",false },
	{ 186.9,6374.75,32.33,"ilegalCriminal",false },
	{ 301.14,-195.75,61.57,"weaponsStore",false },
	{ 121.84,-3024.88,7.04,"mechanicBuy",false },
	{ 128.7,-3050.9,7.04,"mechanicBuy",false },
	{ 129.92,-3031.54,7.04,"mechanicBuy",false },
	{ 947.97,-972.36,39.5,"mechanicTools",false },
	{ 884.63,-2017.63,30.62,"mechanicTools",false },
	{ -345.28,-124.54,39.01,"mechanicTools",false },
	{ 729.47,-1064.09,22.16,"mechanicTools",false },
	{ -1141.23,-2005.29,13.18,"mechanicTools",false },
	{ -1294.29,-284.79,36.82,"mechanicTools",false },
	{ 98.06,6619.23,32.44,"mechanicTools",false },
	{ -216.4,-1318.9,30.89,"mechanicTools",false },
	{ -197.4,-1320.51,31.09,"mechanicTools",false },
	{ -199.41,-1319.81,31.09,"mechanicTools",false },
	{ -1407.48,-443.59,35.91,"mechanicTools",false },
	{ 842.56,-977.16,26.49,"mechanicTools",false },
	{ 842.55,-986.3,26.49,"mechanicTools",false },
	{ -32.14,-1039.04,28.59,"mechanicTools",false },
	{ 1179.12,2635.86,37.74,"mechanicTools",false },
	{ 1523.69,3782.48,34.51,"fishdepartamentStore",true },
	{ 563.19,2752.92,42.87,"animalStore",false },
	{ 987.46,-95.61,74.85,"mcFridge",false },
	{ 2512.3,4098.11,38.59,"mcFridge",false },
	{ 129.71,-1284.65,29.27,"mcFridge",false },
	{ -561.75,286.7,82.18,"mcFridge",false },
	{ -1653.78,-1062.18,12.15,"mcFridge",false },
	{ 756.32,-768.02,26.34,"mcFridge",false },
	{ -307.63,-164.17,40.42,"imoveisShop",false },
	{ 1655.77,4874.38,42.04,"imoveisShop",false },
	{ 75.35,-1392.97,29.37,"Clothes",false },
	{ -710.37,-152.18,37.41,"Clothes",false },
	{ -166.69,-301.55,39.73,"Clothes",false },
	{ -817.5,-1074.03,11.32,"Clothes",false },
	{ -1197.33,-778.98,17.32,"Clothes",false },
	{ -1447.84,-240.03,49.81,"Clothes",false },
	{ -0.07,6511.8,31.88,"Clothes",false },
	{ 1691.6,4818.47,42.06,"Clothes",false },
	{ 123.21,-212.34,54.56,"Clothes",false },
	{ 621.24,2753.37,42.09,"Clothes",false },
	{ 1200.68,2707.35,38.22,"Clothes",false },
	{ -3172.39,1055.31,20.86,"Clothes",false },
	{ -1096.53,2711.1,19.11,"Clothes",false },
	{ 422.7,-810.25,29.49,"Clothes",false },
	{ -1173.08,-1572.77,4.67,"weedShop",false },
	{ -1192.56,-905.93,13.99,"burgerShot",false },
	-----------mecanica praia---------------------
	{ -1615.99,-834.84,10.09,"mechanicBuy",false },
	{ -1614.21,-833.67,10.09,"mechanicBuy",false },
	{ -1622.08,-831.28,10.09,"mechanicBuy",false }

}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPINFOS
-----------------------------------------------------------------------------------------------------------------------------------------
local shopInfos = {
	["1"] = {
		{
			event = "shops:openSystem",
			label = "Abrir",
			tunnel = "shop"
		},{
			event = "crafting:ammunationStore",
			label = "Criar",
			tunnel = "shop"
		}
	},
	["2"] = {
		{
			event = "shops:openSystem",
			label = "Abrir",
			tunnel = "shop"
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INFORMATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Informations(shopName)
	if shopName == "ammunationStoreStore" then
		return shopInfos["1"]
	end

	return shopInfos["2"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTARGET
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)

	for k,v in pairs(shopList) do
		exports["target"]:AddCircleZone("Shops:"..k,vector3(v[1],v[2],v[3]),0.75,{
			name = "Shops:"..k,
			heading = 3374176
		},{
			shop = k,
			distance = 1.75,
			options = Informations(v[4])
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:openSystem",function(shopId)
	if vSERVER.requestPerm(shopList[shopId][4]) and MumbleIsConnected() then
		SetNuiFocus(true,true)
		SendNUIMessage({ action = "showNUI", name = shopList[shopId][4], type = vSERVER.getShopType(shopList[shopId][4]) })

		if shopList[shopId][5] then
			TriggerEvent("sounds:source","shop",0.5)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:COFFEEMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:coffeeMachine",function()
	if MumbleIsConnected() then
		SendNUIMessage({ action = "showNUI", name = "coffeeMachine", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:SODAMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:sodaMachine",function()
	if MumbleIsConnected() then
		SendNUIMessage({ action = "showNUI", name = "sodaMachine", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:DONUTMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:donutMachine",function()
	if MumbleIsConnected() then
		SendNUIMessage({ action = "showNUI", name = "donutMachine", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:BURGERMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:burgerMachine",function()
	if MumbleIsConnected() then
		SendNUIMessage({ action = "showNUI", name = "burgerMachine", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:HOTDOGMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:hotdogMachine",function()
	if MumbleIsConnected() then
		SendNUIMessage({ action = "showNUI", name = "hotdogMachine", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:CHIHUAHUA
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Chihuahua",function()
	if MumbleIsConnected() then
		SendNUIMessage({ action = "showNUI", name = "Chihuahua", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:WATERMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:waterMachine",function()
	if MumbleIsConnected() then
		SendNUIMessage({ action = "showNUI", name = "waterMachine", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:MEDICBAG
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:medicBag",function()
	if vSERVER.requestPerm("pharmacyParamedic") and MumbleIsConnected() then
		SetNuiFocus(true,true)
		SendNUIMessage({ action = "showNUI", name = "pharmacyParamedic", type = "Buy" })
	end
end)
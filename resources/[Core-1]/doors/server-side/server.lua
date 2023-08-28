-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("doors",cRP)
vTASKBAR = Tunnel.getInterface("taskbar")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Doors"] = {
	[1] = { x = 431.38, y = -1000.68, z = 25.55, hash = 2130672747, lock = true, text = true, distance = 20, press = 5, perm = "Police" },
	[2] = { x = 452.25, y = -1000.73, z = 25.55, hash = 2130672747, lock = true, text = true, distance = 20, press = 5, perm = "Police" },
	[3] = { x = 488.90, y = -1017.19, z = 28.50, hash = -1603817716, lock = true, text = true, distance = 20, press = 5, perm = "Police" },
	[4] = { x = 476.59, y = -1007.79, z = 26.54, hash = -53345114, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[5] = { x = 482.11, y = -1004.11, z = 26.54, hash = -53345114, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[6] = { x = 476.82, y = -1012.13, z = 26.54, hash = -53345114, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[7] = { x = 479.83, y = -1012.17, z = 26.54, hash = -53345114, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[8] = { x = 482.83, y = -1012.18, z = 26.54, hash = -53345114, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[9] = { x = 485.81, y = -1012.17, z = 26.54, hash = -53345114, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[10] = { x = 485.26, y = -1007.78, z = 26.54, hash = -53345114, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[11] = { x = 441.62, y = -977.67, z = 30.95, hash = 2888281650, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[12] = { x = 441.58, y = -986.18, z = 30.95, hash = 4198287975, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[13] = { x = 479.69, y = -998.53, z = 30.95, hash = -692649124, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[14] = { x = 486.36, y = -1000.26, z = 30.95, hash = -692649124, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[15] = { x = 467.96, y = -1014.42, z = 26.5, hash = -692649124, lock = true, text = true, distance = 10, press = 2, perm = "Police", other = 16 },
	[16] = { x = 469.06, y = -1014.41, z = 26.5, hash = -692649124, lock = true, text = true, distance = 10, press = 2, perm = "Police", other = 15 },
	[17] = { x = 441.27, y = -998.75, z = 30.95, hash = -1547307588, lock = true, text = true, distance = 10, press = 2, perm = "Police", other = 18 },
	[18] = { x = 442.43, y = -998.78, z = 30.95, hash = -1547307588, lock = true, text = true, distance = 10, press = 2, perm = "Police", other = 17 },
	[19] = { x = 457.59, y = -972.28, z = 30.95, hash = -1547307588, lock = true, text = true, distance = 10, press = 2, perm = "Police", other = 20 },
	[20] = { x = 456.43, y = -972.27, z = 30.95, hash = -1547307588, lock = true, text = true, distance = 10, press = 2, perm = "Police", other = 19 },
	[21] = { x = 1846.049, y = 2604.733, z = 45.579, hash = 741314661, lock = true, text = true, distance = 30, press = 10, perm = "Emergency" },
	[22] = { x = 1819.475, y = 2604.743, z = 45.577, hash = 741314661, lock = true, text = true, distance = 30, press = 10, perm = "Emergency" },
	[23] = { x = 1836.71, y = 2590.32, z = 46.20, hash = 539686410, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[24] = { x = 1769.52, y = 2498.92, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[25] = { x = 1766.34, y = 2497.09, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[26] = { x = 1763.20, y = 2495.26, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[27] = { x = 1756.89, y = 2491.66, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[28] = { x = 1753.75, y = 2489.85, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[29] = { x = 1750.61, y = 2488.02, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[30] = { x = 1757.14, y = 2474.87, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[31] = { x = 1760.26, y = 2476.71, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[32] = { x = 1763.44, y = 2478.50, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[33] = { x = 1766.54, y = 2480.33, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[34] = { x = 1769.73, y = 2482.13, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[35] = { x = 1772.83, y = 2483.97, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[36] = { x = 1776.00, y = 2485.77, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[37] = { x = 383.45, y = 799.41, z = 187.65, hash = 517369125, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[38] = { x = 382.76, y = 796.84, z = 187.65, hash = 517369125, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[39] = { x = 379.26, y = 796.84, z = 187.65, hash = 517369125, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[40] = { x = 398.14, y = -1607.53, z = 29.50, hash = 1286535678, lock = true, text = true, distance = 20, press = 5, perm = "Police" },

	[41] = { x = -444.45, y = 6007.71, z = 27.75, hash = -594854737, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[42] = { x = -442.98, y = 6011.80, z = 27.75, hash = -594854737, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[43] = { x = -445.12, y = 6012.14, z = 27.75, hash = -594854737, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[44] = { x = -448.08, y = 6015.12, z = 27.75, hash = -594854737, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[45] = { x = -445.60, y = 6017.56, z = 27.75, hash = -594854737, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[46] = { x = -442.63, y = 6014.60, z = 27.75, hash = -594854737, lock = true, text = true, distance = 10, press = 2, perm = "Police" },

	[51] = { x = 370.17, y = -1606.45, z = 30.25, hash = -674638964, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[52] = { x = 367.29, y = -1604.14, z = 30.25, hash = -674638964, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[53] = { x = 374.00, y = -1597.64, z = 25.75, hash = -674638964, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[54] = { x = 376.83, y = -1599.97, z = 25.75, hash = -674638964, lock = true, text = true, distance = 10, press = 2, perm = "Police" },

	[61] = { x = 1849.02, y = 3693.30, z = 34.37, hash = -1491332605, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[62] = { x = 1851.94, y = 3694.98, z = 34.37, hash = -1491332605, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[63] = { x = 1856.33, y = 3696.54, z = 34.37, hash = -1491332605, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[64] = { x = 1853.76, y = 3699.85, z = 34.37, hash = -2002725619, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
	[65] = { x = 1847.24, y = 3688.46, z = 34.37, hash = -2002725619, lock = true, text = true, distance = 10, press = 2, perm = "Police" },

	---[66] = { x = -205.88, y = -1310.58, z =31.29, hash = -427498890, lock = true, text = true, distance = 20, press = 5, perm = "Mechanic" },---bennys
	[67] = { x = -1604.46, y = -832.54, z =10.26, hash = -58667380, lock = true, text = true, distance = 10, press = 2, perm = "Mechanic" },---mecanica praia
	[68] = { x = -1610.05, y = -837.04, z =10.09, hash = 528027285, lock = true, text = true, distance = 10, press = 2, perm = "Mechanic" },---mecanica praia
	[69] = { x = -1608.87, y = -835.63, z =10.09, hash = 528027285, lock = true, text = true, distance = 10, press = 2, perm = "Mechanic" },---mecanica praia
	[71] = { x = 308.03, y = -597.30, z = 43.39, hash = 854291622, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic" },
	[72] = { x = 308.20, y = -570.00, z = 43.39, hash = 854291622, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic" },
	[73] = { x = 337.25, y = -580.58, z = 43.39, hash = 854291622, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic" },
	[74] = { x = 341.87, y = -582.25, z = 43.39, hash = 854291622, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic" },
	[75] = { x = 347.87, y = -584.44, z = 43.39, hash = 854291622, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic" },
	[76] = { x = 340.13, y = -587.07, z = 43.39, hash = 854291622, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic" },
	[77] = { x = 361.60, y = -589.44, z = 43.39, hash = 854291622, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic" },
	[78] = { x = 359.86, y = -594.25, z = 43.39, hash = 854291622, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic" },
	[79] = { x = 351.75, y = -595.23, z = 43.39, hash = 854291622, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic" },
	[80] = { x = 350.39, y = -598.99, z = 43.39, hash = 854291622, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic" },
	[81] = { x = 345.96, y = -596.25, z = 43.39, hash = 854291622, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic" },
	[82] = { x = 347.32, y = -592.49, z = 43.39, hash = 854291622, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic" },
	[83] = { x = 355.68, y = -584.45, z = 43.39, hash = 854291622, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic" },
	[84] = { x = 357.04, y = -580.70, z = 43.39, hash = 854291622, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic" },
	[85] = { x = 304.40, y = -571.45, z = 43.39, hash = 854291622, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic" },
	[86] = { x = 303.60, y = -581.75, z = 43.39, hash = -434783486, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic", other = 87 },
	[87] = { x = 304.39, y = -582.05, z = 43.39, hash = -1700911976, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic", other = 86 },
	[88] = { x = 325.03, y = -589.55, z = 43.39, hash = -434783486, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic", other = 89 },
	[89] = { x = 325.81, y = -589.84, z = 43.39, hash = -1700911976, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic", other = 88 },
	[90] = { x = 312.80, y = -571.67, z = 43.39, hash = -434783486, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic", other = 91 },
	[91] = { x = 313.58, y = -571.95, z = 43.39, hash = -1700911976, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic", other = 90 },
	[92] = { x = 318.64, y = -574.08, z = 43.39, hash = -434783486, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic", other = 93 },
	[93] = { x = 319.44, y = -575.76, z = 43.39, hash = -1700911976, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic", other = 92 },
	[94] = { x = 324.04, y = -575.76, z = 43.39, hash = -434783486, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic", other = 95 },
	[95] = { x = 324.83, y = -576.04, z = 43.39, hash = -1700911976, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic", other = 94 },
	[96] = { x = 1057.67, y = 981.37, z = 245.16, hash = -1697796712, lock = true, text = true, distance = 10, press = 2, perm = "Favela02" },---favela02
	[97] = { x = 1059.34, y = 981.46, z = 245.16, hash = -1697796712, lock = true, text = true, distance = 10, press = 2, perm = "Favela02" },---favela02
	[98] = { x = -149.18, y = 2129.44, z = 166.14, hash = 161378502, lock = true, text = true, distance = 10, press = 2, perm = "Favela03" },---favela03
	[99] = { x = -153.12, y = 2122.55, z = 166.14, hash = 161378502, lock = true, text = true, distance = 10, press = 2, perm = "Favela03" },---favela03
	[100] = { x = -145.37, y = 2128.42, z = 170.13, hash = -1572101598, lock = true, text = true, distance = 10, press = 2, perm = "Favela03" },---favela03
	[102] = { x = -2558.2, y = 2955.28, z = 40.27, hash = 1042741067, lock = true, text = true, distance = 10, press = 2, perm = "Favela04" },---favela04
	[103] = { x = -2549.61, y = 2956.0, z = 43.54, hash = 1042741067, lock = true, text = true, distance = 10, press = 2, perm = "Favela04" },---favela04
	[104] = { x = 407.23, y = -17.65, z = 91.93, hash = -973354389, lock = true, text = true, distance = 10, press = 2, perm = "Mafia" },---Mafia
	[105] = { x = 390.69, y = -0.17, z = 91.93, hash = 607720026, lock = true, text = true, distance = 10, press = 2, perm = "Mafia" },---Mafia
	[106] = { x = 391.71, y = 1.57, z = 91.93, hash = 607720026, lock = true, text = true, distance = 10, press = 2, perm = "Mafia" },---Mafia
	[107] = { x = 353.9, y = 18.91, z = 84.81, hash = -1140189596, lock = true, text = true, distance = 20, press = 5, perm = "Mafia" },---Mafia
	[108] = { x = -1864.53, y = 2060.88, z = 140.97, hash = 988364535, lock = true, text = true, distance = 1, press = 1, perm = "Vinhedo" },---Vinhedo
	[109] = { x = -1864.5, y = 2060.19, z = 140.97, hash = -1141522158, lock = true, text = true, distance = 1, press = 1, perm = "Vinhedo" },---Vinhedo
	[115] = { x = -1828.47, y = 4525.56, z = 5.29, hash = 11733050, lock = true, text = true, distance = 10, press = 4, perm = "Bunker" },---Bunker
	[116] = { x = -1841.52, y = 4543.69, z = 6.34, hash = 1252997920, lock = true, text = true, distance = 20, press = 6, perm = "Bunker" },---Bunker
	[117] = { x = -1844.71, y = 4542.03, z = 6.34, hash = 1252997920, lock = true, text = true, distance = 10, press = 9, perm = "Bunker" },---Bunker
	[118] = { x = -205.88, y = -1310.58, z =31.29, hash = -427498890, lock = true, text = true, distance = 20, press = 11, perm = "Bennys" },---bennys
	[119] = { x = -203.39, y = -1335.01, z =34.9, hash = -1320876379, lock = true, text = true, distance = 10, press = 2, perm = "Bennys" },---bennys
	[120] = { x = 1274.66, y = -1720.94, z =54.68, hash = 1145337974, lock = true, text = true, distance = 10, press = 7, perm = "Lester" },---lester
	[121] = { x = -1199.96, y = -903.7, z =13.8, hash = -1300743830, lock = true, text = true, distance = 10, press = 7, perm = "Burgershot" },---burguershot
	[122] = { x = -1178.29, y = -892.1, z =13.78, hash = -1300743830, lock = true, text = true, distance = 10, press = 7, perm = "Burgershot" },---burguershot
	[123] = { x = -1183.17, y = -885.05, z =13.93, hash = 1934064671, lock = true, text = true, distance = 5, press = 2, perm = "Burgershot" },---burguershot
	[124] = { x = -1184.09, y = -883.63, z =13.92, hash = -186646702, lock = true, text = true, distance = 5, press = 2, perm = "Burgershot" },---burguershot
	[125] = { x = -1197.41, y = -883.54, z =13.87, hash = 1934064671, lock = true, text = true, distance = 5, press = 2, perm = "Burgershot" },---burguershot
	[126] = { x = -1198.73, y = -884.36, z =13.83, hash = -186646702, lock = true, text = true, distance = 5, press = 2, perm = "Burgershot" },---burguershot
	[127] = { x = -1371.53, y = -607.92, z =30.72, hash = 401003935, lock = true, text = true, distance = 5, press = 2, perm = "Bahamas" },

	[128] = { x = -2282.51, y = 347.21, z = 174.6, hash = -2023754432, lock = true, text = true, distance = 5, press = 2, perm = "Video" },
	
	[101] = { x = -1646.20, y = -1069.72, z = 13.85, hash = 855881614, lock = true, text = true, distance = 10, press = 2, perm = "Arcade" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORSSTATISTICS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.doorsStatistics(doorNumber,doorStatus)
	local Doors = GlobalState["Doors"]

	Doors[doorNumber]["lock"] = doorStatus

	if Doors[doorNumber]["other"] ~= nil then
		local doorSecond = Doors[doorNumber]["other"]
		Doors[doorSecond]["lock"] = doorStatus
	end

	GlobalState["Doors"] = Doors
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORSPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.doorsPermission(doorNumber)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if GlobalState["Doors"][doorNumber]["perm"] ~= nil then
			if vRP.hasGroup(user_id,GlobalState["Doors"][doorNumber]["perm"]) then
				return true
			else
				local consultItem = vRP.getInventoryItemAmount(user_id,"lockpick2")
				if consultItem[1] >= 1 then
					if math.random(100) >= 50 then
						vRP.removeInventoryItem(user_id,consultItem[2],1,true)
						vRP.generateItem(user_id,"brokenpick",1,false)
					end

					local taskResult = vTASKBAR.taskDoors(source)
					if taskResult then
						return true
					end
				end
			end
		end
	end

	return false
end
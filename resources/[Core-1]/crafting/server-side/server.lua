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
Tunnel.bindInterface("crafting",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFTLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local craftList = {
	["PlayboyPeças"] = {
		["perm"] = "Playboy", 
		["list"] = {
			["smgbody"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["sheetmetal"] = 6
				}
			},
			["pistolbody"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["sheetmetal"] = 3
				}
			},
			["riflebody"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["sheetmetal"] = 10
				}
			},
			["sheetmetal"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 10
				}
			},
		}
	},
	["BunkerPeças"] = {
		["perm"] = "Mafia",
		["list"] = {
			["smgbody"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["sheetmetal"] = 6
				}
			},
			["pistolbody"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["sheetmetal"] = 3
				}
			},
			["riflebody"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["sheetmetal"] =  10
				}
			},
			["sheetmetal"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["sheetmetal"] = 10
				}
			},
		}
	},
	["Bunker"] = {
		["perm"] = "Bunker",
		["list"] = {
			["WEAPON_PISTOL_AMMO"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["nails"] = 1,
					["aluminum"] = 1,
					["copper"] = 1
				}
			},
			["WEAPON_SMG_AMMO"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["nails"] = 2,
					["aluminum"] = 2,
					["copper"] = 2
				}
			},
			["WEAPON_RIFLE_AMMO"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["nails"] = 2,
					["aluminum"] = 2,
					["copper"] = 2
				}

			},
		}
	},
	["salierisShop"] = {
		["perm"] = "Salieris",
		["list"] = {
			["nails"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["badge01"] = 1
				}
			}
		}
	},
	["Favela01"] = {
		["perm"] = "Favela01",
		["list"] = {
			["methtable"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 15,
					["pliers"] = 1,
				}
			},
			["meth"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["acetone"] = 2
				}
			},
		}
	},
	["Favela02"] = {
		["perm"] = "Favela02",
		["list"] = {
			["coketable"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 15,
					["pliers"] = 1,
				}
			},
			["cocaine"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["cokeleaf"] = 2
				}
			},
		}
	},
	["Favela03"] = {
		["perm"] = "Favela03",
		["list"] = {
			["weedtable"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 15,
					["pliers"] = 1,
				}
			},
			["joint"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["weedleaf"] = 2
				}
			},
		}
	},
	["Favela04"] = {
		["perm"] = "Favela04",
		["list"] = {
			["weedtable"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 15,
					["pliers"] = 1,
				}
			},
			["lean"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["codeine"] = 2
				}
			},
		}
	},
	["playboyShop"] = {
		["perm"] = "Playboy",
		["list"] = {
			["WEAPON_PISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["pistolbody"] = 1,
					["aluminum"] = 45,
					["copper"] = 45,
					["plastic"] = 30,
					["glass"] = 30,
					["rubber"] = 30,
					["nails"] = 1
				}
			},
			["WEAPON_MACHINEPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["smgbody"] = 1,
					["aluminum"] = 75,
					["copper"] = 75,
					["plastic"] = 35,
					["glass"] = 35,
					["rubber"] = 35,
					["nails"] = 1
				}
			},
			["WEAPON_MICROSMG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["smgbody"] = 1,
					["aluminum"] = 125,
					["copper"] = 125,
					["plastic"] = 75,
					["glass"] = 75,
					["rubber"] = 75,
					["nails"] = 1
				}
			},
			["WEAPON_GUSENBERG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 125,
					["copper"] = 125,
					["plastic"] = 100,
					["glass"] = 100,
					["rubber"] = 100,
					["nails"] = 1
				}
			},
			["WEAPON_APPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["pistolbody"] = 1,
					["aluminum"] = 45,
					["copper"] = 45,
					["plastic"] = 30,
					["glass"] = 30,
					["rubber"] = 30,
					["nails"] = 1
				}
			},
			["WEAPON_SNSPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["pistolbody"] = 1,
					["aluminum"] = 35,
					["copper"] = 35,
					["plastic"] = 15,
					["glass"] = 15,
					["rubber"] = 10,
					["nails"] = 1
				}
			},
			["WEAPON_MINISMG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["smgbody"] = 1,
					["aluminum"] = 125,
					["copper"] = 125,
					["plastic"] = 80,
					["glass"] = 80,
					["rubber"] = 75,
					["nails"] = 1
				}
			},
			["WEAPON_PISTOL_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["pistolbody"] = 1,
					["aluminum"] = 45,
					["copper"] = 45,
					["plastic"] = 25,
					["glass"] = 25,
					["rubber"] = 25,
					["nails"] = 1
				}
			},
			["WEAPON_SNSPISTOL_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["pistolbody"] = 1,
					["aluminum"] = 45,
					["copper"] = 45,
					["plastic"] = 25,
					["glass"] = 25,
					["rubber"] = 25,
					["nails"] = 1
				}
			},
			["WEAPON_VINTAGEPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["pistolbody"] = 1,
					["aluminum"] = 45,
					["copper"] = 25,
					["plastic"] = 15,
					["glass"] = 15,
					["rubber"] = 15,
					["nails"] = 1
				}
			},
			["WEAPON_COMPACTRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 125,
					["copper"] = 125,
					["plastic"] = 75,
					["glass"] = 75,
					["rubber"] = 75,
					["nails"] = 1
				}
			},
			["WEAPON_ADVANCEDRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 225,
					["copper"] = 225,
					["plastic"] = 175,
					["glass"] = 125,
					["rubber"] = 125,
					["nails"] = 1
				}
			},
			["WEAPON_BULLPUPRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 225,
					["copper"] = 225,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["nails"] = 1
				}
			},
			["WEAPON_BULLPUPRIFLE_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 225,
					["copper"] = 225,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["nails"] = 1
				}
			},
			["WEAPON_SPECIALCARBINE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 225,
					["copper"] = 225,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["nails"] = 1
				}
			},
			["WEAPON_SPECIALCARBINE_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 225,
					["copper"] = 225,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["nails"] = 1
				}
			},
			["WEAPON_SMG_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["smgbody"] = 1,
					["aluminum"] = 150,
					["copper"] = 150,
					["plastic"] = 100,
					["glass"] = 75,
					["rubber"] = 75,
					["nails"] = 1
				}
			},
			["WEAPON_ASSAULTRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 225,
					["copper"] = 225,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["nails"] = 1
				}
			},
			["WEAPON_ASSAULTRIFLE_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 225,
					["copper"] = 225,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["nails"] = 1
				}
			},
			["WEAPON_ASSAULTSMG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["smgbody"] = 1,
					["aluminum"] = 150,
					["copper"] = 150,
					["plastic"] = 100,
					["glass"] = 75,
					["rubber"] = 75,
					["nails"] = 1
				}
			}
		}
	},
	["AutosportShop"] = {
		["perm"] = "Autosport",
		["list"] = {
			["plate"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 6,
					["copper"] = 6
				}
			},
			["lockpick"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["rubber"] = 5,
					["aluminum"] = 10
				}
			},
			["pliers"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 3,
					["rubber"] = 2,
					["aluminum"] = 5
				}
			},
			["credential"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 4,
					["techtrash"] = 1
				}
			},
			["nitro"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 6,
					["aluminum"] = 13
				}
			},
			["notebook"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 10,
					["aluminum"] = 25,
					["plastic"] = 15
				}
			}
		}
	},
	["CustombrasilShop"] = {
		["perm"] = "Custombrasil",
		["list"] = {
			["plate"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 6,
					["copper"] = 6
				}
			},
			["lockpick"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["rubber"] = 5,
					["aluminum"] = 10
				}
			},
			["pliers"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 3,
					["rubber"] = 2,
					["aluminum"] = 5
				}
			},
			["credential"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 4,
					["techtrash"] = 1
				}
			},
			["nitro"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 6,
					["aluminum"] = 13
				}
			},
			["notebook"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 10,
					["aluminum"] = 25,
					["plastic"] = 15
				}
			}
		}
	},
	["legalShop"] = {
		["list"] = {
			["keyboard"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 3,
					["plastic"] = 4,
					["rubber"] = 2
				}
			},
			["mouse"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 3, 
					["plastic"] = 4,
					["rubber"] = 2
				}
			},
			["playstation"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 2,
					["copper"] = 2,
					["plastic"] = 3,
					["glass"] = 3
				}
			},
			["xbox"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 2,
					["copper"] = 2,
					["plastic"] = 3,
					["glass"] = 3
				}
			},
			["brick"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["rubber"] = 2,
					["plastic"] = 1,
					["glass"] = 1
				}
			},
			["pan"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 2,
					["copper"] = 2,
					["rubber"] = 2,
					["plastic"] = 3,
					["glass"] = 3
				}
			},
			["fan"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 3,
					["rubber"] = 2,
					["plastic"] = 4
				}
			},
			["blender"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 3,
					["rubber"] = 2,
					["plastic"] = 4
				}
			},
			["switch"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 1,
					["plastic"] = 3
				}
			},
			["cup"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 2,
					["copper"] = 2,
					["rubber"] = 2,
					["plastic"] = 3,
					["glass"] = 3
				}
			},
			["lampshade"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 2,
					["copper"] = 2,
					["rubber"] = 2,
					["plastic"] = 2,
					["glass"] = 2
				}
			},
			["silverring"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["silvercoin"] = 4,
					["copper"] = 2,
					["glass"] = 3
				}
			},
			["goldring"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["goldcoin"] = 4,
					["copper"] = 2,
					["rubber"] = 2,
					["plastic"] = 3,
					["glass"] = 3
				}
			},
			["watch"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["goldcoin"] = 4,
					["copper"] = 2,
					["rubber"] = 2,
					["plastic"] = 3,
					["glass"] = 3
				}
			},
			["bracelet"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["goldcoin"] = 4,
					["copper"] = 2,
					["rubber"] = 2,
					["plastic"] = 3,
					["glass"] = 3
				}
			},
			["dildo"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 3,
					["rubber"] = 2,
					["plastic"] = 4
				}
			},
			["spray01"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 3,
					["rubber"] = 2,
					["plastic"] = 4
				}
			},
			["spray02"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 3,
					["rubber"] = 2,
					["plastic"] = 4
				}
			},
			["spray03"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 3,
					["rubber"] = 2,
					["plastic"] = 4
				}
			},
			["spray04"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 3,
					["rubber"] = 2,
					["plastic"] = 4
				}
			},
			["sneakers"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["rubber"] = 6
				}
			},
			["slipper"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["rubber"] = 6
				}
			},
			["rimel"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 3,
					["rubber"] = 2,
					["plastic"] = 4
				}
			},
			["brush"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 3,
					["rubber"] = 2,
					["plastic"] = 4
				}
			},
			["soap"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 3,
					["rubber"] = 2,
					["plastic"] = 3
				}
			},
			["eraser"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 3,
					["rubber"] = 2,
					["plastic"] = 4
				}
			},
			["legos"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 1,
					["rubber"] = 2,
					["plastic"] = 8
				}
			},
			["ominitrix"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 1,
					["rubber"] = 2,
					["plastic"] = 8
				}
			},
			["dices"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 1,
					["plastic"] = 4
				}
			},
			["domino"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 1,
					["plastic"] = 5
				}
			},
			["horseshoe"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 3,
					["rubber"] = 2,
					["plastic"] = 4
				}
			},
			["deck"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 3,
					["rubber"] = 2,
					["plastic"] = 3
				}
			},
			["pliers"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 3,
					["rubber"] = 2,
					["plastic"] = 3
				}
			}
		}
	},
	["craftHeroine"] = {
		["list"] = {
			["heroine"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["amphetamine"] = 1,
					["syringe"] = 1,
					["codeine"] = 1
				}
			}
		}
	},
	["Vinhedo"] = {
		["perm"] = "Vinhedo",
		["list"] = {
			["dollars"] = {
				["amount"] = 25000,
				["destroy"] = false,
				["require"] = {
					["elastic"] = 25,
					["dollars2"] = 25000
				}
			}
		}
	},
	["Bahamas"] = {
		["perm"] = "Bahamas",
		["list"] = {
			["dollars"] = {
				["amount"] = 25000,
				["destroy"] = false,
				["require"] = {
					["elastic"] = 25,
					["dollars2"] = 25000
				}
			}
		}
	},
	["Desserts"] = {
		["perm"] = "Desserts",
		["list"] = {
			["nigirizushi"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["fishfillet"] = 1,
					["wheat"] = 4
				}
			},
			["sushi"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["fishfillet"] = 1,
					["wheat"] = 6,
					["seaweed"] = 1
				}
			},
			["cupcake"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["chocolate"] = 1,
					["wheat"] = 10,
					["milkbottle"] = 1
				}
			},
			["applelove"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["apple"] = 1,
					["sugar"] = 5,
					["water"] = 1
				}
			},
			["milkshake"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["chocolate"] = 2,
					["milkbottle"] = 2
				}
			},
			["cappuccino"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["chocolate"] = 2,
					["milkbottle"] = 2,
					["coffee2"] = 5
				}
			}
		}
	},
	["pizzaThis"] = {
		["list"] = {
			["pizza"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["cheese"] = 1,
					["wheat"] = 10,
					["ketchup"] = 1
				}
			},
			["pizza2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["cheese"] = 1,
					["wheat"] = 8,
					["mushroom"] = 6
				}
			}
		}
	},
	["burgerShot"] = {
		["perm"] = "Burgershot",
		["list"] = {
			["hamburger"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["bread"] = 1,
					["ketchup"] = 1
				}
			},
			["hamburger2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["bread"] = 1,
					["foodburger"] = 1,
					["ketchup"] = 1
				}
			},
			["grapejuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["grape"] = 1,
					["sugar"] = 1,
					["foodjuice"] = 1
				}
			},
			["orangejuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["orange"] = 1,
					["sugar"] = 1,
					["foodjuice"] = 1
				}
			}
		}
	},
	["popsDiner"] = {
		["list"] = {
			["orangejuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["orange"] = 9
				}
			},
			["tangejuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["tange"] = 9
				}
			},
			["grapejuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["grape"] = 9
				}
			},
			["strawberryjuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["strawberry"] = 9
				}
			},
			["bananajuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["banana"] = 9
				}
			},
			["passionjuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["passion"] = 9
				}
			},
			["mushroomtea"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["mushroom"] = 30,
					["water"] = 1
				}
			}
		}
	},
	["craftShop"] = {
		["list"] = {
			["ketchup"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["emptybottle"] = 1,
					["tomato"] = 6
				}
			},
			["bandage"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plaster"] = 1,
					["cotton"] = 1,
					["alcohol"] = 1
				}
			},
			["gauze"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["saline"] = 1,
					["cotton"] = 1
				}
			},
			["bucket"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 5,
					["aluminum"] = 2
				}
			},
			["campfire"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["alcohol"] = 1,
					["lighter"] = 1,
					["woodlog"] = 10
				}
			},
			["seaweed"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["wheat"] = 3
				}
			},
			["dollars"] = {
				["amount"] = 4750,
				["destroy"] = false,
				["require"] = {
					["cryptocoins"] = 21600
				}
			}
		}
	},
	["theLostShop"] = {
		["perm"] = "TheLost",
		["list"] = {
			["coketable"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["woodlog"] = 10,
					["glass"] = 25,
					["rubber"] = 15,
					["aluminum"] = 10,
					["sheetmetal"] = 2,
					["tarp"] = 1,
					["explosives"] = 3
				}
			},
			["methtable"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["woodlog"] = 10,
					["glass"] = 25,
					["rubber"] = 15,
					["aluminum"] = 10,
					["sheetmetal"] = 2,
					["tarp"] = 1,
					["explosives"] = 3
				}
			},
			["weedtable"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["woodlog"] = 10,
					["glass"] = 25,
					["rubber"] = 15,
					["aluminum"] = 10,
					["sheetmetal"] = 2,
					["tarp"] = 1,
					["explosives"] = 3
				}
			},
			["WEAPON_PISTOL_AMMO"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 1
				}
			},
			["WEAPON_SMG_AMMO"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 1
				}
			},
			["WEAPON_RIFLE_AMMO"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 1
				}
			},
			["WEAPON_SHOTGUN_AMMO"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 1
				}
			}
		}
	},
	["BloodsShop"] = {
		["perm"] = "Bloods",
		["list"] = {
			["vest"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["tarp"] = 1,
					["roadsigns"] = 4,
					["leather"] = 12,
					["sheetmetal"] = 5
				}
			},
			["handcuff"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["roadsigns"] = 5,
					["sheetmetal"] = 30
				}
			},
			["hood"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["leather"] = 50,
					["tarp"] = 15
				}
			},
			["blocksignal"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["sheetmetal"] = 8,
					["plastic"] = 55
				}
			},
			["lockpick"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 5,
					["rubber"] = 5,
					["aluminum"] = 10,
					["glass"] = 4
				}
			},
			["lockpick2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 5,
					["rubber"] = 5,
					["copper"] = 10,
					["glass"] = 4
				}
			},
			["oxy"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["wheat"] = 3,
					["water"] = 1,
				}
			}
		}
	},
	["VagosShop"] = {
		["perm"] = "Vagos",
		["list"] = {
			["vest"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["tarp"] = 1,
					["roadsigns"] = 4,
					["leather"] = 12,
					["sheetmetal"] = 5
				}
			},
			["handcuff"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["roadsigns"] = 5,
					["sheetmetal"] = 30
				}
			},
			["hood"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["leather"] = 50,
					["tarp"] = 15
				}
			},
			["blocksignal"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["sheetmetal"] = 8,
					["plastic"] = 55
				}
			},
			["lockpick"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 5,
					["rubber"] = 5,
					["aluminum"] = 10,
					["glass"] = 4
				}
			},
			["lockpick2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 5,
					["rubber"] = 5,
					["copper"] = 10,
					["glass"] = 4
				}
			},
			["oxy"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["wheat"] = 3,
					["water"] = 1,
				}
			}
		}
	},
	["Favela05"] = {
		["perm"] = "Favela05",
		["list"] = {
			["vest"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["tarp"] = 1,
					["roadsigns"] = 4,
					["leather"] = 12,
					["sheetmetal"] = 5
				}
			},
			["handcuff"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["roadsigns"] = 5,
					["sheetmetal"] = 30
				}
			},
			["hood"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["leather"] = 50,
					["tarp"] = 15
				}
			},
			["blocksignal"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["sheetmetal"] = 8,
					["plastic"] = 55
				}
			},
			["lockpick"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 5,
					["rubber"] = 5,
					["aluminum"] = 10,
					["glass"] = 4
				}
			},
			["lockpick2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 5,
					["rubber"] = 5,
					["copper"] = 10,
					["glass"] = 4
				}
			},
			["oxy"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["wheat"] = 3,
					["water"] = 1,
				}
			}
		}
	},
	["AutosportShop"] = {
		["perm"] = "Autosport",
		["list"] = {
			["plate"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 6,
					["copper"] = 6
				}
			},
			["lockpick"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["rubber"] = 5,
					["aluminum"] = 10
				}
			},
			["pliers"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 3,
					["rubber"] = 2,
					["aluminum"] = 5
				}
			},
			["credential"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 4,
					["techtrash"] = 1
				}
			},
			["nitro"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 6,
					["aluminum"] = 13
				}
			},
			["notebook"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 10,
					["aluminum"] = 25,
					["plastic"] = 15
				}
			}
		}
	},
	["CustombrasilShop"] = {
		["perm"] = "Custombrasil",
		["list"] = {
			["plate"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 6,
					["copper"] = 6
				}
			},
			["lockpick"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["rubber"] = 5,
					["aluminum"] = 10
				}
			},
			["pliers"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 3,
					["rubber"] = 2,
					["aluminum"] = 5
				}
			},
			["credential"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 4,
					["techtrash"] = 1
				}
			},
			["nitro"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 6,
					["aluminum"] = 13
				}
			},
			["notebook"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 10,
					["aluminum"] = 25,
					["plastic"] = 15
				}
			}
		}
	},
	["gardenShop"] = {
		["perm"] = "Garden",
		["list"] = {
			["coketable"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["woodlog"] = 10,
					["glass"] = 25,
					["rubber"] = 15,
					["aluminum"] = 10,
					["sheetmetal"] = 2,
					["tarp"] = 1,
					["explosives"] = 3
				}
			},
			["methtable"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["woodlog"] = 10,
					["glass"] = 25,
					["rubber"] = 15,
					["aluminum"] = 10,
					["sheetmetal"] = 2,
					["tarp"] = 1,
					["explosives"] = 3
				}
			},
			["weedtable"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["woodlog"] = 10,
					["glass"] = 25,
					["rubber"] = 15,
					["aluminum"] = 10,
					["sheetmetal"] = 2,
					["tarp"] = 1,
					["explosives"] = 3
				}
			},
			["WEAPON_PISTOL_AMMO"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 1
				}
			},
			["WEAPON_SMG_AMMO"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 1
				}
			},
			["WEAPON_RIFLE_AMMO"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 1
				}
			},
			["WEAPON_SHOTGUN_AMMO"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["copper"] = 1
				}
			}
		}
	},
	["MafiaShop"] = {
		["perm"] = "Mafia",
		["list"] = {
			["WEAPON_PISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["pistolbody"] = 1,
					["aluminum"] = 30,
					["copper"] = 10
				}
			},
			["WEAPON_MACHINEPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["smgbody"] = 1,
					["aluminum"] = 45,
					["copper"] = 20
				}
			},
			["WEAPON_MICROSMG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["smgbody"] = 1,
					["aluminum"] = 60,
					["copper"] = 25
				}
			},
			["WEAPON_GUSENBERG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 65,
					["copper"] = 30
				}
			},
			["WEAPON_APPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["pistolbody"] = 1,
					["aluminum"] = 40,
					["copper"] = 15
				}
			},
			["WEAPON_SNSPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["pistolbody"] = 1,
					["aluminum"] = 35,
					["copper"] = 15
				}
			},
			["WEAPON_MINISMG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["smgbody"] = 1,
					["aluminum"] = 50,
					["copper"] = 25
				}
			},
			["WEAPON_PISTOL_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["pistolbody"] = 1,
					["aluminum"] = 40,
					["copper"] = 20
				}
			},
			["WEAPON_SNSPISTOL_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["pistolbody"] = 1,
					["aluminum"] = 45,
					["copper"] = 20
				}
			},
			["WEAPON_VINTAGEPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["pistolbody"] = 1,
					["aluminum"] = 45,
					["copper"] = 20
				}
			},
			["WEAPON_COMPACTRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 75,
					["copper"] = 35
				}
			},
			["WEAPON_ADVANCEDRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 80,
					["copper"] = 40
				}
			},
			["WEAPON_BULLPUPRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 85,
					["copper"] = 40
				}
			},
			["WEAPON_BULLPUPRIFLE_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 90,
					["copper"] = 40
				}
			},
			["WEAPON_SPECIALCARBINE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 85,
					["copper"] = 40
				}
			},
			["WEAPON_SPECIALCARBINE_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 90,
					["copper"] = 40
				}
			},
			["WEAPON_SMG_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["smgbody"] = 1,
					["aluminum"] = 75,
					["copper"] = 35
				}
			},
			["WEAPON_ASSAULTRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 80,
					["copper"] = 40
				}
			},
			["WEAPON_ASSAULTRIFLE_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["riflebody"] = 1,
					["aluminum"] = 85,
					["copper"] = 40
				}
			},
			["WEAPON_ASSAULTSMG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["smgbody"] = 1,
					["aluminum"] = 75,
					["copper"] = 40
				}
			}
		}
	},
	["lixeiroShop"] = {
		["list"] = {
			["glass"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["glassbottle"] = 1
				}
			},
			["plastic"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["plasticbottle"] = 1
				}
			},
			["rubber"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["elastic"] = 1
				}
			},
			["aluminum"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["metalcan"] = 1
				}
			},
			["copper"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["battery"] = 1
				}
			}
		}
	},
	["fuelShop"] = {
		["list"] = {
			["WEAPON_PETROLCAN"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["dollars"] = 50
				}
			},
			["WEAPON_PETROLCAN_AMMO"] = {
				["amount"] = 4500,
				["destroy"] = false,
				["require"] = {
					["dollars"] = 200
				}
			}
		}
	},
	["Lester"] = {
		-- ["perm"] = "Lester",
		["list"] = {
			["vest"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["tarp"] = 10,
					["aluminum"] = 7
				}
			},
			["floppy"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 3,
					["plastic"] = 5,
					["tarp"] = 2
				}
			},
			["attachsFlashlight"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 10,
					["tarp"] = 2,
					["plastic"] = 3
				}
			},
			["card01"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 6,
					["plastic"] = 3
				}
			},
			["card01"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 6,
					["plastic"] = 3
				}
			},
			["card02"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 7,
					["plastic"] = 4
				}
			},
			["card03"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 8,
					["plastic"] = 4
				}
			},
			["card04"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 9,
					["plastic"] = 5
				}
			},
			["card05"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 10,
					["plastic"] = 5
				}
			},
			["attachsCrosshair"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 10,
					["tarp"] = 2,
					["aluminum"] = 3
				}
			},
			["attachsSilencer"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 10,
					["tarp"] = 2,
					["aluminum"] = 3
				}
			},
			["attachsMagazine"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 10,
					["tarp"] = 2,
					["aluminum"] = 3
				}
			},
			["attachsGrip"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["techtrash"] = 10,
					["tarp"] = 2,
					["aluminum"] = 3
				}
			}
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestPerm(craftType)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getFines(user_id) > 0 then
			TriggerClientEvent("Notify",source,"vermelho","Multas pendentes encontradas.",3000)
			return false
		end

		if exports["hud"]:Wanted(user_id) then
			return false
		end

		if craftList[craftType]["perm"] ~= nil then
			if not vRP.hasGroup(user_id,craftList[craftType]["perm"]) then
				return false
			end
		end

		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestCrafting(craftType)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inventoryShop = {}
		for k,v in pairs(craftList[craftType]["list"]) do
			local craftList = {}
			for k,v in pairs(v["require"]) do
				table.insert(craftList,{ name = itemName(k), amount = v })
			end

			table.insert(inventoryShop,{ name = itemName(k), index = itemIndex(k), key = k, peso = itemWeight(k), list = craftList, amount = parseInt(v["amount"]), desc = itemDescription(k) })
		end

		local inventoryUser = {}
		local inventory = vRP.userInventory(user_id)
		for k,v in pairs(inventory) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local splitName = splitString(v["item"],"-")
			if splitName[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - splitName[2])
					v["days"] = itemDurability(v["item"])
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			inventoryUser[k] = v
		end

		return inventoryShop,inventoryUser,vRP.inventoryWeight(user_id),vRP.getWeight(user_id)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONCRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.functionCrafting(shopItem,shopType,shopAmount,slot)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if shopAmount == nil then shopAmount = 1 end
		if shopAmount <= 0 then shopAmount = 1 end

		if craftList[shopType]["list"][shopItem] then
			if vRP.checkMaxItens(user_id,shopItem,craftList[shopType]["list"][shopItem]["amount"] * shopAmount) then
				TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
				TriggerClientEvent("crafting:Update",source,"requestCrafting")
				return
			end

			if (vRP.inventoryWeight(user_id) + (itemWeight(shopItem) * parseInt(shopAmount))) <= vRP.getWeight(user_id) then
				if shopItem == "nails" then
					local Inventory = vRP.userInventory(user_id)
					if Inventory then
						for k,v in pairs(Inventory) do
							if string.sub(v["item"],1,5) == "badge" then
								vRP.removeInventoryItem(user_id,v["item"],1,false)
								vRP.generateItem(user_id,shopItem,craftList[shopType]["list"][shopItem]["amount"] * shopAmount,false,slot)
								break
							end
						end
					end
				else
					for k,v in pairs(craftList[shopType]["list"][shopItem]["require"]) do
						local consultItem = vRP.getInventoryItemAmount(user_id,k)
						if consultItem[1] < parseInt(v * shopAmount) then
							return
						end

						if vRP.checkBroken(consultItem[2]) then
							TriggerClientEvent("Notify",source,"vermelho","Item quebrado.",5000)
							return
						end
					end

					for k,v in pairs(craftList[shopType]["list"][shopItem]["require"]) do
						local consultItem = vRP.getInventoryItemAmount(user_id,k)
						vRP.removeInventoryItem(user_id,consultItem[2],parseInt(v * shopAmount))
					end

					vRP.generateItem(user_id,shopItem,craftList[shopType]["list"][shopItem]["amount"] * shopAmount,false,slot)
				end
			end
		end

		TriggerClientEvent("crafting:Update",source,"requestCrafting")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONDESTROY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.functionDestroy(shopItem,shopType,shopAmount,slot)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if shopAmount == nil then shopAmount = 1 end
		if shopAmount <= 0 then shopAmount = 1 end
		local splitName = splitString(shopItem,"-")

		if craftList[shopType]["list"][splitName[1]] then
			if craftList[shopType]["list"][splitName[1]]["destroy"] then
				if vRP.checkBroken(shopItem) then
					TriggerClientEvent("Notify",source,"vermelho","Itens quebrados reciclados.",5000)
					TriggerClientEvent("crafting:Update",source,"requestCrafting")
					return
				end

				if vRP.tryGetInventoryItem(user_id,shopItem,craftList[shopType]["list"][splitName[1]]["amount"]) then
					for k,v in pairs(craftList[shopType]["list"][splitName[1]]["require"]) do
						if parseInt(v) <= 1 then
							vRP.generateItem(user_id,k,1)
						else
							vRP.generateItem(user_id,k,v / 2)
						end
					end
				end
			end
		end

		TriggerClientEvent("crafting:Update",source,"requestCrafting")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("crafting:populateSlot")
AddEventHandler("crafting:populateSlot",function(nameItem,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		if vRP.tryGetInventoryItem(user_id,nameItem,amount,false,slot) then
			vRP.giveInventoryItem(user_id,nameItem,amount,false,target)
			TriggerClientEvent("crafting:Update",source,"requestCrafting")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("crafting:updateSlot")
AddEventHandler("crafting:updateSlot",function(nameItem,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		local inventory = vRP.userInventory(user_id)
		if inventory[tostring(slot)] and inventory[tostring(target)] and inventory[tostring(slot)]["item"] == inventory[tostring(target)]["item"] then
			if vRP.tryGetInventoryItem(user_id,nameItem,amount,false,slot) then
				vRP.giveInventoryItem(user_id,nameItem,amount,false,target)
			end
		else
			vRP.swapSlot(user_id,slot,target)
		end

		TriggerClientEvent("crafting:Update",source,"requestCrafting")
	end
end)
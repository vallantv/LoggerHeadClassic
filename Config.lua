local ADDON_NAME, addon = ...
local module = addon:NewModule("Config")

local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

local ADDON_TITLE = "LoggerHeadLite Classic"

local CLASSIC_INSTANCE_INFO =  {
	[249] = "Onyxia's Lair",
    [409] = "Molten Core",
    [469] = "Blackwing Lair",
    [509] = "Ruins of Ahn'Qiraj",
    [531] = "Ahn'Qiraj Temple",
	[533] = "Naxxramas",
	[309] = "Zul'Gurub",
}
local BCC_INSTANCE_INFO = {
	[532] = "Karazhan",
	[565] = "Gruul's Lair",
	[544] = "Magtheridon's Lair",
	[564] = "Black Temple",
	[534] = "Hyjal Summit",
	[548] = "Serpentshrine Cavern",
	[550] = "Tempest Keep",
	[580] = "Sunwell Plateau",
}

local function GetOptions()
	local db = addon.db.profile
	local options = {
		name = ADDON_TITLE,
		type = "group",
		get = function(info) return db[info[#info]] end,
		set = function(info, value) db[info[#info]] = value end,
		args = {
			desc = {
				type = "description",
				name = L["Automatically turns on the combat log for selected raids."].."\n",
				fontSize = "medium",
				order = 0,
			}
		},
		
	}
	local getFunc = function(info) return db.zones[tonumber(info[#info]) ] end
	local setFunc = function(info, value) db.zones[ tonumber(info[#info]) ] = value; addon:CheckInstance() end
	
	options.args['Classic'] = { name = "Classic Raids", type = "group", order = 1, args = {} }
	for mapID,name in pairs(CLASSIC_INSTANCE_INFO) do		
		options.args['Classic'].args[tostring(mapID)] = { type = "toggle", name = name, get = getFunc, set = setFunc } 	
	end

	options.args['BCC'] = { name = "Burning Crusade Raids", type = "group", order = 2, args = {} }
	for mapID,name in pairs(BCC_INSTANCE_INFO) do		
		options.args['BCC'].args[tostring(mapID)] = { type = "toggle", name = name, get = getFunc, set = setFunc } 	
	end


	return options
end

function module:OnInitialize()
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("LoggerHeadLite", GetOptions)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LoggerHeadLite", ADDON_TITLE)

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("LoggerHeadLite/Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(addon.db))
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LoggerHeadLite/Profiles", L["Profiles"], ADDON_TITLE)
end

function addon:OpenOptions()
	InterfaceOptionsFrame_OpenToCategory(ADDON_TITLE)
	InterfaceOptionsFrame_OpenToCategory(ADDON_TITLE)
end

SLASH_LOGGERHEAD1 = "/loggerhead"
SLASH_LOGGERHEAD2 = "/lh"
SlashCmdList["LOGGERHEAD"] = addon.OpenOptions

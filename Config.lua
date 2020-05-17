local ADDON_NAME, addon = ...
local module = addon:NewModule("Config")

local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

local ADDON_TITLE = "LoggerHeadLite Classic"

local INSTANCE_INFO =  {
	[249] = "Onyxia's Lair",
    [409] = "Molten Core",
    [469] = "Blackwing Lair",
    [509] = "Ruins of Ahn'Qiraj",
    [531] = "Ahn'Qiraj Temple",
	[533] = "Naxxramas",
	[309] = "Zul'Gurub"
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
	options.args['Classic'] = {
		name = "Classic Raids",
		type = "group",

		args = {}
	}
	local options_count = 0;

	for mapID,name in pairs(INSTANCE_INFO) do		
		options_count = options_count + 1;
		options.args['Classic'].args[tostring(mapID)] = {
			type = "toggle",
			name = name,
			order = options_count,
			get = function(info) return db.zones[mapID] end,
			set = function(info, value)
				db.zones[mapID] = value
				addon:CheckInstance()
			end	
		} 	

		
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

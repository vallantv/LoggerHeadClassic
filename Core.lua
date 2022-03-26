local ADDON_NAME, addon = ...
LibStub("AceAddon-3.0"):NewAddon(addon, ADDON_NAME, "AceEvent-3.0", "AceTimer-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

local defaults = {
	profile = {
		prompt = true,
		zones = {
			--Classic
			[249] = true, --Onyxia's Lair
			[409] = true, --Molten Core
			[469] = true, --Blackwing Lair
			[509] = true, --Ruins of Ahn'Qiraj
			[531] = true, --Ahn'Qiraj Temple
			[533] = true, --Naxxramas
			[309] = true, --Zul'Gurub
			--BC
			[532] = true, --Karazhan
			[565] = true, --Gruul's Lair
			[544] = true, --Magtheridon's Lair
			[564] = true, --Black Temple
			[534] = true, --Hyjal Summit
			[548] = true, --Serpentshrine Cavern
			[550] = true, --Tempest Keep
			[580] = true, --Sunwell Plateau
			[568] = true --Zul'Aman
		}
	}
}

local function print(msg)
	local info = ChatTypeInfo["SYSTEM"]
	DEFAULT_CHAT_FRAME:AddMessage(msg, info.r, info.g, info.b, info.id)
end

function addon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("LoggerHeadNDB", defaults, true)
	-- local db = self.db.profile
	-- if db.zones == nil then
	-- 	defaults.profile.zones;
	-- end
end

local function delayedCheck()
	addon:ScheduleTimer("CheckInstance", 2)
end

function addon:OnEnable()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", delayedCheck)
	self:CheckInstance()
end

function addon:CheckInstance(_, override)
	local zoneName, instanceType, difficultyID, _, _, _, _, areaID = GetInstanceInfo()
	local db = self.db.profile

	if instanceType == "raid" then -- raid or challenge mode
		if override ~= nil then -- called from the prompt
			db.zones[areaID] = override
		end

		if db.zones[areaID] then
			self:EnableLogging(true)
			return
		end
	end
	if instanceType == "party" and difficultyID == 174 then
		if override ~= nil then -- called from the prompt
			db.zones[areaID] = override
		end

		if db.zones[areaID] then
			self:EnableLogging(true)
			return
		end
	end
	self:DisableLogging(true)
end

function addon:EnableLogging(auto)
	if not LoggingCombat() then
		LoggingCombat(true)
		print(COMBATLOGENABLED)
	end
end

function addon:DisableLogging(auto)
	if LoggingCombat() then
		LoggingCombat(false)
		print(COMBATLOGDISABLED)
	end
end

function addon:ToggleLogging()
	if LoggingCombat() then
		self:DisableLogging()
	else
		self:EnableLogging()
	end
end

SLASH_LOGTOGGLE1 = "/log"
SlashCmdList["LOGTOGGLE"] = function()
	addon:ToggleLogging()
end

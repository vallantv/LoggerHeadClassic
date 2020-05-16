local ADDON_NAME, addon = ...
LibStub("AceAddon-3.0"):NewAddon(addon, ADDON_NAME, "AceEvent-3.0", "AceTimer-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

local defaults = {
	profile = {
		prompt = true,
		zones = {
			[249] = true,
			[409] = true,
			[469] = true,
			[509] = true,
			[531] = true,
			[533] = true,
			[309] = true
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
	local zoneName, instanceType, _, _, _, _, _, areaID = GetInstanceInfo()
	local db = self.db.profile;
	
	if instanceType == "raid" then -- raid or challenge mode
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
SlashCmdList["LOGTOGGLE"] = function() addon:ToggleLogging() end

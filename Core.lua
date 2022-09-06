--luacheck: globals LibStub L ChatTypeInfo DEFAULT_CHAT_FRAME GetInstanceInfo LoggingCombat C_Timer
--luacheck: globals COMBATLOGENABLED COMBATLOGDISABLED SLASH_LOGTOGGLE1 SlashCmdList
--luacheck: no max line length

local ADDON_NAME, addon = ...
LibStub("AceAddon-3.0"):NewAddon(addon, ADDON_NAME, "AceEvent-3.0", "AceTimer-3.0")

local defaults = {
	profile = {
		prompt = true,
		zones = {
			["*"] = true --Default is always enabled
		}
	}
}

local function print(msg)
	local info = ChatTypeInfo["SYSTEM"]
	DEFAULT_CHAT_FRAME:AddMessage(msg, info.r, info.g, info.b, info.id)
end

function addon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("LoggerHeadNDB", defaults, true)
end

local function delayedCheck()
	C_Timer.After(2, addon.CheckInstance)
end

function addon:OnEnable()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", delayedCheck)
	delayedCheck()
end

function addon.CheckInstance(_, override)
	local _, instanceType, difficultyID, _, _, _, _, areaID = GetInstanceInfo()
	local db = addon.db.profile

	if instanceType == "raid" then -- raid or challenge mode
		if override ~= nil then -- called from the prompt
			db.zones[areaID] = override
		end

		if db.zones[areaID] then
			addon.EnableLogging()
			return
		end
	end
	if instanceType == "party" and difficultyID == 2 then
		if override ~= nil then -- called from the prompt
			db.zones[areaID] = override
		end

		if db.zones[areaID] then
			addon.EnableLogging()
			return
		end
	end
	addon.DisableLogging()
end

function addon.EnableLogging()
	if not LoggingCombat() then
		LoggingCombat(true)
		print(COMBATLOGENABLED)
	end
end

function addon.DisableLogging()
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

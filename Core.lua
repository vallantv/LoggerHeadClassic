local ADDON_NAME, addon = ...
LibStub("AceAddon-3.0"):NewAddon(addon, ADDON_NAME, "AceEvent-3.0", "AceTimer-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

local defaults = {
	profile = {
		prompt = true,
		zones = {
			--Classic - Raids
			[249] = true, --Onyxia's Lair
			[409] = true, --Molten Core
			[469] = true, --Blackwing Lair
			[509] = true, --Ruins of Ahn'Qiraj
			[531] = true, --Ahn'Qiraj Temple
			[533] = true, --Naxxramas
			[309] = true, --Zul'Gurub
			--BC - Raids
			[532] = true, --Karazhan
			[565] = true, --Gruul's Lair
			[544] = true, --Magtheridon's Lair
			[564] = true, --Black Temple
			[534] = true, --Hyjal Summit
			[548] = true, --Serpentshrine Cavern
			[550] = true, --Tempest Keep
			[580] = true, --Sunwell Plateau
			--BC - Heroics - Disabled By Default
			[558] = false, --Auchenai Crypts
			[543] = false, --Hellfire Ramparts
			[585] = false, --Magisters' Terrace
			[557] = false, --Mana-Tombs
			[560] = false, --Old Hillsbrad Foothills
			[556] = false, --Sethekk Halls
			[555] = false, --Shadow Labyrinth
			[552] = false, --The Arcatraz
			[269] = false, --The Black Morass
			[542] = false, --The Blood Furnace
			[553] = false, --The Botanica
			[554] = false, --The Mechanar
			[540] = false, --The Shattered Halls
			[547] = false, --The Slave Pens
			[545] = false, --The Steamvault
			[546] = false --The Underbog
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

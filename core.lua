
	--[[

		PlateBuffer
			Nameplate auras for Wow TBC 2.4.3
			https://github.com/nullfoxh
		
			Core

	]]--


	local debug = false

	local DR_RESET_TIME = 18

	local texCoord = { .1, .9, .2, .8 } -- for squares use { .07, .93, .07, .93 }
	local font = "Interface\\AddOns\\PlateBuffer\\homespun.ttf"

	---------------------------------------------------------------------------------------------

	local ceil, floor, upper, format = math.ceil, math.floor, string.upper, string.format

	local pairs, select, unpack, strsub, strsplit, tonumber, bit_band, table_sort, table_insert
		= pairs, select, unpack, strsub, strsplit, tonumber, bit.band, table.sort, table.insert

	local UnitGUID, UnitBuff, UnitDebuff, UnitExists, UnitCanAttack, UnitName, UnitIsPlayer
		= UnitGUID, UnitBuff, UnitDebuff, UnitExists, UnitCanAttack, UnitName, UnitIsPlayer

	local tostring, GetTime, GetSpellInfo, DebuffTypeColor, IsInInstance, UnitIsPlayer, UnitLevel
		= tostring, GetTime, GetSpellInfo, DebuffTypeColor, IsInInstance, UnitIsPlayer, UnitLevel

	local print = function(s) DEFAULT_CHAT_FRAME:AddMessage("|cffa0f6aaPlateBuffer|r: "..s) end
	print("Loaded. Get updates from https://github.com/nullfoxh/PlateBuffer")

	---------------------------------------------------------------------------------------------

	local PB = CreateFrame("Frame")
	local newChildren, numChildren = 0, 0
	local hasTarget, targetPlate = false, nil
	local updateTarget, updateMouseOver = false, false
	local visiblePlates, knownPlates, knownPlayers = {}, {}, {}
	local uiScale = 0.7111
	local playerGUID, targetGUID, focusGUID, mouseGUID = UnitGUID("player")

	local DRLib = LibStub("DRData-1.0")
	local DRCache, AuraCache, conf = {}, {}
	local SpellData = PBAD

	local WATCHER_UPDATE_INTERVAL = 0.1
	local Watcher = CreateFrame("Frame")
	local WatchedFrames = {}
	local WatcherActive = false
	local WatcherThrottle = 0

	---------------------------------------------------------------------------------------------

	-- WATCHER FRAME

	---------------------------------------------------------------------------------------------

	local function WatcherUpdate(self, elapsed)
		WatcherThrottle = WatcherThrottle - elapsed

		if WatcherThrottle < 0 then
			WatcherThrottle = WATCHER_UPDATE_INTERVAL

			local time = GetTime()
			local framecount = 0

			for frame, expiration in pairs(WatchedFrames) do
				if expiration < time then
					frame:Hide()
					WatchedFrames[frame] = nil
				else
					framecount = framecount + 1
				end
			end

			if framecount == 0 then 
				Watcher:SetScript("OnUpdate", nil)
				WatcherActive = false 
			end
		end
	end

	local function PolledHideIn(frame, expiration)
		if expiration == 0 then
			frame:Hide()
			WatchedFrames[frame] = nil
		else
			WatchedFrames[frame] = expiration
			frame:Show()

			if not WatcherActive then
				Watcher:SetScript("OnUpdate", WatcherUpdate)
				WatcherActive = true
			end
		end
	end

	---------------------------------------------------------------------------------------------

	-- CREATE AURA FRAMES

	---------------------------------------------------------------------------------------------

	local function FormatTime(s)
		if s > 3600 then
			return format("%dh", ceil(s/3600)), s % 3600
		elseif s > 60 then
			return format("%dm", ceil(s/60)), s % 60
		elseif s > 6 then
			return floor(s), s - floor(s)
		elseif s > 3 then
			return format("|cffffff00%.1f|r", s), (s*10 - floor(s*10)) / 10
		elseif s > 1 then
			return format("|cffff0000%.1f|r", s), (s*10 - floor(s*10)) / 10
		else
			return format("|cffff0000.%d|r", s*10), (s*10 - floor(s*10)) / 10
		end
	end

	local function UpdateTimer(self, elapsed)
		if self.nextUpdate > 0 then
			self.nextUpdate = self.nextUpdate - elapsed
		else
			local remain = self.expiration - GetTime()
			if remain > 0 then
				local time, nextUpdate = FormatTime(remain)
				self.timer:SetText(time)
				self.nextUpdate = nextUpdate
			else
				self.timer:Hide()
				self:SetScript("OnUpdate", nil)
			end
		end
	end

	local function CreateAura(plate, i, aura, row)
		if not plate.debuffs then plate.debuffs = {} end

		local width, height = conf.auraWidth, conf.auraHeight
		local perRow, spacing = conf.aurasPerRow, conf.auraSpacing*uiScale

		local f = CreateFrame("Frame", nil, plate)
		f:SetFrameStrata("BACKGROUND")

		f.bg = f:CreateTexture(nil, "BACKGROUND")
		f.bg:SetPoint("TOPLEFT", f, -uiScale, uiScale)
		f.bg:SetPoint("BOTTOMRIGHT", f, uiScale, -uiScale)
		f.bg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
		f.bg:SetVertexColor(0, 0, 0)

		f:SetWidth(width)
		f:SetHeight(height)

		f.icon = f:CreateTexture(nil, "ARTWORK")
		f.icon:SetAllPoints(f)

		if not conf.disableCooldown then
			f.cd = CreateFrame("Cooldown", nil, f, "PlateBufferCD")
			f.cd:SetAllPoints(f)
		else
			f.cd = CreateFrame("Frame", nil, f)
			f.cd:SetAllPoints(f)
		end

		f.count = f.cd:CreateFontString(nil, "OVERLAY")
		f.count:SetFont(font,  conf.fontSize * uiScale, "OUTLINE")
		f.count:SetShadowColor(0, 0, 0)
		f.count:SetShadowOffset(1, -1)
		f.count:SetPoint("BOTTOMRIGHT", f.cd, "BOTTOMRIGHT", 1, 2)
		f.count:SetJustifyH("RIGHT")

		if not conf.disableDuration then
			f.cd.noCooldownCount = true -- disable OmniCC
			f.timer = f.cd:CreateFontString(nil, "OVERLAY")
			f.timer:SetFont(font,  conf.fontSize * uiScale, "OUTLINE")
			f.timer:SetShadowColor(0, 0, 0)
			f.timer:SetShadowOffset(1, -1)
			f.timer:SetPoint("CENTER", f.cd, "CENTER", conf.fontOffx, conf.fontOffy)
			f.timer:SetJustifyH("CENTER")
		end

		if i == 1 then
			f:SetPoint("BOTTOMLEFT", plate, "TOP", conf.auraOffx-((width+spacing)*perRow-spacing)/2, conf.auraOffy)
		elseif row > 1 then
			f:SetPoint("BOTTOM", plate.debuffs[i-perRow], "TOP", 0, spacing)
		else
			f:SetPoint("LEFT", plate.debuffs[aura-1], "RIGHT", spacing, 0)
		end

		plate.debuffs[i] = f
		return f
	end

	---------------------------------------------------------------------------------------------

	-- HANDLE PLATE AURAS

	---------------------------------------------------------------------------------------------

	function PB:UpdatePlate(guid, name)
		local plate = knownPlates[guid]

		if plate then 
			PB:UpdatePlateAuras(plate, guid)
		elseif name then
			plate = PB:GetPlateByName(name)
			if plate then
				PB:OnPlateIdentified(plate, guid, true)
			end
		end
	end

	function PB:UpdatePlateAuras(plate, guid)
		local plate = knownPlates[guid]
		local auras = PB:GetUnitAuras(guid)

		if not plate or not auras then
			return
		end

		local i = 1
		for row = 1, conf.auraRows do
			for a = 1, conf.aurasPerRow do
				local aura = auras[i]

				if aura then
					local button	
					if plate.debuffs and plate.debuffs[i] then
						button = plate.debuffs[i]
					else
						button = CreateAura(plate, i, a, row)
					end

					button.icon:SetTexture(aura.icon)
					button.icon:SetTexCoord(unpack(texCoord))
					button.count:SetText(aura.count > 1 and aura.count)

					if aura.type ~= "BUFF" then
						local color = DebuffTypeColor[aura.type]
						button.bg:SetVertexColor(color.r, color.g, color.b)
					else
						button.bg:SetVertexColor(0, 0, 0)
					end

					if aura.duration and aura.duration > 0 then
						if not conf.disableCooldown then
							button.cd:SetCooldown(aura.startTime, aura.duration)
							button.cd:SetReverse()
						end

						if not conf.disableDuration then
							button.timer:Show()
							button.expiration = aura.expiration
							button.nextUpdate = 0
							button:SetScript("OnUpdate", UpdateTimer)
						end
					end

					PolledHideIn(button, aura.expiration)

				elseif plate.debuffs and plate.debuffs[i] then
					PolledHideIn(plate.debuffs[i], 0)
				end

				i = i + 1
			end
		end
	end

	---------------------------------------------------------------------------------------------

	-- HANDLE UNIT AURAS

	---------------------------------------------------------------------------------------------

	local function AuraSort(a, b)
		if a and b then
			if a.isMine and not b.isMine then
				return true
			elseif b.isMine and not a.isMine then
				return false
			end

			return a.expiration < b.expiration
		end
	end

	function PB:GetUnitAuras(guid)
		if AuraCache[guid] then 
			local auras = {}
			local time = GetTime()

			for k, v in pairs(AuraCache[guid]) do
				local aura = {}
				aura.name, aura.spellID, aura.icon, aura.count, aura.type, aura.duration, aura.timeLeft, aura.startTime, aura.expiration, aura.isMine = PB:GetAuraInstance(guid, k)

				if time < aura.expiration then
					if aura.duration > 0 then
						table_insert(auras, aura)
					end
				else
					PB:RemoveAuraInstance(guid, k)
				end
			end
			table_sort(auras, AuraSort)
			return auras
		end
		return nil
	end
	
	function PB:SetAuraInstance(guid, spellName, spellID, icon, count, dtype, duration, timeLeft, isMine)
		if not AuraCache[guid] then AuraCache[guid] = {} end
		local time = GetTime()
		AuraCache[guid][spellName] = { spellName, spellID, icon, count or 0, dtype or "none", duration, timeLeft, time-(duration-timeLeft), time+timeLeft, isMine}
	end

	-- AuraInstance: spellName, spellID, icon, count, type, duration, timeLeft, startTime, expiration, isMine
	function PB:GetAuraInstance(guid, spellName)
		if AuraCache[guid] and AuraCache[guid][spellName] then
			return unpack(AuraCache[guid][spellName])
		end
	end

	function PB:RemoveAuraInstance(guid, spellName)
		if AuraCache[guid] and AuraCache[guid][spellName] then
			AuraCache[guid][spellName] = nil
			return true
		end
		return false
	end

	function PB:WipeAuraCache(guid)
		if AuraCache[guid] then
			AuraCache[guid] = nil
		end
	end

	---------------------------------------------------------------------------------------------

	-- HANDLE SPELLDATA

	---------------------------------------------------------------------------------------------

	function PB:GetSpellData(spellID, isPlayer)
		if SpellData.auraInfo[spellID] then
			local duration, debuffType = strsplit(";", SpellData.auraInfo[spellID])
			debuffType = SpellData.debuffTypes[tonumber(debuffType)]

			if isPlayer and SpellData.auraInfoPvP[spellID] then
				return SpellData.auraInfoPvP[spellID], debuffType
			else
				return tonumber(duration), debuffType
			end
		end
	end

	function PB:IsTracked(name, isMine)
		if not conf.auraList[name] then
			return false
		elseif conf.auraList[name] == "mine" and not isMine then
			return false
		elseif conf.auraList[name] == "mine" and isMine then	
			return true
		elseif conf.auraList[name] == "all" then
			return true
		end
		return false
	end		

	---------------------------------------------------------------------------------------------

	-- HANDLE DR DATA

	---------------------------------------------------------------------------------------------

	function PB:InitDR(guid, spellID, isPlayer)
		local cat = DRLib:GetSpellCategory(spellID)

		if cat then
			if not isPlayer and not DRLib:IsPVE(cat) then
				return 1
			end

			if not DRCache[guid] then
				DRCache[guid] = {}
			end

			if not DRCache[guid][cat] then
				DRCache[guid][cat] = { reset = 0, diminished = 1.0 }
			end

			if DRCache[guid][cat].reset <= GetTime() then
				DRCache[guid][cat].diminished = 1.0
			end

			return DRCache[guid][cat].diminished
		end
		return 1
	end

	function PB:ApplyDR(guid, spellID, isPlayer)
		local cat = DRLib:GetSpellCategory(spellID)

		if cat then
			if not isPlayer and not DRLib:IsPVE(cat) then
				return
			end

			if not DRCache[guid] then
				DRCache[guid] = {}
			end

			if not DRCache[guid][cat] then
				DRCache[guid][cat] = { reset = 0, diminished = 1.0 }
			end
			
			local tracked = DRCache[guid][cat]
			tracked.reset = GetTime() + DR_RESET_TIME
			tracked.diminished = DRLib:NextDR(tracked.diminished)
		end
	end

	function PB:ResetDR(guid)
		if DRCache[guid] then
			for cat in pairs (DRCache[guid]) do
				DRCache[guid][cat].reset = 0
				DRCache[guid][cat].diminished = 1.0
			end
		end
	end

	---------------------------------------------------------------------------------------------

	-- HANDLE COMBATLOG AURAS

	---------------------------------------------------------------------------------------------

	local function IsPlayer(GUID)
		return bit_band(strsub(GUID, 1, 5), 0x00F) == 0
	end

	function PB:OnAuraApplied(srcGUID, dstGUID, dstName, spellID, spellName, auraType, stackCount)
		local isPlayer = IsPlayer(dstGUID)

		local dr = 1
		if DRLib:GetSpellCategory(spellID) then
			dr = PB:InitDR(dstGUID, spellID, isPlayer)
		end

		if isPlayer then 
			knownPlayers[dstName] = dstGUID 
		end

		local isMine = srcGUID == playerGUID

		if not PB:IsTracked(spellName, isMine) then
			return
		end

		local duration, debuffType = PB:GetSpellData(spellID, isPlayer)

		if duration then
			if auraType == "DEBUFF" then 
				auraType = debuffType 
			end

			duration = duration * dr

			if duration > 0 then
				local _, _, icon = GetSpellInfo(spellID)
				PB:SetAuraInstance(dstGUID, spellName, spellID, icon, stackCount, auraType, duration, duration, isMine)
				PB:UpdatePlate(dstGUID, isPlayer and dstName or nil)
			end
		elseif debug then
			print(format('Missing aura info, please report: [%s] = "0;0", -- %s', spellID, spellName))
		end
	end

	function PB:OnAuraRemoved(dstGUID, dstName, spellName, spellID)
		local isPlayer = IsPlayer(dstGUID)

		PB:ApplyDR(dstGUID, spellID, isPlayer)

		if PB:RemoveAuraInstance(dstGUID, spellName) then
			PB:UpdatePlate(dstGUID, isPlayer and dstName or nil)
		end
	end

	function PB:OnMeleeRefresh(srcGUID, dstGUID, dstName, spellID, spellName, auraType, stackCount)
		local _, _, _, _, _, _, _, _, expiration = PB:GetAuraInstance(dstGUID, spellName)
		if expiration and GetTime() <= expiration then
			PB:ApplyDR(dstGUID, spellID, IsPlayer(dstGUID))
			PB:OnAuraApplied(srcGUID, dstGUID, dstName, spellID, spellName, auraType, stackCount)
		end
	end

	---------------------------------------------------------------------------------------------

	-- PARSE COMBAT LOG EVENTS

	---------------------------------------------------------------------------------------------

	local friendly = COMBATLOG_OBJECT_REACTION_FRIENDLY
	local function IsFriendly(flags)
		return bit_band(flags, friendly) == friendly
	end

	function PB:COMBAT_LOG_EVENT_UNFILTERED(...)
		local _, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID, spellName, spellSchool, auraType, stackCount = select(1, ...)

		if IsFriendly(dstFlags) then return end

		if eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_APPLIED_DOSE" or eventType == "SPELL_AURA_REMOVED_DOSE" then
			PB:OnAuraApplied(srcGUID, dstGUID, dstName, spellID, spellName, auraType, stackCount)

		elseif eventType == "SPELL_AURA_REFRESH" then
			PB:OnAuraRemoved(dstGUID, dstName, spellName, spellID)
			PB:OnAuraApplied(srcGUID, dstGUID, dstName, spellID, spellName, auraType, stackCount)

		elseif eventType == "SPELL_AURA_REMOVED" or eventType == "SPELL_AURA_DISPEL" or eventType == "SPELL_AURA_STOLEN" then
			PB:OnAuraRemoved(dstGUID, dstName, spellName, spellID)

		elseif eventType == "SPELL_CAST_SUCCESS" and spellSchool == 1 then
			PB:OnMeleeRefresh(srcGUID, dstGUID, dstName, spellID, spellName, auraType, stackCount)

		elseif (eventType == "UNIT_DIED" and select(2, IsInInstance()) ~= "arena") or eventType == "PARTY_KILL" then
			PB:WipeAuraCache(dstGUID)
			PB:ResetDR(dstGUID)
		end
	end

	---------------------------------------------------------------------------------------------

	-- UNIT_AURA

	---------------------------------------------------------------------------------------------

	function PB:UNIT_AURA(unit, noUpdate)
		if unit ~= "target" and unit ~= "focus" and unit ~= "mouseover" then
			return
		end

		if not UnitCanAttack("player", unit) then
			return
		end

		local needUpdate = false
		local guid = UnitGUID(unit)

		for i = 1, 40 do
			local name, rank, icon, count, dtype, duration, timeLeft, isMine = UnitDebuff(unit, i)
			if not name then break end

			if isMine or (isMine == nil and duration and duration > 0) then
				if PB:IsTracked(name, true) then
					PB:SetAuraInstance(guid, name, nil, icon, count, dtype, duration, timeLeft, true)
					needUpdate = true
				end
			end
		end

		for i = 1, 40 do
			local name, rank, icon, count, duration, timeLeft, isMine = UnitBuff(unit, i)
			if not name then break end

			if isMine or (isMine == nil and duration and duration > 0) then
				if PB:IsTracked(name, true) then
					PB:SetAuraInstance(guid, name, nil, icon, count, "BUFF", duration, timeLeft, true)
					needUpdate = true
				end
			end
		end

		if needUpdate and not noUpdate then
			PB:UpdatePlate(guid, UnitIsPlayer(unit) and UnitName(unit) or nil)
		end
	end

	---------------------------------------------------------------------------------------------

	-- EVENTS

	---------------------------------------------------------------------------------------------

	function PB:PLAYER_TARGET_CHANGED()
		targetPlate = nil
		targetGUID = nil
		hasTarget = UnitCanAttack("player", "target") == 1
		if hasTarget then
			updateTarget = true
		end
	end

	function PB:UPDATE_MOUSEOVER_UNIT()
		mouseGUID = nil
		if UnitCanAttack("player", "mouseover") == 1 then
			updateMouseOver = true
		end
	end

	function PB:PLAYER_FOCUS_CHANGED()
		focusGUID = UnitGUID("focus")
		PB:UNIT_AURA("focus")
	end

	function PB:VARIABLES_LOADED()
		uiScale = tonumber(GetCVar("uiScale"))
	end

	function PB:UI_SCALE_CHANGED()
		uiScale = tonumber(GetCVar("uiScale"))
	end

	function PB:ADDON_LOADED(addon)
		if addon == "PlateBuffer" then
			PB:UnregisterEvent("ADDON_LOADED")
			conf = PBCONF.activeprofile
		end
	end

	function PB:OnEvent(event, ...)
		self[event](self, ...) 
	end

	PB:SetScript("OnEvent", PB.OnEvent)
	PB:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	PB:RegisterEvent("PLAYER_FOCUS_CHANGED")
	PB:RegisterEvent("PLAYER_TARGET_CHANGED")
	PB:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	PB:RegisterEvent("VARIABLES_LOADED")
	PB:RegisterEvent("UI_SCALE_CHANGED")
	PB:RegisterEvent("ADDON_LOADED")
	PB:RegisterEvent("UNIT_AURA")

	---------------------------------------------------------------------------------------------

	-- SETUP PLATES

	---------------------------------------------------------------------------------------------

	local function PlateOnShow(frame)
		visiblePlates[frame] = true
		frame.pbguid = nil
		frame.pbname = frame.name:GetText()
		frame.pblevel = frame.level:GetText()
		frame.pbicon = nil

		local guid = knownPlayers[frame.pbname]
		if guid then
			PB:OnPlateIdentified(frame, guid)
		elseif hasTarget and not targetPlate then
			updateTarget = true
		end
	end

	local function PlateOnHide(frame)
		if frame.pbguid then
			knownPlates[frame.pbguid] = nil
			frame.pbguid = nil
		end

		frame.pbname = nil
		frame.pblevel = nil
		frame.pbicon = nil

		if targetPlate == frame then
			targetPlate = nil
		end

		if frame.debuffs then
			for i = 1, conf.auraRows*conf.aurasPerRow do
				if frame.debuffs[i] then
					PolledHideIn(frame.debuffs[i], 0)
				else
					break
				end
			end
		end

		visiblePlates[frame] = nil
	end

	local function SetupPlate(frame)
		local _, _, _, highlight, nameText, levelText, _, raidIcon = frame:GetRegions()

		-- For elvui compatibility
		frame.icon = raidIcon
		frame.name = nameText
		frame.level = levelText
		frame.highlight = highlight

		if frame:GetScript("OnShow") then
			frame:HookScript("OnShow", PlateOnShow)
		else
			frame:SetScript("OnShow", PlateOnShow)
		end

		if frame:GetScript("OnHide") then
			frame:HookScript("OnHide", PlateOnHide)
		else
			frame:SetScript("OnHide", PlateOnHide)
		end
		frame.pbsetup = true
		PlateOnShow(frame)
	end

	local function IsNameplate(frame)
		if frame:GetName() then return false end
		local overlay = frame:GetRegions()
		if overlay and overlay:GetObjectType() == "Texture" then
			return overlay:GetTexture() == "Interface\\Tooltips\\Nameplate-Border"
		end
		return false
	end

	local function GetNewPlates(newChildren, ...)
		for i = numChildren + 1, newChildren do
			local frame = select(i, ...)
			if IsNameplate(frame) and not frame.pbsetup then
				SetupPlate(frame)
			end
		end
	end

	function PB:OnUpdate()
		if updateTarget then 
			PB:UpdateTargetPlate()
		end
		
		if updateMouseOver then 
			PB:UpdateMouseOverPlate() 
		end

		newChildren = WorldFrame:GetNumChildren()
		if newChildren > numChildren then
			GetNewPlates(newChildren, WorldFrame:GetChildren())
			numChildren = newChildren
		end
	end

	PB:SetScript("OnUpdate", PB.OnUpdate)

	---------------------------------------------------------------------------------------------

	-- PLATE HANDLERS

	---------------------------------------------------------------------------------------------

	function PB:OnPlateIdentified(plate, guid, override)
		local old = knownPlates[guid]
		if old and plate ~= old then
			if override then
				PlateOnHide(old)
				PlateOnShow(old)
			else
				return
			end
		end

		knownPlates[guid] = plate
		plate.pbguid = guid
		PB:UpdatePlateAuras(plate, guid)
	end

	function PB:GetPlateByName(name)
		for v in pairs(visiblePlates) do
			if name == v.pbname then
				return v
			end
		end
	end

	function PB:GetTargetPlate()
		for v in pairs(visiblePlates) do
			if v:IsShown() and v:GetAlpha() == 1 then
				return v
			end
		end
	end

	function PB:GetMouseOverPlate()
		-- compare name and level too as this is pretty unreliable..
		local name, level = UnitName("mouseover"), tostring(UnitLevel("mouseover"))
		local count = 0
		local plate

		for v in pairs(visiblePlates) do
			if v:IsShown() and v.highlight:IsShown() and name == v.pbname and level == v.pblevel then
				plate = v
				count = count + 1
			end
		end
		-- this was a fun bug to hunt down
		if count == 1 then
			return plate
		end
	end

	function PB:UpdateTargetPlate()
		updateTarget = false
		if UnitCanAttack("player", "target") == 1 then
			targetGUID = UnitGUID("target")

			local plate = PB:GetTargetPlate()
			if plate then
				targetPlate = plate
				PB:UNIT_AURA("target", true)
				PB:OnPlateIdentified(plate, targetGUID, true)
			end
		end
	end

	function PB:UpdateMouseOverPlate()
		updateMouseOver = false
		if UnitCanAttack("player", "mouseover") == 1 then
			mouseGUID = UnitGUID("mouseover")

			local plate

			if mouseGUID == targetGUID then 
				return 
			elseif knownPlates[mouseGUID] then
				PB:UNIT_AURA("mouseover")
			elseif UnitIsPlayer("mouseover") then
				plate = PB:GetPlateByName(UnitName("mouseover"))
			else
				plate = PB:GetMouseOverPlate()
			end

			if plate then
				PB:UNIT_AURA("mouseover", true)
				PB:OnPlateIdentified(plate, mouseGUID)
			end
		end
	end
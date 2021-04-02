m4xVisionHelperDB = m4xVisionHelperDB or {}

local ResetFrames, PotionReset, ArrangeFrames, InitiateFrames, MoveFrames, PlayerInVision, PlayerOutVision, SanityTimer, BuffTimer

local newsanityvalue, sanitytick, oldsanitydiff

local initiated = false

local SanityColor, DefenseColor, HealColor, FireColor
local black = {0, 0, 0}
local blue = {0, 0, 1}
local green = {0, 1, 0}
local purple = {1, 0, 1}
local red = {1, 0, 0}

local f = CreateFrame("Frame")

ResetFrames = function()
	_G["MainVHFrame"]:SetBackdropColor(1, 0, 0, 0)
	_G["MainVHFrame"]:SetSize(200, 285)
	_G["MainVHFrame"]:SetPoint("LEFT", UIParent, "LEFT", 100, 0)
	_G["InfoVHFrame"]:SetSize(200, 35)
	_G["InfoVHFrame"]:SetPoint("TOP", "MainVHFrame", "TOP", 0, 0)
	_G["ColorVHFrame"]:SetSize(150, 250)
	_G["ColorVHFrame"]:SetPoint("TOPRIGHT", "InfoVHFrame", "BOTTOMRIGHT", 0, 0)
	_G["BuffsVHFrame"]:SetSize(50, 250)
	_G["BuffsVHFrame"]:SetPoint("TOPLEFT", "InfoVHFrame", "BOTTOMLEFT", 0, 0)
	_G["CheatDeathVHFrame"]:SetAlpha(0.3)
	_G["TitanVHFrame"]:SetAlpha(0.3)
	_G["DefenseVHFrame"]:SetAlpha(0.3)
	_G["HealVHFrame"]:SetAlpha(0.3)
	_G["FireVHFrame"]:SetAlpha(0.3)
	_G["Button2VHFrame"]:SetScript("OnClick", function()
		ArrangeFrames(blue)
	end)
	_G["Button3VHFrame"]:SetScript("OnClick", function()
		ArrangeFrames(green)
	end)
	_G["Button4VHFrame"]:SetScript("OnClick", function()
		ArrangeFrames(purple)
	end)
	_G["Button5VHFrame"]:SetScript("OnClick", function()
		ArrangeFrames(red)
	end)
end

PotionReset = function()
	_G["Button1VHFrame"]:SetBackdropColor(unpack(black))
	_G["Button1VHFrameText"]:SetText("")
	_G["Button1VHFrame"]:SetScript("OnEnter", nil)
	_G["Button1VHFrame"]:SetScript("OnLeave", nil)
	_G["Button1VHFrame"]:SetScript("OnClick", function()
		ArrangeFrames(black)
	end)
	_G["Button2VHFrame"]:SetBackdropColor(unpack(blue))
	_G["Button2VHFrameText"]:SetText("")
	_G["Button2VHFrame"]:EnableMouse(true)
	_G["Button3VHFrame"]:SetBackdropColor(unpack(green))
	_G["Button3VHFrameText"]:SetText("")
	_G["Button3VHFrame"]:EnableMouse(true)
	_G["Button4VHFrame"]:SetBackdropColor(unpack(purple))
	_G["Button4VHFrameText"]:SetText("")
	_G["Button4VHFrame"]:EnableMouse(true)
	_G["Button5VHFrame"]:SetBackdropColor(unpack(red))
	_G["Button5VHFrameText"]:SetText("")
	_G["Button5VHFrame"]:EnableMouse(true)
end

ArrangeFrames = function(badpotion)
	if badpotion == black then
		SanityColor = green
		DefenseColor = red
		HealColor = blue
		FireColor = purple
	elseif badpotion == blue then
		SanityColor = purple
		DefenseColor = black
		HealColor = green
		FireColor = red
	elseif badpotion == green then
		SanityColor = red
		DefenseColor = blue
		HealColor = purple
		FireColor = black
	elseif badpotion == purple then
		SanityColor = black
		DefenseColor = green
		HealColor = red
		FireColor = blue
	elseif badpotion == red then
		SanityColor = blue
		DefenseColor = purple
		HealColor = black
		FireColor = green
	end

	_G["Button1VHFrame"]:SetBackdropColor(unpack(badpotion))
	_G["Button1VHFrameText"]:SetText("Poison")
	_G["Button1VHFrame"]:SetScript("OnEnter", function()
		_G["Button1VHFrameText"]:SetText("Reset Colors")
	end)
	_G["Button1VHFrame"]:SetScript("OnLeave", function()
		_G["Button1VHFrameText"]:SetText("Poison")
	end)
	_G["Button1VHFrame"]:SetScript("OnClick", function()
		PotionReset()
	end)
	_G["Button2VHFrame"]:SetBackdropColor(unpack(SanityColor))
	_G["Button2VHFrameText"]:SetText("Sanity")
	_G["Button2VHFrame"]:EnableMouse(false)
	_G["Button3VHFrame"]:SetBackdropColor(unpack(DefenseColor))
	_G["Button3VHFrameText"]:SetText("Defense")
	_G["Button3VHFrame"]:EnableMouse(false)
	_G["Button4VHFrame"]:SetBackdropColor(unpack(HealColor))
	_G["Button4VHFrameText"]:SetText("Heal")
	_G["Button4VHFrame"]:EnableMouse(false)
	_G["Button5VHFrame"]:SetBackdropColor(unpack(FireColor))
	_G["Button5VHFrameText"]:SetText("Fire")
	_G["Button5VHFrame"]:EnableMouse(false)
	_G["BuffsVHFrame"]:Show()
	_G["InfoVHFrame"]:Show()
end

MoveFrames = function()
	if not _G["MainVHFrame"]:IsMovable() then
		_G["MainVHFrame"]:SetMovable(true)
		_G["MainVHFrame"]:RegisterForDrag("LeftButton")
		_G["MainVHFrame"]:EnableMouse(true)
		_G["MainVHFrameText"]:SetText("Move Me")
		_G["MainVHFrame"]:SetBackdropColor(1, 0, 0, 1)
		_G["ColorVHFrame"]:EnableMouse(false)
		_G["ColorVHFrame"]:Hide()
		_G["BuffsVHFrame"]:Hide()
		_G["InfoVHFrame"]:Hide()
	else
		_G["MainVHFrame"]:SetMovable(false)
		_G["MainVHFrame"]:RegisterForDrag()
		_G["MainVHFrame"]:EnableMouse(false)
		_G["MainVHFrameText"]:SetText("")
		_G["MainVHFrame"]:SetBackdropColor(1, 0, 0, 0)
		_G["ColorVHFrame"]:EnableMouse(true)
		_G["ColorVHFrame"]:Show()
		_G["BuffsVHFrame"]:Show()
		_G["InfoVHFrame"]:Show()
		m4xVisionHelperDB["Pos"][1], _, m4xVisionHelperDB["Pos"][3], m4xVisionHelperDB["Pos"][4], m4xVisionHelperDB["Pos"][5] = _G["MainVHFrame"]:GetPoint()
	end
end

InitiateFrames = function()
	initiated = true
	local mainframe = CreateFrame("Frame", "MainVHFrame", UIParent)
	mainframe:SetFrameStrata("MEDIUM")
	mainframe:SetFrameLevel(20)
	mainframe:SetScript("OnDragStart", mainframe.StartMoving)
	mainframe:SetScript("OnDragStop", mainframe.StopMovingOrSizing)
	mainframe.Text = mainframe:CreateFontString("MainVHFrameText", "OVERLAY")
	mainframe.Text:SetPoint("CENTER", mainframe)
	mainframe.Text:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE")
	mainframe.Text:SetTextColor(1, 1, 1)
	mainframe:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
	})

	local colorframe = CreateFrame("Frame", "ColorVHFrame", mainframe)
	colorframe:EnableMouse(true)

	local buffsframe = CreateFrame("Frame", "BuffsVHFrame", mainframe)

	local infoframe = CreateFrame("Frame", "InfoVHFrame", mainframe)
	infoframe.bg = infoframe:CreateTexture("SanityBarVHBG", "BACKGROUND")
	infoframe.bg:SetTexture("Interface\\UNITPOWERBARALT\\Amber_Horizontal_Fill")
	infoframe.bg:SetTexCoord(0.15, 0.85, 0.30, 0.70)
	infoframe.bg:SetPoint("LEFT", 0, 0)
	infoframe.bg:SetSize(200, 35)
	infoframe.fg = infoframe:CreateTexture("SanityBarVHFG", "ARTWORK")
	infoframe.fg:SetTexture("Interface\\UNITPOWERBARALT\\Amber_Horizontal_Fill")
	infoframe.fg:SetTexCoord(0.15, 0.85, 0.30, 0.70)
	infoframe.fg:SetPoint("RIGHT", 0, 0)
	infoframe.fg:SetSize(200, 35)
	infoframe.fg:SetColorTexture(0, 0, 0, 0.8)
	infoframe.Text = infoframe:CreateFontString("InfoVHFrameText", "OVERLAY")
	infoframe.Text:SetPoint("CENTER", infoframe)
	infoframe.Text:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
	infoframe.Text:SetTextColor(1, 1, 1)
	infoframe.Text:SetText("Not in Vision")

	local button1frame = CreateFrame("Button", "Button1VHFrame", colorframe)
	button1frame:SetPoint("TOP", colorframe, "TOP", 0, 0)
	button1frame:SetSize(150, 50)
	button1frame.Text = button1frame:CreateFontString("Button1VHFrameText", "OVERLAY")
	button1frame.Text:SetPoint("CENTER", button1frame)
	button1frame.Text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
	button1frame.Text:SetTextColor(1, 1, 1)
	button1frame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
	})

	local button2frame = CreateFrame("Button", "Button2VHFrame", colorframe)
	button2frame:SetPoint("TOP", button1frame, "BOTTOM", 0, 0)
	button2frame:SetSize(150, 50)
	button2frame.Text = button2frame:CreateFontString("Button2VHFrameText", "OVERLAY")
	button2frame.Text:SetPoint("CENTER", button2frame)
	button2frame.Text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
	button2frame.Text:SetTextColor(1, 1, 1)
	button2frame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
	})

	local button3frame = CreateFrame("Button", "Button3VHFrame", colorframe)
	button3frame:SetPoint("TOP", button2frame, "BOTTOM", 0, 0)
	button3frame:SetSize(150, 50)
	button3frame.Text = button3frame:CreateFontString("Button3VHFrameText", "OVERLAY")
	button3frame.Text:SetPoint("CENTER", button3frame)
	button3frame.Text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
	button3frame.Text:SetTextColor(1, 1, 1)
	button3frame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
	})

	local button4frame = CreateFrame("Button", "Button4VHFrame", colorframe)
	button4frame:SetPoint("TOP", button3frame, "BOTTOM", 0, 0)
	button4frame:SetSize(150, 50)
	button4frame.Text = button4frame:CreateFontString("Button4VHFrameText", "OVERLAY")
	button4frame.Text:SetPoint("CENTER", button4frame)
	button4frame.Text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
	button4frame.Text:SetTextColor(1, 1, 1)
	button4frame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
	})

	local button5frame = CreateFrame("Button", "Button5VHFrame", colorframe)
	button5frame:SetPoint("TOP", button4frame, "BOTTOM", 0, 0)
	button5frame:SetSize(150, 50)
	button5frame.Text = button5frame:CreateFontString("Button5VHFrameText", "OVERLAY")
	button5frame.Text:SetPoint("CENTER", button5frame)
	button5frame.Text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
	button5frame.Text:SetTextColor(1, 1, 1)
	button5frame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
	})

	local cheatdeathframe = CreateFrame("Frame", "CheatDeathVHFrame", buffsframe)
	cheatdeathframe:SetPoint("TOP", buffsframe, "TOP", 0, 0)
	cheatdeathframe:SetSize(50, 50)
	cheatdeathframe.Text = cheatdeathframe:CreateFontString("CheatDeathVHFrameText", "OVERLAY")
	cheatdeathframe.Text:SetPoint("CENTER", cheatdeathframe)
	cheatdeathframe.Text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
	cheatdeathframe.Text:SetTextColor(1, 1, 1)

	cheatdeathframe:SetBackdrop({
		bgFile = "Interface\\ICONS\\Ability_Mage_StudentOfTheMind"
	})

	local titanframe = CreateFrame("Frame", "TitanVHFrame", buffsframe)
	titanframe:SetPoint("TOP", cheatdeathframe, "BOTTOM", 0, 0)
	titanframe:SetSize(50, 50)
	titanframe.Text = titanframe:CreateFontString("TitanVHFrameText", "OVERLAY")
	titanframe.Text:SetPoint("CENTER", titanframe)
	titanframe.Text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
	titanframe.Text:SetTextColor(1, 1, 1)
	titanframe:SetBackdrop({
		bgFile = "Interface\\ICONS\\INV_Trinket_80_Titan01b"
	})

	local defenseframe = CreateFrame("Frame", "DefenseVHFrame", buffsframe)
	defenseframe:SetPoint("TOP", titanframe, "BOTTOM", 0, 0)
	defenseframe:SetSize(50, 50)
	defenseframe.Text = defenseframe:CreateFontString("DefenseVHFrameText", "OVERLAY")
	defenseframe.Text:SetPoint("CENTER", defenseframe)
	defenseframe.Text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
	defenseframe.Text:SetTextColor(1, 1, 1)
	defenseframe:SetBackdrop({
		bgFile = "Interface\\ICONS\\Spell_Nature_SicklyPolymorph"
	})

	local healframe = CreateFrame("Frame", "HealVHFrame", buffsframe)
	healframe:SetPoint("TOP", defenseframe, "BOTTOM", 0, 0)
	healframe:SetSize(50, 50)
	healframe.Text = healframe:CreateFontString("HealVHFrameText", "OVERLAY")
	healframe.Text:SetPoint("CENTER", healframe)
	healframe.Text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
	healframe.Text:SetTextColor(1, 1, 1)
	healframe:SetBackdrop({
		bgFile = "Interface\\ICONS\\Spell_Nature_Slow"
	})

	local fireframe = CreateFrame("Frame", "FireVHFrame", buffsframe)
	fireframe:SetPoint("TOP", healframe, "BOTTOM", 0, 0)
	fireframe:SetSize(50, 50)
	fireframe.Text = fireframe:CreateFontString("FireVHFrameText", "OVERLAY")
	fireframe.Text:SetPoint("CENTER", fireframe)
	fireframe.Text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
	fireframe.Text:SetTextColor(1, 1, 1)
	fireframe:SetBackdrop({
		bgFile = "Interface\\ICONS\\Ability_Monk_BreathofFire"
	})

	ResetFrames()
	PotionReset()

	if m4xVisionHelperDB.Pos then
		_G["MainVHFrame"]:ClearAllPoints()
		_G["MainVHFrame"]:SetPoint(unpack(m4xVisionHelperDB.Pos))
	else
		m4xVisionHelperDB.Pos = {}
		m4xVisionHelperDB.Pos[1], _, m4xVisionHelperDB.Pos[3], m4xVisionHelperDB.Pos[4], m4xVisionHelperDB.Pos[5] = _G["MainVHFrame"]:GetPoint()
		m4xVisionHelperDB.Pos[2] = nil
	end
end

PlayerInVision = function()
	print("-- Entered Vision --")
	if not initiated then
		InitiateFrames()
	else
		_G["MainVHFrame"]:Show()
	end
	sanitytick = 0
	oldsanitydiff = 0
	newsanityvalue = 1000
	_G["InfoVHFrameText"]:SetText("In Vision")
	_G["SanityBarVHFG"]:SetWidth(0)
	f:UnregisterEvent("UNIT_POWER_BAR_SHOW")
	f:RegisterEvent("UNIT_POWER_BAR_HIDE")
	f:RegisterEvent("UNIT_POWER_UPDATE") -- f:RegisterEvent("UNIT_POWER_FREQUENT")
end

PlayerOutVision = function()
	print("-- Left Vision --")
	PotionReset()
	_G["CheatDeathVHFrame"]:SetAlpha(0.3)
	_G["CheatDeathVHFrameText"]:SetText("")
	_G["TitanVHFrame"]:SetAlpha(0.3)
	_G["TitanVHFrameText"]:SetText("")
	_G["DefenseVHFrame"]:SetAlpha(0.3)
	_G["DefenseVHFrameText"]:SetText("")
	_G["HealVHFrame"]:SetAlpha(0.3)
	_G["HealVHFrameText"]:SetText("")
	_G["FireVHFrame"]:SetAlpha(0.3)
	_G["FireVHFrameText"]:SetText("")
	_G["InfoVHFrameText"]:SetText("Not in Vision")
	_G["MainVHFrame"]:Hide()
	f:UnregisterEvent("UNIT_POWER_UPDATE")
	f:UnregisterEvent("UNIT_POWER_BAR_HIDE")
	f:RegisterEvent("UNIT_POWER_BAR_SHOW")
end

SanityTimer = function(sanityvalue)
	local timervaluesec, timervaluemin = 0, 0
	local oldsanityvalue = newsanityvalue
	newsanityvalue = sanityvalue
	local newsanitydiff = oldsanityvalue - newsanityvalue
	print("--------------------")
	print("SanityValue: " .. newsanityvalue)
	print("SanityDiff: " .. newsanitydiff)
	if newsanitydiff < 13 and newsanitydiff ~= sanitytick and oldsanitydiff ~= sanitytick then
		sanitytick = newsanitydiff
		print("-- Changed Tick --")
	end
	oldsanitydiff = newsanitydiff
	if sanitytick < 1 then
		sanitytick = 1 -- temporary fix
		print("Tick was 0 or negative")
	end
	timervaluesec = sanityvalue / sanitytick
	print("SanityTick: " .. sanitytick)
	print("Timer: " .. timervaluesec)
	if timervaluesec > 59 then
		timervaluemin = floor(timervaluesec / 60)
		timervaluesec = timervaluesec - (timervaluemin * 60)
	end
	_G["InfoVHFrameText"]:SetFormattedText(timervaluemin > 0 and "%02d:%02d" or "%2$d", timervaluemin, floor(timervaluesec + 0.5))
	_G["SanityBarVHFG"]:SetWidth(200 - (newsanityvalue / 5))
end

BuffTimer = function(timer, buff)
	if timer then
		if buff ~= "CheatDeath" then
			local timervaluesec, timervaluemin = 0, 0
			timervaluesec = timer - GetTime()
			if timervaluesec > 59 then
				timervaluemin = floor(timervaluesec / 60)
				timervaluesec = timervaluesec - (timervaluemin * 60)
			end
			_G[buff .. "VHFrame"]:SetAlpha(1)
			_G[buff .. "VHFrameText"]:SetFormattedText(timervaluemin > 0 and "%02d:%02d" or "%2$d", timervaluemin, floor(timervaluesec + 0.5))
		else
			print("Cheat Death engaged")
			_G[buff .. "VHFrame"]:SetAlpha(1)
			_G[buff .. "VHFrameText"]:SetText("Used")
		end
	else
		if buff ~= "CheatDeath" then
			_G[buff .. "VHFrame"]:SetAlpha(0.3)
			_G[buff .. "VHFrameText"]:SetText("")
		end
	end
end

f:RegisterEvent("UNIT_POWER_BAR_SHOW")

f:SetScript("OnEvent", function(self, event, ...)
	if event == "UNIT_POWER_BAR_SHOW" then
		if C_Scenario.IsInScenario() and strmatch(select(1, C_Scenario.GetInfo()), "Vision of ") then
			PlayerInVision()
		end
	elseif event == "UNIT_POWER_BAR_HIDE" then
		PlayerOutVision()
	elseif event == "UNIT_POWER_UPDATE" then
		for i, v in pairs({["CheatDeath"] = "Emergency Cranial Defibrillation", ["Titan"] = "Gift of the Titans", ["Defense"] = "Sickening Potion", ["Heal"] = "Sluggish Potion", ["Fire"] = "Spicy Potion"}) do
			local _, _, _, _, _, timer = AuraUtil.FindAuraByName(v, "player")
			BuffTimer(timer, i)
		end
		local unit, powertype = ...
		if unit == "player" and powertype == "ALTERNATE" then
			SanityTimer(UnitPower("player", 10))
		end
	end
end)

SlashCmdList["M4XVISIONHELPER"] = function(chat)
	if chat == "reset" then
		ResetFrames()
	elseif chat == "lock" then
		MoveFrames()
	elseif chat == "show" then
		if not initiated then
			InitiateFrames()
		else
			if _G["MainVHFrame"]:IsShown() then
				_G["MainVHFrame"]:Hide()
			else
				_G["MainVHFrame"]:Show()
			end
		end
	end
end

SLASH_M4XVISIONHELPER1 = "/mvh"
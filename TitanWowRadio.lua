TITAN_WOWRADIO_ID =  "WowRadio"
TITAN_WOWRADIO_MENU_TEXT = "WowRadio"
TITAN_WOWRADIO_BUTTON_LABEL =  "WowRadio: "
TITANWOWRADIO_ICON = "Interface\\AddOns\\TitanWowRadio\\speaker"
function TitanPanelWowRadioButton_OnLoad()
	this.registry = { 
		id = TITAN_WOWRADIO_ID,
		version = TITAN_WOWRADIO_VERSION,
		menuText = TITAN_WOWRADIO_MENU_TEXT, 
		buttonTextFunction = "TitanPanelWowRadioButton_GetButtonText", 
		tooltipTitle = TITAN_WOWRADIO_TOOLTIP,
		tooltipTextFunction = "TitanPanelWowRadioButton_GetTooltipText", 
		icon = TITANWOWRADIO_ICON,
		iconWidth = 16,
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = 1,
			autostart = 0,
		},
		frequency = 3
	};
end

function TitanPanelWowRadioButton_GetButtonText(id)
	local id = TitanUtils_GetButton(id, true)

	local autostart = TitanGetVar(TITAN_WOWRADIO_ID, "autostart")
	local titan_auto = false

	if autostart == 1 then
		titan_auto = true
	end

	if titan_auto ~= WowRadio:isAutostart() then
		WowRadio:toggleAutostart()
	end
	
	if WowRadio.isStopped() then
		return "stopped"
	elseif WowRadio.getCustomUrl() ~= nil then
		return "[custom]"
	else
		return TITAN_WOWRADIO_BUTTON_LABEL, TitanUtils_GetHighlightText(WowRadio:getStation().."/"..WowRadio:getStationSize())
	end
end

function TitanPanelWowRadioButton_GetTooltipText()
	TitanPanelButton_UpdateButton(this.value);
	local tooltiptext = "";
	local station = WowRadio:getStation()
	for index,value in ipairs(WowRadio:getStationNames()) do 
		if index < 10 then
			idx = "0"..index
		else
			idx = index
		end
		if index == station and WowRadio:getCustomUrl() == nil then
			tooltiptext = tooltiptext..TitanUtils_GetHighlightText("["..idx.."]  "..value.."\n")
		else
			tooltiptext = tooltiptext..TitanUtils_GetNormalText("["..idx.."]  "..value.."\n")
		end
	end
	if WowRadio:getCustomUrl() ~= nil then
		tooltiptext = tooltiptext..TitanUtils_GetHighlightText(WowRadio:getCustomUrl())
	end
	return tooltiptext
end

function TitanPanelRightClickMenu_PrepareWowRadioMenu()
	
	if ( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
		if ( UIDROPDOWNMENU_MENU_VALUE == TITAN_WOWRADIO_MENU_STATIONS ) then
			local station = WowRadio:getStation()
			for index,value in ipairs(WowRadio:getStationNames()) do 
				info = {};
				if index < 10 then
					idx = "0"..index
				else
					idx = index
				end
				info.text = idx;
				info.func = tune;
				info.value = index;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end
		end
		return
	end

	-- Menu title
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_WOWRADIO_ID].menuText);	
	
	-- create the title for the radio station select submenu
	info = {};
	info.text = TITAN_WOWRADIO_MENU_STATIONS;
	info.value = TITAN_WOWRADIO_MENU_STATIONS;
	info.hasArrow = 1;
	UIDropDownMenu_AddButton(info);
	
	if WowRadio:isStopped() then
		TitanPanelRightClickMenu_AddCommand(TITAN_WOWRADIO_MENU_PLAY, TITAN_WOWRADIO_ID, "TitanPanelWowRadioButton_Play");
	else
		TitanPanelRightClickMenu_AddCommand(TITAN_WOWRADIO_MENU_STOP, TITAN_WOWRADIO_ID, "TitanPanelWowRadioButton_Stop");
	end
	TitanPanelRightClickMenu_AddCommand(TITAN_WOWRADIO_MENU_NEXT, TITAN_WOWRADIO_ID, "TitanPanelWowRadioButton_Next")
	TitanPanelRightClickMenu_AddCommand(TITAN_WOWRADIO_MENU_PREV, TITAN_WOWRADIO_ID, "TitanPanelWowRadioButton_Prev")
	TitanPanelRightClickMenu_AddCommand(TITAN_WOWRADIO_MENU_RND, TITAN_WOWRADIO_ID, "TitanPanelWowRadioButton_Rnd")

	-- A blank line in the menu
	TitanPanelRightClickMenu_AddSpacer();	

	TitanPanelRightClickMenu_AddToggleVar(TITAN_WOWRADIO_MENU_AUTO, TITAN_WOWRADIO_ID, "autostart")

	-- A blank line in the menu
	TitanPanelRightClickMenu_AddSpacer();	
	
	-- Generic function to toggle label text
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_WOWRADIO_ID);
	TitanPanelRightClickMenu_AddToggleIcon(TITAN_WOWRADIO_ID);

	-- Generic function to hide the plugin
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, TITAN_WOWRADIO_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end

function TitanPanelWowRadioButton_OnClick(button)
	if ( button == "LeftButton" and IsControlKeyDown()) then
		WowRadio:next()
	elseif (button == "LeftButton" and IsAltKeyDown()) then
		WowRadio:prev()
	end
	TitanPanelButton_OnClick(arg1);
end


function TitanPanelWowRadioButton_Play()
	local button = TitanUtils_GetButton(this.value);
	if (button and IsAddOnLoaded("WowRadio")) then
		WowRadio:play()
	end
end

function TitanPanelWowRadioButton_Stop()
	local button = TitanUtils_GetButton(this.value);
	if (button and IsAddOnLoaded("WowRadio")) then
		WowRadio:stop()
	end
end

function TitanPanelWowRadioButton_Next()
	local button = TitanUtils_GetButton(this.value);
	if (button and IsAddOnLoaded("WowRadio")) then
		WowRadio:next()
	end
end

function TitanPanelWowRadioButton_Prev()
	local button = TitanUtils_GetButton(this.value);
	if (button and IsAddOnLoaded("WowRadio")) then
		WowRadio:prev()
	end
end

function TitanPanelWowRadioButton_Rnd()
	local button = TitanUtils_GetButton(this.value);
	if (button and IsAddOnLoaded("WowRadio")) then
		WowRadio:rnd()
	end
end

function tune() 
	if(this.value == WowRadio:getStation()) then return end
	WowRadio:play(this.value)
end
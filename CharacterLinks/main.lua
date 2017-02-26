-- Based on ArmoryQuickLink and WoWProgressLink

UnitPopupButtons["CL"]={text = "Character Links", dist = 0, nested = 1,};
UnitPopupButtons["A"] = {text = "Armory", dist = 0, checkable = nil};
UnitPopupButtons["WL"] = {text = "Warcraft Logs", dist = 0, checkable = nil};
UnitPopupButtons["WH"] = {text = "WarcraftHub", dist = 0, checkable = nil};
UnitPopupButtons["WP"] = {text = "WoWProgress", dist = 0, checkable = nil};
table.insert(UnitPopupMenus["SELF"], #(UnitPopupMenus["SELF"])-1, "CL");
table.insert(UnitPopupMenus["PARTY"], #(UnitPopupMenus["PARTY"])-1, "CL");
table.insert(UnitPopupMenus["PLAYER"], #(UnitPopupMenus["PLAYER"])-1, "CL");
table.insert(UnitPopupMenus["RAID_PLAYER"], #(UnitPopupMenus["RAID_PLAYER"])-1, "CL");
table.insert(UnitPopupMenus["GUILD"], #(UnitPopupMenus["GUILD"])-1, "CL");
table.insert(UnitPopupMenus["GUILD_OFFLINE"], #(UnitPopupMenus["GUILD_OFFLINE"])-1, "CL");
table.insert(UnitPopupMenus["FRIEND"], #(UnitPopupMenus["FRIEND"])-1, "CL");
table.insert(UnitPopupMenus["FRIEND_OFFLINE"], #(UnitPopupMenus["FRIEND_OFFLINE"])-1, "CL");
table.insert(UnitPopupMenus["CHAT_ROSTER"], #(UnitPopupMenus["CHAT_ROSTER"])-1, "CL");
UnitPopupMenus["CL"] = {"A", "WH", "WL", "WP"};

local function getRegion()
	local regionLabel = {"us", "kr", "eu", "tw", "cn"}
	local regionId = GetCurrentRegion()
	return regionLabel[regionId]
end

local function buildLink(name,site)
	local char, server = string.match(name, "(.-)-(.*)")
	if not char then
		char = name
		server = GetRealmName()
	end
	server = string.gsub(server, "(%l)(%u)", "%1-%2")
	server = string.gsub(server, "'", "-")
	if server == ""	then
		DEFAULT_CHAT_FRAME:AddMessage("|CFFCC33FFCharacter Links|r: ".."Out of range!");
	else
		local region = getRegion()
		if site == "armory" then
			url = "https://" .. region .. ".battle.net/wow/en/character/" .. server .. "/" .. char .. "/advanced"
		elseif site == "warcrafthub" then
			url = "https://www.warcraftparser.com/character/" .. region .. "/" .. server .. "/" .. char .. "/"
		elseif site == "warcraftlogs" then
			url = "https://www.warcraftlogs.com/rankings/character_name/" .. char .. "/" .. server .. "/" .. region
		elseif site == "wowprogress" then
			url = "https://www.wowprogress.com/character/" .. region .. "/" .. server .. "/" .. char
		end
		return url;
	end
end

local function ShowUrl(name,site)
	if not name then return end
	local url = buildLink(name,site)
	if url then
		local edit_box = ChatEdit_ChooseBoxForSend()
		ChatEdit_ActivateChat(edit_box)
		if url then
			edit_box:Insert(url);
			edit_box:HighlightText();
		end
	end
end

local CURRENT_NAME, CURRENT_SERVER

hooksecurefunc("UnitPopup_ShowMenu", function (dropdownMenu, which, unit, name, userData)
	local server = nil;
	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
		if ( unit ) then
			name, server = UnitName(unit);
		elseif ( name ) then
			local n, s = strmatch(name, "^([^-]+)-(.*)");
			if ( n ) then
				name = n;
				server = s;
			end
		end

		CURRENT_NAME = name;
		CURRENT_SERVER = server;
	end
end)

hooksecurefunc("UnitPopup_OnClick", function(self)
	local site
	local name, realm = UIDROPDOWNMENU_INIT_MENU.name, UIDROPDOWNMENU_INIT_MENU.server
	if name == CURRENT_NAME and not realm then realm = CURRENT_SERVER end
	if self.value == "A" then
		site = "armory"
	elseif self.value == "WH" then
		site = "warcrafthub"
	elseif self.value == "WL" then
		site = "warcraftlogs"
	elseif self.value == "WP" then
		site = "wowprogress"
	else return;
	end
	if realm then
		ShowUrl(name .. "-" .. realm,site)
	else
		ShowUrl(name,site)
	end
end)

local LFG_LIST_SEARCH_ENTRY_MENU = {
	{
		text = nil,
		isTitle = true,
		notCheckable = true,
	},
	{
		text = WHISPER_LEADER,
		func = function(_, name) ChatFrame_SendTell(name); end,
		notCheckable = true,
		arg1 = nil,
		disabled = nil,
		tooltipWhileDisabled = 1,
		tooltipOnButton = 1,
		tooltipTitle = nil,
		tooltipText = nil,
	},
	{
		text = "Character Links",
		hasArrow = true,
		notCheckable = true,
		menuList = {
			{
				text = "Armory",
				func = function(_, name) ShowUrl(name,"armory"); end,
				notCheckable = true,
				arg1 = nil,
				disabled = nil,
				notCheckable = true,
			},
			{
				text = "WarcraftHub",
				func = function(_, name) ShowUrl(name,"warcrafthub"); end,
				notCheckable = true,
				arg1 = nil,
				disabled = nil,
				notCheckable = true,
			},
			{
				text = "Warcraft Logs",
				func = function(_, name) ShowUrl(name,"warcraftlogs"); end,
				notCheckable = true,
				arg1 = nil,
				disabled = nil,
				notCheckable = true,
			},
			{
				text = "WoWProgress",
				func = function(_, name) ShowUrl(name,"wowprogress"); end,
				notCheckable = true,
				arg1 = nil,
				disabled = nil,
				notCheckable = true,
			},
		},
	},
	{
		text = LFG_LIST_REPORT_GROUP_FOR,
		hasArrow = true,
		notCheckable = true,
		menuList = {
			{
				text = LFG_LIST_BAD_NAME,
				func = function(_, id) C_LFGList.ReportSearchResult(id, "lfglistname"); end,
				arg1 = nil,
				notCheckable = true,
			},
			{
				text = LFG_LIST_BAD_DESCRIPTION,
				func = function(_, id) C_LFGList.ReportSearchResult(id, "lfglistcomment"); end,
				arg1 = nil,
				notCheckable = true,
				disabled = nil,
			},
			{
				text = LFG_LIST_BAD_VOICE_CHAT_COMMENT,
				func = function(_, id) C_LFGList.ReportSearchResult(id, "lfglistvoicechat"); end,
				arg1 = nil,
				notCheckable = true,
				disabled = nil,
			},
			{
				text = LFG_LIST_BAD_LEADER_NAME,
				func = function(_, id) C_LFGList.ReportSearchResult(id, "badplayername"); end,
				arg1 = nil,
				notCheckable = true,
				disabled = nil,
			},
		},
	},
	{
		text = CANCEL,
		notCheckable = true,
	},
};

function LFGListUtil_GetSearchEntryMenu(resultID)
	local id, activityID, name, comment, voiceChat, iLvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, numMembers = C_LFGList.GetSearchResultInfo(resultID);
	local _, appStatus, pendingStatus, appDuration = C_LFGList.GetApplicationInfo(resultID);
	LFG_LIST_SEARCH_ENTRY_MENU[1].text = name;
	LFG_LIST_SEARCH_ENTRY_MENU[2].arg1 = leaderName;
	LFG_LIST_SEARCH_ENTRY_MENU[2].disabled = not leaderName;
	LFG_LIST_SEARCH_ENTRY_MENU[3].arg1 = leaderName;
	LFG_LIST_SEARCH_ENTRY_MENU[3].disabled = not leaderName;
	LFG_LIST_SEARCH_ENTRY_MENU[3].menuList[1].arg1 = leaderName;
	LFG_LIST_SEARCH_ENTRY_MENU[3].menuList[2].arg1 = leaderName;
	LFG_LIST_SEARCH_ENTRY_MENU[3].menuList[3].arg1 = leaderName;
	LFG_LIST_SEARCH_ENTRY_MENU[3].menuList[4].arg1 = leaderName;
	LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[1].arg1 = resultID;
	LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[2].arg1 = resultID;
	LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[2].disabled = (comment == "");
	LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[3].arg1 = resultID;
	LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[3].disabled = (voiceChat == "");
	LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[4].arg1 = resultID;
	LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[4].disabled = not leaderName;
	return LFG_LIST_SEARCH_ENTRY_MENU;
end

local LFG_LIST_APPLICANT_MEMBER_MENU = {
	{
		text = nil,
		isTitle = true,
		notCheckable = true,
	},
	{
		text = WHISPER,
		func = function(_, name) ChatFrame_SendTell(name); end,
		notCheckable = true,
		arg1 = nil,
		disabled = nil,
	},
	{
		text = "Character Links",
		hasArrow = true,
		notCheckable = true,
		menuList = {
			{
				text = "Armory",
				func = function(_, name) ShowUrl(name,"armory"); end,
				notCheckable = true,
				arg1 = nil,
				disabled = nil,
				notCheckable = true,
			},
			{
				text = "WarcraftHub",
				func = function(_, name) ShowUrl(name,"warcrafthub"); end,
				notCheckable = true,
				arg1 = nil,
				disabled = nil,
				notCheckable = true,
			},
			{
				text = "Warcraft Logs",
				func = function(_, name) ShowUrl(name,"warcraftlogs"); end,
				notCheckable = true,
				arg1 = nil,
				disabled = nil,
				notCheckable = true,
			},
			{
				text = "WoWProgress",
				func = function(_, name) ShowUrl(name,"wowprogress"); end,
				notCheckable = true,
				arg1 = nil,
				disabled = nil,
				notCheckable = true,
			},
		},
	},
	{
		text = LFG_LIST_REPORT_FOR,
		hasArrow = true,
		notCheckable = true,
		menuList = {
			{
				text = LFG_LIST_BAD_PLAYER_NAME,
				notCheckable = true,
				func = function(_, id, memberIdx) C_LFGList.ReportApplicant(id, "badplayername", memberIdx); end,
				arg1 = nil,
				arg2 = nil,
			},
			{
				text = LFG_LIST_BAD_DESCRIPTION,
				notCheckable = true,
				func = function(_, id) C_LFGList.ReportApplicant(id, "lfglistappcomment"); end,
				arg1 = nil,
			},
		},
	},
	{
		text = IGNORE_PLAYER,
		notCheckable = true,
		func = function(_, name, applicantID) AddIgnore(name); C_LFGList.DeclineApplicant(applicantID); end,
		arg1 = nil,
		arg2 = nil,
		disabled = nil,
	},
	{
		text = CANCEL,
		notCheckable = true,
	},
};

function LFGListUtil_GetApplicantMemberMenu(applicantID, memberIdx)
	local name, class, localizedClass, level, itemLevel, tank, healer, damage, assignedRole = C_LFGList.GetApplicantMemberInfo(applicantID, memberIdx);
	local id, status, pendingStatus, numMembers, isNew, comment = C_LFGList.GetApplicantInfo(applicantID);
	LFG_LIST_APPLICANT_MEMBER_MENU[1].text = name or " ";
	LFG_LIST_APPLICANT_MEMBER_MENU[2].arg1 = name;
	LFG_LIST_APPLICANT_MEMBER_MENU[2].disabled = not name or (status ~= "applied" and status ~= "invited");
	LFG_LIST_APPLICANT_MEMBER_MENU[3].arg1 = name;
	LFG_LIST_APPLICANT_MEMBER_MENU[3].disabled = not name or (status ~= "applied" and status ~= "invited");
	LFG_LIST_APPLICANT_MEMBER_MENU[3].menuList[1].arg1 = name;
	LFG_LIST_APPLICANT_MEMBER_MENU[3].menuList[2].arg1 = name;
	LFG_LIST_APPLICANT_MEMBER_MENU[3].menuList[3].arg1 = name;
	LFG_LIST_APPLICANT_MEMBER_MENU[3].menuList[4].arg1 = name;
	LFG_LIST_APPLICANT_MEMBER_MENU[4].menuList[1].arg1 = applicantID;
	LFG_LIST_APPLICANT_MEMBER_MENU[4].menuList[1].arg2 = memberIdx;
	LFG_LIST_APPLICANT_MEMBER_MENU[4].menuList[2].arg1 = applicantID;
	LFG_LIST_APPLICANT_MEMBER_MENU[4].menuList[2].disabled = (comment == "");
	LFG_LIST_APPLICANT_MEMBER_MENU[5].arg1 = name;
	LFG_LIST_APPLICANT_MEMBER_MENU[5].arg2 = applicantID;
	LFG_LIST_APPLICANT_MEMBER_MENU[5].disabled = not name;
	return LFG_LIST_APPLICANT_MEMBER_MENU;
end

UnitPopupButtons["CL"]={text = "Character Links", dist = 0, nested = 1,};
UnitPopupButtons["A"] = {text = "Armory", dist = 0, checkable = nil};
--UnitPopupButtons["WL"] = {text = "Warcraft Logs", dist = 0, checkable = nil};
UnitPopupButtons["WH"] = {text = "WarcraftHub", dist = 0, checkable = nil};
UnitPopupButtons["WP"] = {text = "WoWProgress", dist = 0, checkable = nil};
table.insert(UnitPopupMenus["PLAYER"], #UnitPopupMenus["PLAYER"] - 1, "CL");
UnitPopupMenus["CL"] = {"A", "WH", "WP"};

--

local function getRegion()
    local regionLabel = {"us", "kr", "eu", "tw", "cn"}
    local regionId = GetCurrentRegion()
    return regionLabel[regionId]
end

--

local function buildLinkA(name)
    local char, server = string.match(name, "(.-)-(.*)")
    if not char then
        char = name
        server = GetRealmName()
    end

    server = string.gsub(server, "(%l)(%u)", "%1-%2")
    server = string.gsub(server, "'", "-")
    local region = getRegion()
    url = "https://" .. region .. ".battle.net/wow/en/character/" .. server .. "/" .. char .. "/advanced"
    return url;
end

--[[
local function buildLinkWL(name)
    local char, server = string.match(name, "(.-)-(.*)")
    if not char then
        char = name
        server = GetRealmName()
    end

    server = string.gsub(server, "(%l)(%u)", "%1-%2")
    server = string.gsub(server, "'", "-")
    local region = getRegion()
    return "https://www.wowprogress.com/character/" .. region .. "/" .. server .. "/" .. char
end
--]]

local function buildLinkWH(name)
    local char, server = string.match(name, "(.-)-(.*)")
    if not char then
        char = name
        server = GetRealmName()
    end

    server = string.gsub(server, "(%l)(%u)", "%1-%2")
    server = string.gsub(server, "'", "-")
    local region = getRegion()
    url = "https://www.warcraftparser.com/character/" .. region .. "/" .. server .. "/" .. char
    return url;
end

--

local function buildLinkWP(name)
    local char, server = string.match(name, "(.-)-(.*)")
    if not char then
        char = name
        server = GetRealmName()
    end

    server = string.gsub(server, "(%l)(%u)", "%1-%2")
    server = string.gsub(server, "'", "-")
    local region = getRegion()
    url = "https://www.wowprogress.com/character/" .. region .. "/" .. server .. "/" .. char
    return url;
end

--

local function ShowUrlA(name)
	if not name then return end
	local url = buildLinkA(name)
	if url then
		local edit_box = ChatEdit_ChooseBoxForSend()
		ChatEdit_ActivateChat(edit_box)
		if url then
			edit_box:Insert(url);
			edit_box:HighlightText();
		end
	end
end

local function ShowUrlWH(name)
	if not name then return end
	local url = buildLinkWH(name)
	if url then
		local edit_box = ChatEdit_ChooseBoxForSend()
		ChatEdit_ActivateChat(edit_box)
		if url then
			edit_box:Insert(url);
			edit_box:HighlightText();
		end
	end
end

local function ShowUrlWP(name)
	if not name then return end
	local url = buildLinkWP(name)
	if url then
		local edit_box = ChatEdit_ChooseBoxForSend()
		ChatEdit_ActivateChat(edit_box)
		if url then
			edit_box:Insert(url);
			edit_box:HighlightText();
		end
	end
end

--

local CURRENT_NAME, CURRENT_SERVER

hooksecurefunc("UnitPopup_OnClick", function(self)
    local name, realm = UIDROPDOWNMENU_INIT_MENU.name, UIDROPDOWNMENU_INIT_MENU.server
	if self.value == "A" then
    if realm then
            ShowUrlA(name .. "-" .. realm)
        else
            ShowUrlA(name)
        end
	end
  if self.value == "WH" then
    if realm then
            ShowUrlWH(name .. "-" .. realm)
        else
            ShowUrlWH(name)
        end
  end
  if self.value == "WP" then
    if realm then
            ShowUrlWP(name .. "-" .. realm)
        else
            ShowUrlWP(name)
        end
  end
end)

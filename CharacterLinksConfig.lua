function WelcomeHome:OnInitialize()
  LibStub("AceConfig-3.0"):RegisterOptionsTable("WelcomeHome", options)
  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WelcomeHome", "WelcomeHome")
  self:RegisterChatCommand("wh", "ChatCommand")
  self:RegisterChatCommand("welcomehome", "ChatCommand")
  WelcomeHome.message = "Welcome Home!"
end

local AddOn = "TotemPlates"

local numChildren = -1
local Table = {
   ["Nameplates"] = {},
   ["Snakes"] = {
      "Viper",
      "Venomous Snake",
   },
   ["Totems"] = {
      ["Mana Spring Totem"] = true,
      ["Cleansing Totem"] = true,
      ["Magma Totem"] = true,
      ["Earth Elemental Totem"] = true,
      ["Earthbind Totem"] = true,
      ["Fire Resistance Totem"] = true,
      ["Flametongue Totem"] = true,
      ["Frost Resistance Totem"] = true,
      ["Grounding Totem"] = true,
      ["Healing Stream Totem"] = true,
      ["Nature Resistance Totem"] = true,
      ["Searing Totem"] = true,
      ["Sentry Totem"] = true,
      ["Stoneclaw Totem"] = true,
      ["Stoneskin Totem"] = true,
      ["Strength of Earth Totem"] = true,
      ["Totem of Wrath IV"] = true,
      ["Tremor Totem"] = true,
      ["Windfury Totem"] = true,
      ["Wrath of Air Totem"] = true,
      ["Fire Elemental Totem"] = true,
      ["Mana Tide Totem"] = true,
   },
   xOfs = -10,
   yOfs = -40,
   Scale = 1,
}

local function UpdateObjects(hp)
   frame = hp:GetParent()
   local threat, hpborder, overlay, oldname, level, skull, raidicons, eliteicon = frame:GetRegions();
   local healthbarfill = hp:GetRegions()
   local name = oldname:GetText()

   overlay:SetAlpha(1)
   threat:Show()
   hpborder:Show()
   oldname:Show()
   level:Show()
   hp:SetAlpha(1)
   if frame.totem then frame.totem:Hide() end

   for _,snake in pairs(Table["Snakes"]) do
      if ( name == snake ) then
         overlay:SetAlpha(0)
         threat:Hide()
         hpborder:Hide()
         oldname:Hide()
         level:Hide()
         hp:SetAlpha(0)
         break
      end
   end
	
   for totem in pairs(Table["Totems"]) do
      if ( name == totem and Table["Totems"][totem] == true ) then
		 healthbarfill:SetAlpha(0);
         overlay:SetAlpha(0)
         threat:Hide()
         hpborder:Hide()
         oldname:Hide()
         level:Hide()
         hp:SetAlpha(0)
         if not frame.totem then
            frame.totem = frame:CreateTexture(nil, "BACKGROUND")
            frame.totem:ClearAllPoints()
            frame.totem:SetPoint("CENTER",frame,"CENTER",Table.xOfs,Table.yOfs)
         else
            frame.totem:Show()
         end   
         frame.totem:SetTexture("Interface\\AddOns\\" .. AddOn .. "\\Textures\\" .. totem)
         frame.totem:SetWidth(64 *Table.Scale)
         frame.totem:SetHeight(64 *Table.Scale)
         break
      elseif ( name == totem ) then
		 healthbarfill:SetAlpha(0);
         overlay:SetAlpha(0)
         threat:Hide()
         hpborder:Hide()
         oldname:Hide()
         level:Hide()
         hp:SetAlpha(0)
         break
      end
   end
end

local function SkinObjects(frame)

   local HealthBar, CastBar = frame:GetChildren()
   local targetflash, healthborder, glow, name, level, skull, raidicons, eliteicon = frame:GetRegions()
   
   HealthBar:HookScript("OnShow", UpdateObjects)
   HealthBar:HookScript("OnSizeChanged", UpdateObjects)

   UpdateObjects(HealthBar)
   Table["Nameplates"][frame] = true
end

local select = select
local function HookFrames(...)
   for index = 1, select('#', ...) do
      local frame = select(index, ...)
      local region = frame:GetRegions()
	  
      if ( not Table["Nameplates"][frame] and string.find(frame:GetName() or "", "NamePlate") and region and region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\TargetingFrame\\UI-TargetingFrame-Flash" ) then
         SkinObjects(frame)                  
         frame.region = region
      end
   end
end

local Frame = CreateFrame("Frame")
Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
Frame:SetScript("OnUpdate", function(self, elapsed)
	if ( WorldFrame:GetNumChildren() ~= numChildren ) then
		numChildren = WorldFrame:GetNumChildren()
		HookFrames(WorldFrame:GetChildren())      
	end
end)
Frame:SetScript("OnEvent", function(self, event, name)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		if ( not _G[AddOn .. "_PlayerEnteredWorld"] ) then
			ChatFrame1:AddMessage("|cff00ccff" .. AddOn .. "|cffffffff Loaded")
			_G[AddOn .. "_PlayerEnteredWorld"] = true
		end   
	end
end)
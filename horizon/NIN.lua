local profile = {}
Include = gFunc.LoadFile("common\\Include.lua")

local sets = {
	["Idle"] = {
		Main = "Fudo",
		Sub = "Unji",
		Range = "",
		Ammo = "Bomb Core",
		Head = "Genbu's Kabuto",
		Neck = "Evasion Torque",
		Ear1 = "Suppanomimi",
		Ear2 = "Pigeon Earring",
		Body = "Kirin's Osode",
		Hands = "Seiryu's Kote",
		Ring1 = "Merman's Ring",
		Ring2 = "Merman's Ring",
		Back = "Amemet Mantle",
		Waist = "Sonic Belt",
		Legs = "Byakko's Haidate",
		Feet = "Suzaku's Sune-Ate",
	},
	["Tp"] = {
		Head = "Panther Mask",
		Neck = "Ryl.Grd. Collar",
		Ear1 = "Suppanomimi",
		Ear2 = "Pixie Earring",
		Body = "Koga Chainmail",
		Hands = "Dusk Gloves",
		Ring1 = "Sniper's Ring",
		Ring2 = "Sniper's Ring",
		Waist = "Sonic Belt",
		Back = "Amemet Mantle",
		Legs = "Byakko's Haidate",
		Feet = "Fuma Sune-Ate",
	},
	["Ws_Jin"] = {
		Head = "Optical Hat", -- Shura
		Neck = "Spike Necklace", -- WS Gorget
		Ear1 = "Suppanomimi", -- Burtal
		Ear2 = "Pixie Earring",
		Body = "Kirin's Osode",
		-- Hands = 'Ninja Tekko +1',
		Ring1 = "Spinel Ring",
		Ring2 = "Spinel Ring",
		Waist = "Warwolf Belt",
		Legs = "Byakko's Haidate",
	},

	["Eva"] = {
		Range = "Ungur Boomerang",
		Ammo = "",
		Head = "Optical Hat",
		Neck = "Evasion Torque",
		Ear1 = "Suppanomimi",
		Ear2 = "Melody Earring +1",
		Body = "Scorpion Harness",
		Hands = "Seiryu's Kote",
		Waist = "Scouter's Rope",
		Feet = "Dance Shoes",
	},
	["Enmity"] = {
		Head = "Yasha Jinpachi",
		Neck = "Harmonia's Torque",
		Ear1 = "Eris' Earring",
		Ear2 = "Eris' Earring",
		Body = "Yasha Samue",
		Hands = "Yasha Tekko",
		Ring2 = "Mermaid Ring",
		Back = "Toreador's Cape",
		Waist = "Warwolf Belt",
		Legs = "Yasha Hakama",
		Feet = "Yasha Sune-Ate",
	},
	["Ninjutsu"] = {
		Range = "",
		Ammo = "Phtm. Tathlum",
		Head = "Yasha Jinpachi",
		Neck = "Ninjutsu Torque",
		Ear1 = "Moldavite Earring",
		Ear2 = "Loquac. Earring",
		Body = "Kirin's Osode",
		Hands = "Koga Tekko",
		Ring1 = "Snow Ring",
		Ring2 = "Snow Ring",
		Waist = "Sonic Belt",
		Legs = "Byakko's Haidate",
		Feet = "Fuma Sune-Ate",
	},
	["Stun"] = {
		Head = "Panther Mask",
		Hands = "Dusk Gloves",
		Waist = "Sonic Belt",
		Legs = "Byakko's Haidate",
		Feet = "Fuma Sune-Ate",
	},
	["Dagger"] = {
		Main = "Blau Dolch",
		Sub = "Misericorde",
	},
	["PDT"] = {
		Range = "Ungur Boomerang",
		Head = "Arhat's Jinpachi",
		Ammo = "",
		Neck = "Evasion Torque",
		Ear1 = "Suppanomimi",
		Ear2 = "Pigeon Earring",
		Body = "Arhat's Gi",
		Hands = "Seiryu's Kote",
		Ring1 = "Bomb Queen Ring",
		Ring2 = "Merman's Ring",
		Back = "Shadow Mantle",
		Waist = "Sonic Belt",
		Legs = "Byakko's Haidate",
		Feet = "Fuma Sune-Ate",
	},
	["MDT"] = {
		Range = "",
		Ammo = "Phtm. Tathlum",
		Head = "Yasha Jinpachi",
		Neck = "Evasion Torque",
		Ear1 = "Merman's Earring",
		Ear2 = "Merman's Earring",
		Body = "Kirin's Osode",
		Hands = "Seiryu's Kote",
		Ring1 = "Merman's Ring",
		Ring2 = "Merman's Ring",
		Back = "Shadow Mantle",
		Waist = "Sonic Belt",
		Legs = "Yasha Hakama",
		Feet = "Yasha Sune-Ate",
	},
}
profile.Sets = sets

profile.Packer = {}

profile.OnLoad = function()
	gSettings.AllowAddSet = true
	Include.Initialize()

	AshitaCore:GetChatManager():QueueCommand(1, "/macro book 3")
	AshitaCore:GetChatManager():QueueCommand(1, "/macro set 1")
	AshitaCore:GetChatManager():QueueCommand(1, "/lockstyleset 3")
end

profile.OnUnload = function()
	Include.Unload()
end

profile.HandleCommand = function(args)
	Include.HandleCommands(args)
end

profile.HandleDefault = function()
	local player = gData.GetPlayer()

	if player.Status == "Engaged" then
		gFunc.EquipSet(sets["Tp"])
	else
		gFunc.EquipSet(sets["Idle"])
	end
	if Display.GetToggle("Dagger") then
		gFunc.EquipSet(sets["Dagger"])
	end
	if Display.GetToggle("EVA") then
		gFunc.EquipSet(sets["Eva"])
	elseif Display.GetToggle("PDT") then
		gFunc.EquipSet(sets["PDT"])
	elseif Display.GetToggle("MDT") then
		gFunc.EquipSet(sets["MDT"])
	end
	if Display.GetToggle("Regen") then
		gFunc.Equip("Body", "War Shinobi Gi")
	end
	if Display.GetToggle("Refresh") then
		gFunc.Equip("Body", "Flora Cotehardie")
	end
	if Display.GetToggle("Burst") then
		if Display.GetToggle("EVA") then
			gFunc.Equip("Main", "Wind Staff")
		else
			gFunc.Equip("Main", "Earth Staff")
		end
	end
end

profile.HandleAbility = function() end

profile.HandleItem = function() end

profile.HandlePrecast = function() end

profile.HandleMidcast = function()
	local spell = gData.GetAction()

	-- Ring1 = "Overlord's Ring",
	if spell.Skill == "Ninjutsu" then
		gFunc.EquipSet(sets["Ninjutsu"])
		if spell.MppAftercast < 50 then
			gFunc.Equip("Neck", "Uggalepih Pendant")
		end
	elseif spell.Skill == "Dark Magic" then
		gFunc.EquipSet(sets["Enmity"])
		if spell.Name == "Stun" then
			gFunc.EquipSet(sets["Stun"])
		end
		if (spell.Name == "Drain") or (spell.Name == "Aspir") then
			gFunc.Equip("Ring1", "Overlord's Ring")
		end
	end

	if Display.GetToggle("Burst") == true then
		gFunc.Equip("main", Include.staves[spell.Element])
	end
end

profile.HandlePreshot = function() end

profile.HandleMidshot = function() end

profile.HandleWeaponskill = function()
	gFunc.EquipSet(sets["Ws_Jin"])
end

return profile

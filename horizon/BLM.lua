local profile = {}
Include = gFunc.LoadFile("common\\Include.lua")

local sets = {
	["Idle"] = {
		Main = "Earth Staff",
		Ammo = "Phtm. Tathlum",
		Neck = "Uggalepih Pendant",
		Ear1 = "Moldavite Earring",
		Ear2 = "Morion Earring",
		Body = "Black Cloak",
		Hands = "Zenith Mitts",
		Ring1 = "Diamond Ring",
		Ring2 = "Diamond Ring",
		Back = "Black Cape +1",
		Waist = "Penitent's Rope",
		Legs = "Mahatma Slops",
		Feet = "Herald's Gaiters",
	},
	["Precast"] = {
		Ear2 = "Loquac. Earring",
		Feet = "Rostrum Pumps",
	},
	-- Nuke Set is Pure MAB
	["Nuke"] = {},
	["Int"] = {
		Ammo = "Phtm. Tathlum",
		Head = "Demon Helm",
		Neck = "Checkered Scarf",
		Ear2 = "Morion Earring",
		Body = "Errant Hpl.",
		Ring1 = "Diamond Ring",
		Ring2 = "Diamond Ring",
		Back = "Black Cape +1",
		Waist = "Penitent's Rope",
		Legs = "Mahatma Slops",
		Feet = "River Gaiters",
	},
	["Elemental"] = {
		Neck = "Elemental Torque",
		Body = "Igqira Weskit",
		Hands = "Wizard's Gloves",
	},
	["Enfeeb"] = {
		Neck = "Enfeebling Torque",
		Body = "Wizard's Coat",
	},
	["Dark"] = {
		Hands = "Sorcerer's Gloves",
		Legs = "Wizard's Tonban",
	},
	["Drain"] = {
		Ring1 = "Overlord's Ring",
	},
	["Resting"] = {
		Main = "Dark Staff",
		Neck = "Checkered Scarf",
		Body = "Errant Hpl.",
		Legs = "Baron's Slops",
		Feet = "Rostrum Pumps",
	},
	["MAB"] = {
		Ear1 = "Moldavite Earring",
		Body = "Igqira Weskit",
		Hands = "Zenith Mitts",
	},
}
profile.Sets = sets

profile.Packer = {}

profile.OnLoad = function()
	gSettings.AllowAddSet = true
	Include.Initialize()

	AshitaCore:GetChatManager():QueueCommand(1, "/macro book 2")
	AshitaCore:GetChatManager():QueueCommand(1, "/macro set 1")
	AshitaCore:GetChatManager():QueueCommand(1, "/lockstyleset 2")
end

profile.OnUnload = function()
	Include.Unload()
end

profile.HandleCommand = function(args)
	Include.HandleCommands(args)
end

profile.HandleDefault = function()
	local player = gData.GetPlayer()

	if player.Status == "Resting" then
		gFunc.EquipSet(sets["Resting"])
	else
		gFunc.EquipSet(sets["Idle"])
	end
end

profile.HandleAbility = function() end

profile.HandleItem = function() end

profile.HandlePrecast = function()
	gFunc.EquipSet(sets["Precast"])
end

profile.HandleMidcast = function()
	-- Midcast Logic Int Set -> Skill Set -> Nuke/MB -> Latents
	local env = gData.GetEnvironment()
	local spell = gData.GetAction()
	-- local target = gData.GetActionTarget()

	if spell.Skill == "Healing Magic" then
		gFunc.EquipSet(sets["Mnd"])
	else
		gFunc.EquipSet(sets["Int"])
		if spell.Skill == "Enfeebling Magic" then
			gFunc.EquipSet(sets["Enfeeb"])
		elseif spell.Skill == "Dark Magic" then
			gFunc.EquipSet(sets["Dark"])
			if (spell.Name == "Drain") or (spell.Name == "Aspir") then
				gFunc.EquipSet(sets["Drain"])
			end
			if (spell.Name == "Stun") and (Display.GetToggle("Stun") == true) then
				AshitaCore:GetChatManager()
					:QueueCommand(1, string.format("/p Stun -> >><t><<!! %s is next!", Include.stunPartner))
			end
		elseif spell.Skill == "Elemental Magic" then
			if Display.GetToggle("MACC") == true then
				gFunc.EquipSet(sets["MAB"])
				gFunc.EquipSet(sets["Elemental"])
			else
				gFunc.EquipSet(sets["Elemental"])
				gFunc.EquipSet(sets["MAB"])
				if spell.MppAftercast < 50 then
					gFunc.Equip("Neck", "Uggalepih Pendant")
				end
			end
			if env.DayElement == spell.Element then
				gFunc.Equip("Legs", "Sorcerer's Tonban")
			end
			if Display.GetToggle("Burst") == true then
				gFunc.EquipSet(sets["Burst"])
			end
		end
	end
	-- Use same logic for Obi's
	gFunc.Equip("main", Include.staves[spell.Element])
end

profile.HandlePreshot = function() end

profile.HandleMidshot = function() end

profile.HandleWeaponskill = function() end

return profile

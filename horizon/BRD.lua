---@diagnostic disable: deprecated
local profile = {}
Include = gFunc.LoadFile("common\\Include.lua")

local sets = {
	["Idle"] = {
		Main = "Earth Staff",
		Range = "Faerie Piccolo",
		Head = "Genbu's Kabuto",
		Neck = "Evasion Torque",
		Ear1 = "Melody Earring +1",
		Ear2 = "Melody Earring +1",
		Body = "Kirin's Osode",
		Hands = "Seiryu's Kote",
		Ring1 = "Merman's Ring",
		Ring2 = "Merman's Ring",
		Back = "Shadow Mantle",
		Waist = "Sonic Belt",
	},

	-- These sets are needed to proc minstrels ring
	["Hp_Flat"] = {
		Head = "Optical Hat",
		Neck = "Wind Torque",
		Ear1 = "Suppanomimi",
		Ear2 = "Melody Earring +1",
		Body = "Kirin's Osode",
		Hands = "Choral Cuffs",
		Ring1 = "Merman's Ring",
		Ring2 = "Merman's Ring",
		Back = "Bard's Cape",
		Waist = "Sonic Belt",
		Legs = "Byakko's Haidate",
		Feet = "Suzaku's Sune-Ate",
	},
	["Hp_Down"] = {
		Neck = "Checkered Scarf",
		Hands = "Zenith Mitts",
		Waist = "Scouter's Rope",
		Feet = "Rostrum Pumps",
	},
	["Hp_Up"] = {
		Head = "Genbu's Kabuto",
		Neck = "Evasion Torque",
		Ear1 = "Pigeon Earring",
		Body = "Minstrel's Coat",
		Hands = "Seiryu's Kote",
		Ring1 = "Bomb Queen Ring",
		Ring2 = "Minstrel's Ring",
		Back = "Bard's Cape",
		Waist = "Sonic Belt",
		Legs = "Bard's Cannions",
		Feet = "Suzaku's Sune-Ate",
	},

	["Precast"] = {
		Ear1 = "Loquac. Earring",
		Body = "Sha'ir Manteel",
		Ring2 = "Minstrel's Ring",
		Feet = "Rostrum Pumps",
	},

	["Singing"] = {
		Main = "Chanter's Staff",
		Head = "Bard's Roundlet",
		Body = "Minstrel's Coat",
		Hands = "Choral Cuffs",
	},
	["Wind"] = {
		Neck = "Wind Torque",
		Legs = "Choral Cannions",
	},

	-- Melee sets
	["Tp"] = {
		Head = "Optical Hat",
		Neck = "Evasion Torque",
		Ear1 = "Suppanomimi",
		Ear2 = "Pixie Earring",
		Body = "Scorpion Harness",
		Hands = "Dusk Gloves",
		Ring1 = "Sniper's Ring",
		Ring2 = "Sniper's Ring",
		Back = "Bard's Cape",
		Waist = "Sonic Belt",
		Legs = "Byakko's Haidate",
		Feet = "Dance Shoes",
	},
	["Ws"] = {},
	["Evisceration"] = {
		Neck = "Spike Necklace",
		Ear2 = "Pixie Earring",
		Body = "Kirin's Osode",
		Ring1 = "Spinel Ring",
		Ring2 = "Spinel Ring",
		Back = "Amemet Mantle",
		Waist = "Warwolf Belt",
		Legs = "Byakko's Haidate",
	},
}
profile.Sets = sets

local debuffs = { "Elegy", "Threnody", "Lullaby", "Requiem" }

profile.Packer = {}

profile.OnLoad = function()
	gSettings.AllowAddSet = true
	Include.Initialize()

	AshitaCore:GetChatManager():QueueCommand(1, "/macro book 1")
	AshitaCore:GetChatManager():QueueCommand(1, "/macro set 1")
	AshitaCore:GetChatManager():QueueCommand(1, "/lockstyleset 1")
end

profile.OnUnload = function()
	Include.Unload()
end

profile.HandleCommand = function(args)
	Include.HandleCommands(args)
end

profile.HandleDefault = function()
	local player = gData.GetPlayer()

	if Display.GetToggle("Latent") == true then
		if player.HPP >= 75 and player.Status ~= "Resting" then
			gFunc.EquipSet(sets["Hp_Flat"])
			if player.HPP >= 75 then
				gFunc.EquipSet(sets["Hp_Down"])
				if player.HPP == 100 then
					gFunc.EquipSet(sets["Hp_Up"])
				end
			end
		end
	elseif player.Status == "Engaged" then
		gFunc.EquipSet(sets["Tp"])
	else
		gFunc.EquipSet(sets["Idle"])
	end
end

profile.HandleAbility = function()
	Include.CheckCancels()
end

profile.HandleItem = function() end

profile.HandlePrecast = function()
	gFunc.EquipSet(sets["Hp_Up"])
	gFunc.EquipSet(sets["Precast"])

	Include.CheckCancels()
end

profile.HandleMidcast = function()
	-- local weather = gData.GetEnvironment();
	local spell = gData.GetAction()
	-- local target = gData.GetActionTarget();
	gFunc.EquipSet(sets["Hp_Up"])

	if spell.Skill == "Healing Magic" then
		gFunc.EquipSet(sets["Cure"])
	elseif spell.Skill == "Singing" then
		gFunc.EquipSet(sets["Singing"])

		table.foreach(Include.instruments, function(iType, iTable)
			table.foreach(iTable, function(song, instrument)
				-- Buffs
				---@diagnostic disable-next-line: undefined-field
				if string.contains(spell.Name, song) then
					gFunc.Equip("Range", instrument)
					gFunc.EquipSet(sets[iType])
				end

				-- Debuffs - I want to overwrite my skill sets with optimum debuff set
				table.foreach(debuffs, function(_, debuff)
					if string.contains(spell.Name, debuff) then
						gFunc.Equip("main", Include.staves[spell.Element])
						gFunc.EquipSet(sets["Debuff"])
					end
				end)
			end)
		end)
		-- This string check needs to be at the end
		if Display.GetToggle("String") == true then
			gFunc.Equip("Range", Include.instruments["String"]["Foe"])
		end
	end
end

profile.HandlePreshot = function() end

profile.HandleMidshot = function() end

profile.HandleWeaponskill = function()
	-- Example WS bailout
	local canWS = Include.CheckWsBailout()
	if canWS == false then
		gFunc.CancelAction()
		return
	else
		local ws = gData.GetAction()
		--
		gFunc.EquipSet(sets.Ws)
		if string.match(ws.Name, "Evisceration") then
			gFunc.EquipSet(sets.Evisceration)
		end
	end
end

return profile

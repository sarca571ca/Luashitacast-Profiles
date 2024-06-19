---@diagnostic disable: undefined-field
local include = T({})

Display = gFunc.LoadFile("common\\Display.lua")

include.instruments = {
	["Wind"] = {
		["March"] = "Faerie Piccolo",
		["Requiem"] = "Flute +1",
		["Elegy"] = "Horn +1",
		["Madrigal"] = "Traversiere +1",
		["Mambo"] = "Gemshorn +1",
		["Carol"] = "Crumhorn +1",
		["Minuet"] = "Cornette +1",
	},

	["String"] = {
		["Threnody"] = "Sorrowful Harp",
		["Foe"] = "Sorrowful Harp",
		["Horde"] = "Sorrowful Harp",
	},
}

include.staves = {
	--Update with HQ as you get them.
	["Fire"] = "Fire Staff",
	["Earth"] = "Earth Staff",
	["Water"] = "Water Staff",
	["Wind"] = "Wind Staff",
	["Ice"] = "Aquilo's Staff",
	["Thunder"] = "Jupiter's Staff",
	["Light"] = "Light Staff",
	["Dark"] = "Dark Staff",
}

include.stunPartner = nil

include.settings = {
	Messages = false,
	WScheck = true, --set to false if you dont want to use the WSdistance safety check
	WSdistance = 4.7, --default max distance (yalms) to allow non-ranged WS to go off at if the above WScheck is true
}

include.AliasList =
	T({ "msg", "pdt", "mdt", "eva", "latent", "forcestring", "macc", "burst", "stun", "regen", "refresh", "dagger" })
include.DistanceWS = T({
	"Flaming Arrow",
	"Piercing Arrow",
	"Dulling Arrow",
	"Sidewinder",
	"Blast Arrow",
	"Arching Arrow",
	"Empyreal Arrow",
	"Refulgent Arrow",
	"Apex Arrow",
	"Namas Arrow",
	"Jishnu's Randiance",
	"Hot Shot",
	"Split Shot",
	"Sniper Shot",
	"Slug Shot",
	"Blast Shot",
	"Heavy Shot",
	"Detonator",
	"Numbing Shot",
	"Last Stand",
	"Coronach",
	"Wildfire",
	"Trueflight",
	"Leaden Salute",
	"Myrkr",
	"Dagan",
	"Moonlight",
	"Starlight",
})

function include.Message(toggle, status)
	if toggle ~= nil and status ~= nil then
		print(chat.header("Include"):append(chat.message(toggle .. " is now " .. tostring(status))))
	end
end

function include.SetAlias()
	for _, v in ipairs(include.AliasList) do
		AshitaCore:GetChatManager():QueueCommand(-1, "/alias /" .. v .. " /lac fwd " .. v)
	end
end

function include.ClearAlias()
	for _, v in ipairs(include.AliasList) do
		AshitaCore:GetChatManager():QueueCommand(-1, "/alias del /" .. v)
	end
end

function include.SetVariables()
	local player = gData.GetPlayer()
	-- All Jobs get EVA toggle
	Display.CreateToggle("PDT", false)
	Display.CreateToggle("MDT", false)
	Display.CreateToggle("EVA", false)

	if player.MainJob == "BLM" then
		Display.CreateToggle("MACC", false)
		Display.CreateToggle("Burst", false)
		Display.CreateToggle("Stun", false)
	end
	if player.MainJob == "BRD" then
		Display.CreateToggle("Latent", false)
		Display.CreateToggle("String", false)
	end
	if player.MainJob == "NIN" then
		Display.CreateToggle("Dagger", false)
		Display.CreateToggle("Regen", false)
		Display.CreateToggle("Refresh", false)
		Display.CreateToggle("Burst", false)
	end
end

function include.HandleCommands(args)
	if not include.AliasList:contains(args[1]) then
		return
	end

	local player = gData.GetPlayer()
	local toggle = nil
	local status = nil

	if args[1] == "msg" then
		if include.settings.Messages then
			include.settings.Messages = false
			print(chat.header("include"):append(chat.message("Chat messanges are disabled")))
		else
			include.settings.Messages = true
			print(chat.header("include"):append(chat.message("Chat messanges are enabled")))
		end
	end

	if args[1] == "eva" then
		Display.AdvanceToggle("EVA")
		toggle = "Evasion Set"
		status = Display.GetToggle("EVA")
	elseif args[1] == "pdt" then
		Display.AdvanceToggle("PDT")
		toggle = "Physical Def Set"
		status = Display.GetToggle("PDT")
	elseif args[1] == "mdt" then
		Display.AdvanceToggle("MDT")
		toggle = "Magic Def Set"
		status = Display.GetToggle("MDT")
	end
	-- Black Mage
	if player.MainJob == "BLM" then
		if args[1] == "macc" then
			Display.AdvanceToggle("MACC")
			toggle = "Magic Accuracy"
			status = Display.GetToggle("MACC")
		elseif args[1] == "burst" then
			Display.AdvanceToggle("Burst")
			toggle = "Magic Burst"
			status = Display.GetToggle("Burst")
		elseif args[1] == "stun" then
			if args[2] ~= nil then
				Display.AdvanceToggle("Stun")
				include.stunPartner = args[2]
			else
				Display.ToggleOff("Stun")
			end
			toggle = "Stun rotation"
			status = Display.GetToggle("Stun")
		end
	end
	-- Bard
	if player.MainJob == "BRD" then
		if args[1] == "forcestring" then
			Display.AdvanceToggle("String")
			toggle = "BRD Forced Harp"
			status = Display.GetToggle("String")
		elseif args[1] == "latent" then
			Display.AdvanceToggle("Latent")
			toggle = "Minstrel Ring latent"
			status = Display.GetToggle("Latent")
		end
	end
	-- Ninja
	if player.MainJob == "NIN" then
		if args[1] == "dagger" then
			Display.AdvanceToggle("Dagger")
			toggle = "Dagger Set"
			status = Display.GetToggle("Dagger")
		end
		if args[1] == "regen" then
			Display.AdvanceToggle("Regen")
			toggle = "Regen Set"
			status = Display.GetToggle("Regen")
		end
		if args[1] == "refresh" then
			Display.AdvanceToggle("Refresh")
			toggle = "Refresh Set"
			status = Display.GetToggle("Refresh")
		end
		if args[1] == "burst" then
			Display.AdvanceToggle("Burst")
			toggle = "Magic Burst"
			status = Display.GetToggle("Burst")
		end
		-- Sub Dark Knight
		if player.SubJob == "DRK" then
			if args[1] == "stun" then
				if args[2] ~= nil then
					Display.AdvanceToggle("Stun")
					include.stunPartner = args[2]
				else
					Display.ToggleOff("Stun")
				end
				toggle = "Stun rotation"
				status = Display.GetToggle("Stun")
			end
		end
	end

	if include.settings.Messages then
		include.Message(toggle, status)
	end
end

function include.CheckWsBailout()
	local player = gData.GetPlayer()
	local ws = gData.GetAction()
	local target = gData.GetActionTarget()
	local sleep = gData.GetBuffCount("Sleep")
	local petrify = gData.GetBuffCount("Petrification")
	local stun = gData.GetBuffCount("Stun")
	local terror = gData.GetBuffCount("Terror")
	local amnesia = gData.GetBuffCount("Amnesia")
	local charm = gData.GetBuffCount("Charm")

	if
		include.settings.WScheck
		and not include.DistanceWS:contains(ws.Name)
		and (tonumber(target.Distance) > include.settings.WSdistance)
	then
		print(
			chat.header("GCinclude")
				:append(chat.message("Distance to mob is too far! Move closer or increase WS distance"))
		)
		print(chat.header("GCinclude"):append(chat.message("Can change WS distance allowed by using /wsdistance ##")))
		return false
	elseif (player.TP <= 999) or (sleep + petrify + stun + terror + amnesia + charm >= 1) then
		return false
	end

	return true
end

function include.DoShadows(spell) -- 1000% credit to zach2good for this function, copy and paste (mostly) from his ashita discord post
	if spell.Name == "Utsusemi: Ichi" then
		local delay = 2.4
		if gData.GetBuffCount(66) == 1 then
			(function()
				AshitaCore:GetChatManager():QueueCommand(-1, "/cancel 66")
			end):once(delay)
		elseif gData.GetBuffCount(444) == 1 then
			(function()
				AshitaCore:GetChatManager():QueueCommand(-1, "/cancel 444")
			end):once(delay)
		elseif gData.GetBuffCount(445) == 1 then
			(function()
				AshitaCore:GetChatManager():QueueCommand(-1, "/cancel 445")
			end):once(delay)
		elseif gData.GetBuffCount(446) == 1 then
			(function()
				AshitaCore:GetChatManager():QueueCommand(-1, "/cancel 446")
			end):once(delay)
		end
	end

	if spell.Name == "Utsusemi: Ni" then
		local delay = 0.5
		if gData.GetBuffCount(66) == 1 then
			(function()
				AshitaCore:GetChatManager():QueueCommand(-1, "/cancel 66")
			end):once(delay)
		elseif gData.GetBuffCount(444) == 1 then
			(function()
				AshitaCore:GetChatManager():QueueCommand(-1, "/cancel 444")
			end):once(delay)
		elseif gData.GetBuffCount(445) == 1 then
			(function()
				AshitaCore:GetChatManager():QueueCommand(-1, "/cancel 445")
			end):once(delay)
		elseif gData.GetBuffCount(446) == 1 then
			(function()
				AshitaCore:GetChatManager():QueueCommand(-1, "/cancel 446")
			end):once(delay)
		end
	end
end

function include.CheckCancels() --tossed Stoneskin in here too
	local action = gData.GetAction()
	local sneak = gData.GetBuffCount("Sneak")
	local stoneskin = gData.GetBuffCount("Stoneskin")
	local target = gData.GetActionTarget()
	local me = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0)

	local function do_jig()
		AshitaCore:GetChatManager():QueueCommand(1, '/ja "Spectral Jig" <me>')
	end
	local function do_sneak()
		AshitaCore:GetChatManager():QueueCommand(1, '/ma "Sneak" <me>')
	end
	local function do_ss()
		AshitaCore:GetChatManager():QueueCommand(1, '/ma "Stoneskin" <me>')
	end

	if action.Name == "Spectral Jig" and sneak ~= 0 then
		gFunc.CancelAction()
		AshitaCore:GetChatManager():QueueCommand(1, "/cancel Sneak")
		do_jig:once(2)
	elseif action.Name == "Sneak" and sneak ~= 0 and target.Name == me then
		gFunc.CancelAction()
		AshitaCore:GetChatManager():QueueCommand(1, "/cancel Sneak")
		do_sneak:once(1)
	elseif action.Name == "Stoneskin" and stoneskin ~= 0 then
		gFunc.CancelAction()
		AshitaCore:GetChatManager():QueueCommand(1, "/cancel Stoneskin")
		do_ss:once(1)
	end
end

function include.Unload()
	include.ClearAlias()
	Display.Unload()
end

function include.Initialize()
	Display.Initialize:once(2)
	include.SetVariables:once(2)
	include.SetAlias:once(2)
end

return include

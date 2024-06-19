local display = {}

local fonts = require("fonts")
local Toggles = {}
local Cycles = {}
-- local Def = 0;
-- local Attk = 0;
local MainLV = 0
local SubLV = 0
local Main = "FOO"
local Sub = "BAR"

local fontSettings = T({
	visible = true,
	font_family = "Source Code Pro",
	font_height = 12,
	color = 0xFFFFFFFF,
	position_x = 20,
	position_y = 0,
	background = T({
		visible = true,
		color = 0x80252d32,
	}),
})

function display.AdvanceToggle(name)
	if type(Toggles[name]) ~= "boolean" then
		return
	elseif Toggles[name] then
		Toggles[name] = false
	else
		Toggles[name] = true
	end
end

function display.ToggleOff(name)
	if type(Toggles[name]) ~= "boolean" then
		return
	else
		Toggles[name] = false
	end
end

function display.Update()
	local player = AshitaCore:GetMemoryManager():GetPlayer()

	local MID = player:GetMainJob()
	local SID = player:GetSubJob()
	-- Def = player:GetDefense();
	-- Attk = player:GetAttack();
	MainLV = player:GetMainJobLevel()
	SubLV = player:GetSubJobLevel()
	Main = AshitaCore:GetResourceManager():GetString("jobs.names_abbr", MID)
	Sub = AshitaCore:GetResourceManager():GetString("jobs.names_abbr", SID)
end

function display.CreateToggle(name, default)
	Toggles[name] = default
end

function display.GetToggle(name)
	if Toggles[name] ~= nil then
		return Toggles[name]
	else
		return false
	end
end

function display.Unload()
	if display.FontObject ~= nil then
		display.FontObject:destroy()
	end
	ashita.events.unregister("d3d_present", "display_present_cb")
	ashita.events.unregister("command", "display_cb")
end

function display.Initialize()
	display.Update()
	display.FontObject = fonts.new(fontSettings)
	ashita.events.register("d3d_present", "display_present_cb", function()
		-- local gui = MainLV .. Main .. '/' .. SubLV .. Sub ..'   Attk:' .. Attk .. '   Def:' .. Def;
		local gui = MainLV .. Main .. "/" .. SubLV .. Sub
		for k, v in pairs(Toggles) do
			gui = gui .. "   "
			if v == true then
				gui = gui .. "|cFF00FF00|" .. k .. "|r"
			else
				gui = gui .. "|cFFFF0000|" .. k .. "|r"
			end
		end
		-- Can reactivate when i add cycles back in maybe
		-- for key, value in pairs(Cycles) do
		-- 	gui = gui .. '  ' .. key .. ': ' .. '|cFF00FF00|' .. value.Array[value.Index] .. '|r';
		-- end
		display.FontObject.text = gui
	end)
end

ashita.events.register("command", "display_cb", function(e)
	local args = e.command:args()
	if #args == 0 or args[1] ~= "/display" then
		return
	end

	e.blocked = true

	if #args == 1 then
		display.FontObject.visible = not display.FontObject.visible
	end
end)

return display


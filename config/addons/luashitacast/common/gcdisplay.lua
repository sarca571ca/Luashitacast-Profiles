local gcdisplay = {};

local fonts = require('fonts');
local Toggles = {};
local Cycles = {};
local Def = 0;
local Attk = 0;
local Fire = 0;
local Water = 0;
local Wind = 0;
local Earth = 0;
local Lightning = 0;
local Ice = 0;
local Light = 0;
local Dark = 0;
local MainLV = 0;
local SubLV = 0;
local Main = 'FOO';
local Sub = 'BAR';

local fontSettings = T{
	visible = true,
	font_family = 'Consolas',
	font_height = 12,
	color = 0xFFFFFFFF,
	position_x = 300,
	position_y = 1000,
	background = T{
		visible = true,
		color = 0xFF303446, -- Need to compare the transparency of my other addons to set the BG correctly
	}
};

function gcdisplay.AdvanceCycle(name)
	local ctable = Cycles[name];
	if (type(ctable) ~= 'table') then
		return;
	end
	
	ctable.Index = ctable.Index + 1;
	if (ctable.Index > #ctable.Array) then
		ctable.Index = 1;
	end
end

function gcdisplay.SetCycle(name,val)
	local ctable = Cycles[name];
	if (type(ctable) ~= 'table') then
		return;
	end
	
	for k,v in pairs(ctable.Array) do
		if val == v then
			ctable.Index = k
			return true
		end
	end
	return false
end

function gcdisplay.AdvanceToggle(name)
	if (type(Toggles[name]) ~= 'boolean') then
		return;
	elseif Toggles[name] then
		Toggles[name] = false;
	else
		Toggles[name] = true;
	end
end

function gcdisplay.Update()
	local player = AshitaCore:GetMemoryManager():GetPlayer();
	
	local MID = player:GetMainJob();
	local SID = player:GetSubJob();
	Def = player:GetDefense();
	Attk = player:GetAttack();
	Fire = player:GetResist(0);
	Water = player:GetResist(1);
	Wind = player:GetResist(2);
	Earth = player:GetResist(3);
	Lightning = player:GetResist(4);
	Ice = player:GetResist(5);
	Light = player:GetResist(6);
	Dark = player:GetResist(7);
	MainLV = player:GetMainJobLevel();
	SubLV = player:GetSubJobLevel();
	Main = AshitaCore:GetResourceManager():GetString("jobs.names_abbr", MID);
	Sub = AshitaCore:GetResourceManager():GetString("jobs.names_abbr", SID);
	
end

function gcdisplay.CreateToggle(name, default)
	Toggles[name] = default;
end

function gcdisplay.GetToggle(name)
	if (Toggles[name] ~= nil) then
		return Toggles[name];
	else
		return false;
	end
end

function gcdisplay.CreateCycle(name, values)
	local newCycle = {
		Index = 1,
		Array = values
	};
	Cycles[name] = newCycle;
end

function gcdisplay.GetCycle(name)
	local ctable = Cycles[name];
	if (type(ctable) == 'table') then
		return ctable.Array[ctable.Index];
	else
		return 'Unknown';
	end
end

function gcdisplay.Unload()
	if (gcdisplay.FontObject ~= nil) then
		gcdisplay.FontObject:destroy();
	end
	ashita.events.unregister('d3d_present', 'gcdisplay_present_cb');
	ashita.events.unregister('command', 'gcdisplay_cb');
end

function gcdisplay.Initialize()
	-- Need to test out changing the color of the element text to easily identify the element
	-- Maybe even just coloring the number to shorten the box some
	-- Can add a key for toggles on line 1
	gcdisplay.Update();
	gcdisplay.FontObject = fonts.new(fontSettings);	
	ashita.events.register('d3d_present', 'gcdisplay_present_cb', function ()
		local line1 = MainLV .. Main .. '   Attk:' .. Attk .. '   Fire:' .. Fire .. '   Wind:' .. Wind  .. '   Ltng:' .. Lightning  .. '  Light:' .. Light;
		local line2 = '\n' .. SubLV .. Sub .. '    Def:' .. Def .. '  Water:' .. Water .. '  Earth:' .. Earth  .. '    Ice:' .. Ice  .. '   Dark:' .. Dark;
		for k, v in pairs(Toggles) do
			line1 = line1 .. '   ';
			if (v == true) then
				line1 = line1 .. '|cFF00FF00|' .. k .. '|r';
			else
				line1 = line1 .. '|cFFFF0000|' .. k .. '|r';
			end
		end
		for key, value in pairs(Cycles) do
			line2 = line2 .. '  ' .. key .. ': ' .. '|cFF00FF00|' .. value.Array[value.Index] .. '|r';
		end
		local function padNumber(number)
			return string.format("%4d", number)
		end
		local display = line1:gsub("%d+", padNumber) .. line2:gsub("%d+", padNumber)
		gcdisplay.FontObject.text = display;
	end);
end

ashita.events.register('command', 'gcdisplay_cb', function (e)
	local args = e.command:args()
    if #args == 0 or args[1] ~= '/gcdisplay' then
        return
    end

    e.blocked = true

    if #args == 1 then
        gcdisplay.FontObject.visible = not gcdisplay.FontObject.visible;
    end
end)

return gcdisplay;
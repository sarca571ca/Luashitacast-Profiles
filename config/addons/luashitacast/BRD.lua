local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

local sets = {
    Idle = {},
    Resting = {},
    Idle_Regen = {},
    Idle_Refresh = {},
    Town = {},

    Dt = {},

    Tp_Default = {},
    Tp_Hybrid = {},
    Tp_Acc = {},


    Precast = {},
    Cure_Precast = {},
    Enhancing_Precast = {},
    Stoneskin_Precast = {},
    Song_Precast = {},


    Cure = {},
    Self_Cure = {},
    Regen = {},
    Cursna = {},

    Enhancing = {},
    Stoneskin = {},
    Phalanx = {},
    Refresh = {},

    Enfeebling = {},

    Wind = {},
    Harp = {--use /forcestring in game to lock this on all songs. put this in dynamis ballads and sleeps.
    },
    Requiem = {},
    Elegy = {},
    Threnody = {},
    Finale = {},
    Foe = {},
    Horde = {},
    Buff = {},
    Paeon = {--I personally use paeons to force my extra song harp, you can also use /forcestring if you want
    },
    March = {},
    Madrigal = {},
    Ballad = {},
    Scherzo = {},

    Drain = {},
    Nuke = {},
    Preshot = {},
    Midshot = {},

    Ws_Default = {},
    Ws_Hybrid = {},
    Ws_Acc = {},

    Savage_Default = {},
    Savage_Hybrid = {},
    Savage_Acc = {},

    Nitro = {},

    TH = {},
    Movement = {},
};
profile.Sets = sets;

profile.Packer = {
    --{Name = 'Chonofuda', Quantity = 'all'},
};

profile.OnLoad = function()
	gSettings.AllowAddSet = true;
    gcinclude.Initialize();

    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 5');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 10');
end

profile.OnUnload = function()
    gcinclude.Unload();
end

profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
    gFunc.EquipSet(sets.Idle);
	
	local player = gData.GetPlayer();
    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.Tp_Default)
        if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
			gFunc.EquipSet('Tp_' .. gcdisplay.GetCycle('MeleeSet')) end
		if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
        if (gcdisplay.GetToggle('Fight') == false) then AshitaCore:GetChatManager():QueueCommand(1, '/fight') end
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    elseif (player.IsMoving == true) then
		gFunc.EquipSet(sets.Movement);
    end
	
    gcinclude.CheckDefault ();
    if (gcdisplay.GetToggle('DTset') == true) then gFunc.EquipSet(sets.Dt) end;
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end;
end

profile.HandleAbility = function()
    local ability = gData.GetAction();

    if string.match(ability.Name, 'Troubadour') or string.match(ability.Name, 'Nightingale') or string.match(ability.Name, 'Soul Voice') then gFunc.EquipSet(sets.Nitro) end

    gcinclude.CheckCancels();
end

profile.HandleItem = function()
    local item = gData.GetAction();

	if string.match(item.Name, 'Holy Water') then gFunc.EquipSet(gcinclude.sets.Holy_Water) end
end

profile.HandlePrecast = function()
    local spell = gData.GetAction();
    gFunc.EquipSet(sets.Precast)

    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Enhancing_Precast);

        if string.contains(spell.Name, 'Stoneskin') then
            gFunc.EquipSet(sets.Stoneskin_Precast);
        end
    elseif (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.Cure_Precast);
    elseif (spell.Skill == 'Singing') then
        gFunc.EquipSet(sets.Song_Precast);
    end

    gcinclude.CheckCancels();
end

profile.HandleMidcast = function()
    local weather = gData.GetEnvironment();
    local spell = gData.GetAction();
    local target = gData.GetActionTarget();
    local me = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);

    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Enhancing);

        if string.match(spell.Name, 'Phalanx') then
            gFunc.EquipSet(sets.Phalanx);
        elseif string.match(spell.Name, 'Stoneskin') then
            gFunc.EquipSet(sets.Stoneskin);
        elseif string.contains(spell.Name, 'Refresh') then
            gFunc.EquipSet(sets.Refresh);
        elseif string.contains(spell.Name, 'Regen') then
            gFunc.EquipSet(sets.Regen);
        end
    elseif (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.Cure);
        if (target.Name == me) then
            gFunc.EquipSet(sets.Self_Cure);
        end
        if string.match(spell.Name, 'Cursna') then
            gFunc.EquipSet(sets.Cursna);
        end
    elseif (spell.Skill == 'Elemental Magic') then
        gFunc.EquipSet(sets.Nuke);

        if (spell.Element == weather.WeatherElement) or (spell.Element == weather.DayElement) then
            gFunc.Equip('Waist', 'Hachirin-no-Obi');
        end
    elseif (spell.Skill == 'Enfeebling Magic') then
        gFunc.EquipSet(sets.Enfeebling);
    elseif (spell.Skill == 'Dark Magic') then
        gFunc.EquipSet(sets.Enfeebling); -- mostly macc anyways
        if (string.contains(spell.Name, 'Aspir') or string.contains(spell.Name, 'Drain')) then
            gFunc.EquipSet(sets.Drain);
        end
    elseif (spell.Skill == 'Singing') then
        if (string.contains(spell.Name, 'Paeon')) or (string.contains(spell.Name, 'Mazurka')) then
            gFunc.EquipSet(sets.Paeon);
        else
            gFunc.EquipSet(sets.Buff);
        end
        if (string.contains(spell.Name, 'Requiem')) or (string.contains(spell.Name, 'Elegy')) or (string.contains(spell.Name, 'Threnody')) or (string.contains(spell.Name, 'Finale')) or (string.contains(spell.Name, 'Lullaby')) then
            gFunc.EquipSet(sets.Wind);
        end
        if (string.contains(spell.Name, 'Requiem')) then
            gFunc.EquipSet(sets.Requiem);
        elseif (string.contains(spell.Name, 'Elegy')) then
            gFunc.EquipSet(sets.Elegy);
        elseif (string.contains(spell.Name, 'Threnody')) then
            gFunc.EquipSet(sets.Threnody);
        elseif (string.contains(spell.Name, 'Finale')) then
            gFunc.EquipSet(sets.Finale);
        elseif (string.contains(spell.Name, 'Horde Lullaby')) then
            gFunc.EquipSet(sets.Horde);
        elseif (string.contains(spell.Name, 'Foe Lullaby')) then
            gFunc.EquipSet(sets.Foe);
        elseif (string.contains(spell.Name, 'March')) then
            gFunc.EquipSet(sets.March);
        elseif (string.contains(spell.Name, 'Madrigal')) then
            gFunc.EquipSet(sets.Madrigal);
        elseif (string.contains(spell.Name, 'Scherzo')) then
            gFunc.EquipSet(sets.Scherzo);
        elseif (string.contains(spell.Name, 'Ballad')) then
            gFunc.EquipSet(sets.Ballad);
        end

        if (gcdisplay.GetToggle('String') == true) then
            gFunc.EquipSet(sets.Harp);
        end
    end
	if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
end

profile.HandlePreshot = function()
    gFunc.EquipSet(sets.Preshot);
end

profile.HandleMidshot = function()
    gFunc.EquipSet(sets.Midshot);
	if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
end

profile.HandleWeaponskill = function()
    local canWS = gcinclude.CheckWsBailout();
    if (canWS == false) then gFunc.CancelAction() return;
    else
        local ws = gData.GetAction();
    
        gFunc.EquipSet(sets.Ws_Default)
        if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
        gFunc.EquipSet('Ws_' .. gcdisplay.GetCycle('MeleeSet')) end
   
        if string.match(ws.Name, 'Savage Blade') then
            gFunc.EquipSet(sets.Savage_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Savage_' .. gcdisplay.GetCycle('MeleeSet')); end
        end
    end
end

return profile;

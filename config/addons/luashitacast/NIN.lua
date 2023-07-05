local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

local sets = {
    Idle = {},
    Resting = {},
    Idle_Regen = {},
    Idle_Refresh = {},
    Town = {},

    Dt = { -- Damage taken set
    },
    Eva = { -- Evasion set
    },

    Tp_Default = { -- Base tp set stp >> dual wield >> haste >> acc
    },
    Tp_Hybrid = { -- Higher atk for low lvl content
    },
    Tp_Acc = { -- Acc gear for hard content or no brd
    },
    Tp_Proc = { -- a set to force low dmg for things like Abyssea
    },

    --These will overwrite any above TP profile.Sets if /tankset is used
    Tank_Main = {--Default Tanking,  dt
    },
    Tank_Fire = {},
    Tank_Water = {},
    Tank_Wind = {},
    Tank_Earth = {},
    Tank_Lightning = {},
    Tank_Ice = {},
    Tank_Light = {},
    Tank_Dark = {},

    Precast = { -- Fast cast gear
    },


    Utsu = { -- Spell interuption gear
    },
    Nuke = { -- Ninjutsu >> INT
    },
    Macc = { -- Macc for harder content
    },

    Preshot = {},
    Midshot = { -- Racc >> Ratk
    },

    Ws_Default = { -- Default ws gear STR/DEX >> atk >> stp
    },
    Ws_Hybrid = {},
    Ws_Acc = { -- Swap acc for atk
    },
    Ws_Proc = { -- a set to force low dmg for things like Abyssea
    },

    Hi_Default = { -- AGI ws gear
    },
    Hi_Hybrid = {},
    Hi_Acc = {},

    Metsu_Default = { -- DEX ws gear
    },
    Metsu_Hybrid = {},
    Metsu_Acc = {},

    Shun_Default = { -- DEX and Gorgets
    },
    Shun_Hybrid = {},
    Shun_Acc = {},

    Chi_Default = { -- STR/INT WS gear
    },
    Chi_Hybrid = {},
    Chi_Acc = {},

    Enmity = { -- Enmity gear Provoke
    },

    Futae = {},
    Yonin = {},
    Innin = {},
    Migawari = {},
    Mijin = {},
    TH = {},
    Movement = {},
    Movement_Night = {},
    Extra1 = {--weapons that are for procing that are in storage slips
    },
    Extra2 = {--weapons that are for procing that are in storage slips
    },
    Extra3 = {--weapons that are for procing that are in storage slips
    },
};
profile.Sets = sets;

profile.Packer = {
    {Name = 'Toolbag (Ino)', Quantity = 'all'},
    {Name = 'Toolbag (Shika)', Quantity = 'all'},
    {Name = 'Toolbag (Cho)', Quantity = 'all'},
    {Name = 'Toolbag (Shihe)', Quantity = 'all'},
    {Name = 'Shihei', Quantity = 'all'},
    {Name = 'Inoshishinofuda', Quantity = 'all'},
    {Name = 'Chonofuda', Quantity = 'all'},
    {Name = 'Shikanofuda', Quantity = 'all'},
    {Name = 'Forbidden Key', Quantity = 'all'},
    {Name = 'Date Shuriken', Quantity = 'all'}
};

profile.OnLoad = function()
	gSettings.AllowAddSet = true;
    gcinclude.Initialize();

    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 4');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 3');
end

profile.OnUnload = function()
    gcinclude.Unload();
end

profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
    gFunc.EquipSet(sets.Idle);
    local game = gData.GetEnvironment();
	local player = gData.GetPlayer();
    local yonin = gData.GetBuffCount('Yonin')
    local innin = gData.GetBuffCount('Innin')
    local migawari = gData.GetBuffCount('Migawari')
    
    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.Tp_Default);
        if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then 
			gFunc.EquipSet('Tp_' .. gcdisplay.GetCycle('MeleeSet')) end
		if (yonin > 0) then gFunc.EquipSet(sets.Yonin)
        elseif (innin > 0) then gFunc.EquipSet(sets.Innin) end
		if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
        if (gcdisplay.GetCycle('TankSet') ~= 'None') then
            if gcdisplay.GetCycle('TankSet') == 'EleRes' then
                gFunc.EquipSet('Tank_' .. gcdisplay.GetCycle('EleRes'));
            else
			    gFunc.EquipSet('Tank_' .. gcdisplay.GetCycle('TankSet'));
            end
        end
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    elseif (player.IsMoving == true) then
		if (game.Time < 6.00) or (game.Time > 18.00) then
		    gFunc.EquipSet(sets.Movement_Night);
        else
            gFunc.EquipSet(sets.Movement);
        end
    end
	
    gcinclude.CheckDefault ();
    if (gcdisplay.GetToggle('DTset') == true) then gFunc.EquipSet(sets.Dt) end
    if (migawari > 0) then gFunc.EquipSet(sets.Migawari) end
    if (gcdisplay.GetToggle('EVA') == true) then gFunc.EquipSet(sets.Eva) end
end

profile.HandleAbility = function()
    local ability = gData.GetAction();

    if string.match(ability.Name, 'Provoke') then gFunc.EquipSet(sets.Enmity)
    elseif string.match(ability.Name, 'Mijin Gakure') then gFunc.EquipSet(sets.Mijin) end

    gcinclude.CheckCancels();
end

profile.HandleItem = function()
    local item = gData.GetAction();

	if string.match(item.Name, 'Holy Water') then gFunc.EquipSet(gcinclude.sets.Holy_Water) end
end

profile.HandlePrecast = function()
    local spell = gData.GetAction();
    gcinclude.DoShadows(spell);
    
    gFunc.EquipSet(sets.Precast);
    gcinclude.CheckCancels();
end

profile.HandleMidcast = function()
    local spell = gData.GetAction();
    local futae = gData.GetBuffCount('Futae')

    if (spell.Skill == 'Ninjutsu') then
        if string.contains(spell.Name, 'Utsusemi') then
            gFunc.EquipSet(sets.Utsu);
        elseif (gcinclude.NinNukes:contains(spell.Name)) then
            gFunc.EquipSet(sets.Nuke);
            if (futae > 0) then gFunc.EquipSet(sets.futae) end
        else
            gFunc.EquipSet(sets.Macc);
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
    elseif (gcdisplay.GetToggle('PROC') == true) then
        gFunc.EquipSet(sets.Ws_Proc);
    else
        local ws = gData.GetAction();
    
        gFunc.EquipSet(sets.Ws_Default)
        if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
        gFunc.EquipSet('Ws_' .. gcdisplay.GetCycle('MeleeSet')) end
        
	    if string.match(ws.Name, 'Blade: Hi') then
            gFunc.EquipSet(sets.Hi_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Hi_' .. gcdisplay.GetCycle('MeleeSet')); end
        elseif string.match(ws.Name, 'Blade: Metsu') then
            gFunc.EquipSet(sets.Metsu_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Metsu_' .. gcdisplay.GetCycle('MeleeSet')); end
        elseif string.match(ws.Name, 'Blade: Shun') then
            gFunc.EquipSet(sets.Shun_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Shun_' .. gcdisplay.GetCycle('MeleeSet')); end
        elseif string.match(ws.Name, 'Blade: Chi') or string.match(ws.Name, 'Blade: Teki') or string.match(ws.Name, 'Blade: To') then
            gFunc.EquipSet(sets.Chi_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Chi_' .. gcdisplay.GetCycle('MeleeSet')); end
        end
    end
end

return profile;

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

    --These will overwrite any above TP profile.Sets if /tankset is used
    Tank_Main = {},
    Tank_Fire = {},
    Tank_Water = {},
    Tank_Wind = {},
    Tank_Earth = {},
    Tank_Lightning = {},
    Tank_Ice = {},
    Tank_Light = {},
    Tank_Dark = {},

    Precast = {},
    Cure_Precast = {},
    Enhancing_Precast = {},
    SIR = {},
    Enmity = {},

    Cure = {},
    Phalanx = {},
    Reprisal = {},
    Flash = {},

    Preshot = {},
    Midshot = {},

    Ws_Default = {},
    Ws_Hybrid = {},
    Ws_Acc = {},
    Chant_Default = {},
    Chant_Hybrid = {},
    Chant_Acc = {},
    Savage_Default = {},
    Savage_Hybrid = {},
    Savage_Acc = {},
    Atone_Default = {},
    Atone_Hybrid = {},
    Atone_Acc = {},
    Aedge_Default = {},
    Aedge_Hybrid = {},
    Aedge_Acc = {},

    Fealty = {},
    Sentinel = {},
    Bash = {},
    Invincible = {},
    Cover = {},
    Rampart = {},

    TH = {},
    Movement = {},
};
profile.Sets = sets;

profile.Packer = {
    {Name = 'Om. Sandwich', Quantity = 'all'},
    {Name = 'Black Curry Bun', Quantity = 'all'},
};

profile.OnLoad = function()
	gSettings.AllowAddSet = true;
    gcinclude.Initialize();

    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 11');
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
		gFunc.EquipSet(sets.Movement);
    end
	
    local cover = gData.GetBuffCount('Cover');
	if (cover >= 1) then
		gFunc.EquipSet(sets.Fealty); -- same set as fealty
	end
	
    gcinclude.CheckDefault ();
    if (gcdisplay.GetToggle('DTset') == true) then gFunc.EquipSet(sets.Dt) end;
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end;
end

profile.HandleAbility = function()
    local ability = gData.GetAction();
    gFunc.EquipSet(sets.Enmity)
	if string.match(ability.Name, 'Fealty') then
		gFunc.EquipSet(sets.Fealty);
    elseif string.match(ability.Name, 'Sentinel') then
		gFunc.EquipSet(sets.Sentinel);
    elseif string.match(ability.Name, 'Shield Bash') or string.match(ability.Name, 'Chivalry') then
		gFunc.EquipSet(sets.Bash);
    elseif string.match(ability.Name, 'Invincible') then
		gFunc.EquipSet(sets.Invincible);
    elseif string.match(ability.Name, 'Cover') then
		gFunc.EquipSet(sets.Cover);
    elseif string.match(ability.Name, 'Rampart') then
		gFunc.EquipSet(sets.Rampart);
	end

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
    elseif (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.Cure_Precast);
    end

    gcinclude.CheckCancels();
end

profile.HandleMidcast = function()
    local spell = gData.GetAction();
    gFunc.EquipSet(sets.SIR);

    if string.contains(spell.Name, 'Cur') then
        gFunc.EquipSet(sets.Cure);
    elseif string.match(spell.Name, 'Phalanx') then
        gFunc.EquipSet(sets.Phalanx);
    elseif string.match(spell.Name, 'Reprisal') then
        gFunc.EquipSet(sets.Reprisal);
        return;--dont want to override this with SIR even with SIR toggle
    elseif string.match(spell.Name, 'Flash') then
        gFunc.EquipSet(sets.Flash);
    else
        gFunc.EquipSet(sets.Enmity);
    end

    if (gcdisplay.GetToggle('SIR') == true) then
        gFunc.EquipSet(sets.SIR);
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
   
        if string.match(ws.Name, 'Chant du Cygne') then
            gFunc.EquipSet(sets.Chant_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Chant_' .. gcdisplay.GetCycle('MeleeSet')); end
	    elseif string.match(ws.Name, 'Savage Blade') or string.match(ws.Name, 'Knights of Round') then
            gFunc.EquipSet(sets.Savage_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Savage_' .. gcdisplay.GetCycle('MeleeSet')); end
        elseif string.match(ws.Name, 'Atonement') then
            gFunc.EquipSet(sets.Atone_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Atone_' .. gcdisplay.GetCycle('MeleeSet')); end
        elseif string.match(ws.Name, 'Aeolian Edge') then
            gFunc.EquipSet(sets.Aedge_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Aedge_' .. gcdisplay.GetCycle('MeleeSet')); end
        end
    end
end

return profile;

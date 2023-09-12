-- The fllowing are just commands that i need to addin to currecnt functionality

-- Maybe can use math.random() to choose lockstyle at random.
-- AshitaCore:GetChatManager():QueueCommand(1, '/lockstyle on'); -- Turns lockstyle on if it was disabled
-- AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 1'); -- Picks the lockstyle you want to use

-- enable addon "debuff" or cancelling shadows wont work

-- start of my preview/edit function

local sets = {
    Idle = {},
    Resting = {},
    Idle_Regen = {},
    Idle_Refresh = {},
    Town = {},
    Dt = {},
    Eva = {},
    Tp_Default = {},
    Tp_Hybrid = {},
    Tp_Acc = {},
    Tp_Proc = {},
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
};

function previewSet(setName) -- Simple function that allows for preview equipment sets hopefully
    if setName == nil then
        return AshitaCore:GetChatManager():QueueCommand(1, '/lac reload');
    end

    local lowerSetName = string.lower(setName)
    local doesExist = false

    for k, _ in pairs(sets) do
        if string.lower(k) == lowerSetName then
            equipSet = k
            doesExist = true
        end
    end
    if doesExist then
        -- the logic for equiping our gear goes here
		AshitaCore:GetChatManager():QueueCommand(1, '/lac disable'); -- might need this at all
        AshitaCore:GetChatManager():QueueCommand(1, '/lac set ' .. equipSet);
    else
        print(setName .. " not found in this profile.")
    end
end

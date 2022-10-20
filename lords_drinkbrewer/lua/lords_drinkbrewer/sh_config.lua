LBrewer.AddCooldown = 0 -- Cooldown between adding ingredients
LBrewer.BarrelModel = "models/props_c17/oildrum001.mdl" -- Barrel Model 
LBrewer.Title = "LDrink Brewer"

LBrewer.Drinks = {
    {
        Name = "Beer", -- Name of drink
        Model = "models/props_junk/garbage_glassbottle003a.mdl", -- The bottle model
        BrewingTime = 5, -- How long it takes to brew
        Bottles = 6, -- Amount of bottles produced
        OnDrunk = function(ply)
            ply:DrunkEffect(15) -- Gives them the 'drunk' effect for 15 seconds
        end,
        Ingredients = {
            {
                Name = "Water", -- Name of ingredient
                PouringTime = 0.2, -- In seconds how long it takes to be added into the barrel
                Amount = 1, -- Amount needed to be poured in
                Price = 127, -- Price of ingredient
            },
            {
                Name = "Wheat", -- Name of ingredient
                PouringTime = 0.2, -- In seconds how long it takes to be added into the barrel
                Amount = 3, -- Amount needed to be poured in
                Price = 354, -- Price of ingredient
            },
            {
                Name = "Hops", -- Name of ingredient
                PouringTime = 0.2, -- In seconds how long it takes to be added into the barrel
                Amount = 2, -- Amount needed to be poured in
                Price = 10, -- Price of ingredient
            },
            {
                Name = "Yeast", -- Name of ingredient
                PouringTime = 0.2, -- In seconds how long it takes to be added into the barrel
                Amount = 4, -- Amount needed to be poured in
                Price = 56, -- Price of ingredient
            },
        },
    },
    {
        Name = "Wine", -- Name of drink
        Model = "models/props_junk/garbage_glassbottle003a.mdl", -- The bottle model
        BrewingTime = 5, -- How long it takes to brew
        Bottles = 2, -- Amount of bottles produced
        OnDrunk = function(ply)
            -- Give the player 20 health if they are over under 200 hp
            if ply:Health() > 200 then return end
            ply:SetHealth(ply:Health() + 20)
        end,
        Ingredients = {
            {
                Name = "Calcium Carbonate", -- Name of ingredient
                PouringTime = 0.2, -- In seconds how long it takes to be added into the barrel
                Amount = 1, -- Amount needed to be poured in
                Price = 250, -- Price of ingredient
            },
            {
                Name = "Grapes", -- Name of ingredient
                PouringTime = 0.2, -- In seconds how long it takes to be added into the barrel
                Amount = 3, -- Amount needed to be poured in
                Price = 135, -- Price of ingredient
            },
            {
                Name = "Sugar", -- Name of ingredient
                PouringTime = 0.2, -- In seconds how long it takes to be added into the barrel
                Amount = 2, -- Amount needed to be poured in
                Price = 167, -- Price of ingredient
            },
            {
                Name = "Yeasts", -- Name of ingredient
                PouringTime = 0.2, -- In seconds how long it takes to be added into the barrel
                Amount = 4, -- Amount needed to be poured in
                Price = 210, -- Price of ingredient
            },
        },
    },
    {
        Name = "Explosive Moonshine", -- Name of drink
        Model = "models/props_junk/garbage_glassbottle003a.mdl", -- The bottle model
        BrewingTime = 5, -- How long it takes to brew
        Bottles = 2, -- Amount of bottles produced
        OnDrunk = function(ply)
            ply:DrunkEffect(15) -- Gives them the 'drunk' effect for 15 seconds
            ply:ExplodeEffect() -- explode them 
        end,
        Ingredients = {
            {
                Name = "Salt Water", -- Name of ingredient
                PouringTime = 0.2, -- In seconds how long it takes to be added into the barrel
                Amount = 1, -- Amount needed to be poured in
                Price = 50, -- Price of ingredient
            },
            {
                Name = "Grain", -- Name of ingredient
                PouringTime = 0.2, -- In seconds how long it takes to be added into the barrel
                Amount = 3, -- Amount needed to be poured in
                Price = 250, -- Price of ingredient
            },
            {
                Name = "Dry Yeast", -- Name of ingredient
                PouringTime = 0.2, -- In seconds how long it takes to be added into the barrel
                Amount = 2, -- Amount needed to be poured in
                Price = 167, -- Price of ingredient
            },
        },
    },
}
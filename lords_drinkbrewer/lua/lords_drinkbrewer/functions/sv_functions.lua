util.AddNetworkString("LBrewer:SendIngredients")
util.AddNetworkString("LBrewer:RequestIngredients")
net.Receive("LBrewer:RequestIngredients", function(len, ply)
    local ent = net.ReadEntity()
    if not IsValid(ent) or not ent.Ingredients then return end

    net.Start("LBrewer:SendIngredients")
    net.WriteEntity(ent)
    net.WriteUInt(table.Count(ent.Ingredients), 32)
    for k, v in pairs(ent.Ingredients) do
        net.WriteString(k)
        net.WriteUInt(v, 32)
    end
    net.Send(ply)
end)

util.AddNetworkString("LBrewer:BuyIngredient")
net.Receive("LBrewer:BuyIngredient", function(len, ply)
    local ent, drinkint, ingredientint = net.ReadEntity(), net.ReadUInt(6), net.ReadUInt(6)
    if not IsValid(ent) then return end
    if ent:GetStage() ~= 0 then DarkRP.notify(ply, 1, 3, "Please wait until we finish our current operation") return end

    local data = LBrewer.Drinks[drinkint].Ingredients[ingredientint]
    if not data then return end
    if not ply:canAfford(data.Price) then DarkRP.notify(ply, 1, 3, "You cannot afford this") return end

    if ent.Ingredients[data.Name] and ent.Ingredients[data.Name] >= data.Amount then DarkRP.notify(ply, 1, 3, "MAXED") return end
    ent:AddIngredient(data.Name, data)
end)

util.AddNetworkString("LBrewer:Brew")
net.Receive("LBrewer:Brew", function(len, ply)
    local ent, int = net.ReadEntity(), net.ReadUInt(6)
    if not IsValid(ent) then return end
    if ent:GetStage() ~= 0 then DarkRP.notify(ply, 1, 3, "Please wait until we finish our current operation") return end
    if not ent:CanBrew(int) then DarkRP.notify(ply, 1, 3, "Please max out the ingredients") return end

    DarkRP.notify(ply, 1, 3, "Brewing")
    ent:Brew(int, ply)
end)

local PLAYER = FindMetaTable("Player")
function PLAYER:DrunkEffect(seconds)
    self:SetNWBool("LBeer:Drunk", true)
    timer.Create(self:SteamID64()..":DrunkEffect", seconds, 1, function()
        self:SetNWBool("LBeer:Drunk", false)
    end)
end

function PLAYER:ExplodeEffect()
	local vPoint = self:GetPos()
	local effect_explode = ents.Create("env_explosion")
	if not IsValid(effect_explode) then return end
	effect_explode:SetPos(vPoint)
	effect_explode:Spawn()
	effect_explode:Fire("Explode", 0, 0)
end
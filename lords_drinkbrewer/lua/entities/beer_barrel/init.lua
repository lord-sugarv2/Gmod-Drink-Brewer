AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel(LBrewer.BarrelModel)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():Wake()
	self:SetUseType(SIMPLE_USE)
	self.Ingredients = {}
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effect_explode = ents.Create("env_explosion")

	if not IsValid(effect_explode) then return end
	effect_explode:SetPos(vPoint)
	effect_explode:Spawn()
	effect_explode:Fire("Explode", 0, 0)

	self:Remove()
end

function ENT:OnTakeDamage(dmg)
	if (not self.m_bApplyingDamage) then
		self.m_bApplyingDamage = true
		
		self:SetHealth((self:Health() or 100) - dmg:GetDamage())
		if self:Health() <= 0 then
			if not IsValid(self) then return end
			self:Destruct()
		end
		
		self.m_bApplyingDamage = false
	end
end

util.AddNetworkString("LBrewer:OpenMenu")
function ENT:Use(ply)
	net.Start("LBrewer:OpenMenu")
	net.WriteEntity(self)
	net.Send(ply)
end

util.AddNetworkString("LBrewer:UpdateIngredients")
function ENT:AddIngredient(id, data)
	self.Ingredients[id] = self.Ingredients[id] and (self.Ingredients[id] + 1) or 1
	net.Start("LBrewer:UpdateIngredients")
	net.WriteEntity(self)
	net.WriteString(id)
	net.WriteUInt(self.Ingredients[id], 32)
	net.Broadcast()

	if not data then return end
	self:SetStage(1)
	self:SetText("Pouring...")

	timer.Remove(self:EntIndex()..":BrewerTimer")
	timer.Create(self:EntIndex()..":BrewerTimer", data.PouringTime, 1, function()
		self:SetStage(2)
		self:SetText("Cooldown")
		timer.Remove(self:EntIndex()..":BrewerTimer")
		timer.Create(self:EntIndex()..":BrewerTimer", LBrewer.AddCooldown, 1, function()
			self:SetStage(0)
			self:SetText("")
		end)
	end)
end

function ENT:CanBrew(int)
	if not LBrewer.Drinks[int] then return false end
	for k, v in ipairs(LBrewer.Drinks[int].Ingredients) do
		if not self.Ingredients[v.Name] then return false end
		if self.Ingredients[v.Name] < v.Amount then return false end
	end 
	return true
end

function ENT:CreateBottles(int, ply)
	local data = LBrewer.Drinks[int]
	if not data then return end
	for i = 1, data.Bottles do
		local beer = ents.Create("beer_bottle")
		beer:SetPos(self:GetPos() + Vector(0, 0, 100))
		beer:SetIndex(int)
		beer:Spawn()

		if ply then
			beer:CPPISetOwner(ply)
		end
	end
end

util.AddNetworkString("LBrewer:ClearIngredients")
function ENT:Brew(int, ply)
	if not self:CanBrew(int) then return end

	self:SetStage(3)
	self:SetText("Brewing")
	timer.Remove(self:EntIndex()..":BrewerTimer")
	timer.Create(self:EntIndex()..":BrewerTimer", LBrewer.Drinks[int].BrewingTime, 1, function()
		self:SetStage(0)
		self:SetText("")
		self:CreateBottles(int, ply)
	end)

	self.Ingredients = {}
	net.Start("LBrewer:ClearIngredients")
	net.WriteEntity(self)
	net.Broadcast()
end
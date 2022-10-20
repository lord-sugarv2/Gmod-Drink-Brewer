AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_glassbottle003a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():Wake()
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
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

function ENT:Use(ply)
	local id = self:GetIndex()
	if not id or not LBrewer.Drinks[id] then return end
	LBrewer.Drinks[id].OnDrunk(ply)

	self:Remove()
end
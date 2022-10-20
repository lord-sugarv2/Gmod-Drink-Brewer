ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Brewing Barrel"
ENT.Author = "Lord Sugar"
ENT.Category = "Lord Sugar"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
	self:NetworkVar("Int", 0, "Stage") -- 0: Nothing 1: Pouring 2: Cooldown 3: Brewing
	self:NetworkVar("String", 0, "Text")

	if SERVER then
		self:SetStage(0)
		self:SetText("")
	end
end
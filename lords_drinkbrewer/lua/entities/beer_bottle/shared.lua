ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Brewing Bottle"
ENT.Author = "Lord Sugar"
ENT.Category = "Lord Sugar"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
	self:NetworkVar("Int", 0, "Index")
end
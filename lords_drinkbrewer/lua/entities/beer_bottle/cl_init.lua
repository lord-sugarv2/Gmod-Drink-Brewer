include("shared.lua")
function ENT:Draw()
  	self:DrawModel()

	local id = self:GetIndex()
	if not id or not LBrewer.Drinks[id] then return end
	PIXEL.DrawEntOverhead(self, LBrewer.Drinks[id].Name)
end
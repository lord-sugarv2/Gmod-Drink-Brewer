include("shared.lua")
function ENT:Draw()
  	self:DrawModel()

	local stage = self:GetStage()
	if stage == 3 then
		PIXEL.DrawEntOverhead(self, "Brewing"..self.extra)
		return
	end

	PIXEL.DrawEntOverhead(self, stage == 0 and "Drink Brewer" or self:GetText())
end

local localPly
local function checkDistance(ent)
    if not IsValid(localPly) then localPly = LocalPlayer() end
    if localPly:GetPos():DistToSqr(ent:GetPos()) > 200000 then return true end
end

function ENT:Think()
	if checkDistance(self) then return end

	self.Time = self.Time or CurTime()
	if self.Time < CurTime() then
		self.Time = self.Time + 0.2
		self.extra = self.extra or ""
		self.pattern = self.pattern or "+"
		if self.pattern == "+" then
			if self.extra == "" then
				self.extra = "."
			elseif self.extra == "." then
				self.extra = ".."
			elseif self.extra == ".." then
				self.extra = "..."
				self.pattern = "-"
			end
		else
			if self.extra == "..." then
				self.extra = ".."
			elseif self.extra == ".." then
				self.extra = "."
			elseif self.extra == "." then
				self.extra = ""
				self.pattern = "+"
			end
		end
	end
end
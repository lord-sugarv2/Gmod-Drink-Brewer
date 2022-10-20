local PANEL = {}
function PANEL:Init()
    self.margin, self.panels = PIXEL.Scale(6), {}
    self.Drink = self:Add("PIXEL.ComboBox")
    self.Drink:Dock(TOP)
    self.Drink:SetTall(PIXEL.Scale(35))
    self.Drink:SetSizeToText(false)
    self.Drink:SetSortItems(false)
    for k, v in ipairs(LBrewer.Drinks) do
        self.Drink:AddChoice(v.Name, k)
    end

    self.BrewDrink = self:Add("PIXEL.TextButton")
    self.BrewDrink:Dock(TOP)
    self.BrewDrink:DockMargin(0, self.margin, 0, 0)
    self.BrewDrink:SetTall(PIXEL.Scale(35))
    self.BrewDrink:SetText("Brew Drink")
    self.BrewDrink.DoClick = function()
        net.Start("LBrewer:Brew")
        net.WriteEntity(self.Barrel)
        net.WriteUInt(self.Drink:GetSelectedID(), 6)
        net.SendToServer()
    end

    self.Scroll = self:Add("PIXEL.ScrollPanel")
    self.Scroll:Dock(FILL)

    if LBrewer.Drinks[1] then
        self.Drink:ChooseOptionID(1)
        self:Build()
    end

    self.Drink.OnSelect = function()
        self:Build()
    end
end

function PANEL:Build()
    for k, v in ipairs(self.panels) do
        if IsValid(v) then v:Remove() end
    end

    for k, v in ipairs(LBrewer.Drinks[self.Drink:GetSelectedID()].Ingredients) do
        local panel = self:Add("PIXEL.TextButton")
        panel:Dock(TOP)
        panel:DockMargin(0, self.margin, 0, 0)
        panel:SetTall(PIXEL.Scale(35))
        panel:SetText(v.Name.."   ".."0 / "..v.Amount)
        panel.Think = function(s)
            if not self.Barrel or not IsValid(self.Barrel) or not self.Barrel.Ingredients then return end

            local amount = self.Barrel.Ingredients[v.Name] and self.Barrel.Ingredients[v.Name] or 0
            s:SetText("("..DarkRP.formatMoney(v.Price)..") "..v.Name..": "..amount.." / "..v.Amount)
        end
        panel.DoClick = function()
            net.Start("LBrewer:BuyIngredient")
            net.WriteEntity(self.Barrel)
            net.WriteUInt(self.Drink:GetSelectedID(), 6)
            net.WriteUInt(k, 6)
            net.SendToServer()
        end

        table.insert(self.panels, panel)
    end
end

function PANEL:SetEnt(ent)
    self.Barrel = ent
end
vgui.Register("LBrewer:Menu", PANEL, "EditablePanel")
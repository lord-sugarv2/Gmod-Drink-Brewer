local blur = Material("pp/blurscreen")
function LBrewer:DrawBlur(x, y, w, h, amount)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)

    surface.SetDrawColor(30, 30, 30, 230)
    surface.DrawRect(x, y, w, h)

    for i = 1, 3 do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x, y, w, h)
    end
end

function LBrewer:OpenMenu(ent)
    if IsValid(LBrewer.Menu) then LBrewer.Menu:Remove() return end
    if not ent.Ingredients then
        net.Start("LBrewer:RequestIngredients")
        net.WriteEntity(ent)
        net.SendToServer()
    end

    LBrewer.Menu = vgui.Create("DPanel")
    LBrewer.Menu:SetText("")
    LBrewer.Menu:SetSize(ScrW(), ScrH())
    LBrewer.Menu.Paint = function(s, w, h)
        LBrewer:DrawBlur(0, 0, w, h)
    end

    local panel = LBrewer.Menu:Add("PIXEL.Frame")
    panel:SetSize(PIXEL.Scale(500), PIXEL.Scale(600))
    panel:Center()
    panel:MakePopup()
    panel:SetTitle(LBrewer.Title)
    panel.OnRemove = function()
        LBrewer.Menu:Remove()
    end

    local panel = panel:Add("LBrewer:Menu")
    panel:Dock(FILL)
    panel:SetEnt(ent)
end

net.Receive("LBrewer:SendIngredients", function()
    local ent, int, tbl = net.ReadEntity(), net.ReadUInt(32), {}
    for i = 1, int do
        local id, amount = net.ReadString(), net.ReadUInt(32)
        tbl[id] = amount
    end
    ent.Ingredients = tbl
end)

net.Receive("LBrewer:OpenMenu", function()
    local ent = net.ReadEntity()
    LBrewer:OpenMenu(ent)
end)

net.Receive("LBrewer:UpdateIngredients", function()
    local ent, id, amount = net.ReadEntity(), net.ReadString(), net.ReadUInt(32)
    if not ent.Ingredients then ent.Ingredients = {} end
    ent.Ingredients[id] = amount
end)

net.Receive("LBrewer:ClearIngredients", function()
    local ent = net.ReadEntity()
    ent.Ingredients = {}
end)

local DrunkEffect = Material("vgui/wave.png")
hook.Add("PostDrawHUD", "Beer:DrawDrunk", function()
    local bool = LocalPlayer():GetNWBool("LBeer:Drunk")
    if not bool then return end
    DrawMotionBlur(0.4, 0.5, 0.1)
end)
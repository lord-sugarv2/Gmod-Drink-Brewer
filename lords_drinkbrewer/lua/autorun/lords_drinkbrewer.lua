LBrewer = LBrewer or {}
hook.Add("PIXEL.UI.FullyLoaded", "LBrewer:Loaded", function()
    PIXEL.LoadDirectoryRecursive("lords_drinkbrewer")
end)
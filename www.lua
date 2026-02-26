-- ================================================
-- Untitled Enhancements X | OrionLib (Compatible con RonixExploit)
-- Creado por Grok - Funciona en Ronix, Solara, Fluxus, etc.
-- UI moderna: Tabs laterales, secciones limpias, mouse visible.
-- Copia y pega COMPLETO en RonixExploit ❤️
-- ================================================

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Window = OrionLib:MakeWindow({
    Name = "Untitled Enhancements X",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "UntitledX",
    IntroEnabled = false
})

OrionLib:MakeNotification({
    Name = "Cargado exitosamente!",
    Content = "¡UI completa! Abre con RightControl.",
    Image = "rbxassetid://4483345998",
    Time = 4
})

-- ==================== PLAYER TAB ====================
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local PlayerSec = PlayerTab:AddSection({
    Name = "Opciones del Jugador"
})

local customLevelTextbox = PlayerTab:AddTextbox({
    Name = "Custom Level (solo client-side)",
    Default = "100",
    Callback = function(Value)
        -- Preview
    end    
})
PlayerTab:AddButton({
    Name = "Aplicar Custom Level",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local levelVal = tonumber(customLevelTextbox.Value) or 1
        if lp:FindFirstChild("leaderstats") and lp.leaderstats:FindFirstChild("Level") then
            lp.leaderstats.Level.Value = levelVal
            OrionLib:MakeNotification({
                Name = "Nivel cambiado",
                Content = "Nivel: " .. levelVal,
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "No hay leaderstats.Level en este juego",
                Image = "rbxassetid://7733716402",
                Time = 3
            })
        end
    end
})

local hiddenNameToggle = PlayerTab:AddToggle({
    Name = "Hidden Name",
    Default = false,
    Callback = function(Value)
        local function hideName(char)
            if char:FindFirstChild("Head") then
                for _, gui in pairs(char.Head:GetChildren()) do
                    if gui:IsA("BillboardGui") then
                        gui.Enabled = not Value
                    end
                end
            end
        end
        local char = game.Players.LocalPlayer.Character
        if char then hideName(char) end
    end    
})

local customNameTextbox = PlayerTab:AddTextbox({
    Name = "Custom Name",
    Default = "MiNombreCool",
    Callback = function(Value)
        -- Preview
    end    
})
PlayerTab:AddButton({
    Name = "Aplicar Custom Name",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if not char or not char:FindFirstChild("Head") then 
            OrionLib:MakeNotification({Name = "Error", Content = "Espera a que cargue el personaje", Time = 3})
            return 
        end
        -- Limpia viejos
        for _, gui in pairs(char.Head:GetChildren()) do
            if gui:IsA("BillboardGui") and gui.Name == "CustomName" then
                gui:Destroy()
            end
        end
        -- Nuevo
        local bgui = Instance.new("BillboardGui")
        bgui.Name = "CustomName"
        bgui.Adornee = char.Head
        bgui.Size = UDim2.new(0, 200, 0, 50)
        bgui.StudsOffset = Vector3.new(0, 2.5, 0)
        bgui.Parent = char.Head
        bgui.AlwaysOnTop = true
        
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = customNameTextbox.Value
        text.TextColor3 = Color3.new(1,1,1)
        text.TextStrokeTransparency = 0
        text.TextStrokeColor3 = Color3.new(0,0,0)
        text.TextScaled = true
        text.Font = Enum.Font.GothamBold
        text.Parent = bgui
        
        OrionLib:MakeNotification({Name = "Aplicado", Content = "Custom Name OK", Time = 2})
    end
})

local flyToggle = PlayerTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local bv = root:FindFirstChild("FlyBV")
        local bg = root:FindFirstChild("FlyBG")
        
        if Value then
            bv = Instance.new("BodyVelocity")
            bv.Name = "FlyBV"
            bv.MaxForce = Vector3.new(4000, 4000, 4000)
            bv.Velocity = Vector3.new(0,0,0)
            bv.Parent = root
            
            bg = Instance.new("BodyGyro")
            bg.Name = "FlyBG"
            bg.MaxTorque = Vector3.new(4000, 4000, 4000)
            bg.P = 2000
            bg.Parent = root
            
            spawn(function()
                repeat
                    local cam = workspace.CurrentCamera
                    local uis = game:GetService("UserInputService")
                    local move = Vector3.new()
                    
                    if uis:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
                    if uis:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
                    if uis:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
                    if uis:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
                    if uis:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
                    if uis:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0,-1,0) end
                    
                    if bv and bg then
                        bv.Velocity = move.Unit * 50 -- Speed fija, ajusta aquí
                        bg.CFrame = cam.CFrame
                    end
                    wait()
                until not flyToggle.Value or not bv or not bg
            end)
        else
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end
})

PlayerTab:AddSlider({
    Name = "Fly Speed (ajusta en código arriba)",
    Min = 1,
    Max = 100,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    Callback = function(v)
        -- Para cambiar speed, edita el 50 en el loop de fly
        OrionLib:MakeNotification({Name = "Nota", Content = "Edita el 50 en el script para speed", Time = 3})
    end    
})

-- ==================== VISUALS TAB ====================
local VisualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local VisualsSec = VisualsTab:AddSection({Name = "Visuales"})

local espToggle = VisualsTab:AddToggle({
    Name = "ESP (Cajas + Nombre + Dist)",
    Default = false,
    Callback = function(Value)
        if Value then
            local espObjects = {}
            local function addESP(plr)
                if plr == game.Players.LocalPlayer then return end
                local box = Drawing.new("Square")
                box.Thickness = 2
                box.Filled = false
                box.Transparency = 1
                box.Color = Color3.new(1,0,0)
                box.Visible = false
                
                local nameTag = Drawing.new("Text")
                nameTag.Size = 16
                nameTag.Center = true
                nameTag.Outline = true
                nameTag.Color = Color3.new(1,1,1)
                nameTag.Visible = false
                
                espObjects[plr] = {box = box, name = nameTag}
            end
            
            for _, plr in pairs(game.Players:GetPlayers()) do addESP(plr) end
            game.Players.PlayerAdded:Connect(addESP)
            game.Players.PlayerRemoving:Connect(function(plr)
                if espObjects[plr] then
                    espObjects[plr].box:Remove()
                    espObjects[plr].name:Remove()
                end
            end)
            
            spawn(function()
                while espToggle.Value do
                    for plr, objs in pairs(espObjects) do
                        local char = plr.Character
                        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and char.Humanoid.Health > 0 then
                            local rootPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                            if onScreen then
                                local headPos = workspace.CurrentCamera:WorldToViewportPoint(char.Head.Position + Vector3.new(0,1,0))
                                local legPos = workspace.CurrentCamera:WorldToViewportPoint(char.HumanoidRootPart.Position - Vector3.new(0,4,0))
                                
                                local height = math.abs(headPos.Y - legPos.Y)
                                local width = height / 2
                                
                                objs.box.Size = Vector2.new(width, height)
                                objs.box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
                                objs.box.Visible = true
                                
                                local dist = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
                                objs.name.Text = plr.DisplayName .. "\n[" .. dist .. "]"
                                objs.name.Position = Vector2.new(rootPos.X, headPos.Y - 20)
                                objs.name.Visible = true
                            else
                                objs.box.Visible = false
                                objs.name.Visible = false
                            end
                        else
                            objs.box.Visible = false
                            objs.name.Visible = false
                        end
                    end
                    wait()
                end
                -- Limpia al desactivar
                for _, objs in pairs(espObjects) do
                    objs.box:Remove()
                    objs.name:Remove()
                end
            end)
            OrionLib:MakeNotification({Name = "ESP", Content = "Activado", Time = 2})
        end
    end
})

local emoteTextbox = VisualsTab:AddTextbox({
    Name = "Emote (wave, point, etc.)",
    Default = "wave",
    Callback = function(Value)
        --
    end    
})
VisualsTab:AddButton({
    Name = "Play Emote Free",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:PlayEmote(emoteTextbox.Value)
            OrionLib:MakeNotification({Name = "Emote", Content = "Reproducido", Time = 2})
        end
    end
})

-- ==================== MISC TAB ====================
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local MiscSec = MiscTab:AddSection({Name = "Misceláneo"})

local skinUserTextbox = MiscTab:AddTextbox({
    Name = "Username para Skin",
    Default = "Roblox",
    Callback = function(Value)
        --
    end    
})
MiscTab:AddButton({
    Name = "Copiar Skin (Client-side)",
    Callback = function()
        local username = skinUserTextbox.Value
        local success, userId = pcall(function()
            return game.Players:GetUserIdFromNameAsync(username)
        end)
        if success and userId then
            local desc = game.Players:GetHumanoidDescriptionFromUserId(userId)
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ApplyDescription(desc)
                OrionLib:MakeNotification({Name = "Skin", Content = "Copiada de " .. username, Time = 3})
            end
        else
            OrionLib:MakeNotification({Name = "Error", Content = "Usuario inválido", Time = 3})
        end
    end
})

local assetIdTextbox = MiscTab:AddTextbox({
    Name = "Asset ID (ej: 15618401241)",
    Default = "",
    Callback = function(Value)
        --
    end    
})

local assetTypes = {"Shirt", "Pants", "Face", "TShirt", "HatAccessory", "GraphicTShirt", "Head"}
local assetDropdown = MiscTab:AddDropdown({
    Name = "Tipo de Item",
    Default = "Shirt",
    Options = assetTypes,
    Callback = function(Value)
        --
    end    
})
MiscTab:AddButton({
    Name = "Añadir Item GRATIS (Client-side)",
    Callback = function()
        local id = assetIdTextbox.Value
        if id == "" then 
            OrionLib:MakeNotification({Name = "Error", Content = "Ingresa Asset ID", Time = 3})
            return 
        end
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local desc = char.Humanoid:GetAppliedDescription() or Instance.new("HumanoidDescription")
            desc[assetDropdown.Value] = tonumber(id)
            char.Humanoid:ApplyDescription(desc)
            OrionLib:MakeNotification({Name = "Item", Content = "Añadido " .. id .. " (solo en juego)", Time = 3})
        end
    end
})

-- ==================== SETTINGS ====================
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

SettingsTab:AddParagraph("OrionLib ya tiene:",
"• Keybind: RightControl (cambia en menú)\n• Colores/Themes\n• Configs auto-guardadas\n• Mouse visible siempre")

-- Auto-reaplicar hidden name en respawn
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    if hiddenNameToggle.Value then
        hiddenNameToggle:Callback(true)
    end
end)

OrionLib:Init()

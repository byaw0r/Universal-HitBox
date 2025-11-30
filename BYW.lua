-- BYW SCRIPT
local hitboxEnabled = false
local espEnabled = true

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HitboxMenu"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local hitboxBtn = Instance.new("TextButton")
hitboxBtn.Name = "HitboxBtn"
hitboxBtn.Size = UDim2.new(0, 40, 0, 40)
hitboxBtn.Position = UDim2.new(0, 10, 0, 10)
hitboxBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
hitboxBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
hitboxBtn.Text = "B"
hitboxBtn.TextSize = 28
hitboxBtn.Font = Enum.Font.GothamBold
hitboxBtn.BorderSizePixel = 0
hitboxBtn.Active = true
hitboxBtn.Draggable = true
hitboxBtn.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = hitboxBtn

local toggleInputBtn = Instance.new("TextButton")
toggleInputBtn.Name = "ToggleInputBtn"
toggleInputBtn.Size = UDim2.new(0, 30, 0, 30)
toggleInputBtn.Position = UDim2.new(0, 55, 0, 15)
toggleInputBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleInputBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleInputBtn.Text = "S"
toggleInputBtn.TextSize = 20
toggleInputBtn.Font = Enum.Font.GothamBold
toggleInputBtn.BorderSizePixel = 0
toggleInputBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleInputBtn

local sizeInput = Instance.new("TextBox")
sizeInput.Name = "SizeInput"
sizeInput.Size = UDim2.new(0, 80, 0, 30)
sizeInput.Position = UDim2.new(0, 10, 0, 55)
sizeInput.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
sizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeInput.Text = "20"
sizeInput.PlaceholderText = "Size"
sizeInput.TextSize = 14
sizeInput.Font = Enum.Font.GothamBold
sizeInput.BorderSizePixel = 2
sizeInput.BorderColor3 = Color3.fromRGB(255, 255, 255)
sizeInput.Visible = false
sizeInput.Parent = screenGui

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = sizeInput

_G.Size = 20
_G.Disabled = false

local espConnection
local originalSizes = {}
local hitboxZones = {}

local function updateHitboxSize()
    local newSize = tonumber(sizeInput.Text)
    if newSize and newSize > 0 then
        _G.Size = newSize
    else
        sizeInput.Text = tostring(_G.Size)
    end
end

local function toggleSizeInput()
    sizeInput.Visible = not sizeInput.Visible
    if sizeInput.Visible then
        sizeInput.Position = UDim2.new(0, hitboxBtn.AbsolutePosition.X, 0, hitboxBtn.AbsolutePosition.Y + 45)
    end
end

local function updateButtonPositions()
    toggleInputBtn.Position = UDim2.new(0, hitboxBtn.AbsolutePosition.X + 45, 0, hitboxBtn.AbsolutePosition.Y + 5)
    if sizeInput.Visible then
        sizeInput.Position = UDim2.new(0, hitboxBtn.AbsolutePosition.X, 0, hitboxBtn.AbsolutePosition.Y + 45)
    end
end

local function isValidNPC(model)
    if not model:IsA("Model") then
        return false
    end
    
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local rootPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso")
    
    if not humanoid or not rootPart then
        return false
    end
    
    if humanoid.Health <= 0 then
        return false
    end
    
    if model:FindFirstChild("Head") then
        return true
    end
    
    return true
end

local function getRootPart(character)
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
end

local function updateESP()
    if _G.Disabled then
        for i,v in next, game:GetService('Players'):GetPlayers() do
            if v.Name ~= game:GetService('Players').LocalPlayer.Name and v.Character then
                pcall(function()
                    local rootPart = getRootPart(v.Character)
                    if rootPart and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                        if not originalSizes[v.Name] then
                            originalSizes[v.Name] = {
                                Size = rootPart.Size,
                                Transparency = rootPart.Transparency,
                                BrickColor = rootPart.BrickColor,
                                Material = rootPart.Material,
                                CanCollide = rootPart.CanCollide
                            }
                        end
                        
                        rootPart.Size = Vector3.new(_G.Size, _G.Size, _G.Size)
                        rootPart.Transparency = 0.7
                        rootPart.BrickColor = BrickColor.new("Really red")
                        rootPart.Material = "Neon"
                        rootPart.CanCollide = false
                    end
                end)
            end
        end
        
        for i, v in next, workspace:GetChildren() do
            if isValidNPC(v) and v ~= game.Players.LocalPlayer.Character then
                pcall(function()
                    local rootPart = getRootPart(v)
                    local humanoid = v:FindFirstChildOfClass("Humanoid")
                    
                    if rootPart and humanoid and humanoid.Health > 0 then
                        if not originalSizes[v.Name] then
                            originalSizes[v.Name] = {
                                Size = rootPart.Size,
                                Transparency = rootPart.Transparency,
                                BrickColor = rootPart.BrickColor,
                                Material = rootPart.Material,
                                CanCollide = rootPart.CanCollide
                            }
                        end
                        
                        rootPart.Size = Vector3.new(_G.Size, _G.Size, _G.Size)
                        rootPart.Transparency = 0.7
                        rootPart.BrickColor = BrickColor.new("Really blue")
                        rootPart.Material = "Neon"
                        rootPart.CanCollide = false
                    end
                end)
            end
        end
    end
end

local function restoreNormalSize()
    for i,v in next, game:GetService('Players'):GetPlayers() do
        if v.Character then
            pcall(function()
                local rootPart = getRootPart(v.Character)
                if rootPart and originalSizes[v.Name] then
                    local original = originalSizes[v.Name]
                    rootPart.Size = original.Size
                    rootPart.Transparency = original.Transparency
                    rootPart.BrickColor = original.BrickColor
                    rootPart.Material = original.Material
                    rootPart.CanCollide = original.CanCollide
                end
            end)
        end
    end
    
    for i, v in next, workspace:GetChildren() do
        if isValidNPC(v) then
            pcall(function()
                local rootPart = getRootPart(v)
                if rootPart and originalSizes[v.Name] then
                    local original = originalSizes[v.Name]
                    rootPart.Size = original.Size
                    rootPart.Transparency = original.Transparency
                    rootPart.BrickColor = original.BrickColor
                    rootPart.Material = original.Material
                    rootPart.CanCollide = original.CanCollide
                end
            end)
        end
    end
    
    originalSizes = {}
end

local function expandHitboxArea()
    if _G.Disabled then
        local localPlayer = game.Players.LocalPlayer
        local localChar = localPlayer.Character
        local localRoot = localChar and getRootPart(localChar)
        
        if localRoot then
            for i, v in next, game:GetService('Players'):GetPlayers() do
                if v.Name ~= localPlayer.Name and v.Character then
                    pcall(function()
                        local targetRoot = getRootPart(v.Character)
                        local humanoid = v.Character:FindFirstChildOfClass("Humanoid")
                        
                        if targetRoot and humanoid and humanoid.Health > 0 then
                            local distance = (localRoot.Position - targetRoot.Position).Magnitude
                            
                            if distance <= _G.Size then
                                local hitboxZone = targetRoot:FindFirstChild("HitboxZone")
                                if not hitboxZone then
                                    hitboxZone = Instance.new("Part")
                                    hitboxZone.Name = "HitboxZone"
                                    hitboxZone.Size = Vector3.new(_G.Size * 2, _G.Size * 2, _G.Size * 2)
                                    hitboxZone.Transparency = 1
                                    hitboxZone.CanCollide = false
                                    hitboxZone.Anchored = true
                                    hitboxZone.Parent = targetRoot
                                    hitboxZones[v.Name] = hitboxZone
                                end
                                
                                hitboxZone.Position = targetRoot.Position
                                hitboxZone.Size = Vector3.new(_G.Size * 2, _G.Size * 2, _G.Size * 2)
                            else
                                local hitboxZone = targetRoot:FindFirstChild("HitboxZone")
                                if hitboxZone then
                                    hitboxZone:Destroy()
                                    hitboxZones[v.Name] = nil
                                end
                            end
                        end
                    end)
                end
            end
            
            for i, v in next, workspace:GetChildren() do
                if isValidNPC(v) and v ~= localChar then
                    pcall(function()
                        local targetRoot = getRootPart(v)
                        local humanoid = v:FindFirstChildOfClass("Humanoid")
                        
                        if targetRoot and humanoid and humanoid.Health > 0 then
                            local distance = (localRoot.Position - targetRoot.Position).Magnitude
                            
                            if distance <= _G.Size then
                                local hitboxZone = targetRoot:FindFirstChild("HitboxZone")
                                if not hitboxZone then
                                    hitboxZone = Instance.new("Part")
                                    hitboxZone.Name = "HitboxZone"
                                    hitboxZone.Size = Vector3.new(_G.Size * 2, _G.Size * 2, _G.Size * 2)
                                    hitboxZone.Transparency = 1
                                    hitboxZone.CanCollide = false
                                    hitboxZone.Anchored = true
                                    hitboxZone.Parent = targetRoot
                                    hitboxZones[v.Name] = hitboxZone
                                end
                                
                                hitboxZone.Position = targetRoot.Position
                                hitboxZone.Size = Vector3.new(_G.Size * 2, _G.Size * 2, _G.Size * 2)
                            else
                                local hitboxZone = targetRoot:FindFirstChild("HitboxZone")
                                if hitboxZone then
                                    hitboxZone:Destroy()
                                    hitboxZones[v.Name] = nil
                                end
                            end
                        end
                    end)
                end
            end
        end
    else
        for name, zone in pairs(hitboxZones) do
            if zone and zone.Parent then
                zone:Destroy()
            end
        end
        hitboxZones = {}
        
        for i, v in next, game:GetService('Players'):GetPlayers() do
            if v.Character then
                pcall(function()
                    local targetRoot = getRootPart(v.Character)
                    if targetRoot then
                        local hitboxZone = targetRoot:FindFirstChild("HitboxZone")
                        if hitboxZone then
                            hitboxZone:Destroy()
                        end
                    end
                end)
            end
        end
        
        for i, v in next, workspace:GetChildren() do
            if isValidNPC(v) then
                pcall(function()
                    local targetRoot = getRootPart(v)
                    if targetRoot then
                        local hitboxZone = targetRoot:FindFirstChild("HitboxZone")
                        if hitboxZone then
                            hitboxZone:Destroy()
                        end
                    end
                end)
            end
        end
    end
end

local function handlePlayerDeath()
    local player = game.Players.LocalPlayer
    
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid")
        
        character.Humanoid.Died:Connect(function()
        end)
    end)
    
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Died:Connect(function()
            end)
        end
    end
end

local function startESP()
    if not espConnection then
        espConnection = game:GetService('RunService').RenderStepped:Connect(function()
            updateESP()
            expandHitboxArea()
        end)
    end
end

local function toggleHitbox()
    hitboxEnabled = not hitboxEnabled
    
    if hitboxEnabled then
        hitboxBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        updateHitboxSize()
        _G.Disabled = true
        if not espConnection then
            startESP()
        end
    else
        hitboxBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        _G.Disabled = false
        restoreNormalSize()
        expandHitboxArea()
    end
end

hitboxBtn.MouseButton1Click:Connect(function()
    toggleHitbox()
end)

toggleInputBtn.MouseButton1Click:Connect(function()
    toggleSizeInput()
end)

sizeInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        updateHitboxSize()
    end
end)

hitboxBtn:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
    updateButtonPositions()
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.H then
        toggleHitbox()
    end
end)

updateButtonPositions()
handlePlayerDeath()

print("BYW SCRIPT loaded!")

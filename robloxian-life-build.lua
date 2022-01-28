local model_id = 57729518

getgenv().stop_command = 'stop' -- your stop command

if getgenv().building == true then
    warn(string.format('already building, type %s%s%s in the chat to stop building.', "'", getgenv().stop_command, "'"))
    return
end    

local lplayer = game.Players.LocalPlayer

local mouse = lplayer:GetMouse()

local transparency_table = {}

local clicked = false

getgenv().building = false

local count = 0


local old_model = game:GetObjects(string.format('http://www.roblox.com/asset/?id=%s', tostring(model_id)))[1]

if old_model:IsA('BasePart') then
    local temp_model = Instance.new('Model', workspace)
    temp_model.Name = old_model.Name
    old_model.Parent = temp_model
    old_model = temp_model
end





old_model.Parent = workspace

for i, v in pairs(old_model:GetDescendants()) do
    if v:IsA('BasePart') then
        if v.Transparency > 0 then
            local inserting_table = {
                v,
                v.Transparency,
                v.Color,
                v.Material,
            }
            table.insert(transparency_table, inserting_table)
        end
        
        count = count + 1
        
        v.Anchored = true
        v.Transparency = .7
        if old_model.PrimaryPart == nil then
            old_model.PrimaryPart = v
        end
    end
end

local camera = workspace.CurrentCamera

local uis = game:GetService('UserInputService')

mouse.TargetFilter = old_model

local cloud = lplayer.Character:FindFirstChild('PompousTheCloud')

if not cloud then
    cloud = lplayer.Backpack:FindFirstChild('PompousTheCloud')
end

if cloud then
    cloud.Parent = lplayer.Character
end

cloud:WaitForChild('LocalScript').Disabled = true

local model = nil

workspace.GuiEvent:FireServer('building_model')

        
local cloud_remote = cloud:WaitForChild('ServerControl')

model = lplayer.Character:WaitForChild('building_model')

model:ClearAllChildren()

cloud_remote:InvokeServer('SetProperty', {Value = old_model.Name, Property = 'Name', Object = model})

cloud_remote:InvokeServer('SetProperty', {Value = workspace, Property = 'Parent', Object = model})

print(count)




if model == nil then
    warn('error while trying to create model')
    return
end

local gui = Instance.new('ScreenGui', lplayer.PlayerGui)
gui.Name = 'part_counter'

local text = Instance.new('TextLabel', gui)
text.Size = UDim2.new(.5, 0, .1, 0)
text.AnchorPoint = Vector2.new(.5, .5)
text.Position = UDim2.new(.5, 0, .85, 0)
text.TextColor3 = Color3.fromRGB(255, 255, 255)
text.Font = 'GothamBlack'
text.TextScaled = true

text.BackgroundTransparency = 1




for i = 1, count do
    text.Text = string.format('%s/%s', i, count)
    workspace.GuiEvent:FireServer('part_model')
    
    lplayer.Character.ChildAdded:Wait()
    
    local part_model = lplayer.Character:WaitForChild('part_model')
    local head_part = part_model:WaitForChild('Head')
    
    spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = false, Property = 'CanCollide', Object = head_part}) end)
    
    cloud_remote:InvokeServer('SetProperty', {Value = lplayer.Character.Humanoid, Property = 'Parent', Object = head_part})
    
end

text.Text = ''



local function build(part)
    local cloud = lplayer.Character:FindFirstChild('PompousTheCloud')
    
    local current_transpareny = 0
    
    for i, v in pairs(transparency_table) do
        if transparency_table[i][1] == part then
            warn('part is transparent')
            current_transpareny = transparency_table[i][2]
            part.Transparency = 1
        end
    end    
    
    if not cloud then
        cloud = lplayer.Backpack:FindFirstChild('PompousTheCloud')
    end
    
    if cloud then
        cloud.Parent = lplayer.Character
    end
    
    if part:IsA('Humanoid') then


        
        local cloud_remote = cloud:WaitForChild('ServerControl')
        
        
        local humanoid = lplayer.Character:FindFirstChildOfClass('Model'):FindFirstChildOfClass('Humanoid')
        
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.Name, Property = 'Name', Object = humanoid}) end)
        
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.MaxHealth, Property = 'MaxHealth', Object = humanoid}) end)
        
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.HealthDisplayType, Property = 'HealthDisplayType', Object = humanoid}) end)
        
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.DisplayDistanceType, Property = 'DisplayDistanceType', Object = humanoid}) end)
        
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.Health, Property = 'Health', Object = humanoid}) end)
        
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.NameDisplayDistance, Property = 'NameDisplayDistance', Object = humanoid}) end)
        
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.NameDisplayDistance, Property = 'NameDisplayDistance', Object = humanoid}) end)
        
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = model, Property = 'Parent', Object = humanoid}) end)
        
        
        local char_head = lplayer.Character:FindFirstChild('Head')
        
        if char_head.Transparency > 0 then
            cloud_remote:InvokeServer('SetProperty', {Value = 0, Property = 'Transparency', Object = head})
        end
        
        
        return
    end
    
    
    local found_mesh = false
    
    
    local cloud_remote = cloud:WaitForChild('ServerControl')
    
    
    local head_part = lplayer.Character.Humanoid:FindFirstChildOfClass('Part')
    
    
    local part_mesh = part:FindFirstChildOfClass('SpecialMesh')
    if part_mesh or part:IsA('MeshPart') then
        found_mesh = true
        for i, v in pairs(head_part:GetChildren()) do
            if v.ClassName ~= 'SpecialMesh' then
                v:Destroy()
            end
        end
    else
        head_part:ClearAllChildren()
    end
    

    

        
    spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = true, Property = 'Anchored', Object = head_part}) end)
    
    spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.CanCollide, Property = 'CanCollide', Object = head_part}) end)
    spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.Velocity, Property = 'Velocity', Object = head_part}) end)
    spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.RotVelocity, Property = 'RotVelocity', Object = head_part}) end)
    spawn(function()
        if part.ClassName ~= 'MeshPart' then
            cloud_remote:InvokeServer('SetProperty', {Value = part.Shape, Property = 'Shape', Object = head_part})
        end
    end)
    spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.Color, Property = 'Color', Object = head_part}) end)
    spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.CFrame, Property = 'CFrame', Object = head_part}) end)
    spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.Size, Property = 'Size', Object = head_part}) end)
    spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.Material, Property = 'Material', Object = head_part}) end)
    
    spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.BackSurface, Property = 'BackSurface', Object = head_part}) end)
    spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.BottomSurface, Property = 'BottomSurface', Object = head_part}) end)
    spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.FrontSurface, Property = 'FrontSurface', Object = head_part}) end)
    spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.LeftSurface, Property = 'BackSurface', Object = head_part}) end)
    spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.RightSurface, Property = 'BackSurface', Object = head_part}) end)
    spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.TopSurface, Property = 'TopSurface', Object = head_part}) end)
    spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = current_transpareny, Property = 'Transparency', Object = head_part}) end)
    
    
    if found_mesh == true and part.ClassName ~= 'MeshPart' then
        warn('mesh found, proceeding to modifying the mesh.')
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part_mesh.MeshId, Property = 'MeshId', Object = head_part.Mesh}) end)
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part_mesh.TextureId, Property = 'TextureId', Object = head_part.Mesh}) end)
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part_mesh.Scale, Property = 'Scale', Object = head_part.Mesh}) end)
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part_mesh.VertexColor, Property = 'VertexColor', Object = head_part.Mesh}) end)
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part_mesh.Offset, Property = 'Offset', Object = head_part.Mesh}) end)
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part_mesh.MeshType, Property = 'MeshType', Object = head_part.Mesh}) end)
    elseif part:IsA('MeshPart') then
        warn('meshpart found, modying the meshpart.')
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.MeshId, Property = 'MeshId', Object = head_part.Mesh}) end)
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = part.TextureID, Property = 'TextureId', Object = head_part.Mesh}) end)
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = Vector3.new(4, 4, 4), Property = 'Scale', Object = head_part.Mesh}) end)
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = Color3.fromRGB(1, 1, 1), Property = 'VertexColor', Object = head_part.Mesh}) end)
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = Vector3.new(0, 0, 0), Property = 'Offset', Object = head_part.Mesh}) end)
        spawn(function() cloud_remote:InvokeServer('SetProperty', {Value = Enum.MeshType.FileMesh, Property = 'MeshType', Object = head_part.Mesh}) end)
        
    end
    
    cloud_remote:InvokeServer('SetProperty', {Value = part.Name, Property = 'Name', Object = head_part})
    
    cloud_remote:InvokeServer('SetProperty', {Value = model, Property = 'Parent', Object = head_part})
    
    
    -- cloud_remote:InvokeServer('Fly', {['Flying'] = false})
end

getgenv().move = nil


getgenv().move = mouse.Move:Connect(function()
    if clicked == false then

            
        if isa_part == true then
            old_model.Position = mouse.Hit.p
            return
        end
        old_model:MoveTo(mouse.Hit.p)
        
    end
end)

mouse.Button1Up:Connect(function()


    if clicked == true then
        return
    end
    clicked = true
    getgenv().building = true
    
    local safety_count = 0
    
    if getgenv().move ~= nil then
        getgenv().move:Disconnect()
        getgenv().move = nil
    end


    for i, v in pairs(old_model:GetDescendants()) do
        if v:IsA('BasePart') then
            v.Anchored = true
            v.Transparency = .3
            
        end
    end
    

    
    
    
    for i, v in ipairs(old_model:GetDescendants()) do
        if getgenv().building == false then
            break
        end
        if v:IsA('Part') or v:IsA('Humanoid') then
            build(v)
            text.Text = string.format('%s/%s', i, count)
        end
    end
    
    old_model:Destroy()
    getgenv().building = false
    
    text.Text = 'Build Completed.'
    local tween = game:GetService('TweenService'):Create(text, TweenInfo.new(.25), {TextColor3 = Color3.fromRGB(0, 255, 0)})
    tween:Play()
    
    tween.Completed:Connect(function()
        wait(.5)
        gui:Destroy()
    end)
    
    
end)

lplayer.Chatted:Connect(function(msg)
    if msg == getgenv().stop_command then
        getgenv().building = false
    end
end)


uis.InputBegan:Connect(function(key, gameProcessed)
    if gameProcessed then
        return -- player is typing in a textbox / chatting
    end
    
    if key.KeyCode == Enum.KeyCode.R and clicked == false then
        if old_model ~= nil then
            old_model:SetPrimaryPartCFrame(old_model:GetPrimaryPartCFrame() * CFrame.Angles(0, math.rad(90), 0))
        end
    elseif key.KeyCode == Enum.KeyCode.T and clicked == false then
        if old_model ~= nil then
            old_model:SetPrimaryPartCFrame(old_model:GetPrimaryPartCFrame() * CFrame.Angles(math.rad(90), 0, 0))
        end
    elseif key.KeyCode == Enum.KeyCode.Y and clicked == false then
        if old_model ~= nil then
            old_model:SetPrimaryPartCFrame(old_model:GetPrimaryPartCFrame() * CFrame.Angles(0, 0, math.rad(90)))
        end
    end
end)

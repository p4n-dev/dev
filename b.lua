local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

Rayfield:Notify({
    Title = "p4n's housing",
    Content = "UwU Thanks For Using My Script 🐾🐾🐾 Meow",
    Duration = 15,
    Image = 4483362458,
 })

local Window = Rayfield:CreateWindow({
    Name = "v3r hub - Horrific Housing",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "by Sirius",
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "Big Hub"
    },
 
    Discord = {
       Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
 
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
       FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

 local Main = Window:CreateTab("Main", 4483362458)
 local Misc = Window:CreateTab("Misc", 4483362458)
 local Teleports = Window:CreateTab("Teleports", 4483362458)
 local UISettings = Window:CreateTab("UI Settings", 4483362458)


 local MiscGroup = Misc:CreateSection("Misc Settings", true)
 local Teleportssd = Teleports:CreateSection('Teleports', true)

 --// Services

local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Market = game:GetService("MarketplaceService")
local Info = Market:GetProductInfo(game.PlaceId)
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Cam = Workspace.CurrentCamera

--// Paths

local Ornaments = ReplicatedStorage.Ornaments
local Furnitures = ReplicatedStorage.Furniture
local LobbySpleef = workspace.Spleef
local Obby = workspace.Obby

--// Tables

local ornaments = {}
local furnitures = {}

--// Variables

local OrnamentSlot = "Ornament1"
local Ornament = ""
local Furniture = ""
local FurnitureSlot = "Furniture1"

local NoBoomDmg = false
local BringAll = false
local InfJump = false
local AutoHit = false
local nohold = false

for i, v in next, Ornaments:GetChildren() do
    if v:IsA("Model") then
        table.insert(ornaments, v.Name)
    end
end

for i, v in next, Furnitures:GetChildren() do
    if v:IsA("Model") then
        table.insert(furnitures, v.Name)
    end
end

local old; old = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FireServer" and self.Name == "damageMe" and NoBoomDmg and not checkcaller() then
        args[1] = 0
        return old(self, unpack(args))
    end

    return old(self, ...)
end)

function Bringall()
    for i, v in next, Players:GetPlayers() do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Team.Name == "Playing" then
            v.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 3
        end
    end
end

function Hitall()
    for i, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and (v.Team and (v.Team.Name == "Playing" or (IncludeLobby and v.Team.Name == "Lobby"))) then
            local targetPos = v.Character.HumanoidRootPart.Position
            local targetPart = v.Character.HumanoidRootPart
            local args = { targetPos, targetPart, 5 }

            if LocalPlayer.Character then
                local tool = LocalPlayer.Character:FindFirstChild("Coconut") 
                          or LocalPlayer.Character:FindFirstChild("Snowball") 
                          or LocalPlayer.Character:FindFirstChild("Thunder Staff")
                          or LocalPlayer.Character:FindFirstChild("PaintballGun")

                if tool and tool:FindFirstChild("throwEvent") then
                    tool.throwEvent:FireServer(unpack(args))
                elseif tool and tool:FindFirstChild("remote") then
                    tool.remote:FireServer(unpack(args))
                elseif tool and tool:FindFirstChild("RemoteEvent") then
                    tool.RemoteEvent:FireServer(unpack(args))
                end
            end
        end
    end
end



RunService.RenderStepped:Connect(function()
    if BringAll then
        Bringall()
    end

    if AutoHit then
        Hitall()
    end
end)

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if nohold then
        prompt.HoldDuration = 0
    end
end)

UserInputService.JumpRequest:Connect(function()
    if InfJump then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

Main:CreateSection("Game Settings")

if hookmetamethod then
    Main:CreateToggle({
        Name =  'No Explosive Damage',
        CurrentOption = false,
    
        Callback = function(Value)
            NoBoomDmg = Value
        end
    })
    else
        Main:CreateLabel("Your executor does not support hookmetamethod which couldnt load this feature: No Explosive Damage", 4483362458, Color3.fromRGB(255, 255, 255), false) -- Title, Icon, Color, IgnoreTheme
    end

    Main:CreateToggle({
        Name = 'Bring All',
        CurrentOption = false,
    
        Callback = function(Value)
            BringAll = Value
        end
    })
    
    Main:CreateToggle({
        Name = 'Auto Hit All',
        CurrentOption = false,
    
        Callback = function(Value)
            AutoHit = Value
        end
    })
    
    Main:CreateToggle({
        Name = 'Include Lobby Players',
        CurrentOption = false,
    
        Callback = function(Value)
            IncludeLobby = Value
        end
    })
    
    Main:CreateToggle({
        Name = 'No Hold Delay',
        CurrentOption = false,
    
        Callback = function(Value)
            nohold = Value
        end
    })
    
    Main:CreateDivider()
    
    Main:CreateButton({
        Name = 'Delete Map (Easy Wins)',
        Callback = function()
            for i = 1, 7000 do
                ReplicatedStorage.EventRemotes.Potion:FireServer(true)
            end
        end,
        DoubleClick = false,
    })
    
    Main:CreateButton({
        Name = 'Hit All With Coconut (Killall)',
        Callback = function()
            for i, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and LocalPlayer.Character:FindFirstChild("Coconut") and v.Character:FindFirstChild("HumanoidRootPart") then
                    local args = {
                        [1] = v.Character.HumanoidRootPart.Position,
                        [2] = v.Character.HumanoidRootPart,
                        [3] = 5
                    }
                    
                    LocalPlayer.Character:FindFirstChild("Coconut").throwEvent:FireServer(unpack(args))
                end
            end
        end,
        DoubleClick = false,
    })
    
    Main:CreateButton({
        Name = 'Spam Hit All With Snowball (Killall)',
        Callback = function()
            for i, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and LocalPlayer.Character:FindFirstChild("Snowball") and v.Character:FindFirstChild("HumanoidRootPart") then
                    local args = {
                        [1] = v.Character.HumanoidRootPart.Position,
                        [2] = v.Character.HumanoidRootPart,
                        [3] = 5
                    }
                    
                    LocalPlayer.Character:FindFirstChild("Snowball").remote:FireServer(unpack(args))
                end
            end
        end,
        DoubleClick = false,
    })
    
    Main:CreateButton({
        Name = 'Spam Hit All With Paintball Gun (Killall)',
        Callback = function()
            for i, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and LocalPlayer.Character:FindFirstChild("PaintballGun") and v.Character:FindFirstChild("HumanoidRootPart") then
                    local args = {
                        [1] = v.Character.HumanoidRootPart.Position,
                        [2] = v.Character.HumanoidRootPart,
                        [3] = 5
                    }
                    
                    LocalPlayer.Character:FindFirstChild("PaintballGun").remote:FireServer(unpack(args))
                end
            end
        end,
        DoubleClick = false,
    })
    
    Main:CreateButton({
        Name = 'Spam Hit All With Thunder Staff (Killall)',
        Callback = function()
            for i, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and LocalPlayer.Character:FindFirstChild("Thunder Staff") and v.Character:FindFirstChild("HumanoidRootPart") then
                    local args = {
                        [1] = v.Character.HumanoidRootPart.Position,
                        [2] = v.Character.HumanoidRootPart,
                        [3] = 5
                    }
                    
                    LocalPlayer.Character:FindFirstChild("Thunder Staff").RemoteEvent:FireServer(unpack(args))
                end
            end
        end,
        DoubleClick = false,
    })
    
    Main:CreateButton({
        Name = 'Drink random potion',
        Callback = function()
            ReplicatedStorage.EventRemotes.Potion:FireServer(true)
        end,
        DoubleClick = false,
    })
    
    Main:CreateButton({
        Name = 'Expand Plate Size',
        Callback = function()
            local Plates = Workspace.Plates[LocalPlayer.Name]
            if Plates then
                local Plate = Plates:FindFirstChild("Plate")
                if Plate then
                    Plate.Size = Vector3.new(250, 1, 250)
                end
            end
        end,
        DoubleClick = false,
    })
    
    Main:CreateButton({
        Name = 'Spleef All Tiles',
        Callback = function()
            local SpleefFolder = Workspace["Spleef Arena"]
    
            for i, v in next, SpleefFolder:GetChildren() do
                if v:IsA("Part") then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
                end
            end
        end,
        DoubleClick = false,
    })
    
    Main:CreateButton({
        Name = 'Remove Lava Kill Part',
        Callback = function()
            local LavaPlate = Workspace.LavaPlate
            LavaPlate:FindFirstChild("TouchInterest"):Destroy()
        end,
        DoubleClick = false,
    })
    
    Main:CreateButton({
        Name = 'Remove Spinner Kill Part',
        Callback = function()
            local Spinnnnnnnnnner = Workspace.Spinner.Sweeper
            Spinnnnnnnnnner:FindFirstChild("TouchInterest"):Destroy()
        end,
        DoubleClick = false,
    })
    
    Main:CreateButton({
        Name = 'Remove Acid Flood Kill Part',
        Callback = function()
            local KillPart = Workspace.Kill
            KillPart:FindFirstChild("TouchInterest"):Destroy()
        end,
        DoubleClick = false,
    })
    
    Main:CreateButton({
        Name = 'Remove Sticky Part',
        Callback = function()
            for i, v in Players:GetPlayers() do
                if v ~= LocalPlayer and v.Team.Name == "Playing" then
                    local StickyPart = Workspace.Plates[v.Name] or workspace.Plates.Plate
                    if StickyPart then
                        StickyPart:FindFirstChild("slime"):Destroy()
                    end
                end
            end
        end,
        DoubleClick = false,
    })

    Main:CreateSection("Lobby Settings", true)
    
    Main:CreateButton({
        Name = 'Spleef Lobby Tiles',
        Callback = function()
            for i, v in next, LobbySpleef:GetChildren() do
                if v:IsA("Part") then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
                end
            end
        end,
        DoubleClick = false,
    })
    
    Main:CreateButton({
        Name = 'Claim all Obby Rewards',
        Callback = function()
            for i, v in next, Obby.ImportantParts:GetChildren() do
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
            end
        end,
        DoubleClick = false,
    })
    
    Main:CreateButton({
        Name = 'Dupe Eggs',
        Callback = function()
            local Eggs = LocalPlayer.Eggs
            for i, v in next, Eggs:GetChildren() do
                if v:IsA("NumberValue") then
                    for eggy = 1, 4 do
                        v:Clone().Parent = Eggs
                    end
                    Library:Notify("Duplicated "..v.Name, 5)
                end
            end
        end,
        DoubleClick = false,
    })

    Main:CreateSection("House Settings", true)
    
    Main:AddDropdown('Furniture Selector', {
        Options = furnitures,
        CurrentOption = "",
        MultipleOptions = false,
        Name = 'Furniture Selector',
    
        Callback = function(Value)
            Furniture = Value
        end
    })
    
    Main:AddDropdown('Slot Selector', {
        Options = { 'Furniture1', 'Furniture2', 'Furniture3' },
        CurrentOption = "Furniture1",
        MultipleOptions = false,
        Name = 'Slot Selector',
    
        Callback = function(Value)
            FurnitureSlot = Value
        end
    })
    
    Main:CreateButton({
        Name = 'Equip Furniture',
        Callback = function()
            ReplicatedStorage:WaitForChild("FurnitureChanged"):FireServer(FurnitureSlot, Furniture)
        end,
        DoubleClick = false,
    })
    
    Main:CreateDivider()
    
    Main:AddDropdown('Ornaments Selector', {
        Options = ornaments,
        CurrentOption = "",
        MultipleOptions = false,
        Name = 'Ornaments Selector',
    
        Callback = function(Value)
            Ornament = Value
        end
    })
    
    Main:AddDropdown('Slot Selector', {
        Options = { 'Ornament1', 'Ornament2', 'Ornament3' },
        CurrentOption = "Ornament1",
        MultipleOptions = false,
        Name = 'Slot Selector',
    
        Callback = function(Value)
            OrnamentSlot = Value
        end
    })
    
    Main:CreateButton({
        Name = 'Equip Ornament',
        Callback = function()
            ReplicatedStorage:WaitForChild("OrnamentChanged"):FireServer(OrnamentSlot, Ornament)
        end,
        DoubleClick = false,
    })
    
    Main:CreateDivider()
    
    Main:AddLabel('House Color'):AddColorPicker('House Color', {
        CurrentOption = Color3.fromRGB(255, 255, 255),
        Title = 'House Color Picker',
    
        Callback = function(Value)
            HouseColor = Value
        end
    })
    
    Main:CreateButton({
        Name = 'Change House Color',
        Callback = function()
            game:GetService("ReplicatedStorage"):WaitForChild("HouseColour"):FireServer(HouseColor)        
        end,
        DoubleClick = false,
    })
    
    MiscGroup:CreateToggle('InfJump', {
        Name = 'Infinite Jump',
        CurrentOption = false,
        Callback = function(Value)
            InfJump = Value
        end
    })
    
    Teleports:CreateButton({
        Name = 'Tp under obby start',
        Callback = function()
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2.914475202560425, -12.149168014526367, -62.4456787109375)
        end,
        DoubleClick = false,
    })
    
    Teleports:CreateButton({
        Name = 'Tp To Illumiati',
        Callback = function()
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0.36450493335723877, 5.543025016784668, -16.87293243408203)
        end,
        DoubleClick = false,
    })
    
    Teleports:CreateButton({
        Name = 'Tp To Spec Button',
        Callback = function()
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(7.635685443878174, 5.498024940490723, -3.420691967010498)
        end,
        DoubleClick = false,
    })
    
    Teleports:CreateButton({
        Name = 'Tp Infront Of Obby',
        Callback = function()
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1.1615108251571655, 17.542022705078125, -109.22512817382812)
        end,
        DoubleClick = false,
    })
    
    Teleports:CreateButton({
        Name = 'Tp To Obby Victory1',
        Callback = function()
            local Victory1 = Obby.ImportantParts.Victory1
            LocalPlayer.Character.HumanoidRootPart.CFrame = Victory1.CFrame
        end,
        DoubleClick = false,
    })
    
    Teleports:CreateButton({
        Name = 'Tp To Obby Victory2',
        Callback = function()
            local Victory1 = Obby.ImportantParts.Victory2
            LocalPlayer.Character.HumanoidRootPart.CFrame = Victory2.CFrame
        end,
        DoubleClick = false,
    })
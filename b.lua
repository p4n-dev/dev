local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

Rayfield:Notify({
    Title = "p4n's housing",
    Content = "UwU Thanks For Using My Script 🐾🐾🐾 Meow",
    Duration = 15,
    Image = 4483362458,
 })

local Window = Rayfield:CreateWindow({
    Name = "Rayfield Example Window",
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
 local ['UI Settings'] = Window:CreateTab("UI Settings", 4483362458)

 local InGameGroup = Main:CreateSection("Game Settings")
 local HouseGroup = Main:CreateSection("House Settings")
 local LobbyGroup = Main:CreateSection("Lobby Settings")
 local MiscGroup = Misc:CreateSection("Misc Settings")
 local TpGroup = Teleports:CreateSection('Teleports')

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

if hookmetamethod then
    InGameGroup:CreateToggle('No Explosive Damage', {
        Name =  'No Explosive Damage',
        CurrentValue = false,
        Tooltip = 'Removes explosive damage from rockets etc. (Wont work for all)',
    
        Callback = function(Value)
            NoBoomDmg = Value
        end
    })
    else
        InGameGroup:CreateLabel("Your executor does not support hookmetamethod which couldnt load this feature: No Explosive Damage", 4483362458, Color3.fromRGB(255, 255, 255), false) -- Title, Icon, Color, IgnoreTheme
    end
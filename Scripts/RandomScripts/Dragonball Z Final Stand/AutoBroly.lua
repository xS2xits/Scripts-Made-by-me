--[[
    Hallo ma scripter friend, its dangerous to go alone, take this code.
    AutoBroly made by CrabGuy#8711 (if you wanna use parts of it just credit me, and make me know so i will give you a kiss)
]]


_G.BrolySettings = _G.BrolySettings or {
    Moves = {
    "Deadly Dance",
    "Blaster Meteor",
    "God Slicer",
    "Anger Rush",
    "Meteor Crash",
    "TS Molotov",
    "Flash Skewer",
    "Vital Strike",
    "Demon Flash",
    "Wolf Fang Fist",
    "Neo Wolf Fang Fist",
    "Power Impact",
    "Combo Barrage",
    "Sweep Kick",
    "Strong Kick",
    },
    FreezeExp = true, -- true or false (makes the double exp gamepass be infinite)
    ChargeTime = 3.9, -- Time in seconds to charge before going in form (for androids its automatic)
    World = "Earth", -- Either "Queue" or "Earth"
    LowGraphics = true, -- true or false (makes the game look shit but boosts fps)
    PunchWhenLowKi = true -- true or false (makes you dropkick broly then you have low ki)
}

if not game:IsLoaded() then
    game.Loaded:Wait()
end
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Camera = workspace:WaitForChild("Camera")
local Backpack = Player:WaitForChild("Backpack")
local ServerTraits = Backpack:WaitForChild("ServerTraits")

if _G.BrolySettings.FreezeExp then
    local TimerLabel = Player.PlayerGui:WaitForChild("HUD"):WaitForChild("FullSize"):WaitForChild("Timer")
    if not (TimerLabel.Text == "") then
        Player.CharacterAdded:Connect(function(Char)
            local TrueValue = Char:WaitForChild("True")
            TrueValue:Destroy()
        end)
    end
end

if _G.BrolySettings.LowGraphics then --Straight from Infinite Yield, credits to them
    workspace:FindFirstChildOfClass('Terrain').WaterWaveSize = 0
    workspace:FindFirstChildOfClass('Terrain').WaterWaveSpeed = 0
    workspace:FindFirstChildOfClass('Terrain').WaterReflectance = 0
    workspace:FindFirstChildOfClass('Terrain').WaterTransparency = 0
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").FogEnd = 9e9
    settings().Rendering.QualityLevel = 1
    for i,v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        end
    end
    for i,v in pairs(game:GetService("Lighting"):GetDescendants()) do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
            v.Enabled = false
        end
    end
    workspace.DescendantAdded:Connect(function(child)
        coroutine.wrap(function()
            if child:IsA('ForceField') then
                game:GetService('RunService').Heartbeat:Wait()
                child:Destroy()
            elseif child:IsA('Sparkles') then
                game:GetService('RunService').Heartbeat:Wait()
                child:Destroy()
            elseif child:IsA('Smoke') or child:IsA('Fire') then
                game:GetService('RunService').Heartbeat:Wait()
                child:Destroy()
            end
        end)()
    end)
end

local WeAreInBroly = (game.PlaceId == 2050207304)
local MainWorldId = 3565304751 --Queue Id
if _G.BrolySettings.World == "Earth" then
    MainWorldId = 536102540 --Earth Id
end
local function BackToMainWorld()
    game:GetService("TeleportService"):Teleport(MainWorldId)
end
if not (game.PlaceId == MainWorldId) and not WeAreInBroly then
    BackToMainWorld()
end

local Char = Player.Character or Player.CharacterAdded:Wait()
local Hrp = Char:WaitForChild("HumanoidRootPart")
local Hum = Char:WaitForChild("Humanoid")

if not WeAreInBroly then --MainWorld Setup
    local PowerOutput = Char:WaitForChild("PowerOutput")
    PowerOutput:Destroy()
    local TeleportPad = workspace:WaitForChild("BrolyTeleport")
    local GoalCFrame = TeleportPad:GetModelCFrame() * CFrame.new(0, -3, 0)
    RunService.Heartbeat:Connect(function(deltaTime)
        Hrp.CFrame = GoalCFrame
    end)
    return
end

local Broly = workspace:WaitForChild("Live"):WaitForChild("Broly BR")
local BrolyHrp = Broly:WaitForChild("HumanoidRootPart")
local BrolyHum = Broly:WaitForChild("Humanoid")
for i, v in pairs(Broly:GetDescendants()) do
    if v:IsA("BasePart") and not v.Anchored then
        v.Anchored = true
    end
end

workspace.ChildAdded:Connect(function(child)
    if child.Name == "ExplosiveWave" then
        game:GetService("RunService").Stepped:Wait()
        child:Destroy()
    end
end)

local Slows = {"KnockBacked", "creator", "Action", "Slow", "NotHardBack", "Using", "Attacking", "Hyper", "heavy", "BodyVelocity", "hyper", "Throw", "Flip", "RightGrip"}
Char.DescendantAdded:Connect(function(child)
    if table.find(Slows, child.Name) then
        game:GetService("RunService").Stepped:Wait()
        child:Destroy()
    end
end)

local Android = (Char:WaitForChild("Race").Value == "Android")
local InputEvent = ServerTraits:WaitForChild("Input")
local TransformEvent = ServerTraits:WaitForChild("Transform")
if not Android and not Char:FindFirstChild("TempAura", true) then
    InputEvent:FireServer({"x"}, CFrame.new(), nil)
    task.wait(_G.BrolySettings.ChargeTime)
    TransformEvent:FireServer("h")
    Hrp.ChildAdded:Wait()
    InputEvent:FireServer({"xoff"}, CFrame.new(), nil)
end
Hum.HealthChanged:Connect(function(health)
    if (health <= Hum.MaxHealth * 1/10) then
        TransformEvent:FireServer("g")
    end
    if health == 1 then
        BackToMainWorld()
    end
end)

local EnoughKi = true
local KiValue = Char:WaitForChild("Ki")
local MaxKi = KiValue.Value
KiValue.Changed:Connect(function(property)
    if (property <= MaxKi * 7/10) and Android then
        TransformEvent:FireServer("g")
    end
    if property < 40 then
        EnoughKi = false
    else
        EnoughKi = true
    end
end)

BrolyHum.HealthChanged:Connect(function(health)
    Broly.Name = tostring(math.ceil(health)).."/"..BrolyHum.MaxHealth
end)

Hum:ChangeState(Enum.HumanoidStateType.StrafingNoPhysics) -- Might as well ¯\_(ツ)_/¯

RunService.Heartbeat:Connect(function()
    local BrolyPosition = BrolyHrp.CFrame.Position
    Hrp.CFrame = CFrame.new(BrolyPosition + Vector3.new(2, 0, 0), BrolyPosition)
    Camera.CameraType = Enum.CameraType.Scriptable
    Camera.CFrame = CFrame.new(Hrp.Position + Vector3.new(0, 10, 0) - Hrp.CFrame.LookVector * 10, BrolyPosition)
end)

local ThrowMove = Backpack:FindFirstChild("Dragon Throw") or Backpack:FindFirstChild("Dragon Crush") or Backpack:WaitForChild("Dragon Throw", 5) or Backpack:WaitForChild("Dragon Crush")

while not Broly:FindFirstChild("MoveStart") do
    ThrowMove.Parent = Player.Character
    local Flip = ThrowMove:FindFirstChild("Flip", true)
    if Flip then
        Flip:Destroy()
    end
    wait()
    ThrowMove:Activate()
    task.wait()
    ThrowMove.Parent = Backpack
end

local SenzuEvent = ServerTraits:WaitForChild("EatSenzu")
SenzuEvent:FireServer(true)
Hrp.ChildRemoved:Connect(function(child)
    if child.Name == "Critz" then
        SenzuEvent:FireServer(true)
    end
end)

Player:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("FullSize"):WaitForChild("Money3"):GetPropertyChangedSignal("Visible"):Connect(BackToMainWorld)

while true do --Needs to be a loop because of the wait <3
    if EnoughKi then
        for i, Move in pairs(Backpack:GetChildren()) do
            if table.find(_G.BrolySettings.Moves, Move.Name) then
                Move.Parent = Player.Character
                Move:Activate()
                task.wait()
                Move.Parent = Backpack
            end
        end
    else
        InputEvent:FireServer({"m2"}, CFrame.new(), nil, false)
        task.wait()
    end
end
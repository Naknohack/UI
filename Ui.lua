repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local plr = Players.LocalPlayer
local PlayerGui = plr:WaitForChild("PlayerGui")

-- XÓA UI CŨ
if PlayerGui:FindFirstChild("NakHubProMax") then
    PlayerGui.NakHubProMax:Destroy()
end

-- GUI
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "NakHubProMax"
ScreenGui.ResetOnSpawn = false

-- 🌌 SAO BĂNG
local BG = Instance.new("Frame", ScreenGui)
BG.Size = UDim2.new(1,0,1,0)
BG.BackgroundTransparency = 1

task.spawn(function()
    while task.wait(0.25) do
        local star = Instance.new("Frame", BG)
        star.Size = UDim2.new(0,2,0,2)
        star.Position = UDim2.new(math.random(),0,-0.1,0)
        star.BackgroundColor3 = Color3.new(1,1,1)

        TweenService:Create(star, TweenInfo.new(1.5), {
            Position = UDim2.new(math.random(),0,1.1,0)
        }):Play()

        game.Debris:AddItem(star,1.5)
    end
end)

-- MAIN
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,450,0,220)
Main.Position = UDim2.new(0.5,0,0.5,0)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,8)

-- SCALE ANIMATION
local Scale = Instance.new("UIScale", Main)
Scale.Scale = 0

TweenService:Create(Scale, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
    Scale = 1
}):Play()

-- 💧 WAVE (nước nhẹ)
local Wave = Instance.new("Frame", Main)
Wave.Size = UDim2.new(1,0,1,0)
Wave.BackgroundColor3 = Color3.fromRGB(0,120,255)
Wave.BackgroundTransparency = 0.9

task.spawn(function()
    while task.wait(0.05) do
        Wave.Position = UDim2.new(0,0,0,math.sin(tick()*2)*3)
    end
end)

-- 🖼 AVATAR
local Avatar = Instance.new("ImageLabel", Main)
Avatar.Size = UDim2.new(0,50,0,50)
Avatar.Position = UDim2.new(0,10,0,10)
Avatar.Image = "rbxassetid://100306458933414"
Avatar.BackgroundTransparency = 1

-- TITLE
local Title = Instance.new("TextLabel", Main)
Title.Position = UDim2.new(0,70,0,10)
Title.Size = UDim2.new(1,-120,0,30)
Title.Text = "NakHub Auto Bounty"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.TextScaled = true
Title.TextXAlignment = Enum.TextXAlignment.Left

-- CLOSE
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0,30,0,30)
Close.Position = UDim2.new(1,-35,0,10)
Close.Text = "—"
Close.BackgroundColor3 = Color3.fromRGB(40,40,40)

-- OPEN BUTTON
local Open = Instance.new("TextButton", ScreenGui)
Open.Size = UDim2.new(0,120,0,35)
Open.Position = UDim2.new(0,20,0,100)
Open.Text = "Open UI"
Open.BackgroundColor3 = Color3.fromRGB(0,120,255)
Open.Visible = false

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    Open.Visible = true
end)

Open.MouseButton1Click:Connect(function()
    Main.Visible = true
    Open.Visible = false
end)

-- CONTAINER
local Container = Instance.new("Frame", Main)
Container.Position = UDim2.new(0,10,0,70)
Container.Size = UDim2.new(1,-20,1,-80)
Container.BackgroundTransparency = 1

local Grid = Instance.new("UIGridLayout", Container)
Grid.CellSize = UDim2.new(0.48,0,0.45,0)
Grid.CellPadding = UDim2.new(0.02,0,0.05,0)

-- BOX
local function Box(text)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,6)

    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1,0,1,0)
    t.BackgroundTransparency = 1
    t.TextColor3 = Color3.new(1,1,1)
    t.TextScaled = true
    t.Text = text

    return f, t
end

local BountyBox, Bounty = Box("0")
BountyBox.Parent = Container

local EarnBox, Earned = Box("0")
EarnBox.Parent = Container

local KillBox, Kill = Box("0")
KillBox.Parent = Container

local TimeBox, Time = Box("0s")
TimeBox.Parent = Container

-- 📊 BOUNTY
local function getBounty()
    local stats = plr:FindFirstChild("leaderstats")
    if stats then
        for _,v in pairs(stats:GetChildren()) do
            if string.find(v.Name,"Bounty") or string.find(v.Name,"Honor") then
                return v.Value
            end
        end
    end
    return 0
end

local function format(n)
    if n >= 1e6 then
        return string.format("%.1fM", n/1e6)
    elseif n >= 1e3 then
        return string.format("%.1fK", n/1e3)
    else
        return tostring(n)
    end
end

-- UPDATE
task.spawn(function()
    local start = getBounty()
    local last = start
    local kill = 0
    local time = 0

    while task.wait(1) do
        time += 1
        local current = getBounty()

        if current > last then
            kill += 1
        end

        last = current

        Bounty.Text = "💰 "..format(current)
        Earned.Text = "📈 "..format(current - start)
        Kill.Text = "⚔ "..kill
        Time.Text = "⏱ "..time.."s"
    end
end)

--[[
    LUAWARE HUB - THE TRUE HAWK REPLICA + LIQUID DRAG ENGINE
    YAPIMCI: NOXYORJ
    Tasarım: Birebir Orijinal Hawk (Kompakt ve Karanlık)
    Motor: Ultra Yumuşak "Liquid" Drag & Inertia (Yağ gibi kayar)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = LocalPlayer:WaitForChild("PlayerGui")

-- Eski Menüyü Temizle
for _, v in pairs(CoreGui:GetChildren()) do 
    if v.Name == "LuawareTrueClone" then v:Destroy() end 
end

-- ============================================
-- BİREBİR RESİMDEKİ RENKLER (Sade ve Karanlık)
-- ============================================
local Theme = {
    Main = Color3.fromRGB(25, 25, 25),       
    TopLine = Color3.fromRGB(45, 45, 45),    
    TabActive = Color3.fromRGB(45, 45, 45),  
    Text = Color3.fromRGB(255, 255, 255),    
    SubText = Color3.fromRGB(180, 180, 180), 
    RedText = Color3.fromRGB(255, 80, 80)    
}

-- ============================================
-- ULTRA YUMUŞAK SÜZÜLME MOTORU (LIQUID DRAG)
-- ============================================
local function MakeSmoothDraggable(dragObject, targetObject)
    local dragging = false
    local dragStart = Vector2.new()
    local startPos = UDim2.new()
    local velocity = Vector2.new()
    local lastPos = Vector2.new()
    local lastTime = tick()
    local dragConnection = nil
    
    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = targetObject.Position
            lastPos = input.Position
            lastTime = tick()
            velocity = Vector2.new()
            
            dragConnection = UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local now = tick()
                    local dt = now - lastTime
                    if dt > 0.001 then
                        velocity = (input.Position - lastPos) / dt
                        lastPos = input.Position
                        lastTime = now
                    end
                    local delta = input.Position - dragStart
                    
                    -- Fareyi takip ederkenki yumuşaklık (Titremeyi %100 önler)
                    TweenService:Create(targetObject, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                        Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                    }):Play()
                end
            end)
            
            local releaseConn; releaseConn = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    if dragConnection then dragConnection:Disconnect() end
                    releaseConn:Disconnect()
                    
                    -- Bırakıldığında buzun üstündeymiş gibi süzülme (Süre: 0.6s, Easing: Quart)
                    if velocity.Magnitude > 10 then
                        local inertiaPos = UDim2.new(
                            targetObject.Position.X.Scale, targetObject.Position.X.Offset + velocity.X * 0.15, 
                            targetObject.Position.Y.Scale, targetObject.Position.Y.Offset + velocity.Y * 0.15
                        )
                        TweenService:Create(targetObject, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Position = inertiaPos
                        }):Play()
                    end
                end
            end)
        end
    end)
end

-- Ana Menü Gövdesi
local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "LuawareTrueClone"; sg.ResetOnSpawn = false

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 520, 0, 320) -- BİREBİR KOMPAKT BOYUT
Main.Position = UDim2.new(0.5, -260, 0.5, -160)
Main.BackgroundColor3 = Theme.Main
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local stroke = Instance.new("UIStroke", Main)
stroke.Color = Theme.TopLine; stroke.Thickness = 1

-- Üst Bar
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundTransparency = 1

local Line = Instance.new("Frame", TopBar)
Line.Size = UDim2.new(1, 0, 0, 1); Line.Position = UDim2.new(0, 0, 1, 0)
Line.BackgroundColor3 = Theme.TopLine; Line.BorderSizePixel = 0

local Icon = Instance.new("ImageLabel", TopBar)
Icon.Size = UDim2.new(0, 16, 0, 16); Icon.Position = UDim2.new(0, 12, 0, 9)
Icon.BackgroundTransparency = 1; Icon.Image = "rbxassetid://13570069771"

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 200, 1, 0); Title.Position = UDim2.new(0, 36, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = "Luaware HUB" 
Title.TextColor3 = Theme.Text; Title.Font = Enum.Font.GothamBold; Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextLabel", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 1, 0); CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.Text; CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 12

-- Ultra Yumuşak Motorumuzu Bağlıyoruz
MakeSmoothDraggable(TopBar, Main)

-- Yan Menü (Sekmeler)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 110, 1, -36); Sidebar.Position = UDim2.new(0, 0, 0, 36)
Sidebar.BackgroundTransparency = 1

local TabList = Instance.new("ScrollingFrame", Sidebar)
TabList.Size = UDim2.new(1, -10, 1, -10); TabList.Position = UDim2.new(0, 5, 0, 5)
TabList.BackgroundTransparency = 1; TabList.ScrollBarThickness = 0
Instance.new("UIListLayout", TabList).Padding = UDim.new(0, 4)

-- İçerik Alanı
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -115, 1, -45); Content.Position = UDim2.new(0, 115, 0, 40)
Content.BackgroundTransparency = 1

local Tabs = {}; local Pages = {}; local isFirst = true

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton", TabList)
    TabBtn.Size = UDim2.new(1, 0, 0, 28)
    TabBtn.BackgroundColor3 = isFirst and Theme.TabActive or Theme.Main
    TabBtn.BackgroundTransparency = isFirst and 0 or 1
    TabBtn.Text = "   " .. name
    TabBtn.TextColor3 = Theme.Text
    TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 12; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

    local Page = Instance.new("Frame", Content)
    Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = isFirst

    table.insert(Tabs, TabBtn); table.insert(Pages, Page); isFirst = false

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, t in pairs(Tabs) do t.BackgroundTransparency = 1; t.BackgroundColor3 = Theme.Main end
        TabBtn.BackgroundTransparency = 0; TabBtn.BackgroundColor3 = Theme.TabActive; Page.Visible = true
    end)
    return Page
end

-- =======================================
-- SEKMELERİ OLUŞTUR
-- =======================================
local PageHome = CreateTab("Home")
local PageGames = CreateTab("Games")
local PageUpdates = CreateTab("Updates")
local PageKrediler = CreateTab("Krediler")
local PageLaunch = CreateTab("Launch")

-- =======================================
-- BİREBİR PROFİL TASARIMI (HOME)
-- =======================================
local WelcomeTitle = Instance.new("TextLabel", PageHome)
WelcomeTitle.Size = UDim2.new(1, 0, 0, 20); WelcomeTitle.BackgroundTransparency = 1
WelcomeTitle.Text = "Welcome to Luaware HUB"
WelcomeTitle.TextColor3 = Theme.Text; WelcomeTitle.Font = Enum.Font.GothamBold; WelcomeTitle.TextSize = 13; WelcomeTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Profil Avatarı
local Avatar = Instance.new("ImageLabel", PageHome)
Avatar.Size = UDim2.new(0, 40, 0, 40); Avatar.Position = UDim2.new(0, 0, 0, 30); Avatar.BackgroundColor3 = Theme.TabActive
Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

-- İsimler
local DisplayName = Instance.new("TextLabel", PageHome)
DisplayName.Size = UDim2.new(0, 200, 0, 15); DisplayName.Position = UDim2.new(0, 50, 0, 32); DisplayName.BackgroundTransparency = 1
DisplayName.Text = LocalPlayer.DisplayName; DisplayName.TextColor3 = Theme.Text; DisplayName.Font = Enum.Font.GothamBold; DisplayName.TextSize = 12; DisplayName.TextXAlignment = Enum.TextXAlignment.Left

local UserName = Instance.new("TextLabel", PageHome)
UserName.Size = UDim2.new(0, 200, 0, 15); UserName.Position = UDim2.new(0, 50, 0, 47); UserName.BackgroundTransparency = 1
UserName.Text = "@" .. LocalPlayer.Name; UserName.TextColor3 = Theme.SubText; UserName.Font = Enum.Font.Gotham; UserName.TextSize = 11; UserName.TextXAlignment = Enum.TextXAlignment.Left

-- Bilgi Yazıları
local InfoText = Instance.new("TextLabel", PageHome)
InfoText.Size = UDim2.new(1, 0, 0, 150); InfoText.Position = UDim2.new(0, 0, 0, 85); InfoText.BackgroundTransparency = 1
InfoText.TextColor3 = Theme.Text; InfoText.Font = Enum.Font.GothamBold; InfoText.TextSize = 11; InfoText.TextXAlignment = Enum.TextXAlignment.Left; InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.RichText = true; InfoText.LineHeight = 1.3

local execName = identifyexecutor and identifyexecutor() or "Xeno"
local gameName = "Bilinmiyor"
pcall(function() gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)

InfoText.Text = string.format(
    "Roblox User Name: <font color='rgb(180,180,180)'>%s</font>\n" ..
    "Game Id: <font color='rgb(180,180,180)'>%d</font>\n" ..
    "Game Name: 🟢 <font color='rgb(180,180,180)'>%s</font>\n" ..
    "Place Id: <font color='rgb(180,180,180)'>%d</font>\n" ..
    "Server: <font color='rgb(180,180,180)'>3/6</font>\n" ..
    "Executor: <font color='rgb(255,80,80)'>%s</font>\n" ..
    "Executor Level: <font color='rgb(255,80,80)'>3</font>",
    LocalPlayer.Name, game.GameId, gameName, game.PlaceId, execName
)

-- Menü Gizle/Aç (RightShift)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

print("Luaware HUB | Ultra Soft Drag Engine Aktif!")

-- =======================================================
-- LUAWARE MÜTEVAZİ KÜTÜPHANE (CUSTOM ENGINE)
-- Resimdeki Sadeliğin ve Mat Temanın Birebir Aynısı
-- =======================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- Eski menüyü temizle (Hata vermemesi için)
local old = pcall(function() return CoreGui:FindFirstChild("LuawareModest") end)
if CoreGui:FindFirstChild("LuawareModest") then CoreGui.LuawareModest:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "LuawareModest"
sg.ResetOnSpawn = false
local success = pcall(function() sg.Parent = CoreGui end)
if not success then sg.Parent = LP:WaitForChild("PlayerGui") end

-- RENK PALETİ (Resimdeki mat, koyu gri tonlar)
local Colors = {
    MainBg = Color3.fromRGB(30, 30, 30),
    SidebarBg = Color3.fromRGB(24, 24, 24),
    TopBarBg = Color3.fromRGB(35, 35, 35),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(160, 160, 160),
    TabActive = Color3.fromRGB(45, 45, 45),
    Indicator = Color3.fromRGB(200, 200, 200)
}

-- 1. ANA KASA
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 480, 0, 300) -- Resimdeki gibi mütevazı bir boyut
Main.Position = UDim2.new(0.5, -240, 0.5, -150)
Main.BackgroundColor3 = Colors.MainBg
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local stroke = Instance.new("UIStroke", Main); stroke.Color = Color3.fromRGB(50, 50, 50)

-- 2. ÜST BAR
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Colors.TopBarBg
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "LUAWARE HUB"
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Colors.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

-- Sürükleme Mantığı
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- 3. YAN MENÜ (SIDEBAR)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 110, 1, -30)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundColor3 = Colors.SidebarBg
Sidebar.BorderSizePixel = 0

local TabLayout = Instance.new("UIListLayout", Sidebar)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -110, 1, -30)
Content.Position = UDim2.new(0, 110, 0, 30)
Content.BackgroundTransparency = 1

-- =======================================================
-- KENDİ MÜTEVAZİ KÜTÜPHANEMİZİN FONKSİYONLARI
-- =======================================================
local Library = {}
local Tabs, Pages, isFirst = {}, {}, true

function Library:MakeTab(name)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = isFirst and Colors.TabActive or Colors.SidebarBg
    btn.BorderSizePixel = 0
    btn.Text = "   " .. name
    btn.TextColor3 = isFirst and Colors.Text or Colors.SubText
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left

    -- Resimdeki gibi soldaki ince beyaz çizgi
    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 2, 1, 0)
    indicator.BackgroundColor3 = Colors.Indicator
    indicator.BorderSizePixel = 0
    indicator.BackgroundTransparency = isFirst and 0 or 1

    local page = Instance.new("ScrollingFrame", Content)
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.Visible = isFirst
    local pLayout = Instance.new("UIListLayout", page)
    pLayout.Padding = UDim.new(0, 4)

    table.insert(Tabs, {b = btn, i = indicator})
    table.insert(Pages, page)
    isFirst = false

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, t in pairs(Tabs) do 
            t.b.BackgroundColor3 = Colors.SidebarBg
            t.b.TextColor3 = Colors.SubText
            t.i.BackgroundTransparency = 1
        end
        page.Visible = true
        btn.BackgroundColor3 = Colors.TabActive
        btn.TextColor3 = Colors.Text
        indicator.BackgroundTransparency = 0
    end)

    local Elements = {}

    function Elements:AddText(text)
        local lbl = Instance.new("TextLabel", page)
        lbl.Size = UDim2.new(1, 0, 0, 20)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Colors.Text
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.RichText = true
    end

    function Elements:AddProfile(name, username)
        local pFrame = Instance.new("Frame", page)
        pFrame.Size = UDim2.new(1, 0, 0, 45)
        pFrame.BackgroundTransparency = 1

        local img = Instance.new("ImageLabel", pFrame)
        img.Size = UDim2.new(0, 35, 0, 35)
        img.Position = UDim2.new(0, 0, 0.5, -17.5)
        img.BackgroundColor3 = Colors.SidebarBg
        Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)
        -- Otomatik olarak senin Roblox profil resmini çeker
        img.Image = "rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=420&h=420"

        local nLbl = Instance.new("TextLabel", pFrame)
        nLbl.Size = UDim2.new(1, -45, 0, 15)
        nLbl.Position = UDim2.new(0, 45, 0, 5)
        nLbl.BackgroundTransparency = 1
        nLbl.Text = name
        nLbl.TextColor3 = Colors.Text
        nLbl.Font = Enum.Font.GothamBold
        nLbl.TextSize = 12
        nLbl.TextXAlignment = Enum.TextXAlignment.Left

        local uLbl = Instance.new("TextLabel", pFrame)
        uLbl.Size = UDim2.new(1, -45, 0, 15)
        uLbl.Position = UDim2.new(0, 45, 0, 22)
        uLbl.BackgroundTransparency = 1
        uLbl.Text = username
        uLbl.TextColor3 = Colors.SubText
        uLbl.Font = Enum.Font.Gotham
        uLbl.TextSize = 11
        uLbl.TextXAlignment = Enum.TextXAlignment.Left
    end

    return Elements
end

-- =======================================================
-- KÜTÜPHANEYİ KULLANMA (RESİMDEKİNİN BİREBİR AYNISI)
-- =======================================================

-- Sekmeler
local TabHome = Library:MakeTab("Home")
local TabGames = Library:MakeTab("Games")
local TabUpdates = Library:MakeTab("Updates")
local TabKrediler = Library:MakeTab("Krediler")
local TabLaunch = Library:MakeTab("Launch")

-- Home Sekmesi İçeriği (Resimdeki yazılar)
TabHome:AddText("Welcome to LUAWARE HUB")
TabHome:AddProfile("Noxy", "@noxyorj") -- Resimdeki profil kısmı
TabHome:AddText("") -- Boşluk

TabHome:AddText("<b>Roblox User Name:</b> " .. LP.Name)
TabHome:AddText("<b>Game Id:</b> " .. tostring(game.GameId))
TabHome:AddText("<b>Game Name:</b> Prison Life") 
TabHome:AddText("<b>Place Id:</b> " .. tostring(game.PlaceId))
TabHome:AddText("<b>Server:</b> 3/6")
TabHome:AddText("<b>Executor:</b> <font color='rgb(255,100,100)'>Xeno</font>")
TabHome:AddText("<b>Executor Level:</b> <font color='rgb(255,100,100)'>3</font>")

print("Luaware Modest Kütüphanesi Yüklendi!")

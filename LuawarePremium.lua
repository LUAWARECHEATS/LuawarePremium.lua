--[[
    LUAWARE UI LIBRARY V1 - THE CUSTOM ENGINE
    YAPIMCI: NOXYORJ
    Tasarım: Birebir Resimdeki (Hawk Style) Düzen, Geniş ve Basık
    Motor: Premium Smooth Drag (Inertia)
    Bağımlılık: YOK (%100 Yerel Kod, Dışarıdan dosya çekmez)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Eski GUI'leri Temizle
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "LuawareEngineV1" then v:Destroy() end
end

-- ============================================
-- LUAWARE V1 TEMA PALETİ (Resimdeki Birebir Renkler)
-- ============================================
local Theme = {
    Main = Color3.fromRGB(30, 30, 30),       -- Ana Arka Plan
    TitleBar = Color3.fromRGB(35, 35, 35),   -- Üst Bar
    Sidebar = Color3.fromRGB(25, 25, 25),    -- Sol Sekmeler (Daha koyu)
    Card = Color3.fromRGB(40, 40, 40),       -- Oyun Kartları
    Accent = Color3.fromRGB(255, 255, 255),  -- Seçili Sekme (Beyaz)
    Text = Color3.fromRGB(245, 245, 255),    -- Beyaz Yazı
    SubText = Color3.fromRGB(150, 150, 150), -- Gri Yazı
    Working = Color3.fromRGB(80, 220, 80),   -- "Working" Yeşili
    DateColor = Color3.fromRGB(80, 200, 220),-- "Last Update" Mavisi
    Border = Color3.fromRGB(50, 50, 50)      -- Çizgiler
}

-- ============================================
-- PREMIUM SMOOTH DRAG (EYLEMSİZLİK MOTORU)
-- ============================================
local function MakeSmoothDraggable(dragObject, targetObject)
    local dragging, dragStart, startPos, velocity, lastPos, lastTime
    local dragConnection, releaseConnection
    
    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = targetObject.Position
            lastPos = input.Position; lastTime = tick(); velocity = Vector2.new()
            
            dragConnection = UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local now = tick(); local dt = now - lastTime
                    if dt > 0.001 then velocity = (input.Position - lastPos) / dt; lastPos = input.Position; lastTime = now end
                    local delta = input.Position - dragStart
                    targetObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            
            releaseConnection = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                    dragging = false; dragConnection:Disconnect(); releaseConnection:Disconnect()
                    if velocity.Magnitude > 10 then
                        local inertiaPos = UDim2.new(targetObject.Position.X.Scale, targetObject.Position.X.Offset + velocity.X * 0.1, targetObject.Position.Y.Scale, targetObject.Position.Y.Offset + velocity.Y * 0.1)
                        TweenService:Create(targetObject, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = inertiaPos}):Play()
                    end
                end
            end)
        end
    end)
end

-- ============================================
-- KENDİ KÜTÜPHANEMİZİN İNŞASI
-- ============================================
local Luaware = {}

function Luaware:Window(Config)
    local sg = Instance.new("ScreenGui", CoreGui)
    sg.Name = "LuawareEngineV1"; sg.ResetOnSpawn = false

    -- ANA PENCERE (Resimdeki orantı: Geniş ve Basık)
    local Main = Instance.new("Frame", sg)
    Main.Size = UDim2.new(0, 680, 0, 360) 
    Main.Position = UDim2.new(0.5, -340, 0.5, -180)
    Main.BackgroundColor3 = Theme.Main; Main.BorderSizePixel = 0; Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    -- ÜST BAR
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 35); TopBar.BackgroundColor3 = Theme.TitleBar; TopBar.BorderSizePixel = 0
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
    local fix = Instance.new("Frame", TopBar); fix.Size = UDim2.new(1, 0, 0, 10); fix.Position = UDim2.new(0, 0, 1, -10); fix.BackgroundColor3 = Theme.TitleBar; fix.BorderSizePixel = 0
    
    local Icon = Instance.new("ImageLabel", TopBar)
    Icon.Size = UDim2.new(0, 18, 0, 18); Icon.Position = UDim2.new(0, 10, 0, 8); Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://13570069771" -- Luaware Logo İkonu

    local TitleLbl = Instance.new("TextLabel", TopBar)
    TitleLbl.Size = UDim2.new(0, 300, 1, 0); TitleLbl.Position = UDim2.new(0, 35, 0, 0); TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = Config.Name or "LUAWARE HUB V1"; TitleLbl.TextColor3 = Theme.Text; TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 13; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(1, -35, 0, 0); CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"; CloseBtn.TextColor3 = Theme.Text; CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14
    CloseBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

    MakeSmoothDraggable(TopBar, Main)

    -- YAN MENÜ (SIDEBAR)
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 140, 1, -35); Sidebar.Position = UDim2.new(0, 0, 0, 35); Sidebar.BackgroundColor3 = Theme.Sidebar; Sidebar.BorderSizePixel = 0
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -10); TabContainer.Position = UDim2.new(0, 0, 0, 10); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 2)

    -- SAYFALAR
    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -150, 1, -45); PageContainer.Position = UDim2.new(0, 150, 0, 40); PageContainer.BackgroundTransparency = 1

    local WindowObj = {}
    local Tabs, Pages, isFirst = {}, {}, true

    function WindowObj:Tab(tabName)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 32); TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "     " .. tabName; TabBtn.TextColor3 = isFirst and Theme.Accent or Theme.SubText
        TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 12; TabBtn.TextXAlignment = Enum.TextXAlignment.Left

        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, -10, 1, -10); Page.Position = UDim2.new(0, 5, 0, 5); Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.Border; Page.Visible = isFirst
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

        table.insert(Tabs, TabBtn); table.insert(Pages, Page); isFirst = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            for _, t in pairs(Tabs) do t.TextColor3 = Theme.SubText end
            Page.Visible = true; TabBtn.TextColor3 = Theme.Accent
        end)

        local Elements = {}

        function Elements:Section(txt)
            local lbl = Instance.new("TextLabel", Page)
            lbl.Size = UDim2.new(1, -10, 0, 25); lbl.BackgroundTransparency = 1; lbl.Text = txt
            lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 14; lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        -- =========================================================
        -- RESİMDEKİ "OYUN KARTI" TASARIMI (BİREBİR)
        -- =========================================================
        function Elements:GameCard(Config)
            local cFrame = Instance.new("Frame", Page)
            cFrame.Size = UDim2.new(1, -10, 0, 80); cFrame.BackgroundColor3 = Theme.Card; Instance.new("UICorner", cFrame).CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", cFrame); stroke.Color = Theme.Border; stroke.Thickness = 1

            -- Sol Taraftaki Oyun Resmi
            local img = Instance.new("ImageLabel", cFrame)
            img.Size = UDim2.new(0, 60, 0, 60); img.Position = UDim2.new(0, 10, 0.5, -30); img.BackgroundTransparency = 1
            img.Image = Config.ImageId or "rbxassetid://0"; Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)

            -- Oyun Başlığı
            local title = Instance.new("TextLabel", cFrame)
            title.Size = UDim2.new(1, -90, 0, 20); title.Position = UDim2.new(0, 80, 0, 10); title.BackgroundTransparency = 1
            title.Text = Config.Title or "Oyun Adı"; title.TextColor3 = Theme.Text; title.Font = Enum.Font.GothamBold; title.TextSize = 13; title.TextXAlignment = Enum.TextXAlignment.Left

            -- Status Yazısı (Yeşil)
            local statusLbl = Instance.new("TextLabel", cFrame)
            statusLbl.Size = UDim2.new(1, -90, 0, 16); statusLbl.Position = UDim2.new(0, 80, 0, 32); statusLbl.BackgroundTransparency = 1
            statusLbl.Text = "Status: Working"; statusLbl.TextColor3 = Theme.Working; statusLbl.Font = Enum.Font.GothamBold; statusLbl.TextSize = 11; statusLbl.TextXAlignment = Enum.TextXAlignment.Left

            -- Last Update Yazısı (Mavi/Cyan)
            local dateLbl = Instance.new("TextLabel", cFrame)
            dateLbl.Size = UDim2.new(1, -90, 0, 16); dateLbl.Position = UDim2.new(0, 80, 0, 48); dateLbl.BackgroundTransparency = 1
            dateLbl.Text = "Last Update: " .. (Config.LastUpdate or "Bilinmiyor"); dateLbl.TextColor3 = Theme.DateColor; dateLbl.Font = Enum.Font.GothamBold; dateLbl.TextSize = 11; dateLbl.TextXAlignment = Enum.TextXAlignment.Left

            -- Tıklama Butonu (İleride kullanmak istersen)
            local clickBtn = Instance.new("TextButton", cFrame); clickBtn.Size = UDim2.new(1, 0, 1, 0); clickBtn.BackgroundTransparency = 1; clickBtn.Text = ""
            clickBtn.MouseButton1Click:Connect(function() if Config.Callback then Config.Callback() end end)
        end

        return Elements
    end

    return WindowObj
end

-- =========================================================================
-- KULLANIM: RESİMDEKİ EKRANIN BİREBİR KOPYASI
-- =========================================================================

local Menu = Luaware:Window({
    Name = "LUAWARE HUB V1"
})

-- Resimdeki Sekmeler Sırasıyla:
local TabHome = Menu:Tab("Home")
local TabGames = Menu:Tab("Games")
local TabUpdates = Menu:Tab("Updates")
local TabKrediler = Menu:Tab("Krediler")
local TabLaunch = Menu:Tab("Launch")

-- =======================================
-- GAMES SEKMESİ İÇERİĞİ (Resimdeki Tasarım)
-- =======================================
TabGames:Section("Games LUAWARE HUB Supports")

-- 1. Oyun Kartı: Hide and Seek
TabGames:GameCard({
    Title = "Hide and Seek Extreme",
    LastUpdate = "23/04/2026",
    ImageId = "rbxassetid://14451084285", -- Örnek icon
    Callback = function()
        print("Hide and Seek seçildi")
    end
})

-- 2. Oyun Kartı: Zombie Attack
TabGames:GameCard({
    Title = "Zombie Attack",
    LastUpdate = "01/05/2026",
    ImageId = "rbxassetid://13570069771", -- Örnek icon
    Callback = function()
        print("Zombie Attack seçildi")
    end
})

print("LUAWARE HUB V1 - Kendi kütüphanemiz başarıyla başlatıldı!")

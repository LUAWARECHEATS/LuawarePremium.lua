--[[
    LUAWARE UI LIBRARY V6 - CUSTOM ENGINE
    YAPIMCI: NOXYORJ
    Görünüm: Yandan Geniş, Aşağıdan Kısık (Cinematic)
    Motor: Premium Smooth Drag (Inertia)
    Bağımlılık: YOK (%100 Yerel Kod)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ============================================
-- LUAWARE ÖZEL TEMA PALETİ
-- ============================================
local Theme = {
    Main = Color3.fromRGB(18, 18, 22),       -- Ana Arka Plan
    TitleBar = Color3.fromRGB(24, 24, 28),   -- Üst Bar
    Sidebar = Color3.fromRGB(20, 20, 24),    -- Sol Sekmeler
    Card = Color3.fromRGB(28, 28, 34),       -- Element Kartları
    Accent = Color3.fromRGB(255, 50, 60),    -- Luaware Kırmızısı
    Text = Color3.fromRGB(245, 245, 255),    -- Beyaz Yazı
    SubText = Color3.fromRGB(150, 150, 160), -- Gri Yazı
    Working = Color3.fromRGB(80, 220, 80),   -- Aktif Yeşili
    Border = Color3.fromRGB(40, 40, 45)      -- Çizgiler
}

-- ============================================
-- PREMIUM SMOOTH DRAG (SENİN EYLEMSİZLİK MOTORUN)
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
                    targetObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            
            local releaseConn; releaseConn = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    if dragConnection then dragConnection:Disconnect() end
                    releaseConn:Disconnect()
                    
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
-- LUAWARE KÜTÜPHANE İNŞASI
-- ============================================
local Luaware = {}

function Luaware:Window(Config)
    -- Eski GUI'leri Temizle
    for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
        if v.Name == "LuawareEngine" then v:Destroy() end
    end

    local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
    sg.Name = "LuawareEngine"; sg.ResetOnSpawn = false

    -- ANA PENCERE (TAM İSTEDİĞİN GİBİ: YANDAN GENİŞ, AŞAĞIDAN KISIK)
    local Main = Instance.new("Frame", sg)
    Main.Size = UDim2.new(0, 680, 0, 340) -- GENİŞLİK: 680, YÜKSEKLİK: 340
    Main.Position = UDim2.new(0.5, -340, 0.5, -170)
    Main.BackgroundColor3 = Theme.Main; Main.BorderSizePixel = 0; Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", Main); stroke.Color = Theme.Border; stroke.Thickness = 1.5

    -- ÜST BAR
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 38); TopBar.BackgroundColor3 = Theme.TitleBar; TopBar.BorderSizePixel = 0
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
    local fix = Instance.new("Frame", TopBar); fix.Size = UDim2.new(1, 0, 0, 10); fix.Position = UDim2.new(0, 0, 1, -10); fix.BackgroundColor3 = Theme.TitleBar; fix.BorderSizePixel = 0
    local line = Instance.new("Frame", TopBar); line.Size = UDim2.new(1, 0, 0, 2); line.Position = UDim2.new(0, 0, 1, 0); line.BackgroundColor3 = Theme.Accent; line.BorderSizePixel = 0

    local TitleLbl = Instance.new("TextLabel", TopBar)
    TitleLbl.Size = UDim2.new(0, 300, 1, 0); TitleLbl.Position = UDim2.new(0, 15, 0, 0); TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = Config.Name or "LUAWARE ENGINE"; TitleLbl.TextColor3 = Color3.new(1,1,1); TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 14; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Eylemsizlik Motorunu Bağla
    MakeSmoothDraggable(TopBar, Main)

    -- YAN MENÜ (SIDEBAR)
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 160, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.BackgroundColor3 = Theme.Sidebar; Sidebar.BorderSizePixel = 0
    local sLine = Instance.new("Frame", Sidebar); sLine.Size = UDim2.new(0, 1, 1, 0); sLine.Position = UDim2.new(1, 0, 0, 0); sLine.BackgroundColor3 = Theme.Border; sLine.BorderSizePixel = 0
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -10); TabContainer.Position = UDim2.new(0, 0, 0, 5); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 6)

    -- SAYFALARIN BULUNDUĞU ALAN
    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -170, 1, -50); PageContainer.Position = UDim2.new(0, 165, 0, 45); PageContainer.BackgroundTransparency = 1

    local WindowObj = {}
    local Tabs, Pages, isFirst = {}, {}, true

    -- SEKME (TAB) FONKSİYONU
    function WindowObj:Tab(tabName)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -10, 0, 34); TabBtn.Position = UDim2.new(0, 5, 0, 0); TabBtn.BackgroundColor3 = isFirst and Theme.Card or Theme.Sidebar
        TabBtn.Text = "   " .. tabName; TabBtn.TextColor3 = isFirst and Theme.Accent or Theme.SubText; TabBtn.Font = Enum.Font.GothamSemibold; TabBtn.TextSize = 13; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Marker = Instance.new("Frame", TabBtn)
        Marker.Size = UDim2.new(0, 4, 0, 16); Marker.Position = UDim2.new(0, 0, 0.5, -8); Marker.BackgroundColor3 = Theme.Accent; Marker.BackgroundTransparency = isFirst and 0 or 1
        Instance.new("UICorner", Marker).CornerRadius = UDim.new(1, 0)

        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.Accent; Page.Visible = isFirst
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

        table.insert(Tabs, TabBtn); table.insert(Pages, Page); isFirst = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            for _, t in pairs(Tabs) do t.BackgroundColor3 = Theme.Sidebar; t.TextColor3 = Theme.SubText; t:FindFirstChildOfClass("Frame").BackgroundTransparency = 1 end
            Page.Visible = true; TabBtn.BackgroundColor3 = Theme.Card; TabBtn.TextColor3 = Theme.Accent; Marker.BackgroundTransparency = 0
        end)

        local Elements = {}

        function Elements:Section(txt)
            local lbl = Instance.new("TextLabel", Page)
            lbl.Size = UDim2.new(1, -10, 0, 20); lbl.BackgroundTransparency = 1; lbl.Text = " " .. txt; lbl.TextColor3 = Theme.Accent; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Elements:Button(txt, desc, cb)
            local btnF = Instance.new("Frame", Page)
            btnF.Size = UDim2.new(1, -10, 0, 50); btnF.BackgroundColor3 = Theme.Card; Instance.new("UICorner", btnF).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", btnF).Color = Theme.Border
            
            local title = Instance.new("TextLabel", btnF)
            title.Size = UDim2.new(1, -20, 0, 18); title.Position = UDim2.new(0, 12, 0, 8); title.BackgroundTransparency = 1; title.Text = txt; title.TextColor3 = Color3.new(1,1,1); title.Font = Enum.Font.GothamBold; title.TextSize = 13; title.TextXAlignment = Enum.TextXAlignment.Left
            
            local dLbl = Instance.new("TextLabel", btnF)
            dLbl.Size = UDim2.new(1, -20, 0, 16); dLbl.Position = UDim2.new(0, 12, 0, 26); dLbl.BackgroundTransparency = 1; dLbl.Text = desc; dLbl.TextColor3 = Theme.SubText; dLbl.Font = Enum.Font.Gotham; dLbl.TextSize = 11; dLbl.TextXAlignment = Enum.TextXAlignment.Left

            local click = Instance.new("TextButton", btnF); click.Size = UDim2.new(1,0,1,0); click.BackgroundTransparency = 1; click.Text = ""
            click.MouseButton1Click:Connect(function() 
                TweenService:Create(btnF, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Border}):Play()
                task.wait(0.1); TweenService:Create(btnF, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Card}):Play()
                pcall(cb) 
            end)
        end

        function Elements:Toggle(txt, desc, def, cb)
            local state = def or false
            local tF = Instance.new("Frame", Page)
            tF.Size = UDim2.new(1, -10, 0, 50); tF.BackgroundColor3 = Theme.Card; Instance.new("UICorner", tF).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", tF).Color = Theme.Border
            
            local title = Instance.new("TextLabel", tF)
            title.Size = UDim2.new(0.6, 0, 0, 18); title.Position = UDim2.new(0, 12, 0, 8); title.BackgroundTransparency = 1; title.Text = txt; title.TextColor3 = Color3.new(1,1,1); title.Font = Enum.Font.GothamBold; title.TextSize = 13; title.TextXAlignment = Enum.TextXAlignment.Left
            
            local dLbl = Instance.new("TextLabel", tF)
            dLbl.Size = UDim2.new(0.6, 0, 0, 16); dLbl.Position = UDim2.new(0, 12, 0, 26); dLbl.BackgroundTransparency = 1; dLbl.Text = desc; dLbl.TextColor3 = Theme.SubText; dLbl.Font = Enum.Font.Gotham; dLbl.TextSize = 11; dLbl.TextXAlignment = Enum.TextXAlignment.Left

            local status = Instance.new("TextLabel", tF)
            status.Size = UDim2.new(0, 120, 1, 0); status.Position = UDim2.new(1, -135, 0, 0); status.BackgroundTransparency = 1
            status.Text = state and "Status: Working" or "Status: Idle"; status.TextColor3 = state and Theme.Working or Theme.SubText
            status.Font = Enum.Font.GothamBold; status.TextSize = 11; status.TextXAlignment = Enum.TextXAlignment.Right

            local click = Instance.new("TextButton", tF); click.Size = UDim2.new(1,0,1,0); click.BackgroundTransparency = 1; click.Text = ""
            click.MouseButton1Click:Connect(function()
                state = not state
                status.Text = state and "Status: Working" or "Status: Idle"
                status.TextColor3 = state and Theme.Working or Theme.SubText
                pcall(cb, state)
            end)
        end

        function Elements:Slider(txt, min, max, def, cb)
            local val = def or min
            local sF = Instance.new("Frame", Page)
            sF.Size = UDim2.new(1, -10, 0, 60); sF.BackgroundColor3 = Theme.Card; Instance.new("UICorner", sF).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", sF).Color = Theme.Border
            
            local sTitle = Instance.new("TextLabel", sF)
            sTitle.Size = UDim2.new(0.5, 0, 0, 20); sTitle.Position = UDim2.new(0, 12, 0, 8); sTitle.BackgroundTransparency = 1; sTitle.Text = txt; sTitle.TextColor3 = Color3.new(1,1,1); sTitle.Font = Enum.Font.GothamBold; sTitle.TextSize = 13; sTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local num = Instance.new("TextLabel", sF)
            num.Size = UDim2.new(0, 40, 0, 20); num.Position = UDim2.new(1, -52, 0, 8); num.BackgroundTransparency = 1; num.Text = tostring(val); num.TextColor3 = Theme.Accent; num.Font = Enum.Font.GothamBold; num.TextSize = 13; num.TextXAlignment = Enum.TextXAlignment.Right

            local bg = Instance.new("Frame", sF)
            bg.Size = UDim2.new(1, -24, 0, 8); bg.Position = UDim2.new(0, 12, 0, 36); bg.BackgroundColor3 = Theme.Main; Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
            
            local fill = Instance.new("Frame", bg)
            fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0); fill.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

            local dragBtn = Instance.new("TextButton", bg); dragBtn.Size = UDim2.new(1,0,1,0); dragBtn.BackgroundTransparency = 1; dragBtn.Text = ""
            dragBtn.MouseButton1Down:Connect(function()
                local moveConn; moveConn = RunService.RenderStepped:Connect(function()
                    local pct = math.clamp((Mouse.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                    fill.Size = UDim2.new(pct, 0, 1, 0); val = math.floor(min + ((max - min) * pct)); num.Text = tostring(val); pcall(cb, val)
                end)
                local release; release = UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then moveConn:Disconnect(); release:Disconnect() end end)
            end)
        end

        return Elements
    end

    -- Menü Kısayolu (RightShift)
    UserInputService.InputBegan:Connect(function(i, p)
        if not p and i.KeyCode == Enum.KeyCode.RightShift then
            Main.Visible = not Main.Visible
        end
    end)

    return WindowObj
end

-- =========================================================================
-- KÜTÜPHANEYİ KULLANMA (TEST ALANI)
-- =========================================================================

local Win = Luaware:Window({
    Name = "LUAWARE V6 | CINEMATIC EDITION"
})

local Tab1 = Win:Tab("Main Settings")
local Tab2 = Win:Tab("Combat")
local Tab3 = Win:Tab("Vercel Links")

Tab1:Section("Görünüm ve Özellikler")

Tab1:Toggle("Luaware Engine Aktif", "V6 Motorunu ve Eylemsizliği açar", true, function(v)
    print("Motor Durumu:", v)
end)

Tab1:Slider("Görüş Alanı (FOV)", 10, 200, 100, function(v)
    print("FOV:", v)
end)

Tab2:Section("Savaş Modülleri")

Tab2:Toggle("Aimbot", "Kilitlenme motoru", false, function(v)
    print("Aimbot:", v)
end)

Tab2:Button("Kill All (OP)", "Herkesi anında öldürür", function()
    print("Herkes öldürüldü!")
end)

Tab3:Section("Veritabanı (Vercel)")

Tab3:Button("Lisansı Kontrol Et", "Vercel sunucusundan kontrol eder", function()
    print("Vercel'den lisans doğrulandı!")
end)

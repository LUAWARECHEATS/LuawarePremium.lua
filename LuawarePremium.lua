-- ========================================================
-- LUAWARE PREMIUM UI KÜTÜPHANESİ (HAWK HUB STYLE)
-- YAPIMCI: NOXYORJ
-- NOT: Bu kod sadece GitHub'da barındırılır.
-- ========================================================

local Luaware = {}
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local coreGui = pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")

function Luaware:MakeWindow(Config)
    local WindowTitle = Config.Name or "Luaware Premium Hub"
    local ThemeColor = Config.Color or Color3.fromRGB(235, 80, 80) -- Default Theme Color

    -- Güvenli UI Başlatma
    local gui = Instance.new("ScreenGui")
    gui.Name = "Luaware_Premium_Lib"
    gui.ResetOnSpawn = false
    gui.Parent = coreGui

    -- Ana Kasa (Hawk Hub Tarzı Dark Tema)
    local Main = Instance.new("Frame", gui)
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

    -- Üst Bar (Başlık ve Sürükleme)
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 6)
    
    local TopBorder = Instance.new("Frame", TopBar)
    TopBorder.Size = UDim2.new(1, 0, 0, 1)
    TopBorder.Position = UDim2.new(0, 0, 1, 0)
    TopBorder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TopBorder.BorderSizePixel = 0

    local TitleLbl = Instance.new("TextLabel", TopBar)
    TitleLbl.Size = UDim2.new(1, -20, 1, 0)
    TitleLbl.Position = UDim2.new(0, 15, 0, 0)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = WindowTitle
    TitleLbl.TextColor3 = Color3.new(1, 1, 1)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 13
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Sürükleme Mantığı
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    uis.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Yan Menü (Sekmeler)
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 140, 1, -35)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Sidebar.BorderSizePixel = 0

    local SideBorder = Instance.new("Frame", Sidebar)
    SideBorder.Size = UDim2.new(0, 1, 1, 0)
    SideBorder.Position = UDim2.new(1, 0, 0, 0)
    SideBorder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SideBorder.BorderSizePixel = 0

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -10)
    TabContainer.Position = UDim2.new(0, 0, 0, 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 4)

    local ContentContainer = Instance.new("Frame", Main)
    ContentContainer.Size = UDim2.new(1, -145, 1, -45)
    ContentContainer.Position = UDim2.new(0, 145, 0, 40)
    ContentContainer.BackgroundTransparency = 1

    local WindowObj = {}
    local Tabs = {}
    local Pages = {}
    local FirstTab = true

    -- Sekme (Tab) Oluşturucu
    function WindowObj:MakeTab(TabConfig)
        local TabName = TabConfig.Name or "Tab"
        
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -10, 0, 32)
        TabBtn.Position = UDim2.new(0, 5, 0, 0)
        TabBtn.BackgroundColor3 = FirstTab and Color3.fromRGB(35, 35, 35) or Color3.fromRGB(20, 20, 20)
        TabBtn.Text = "   " .. TabName
        TabBtn.TextColor3 = FirstTab and ThemeColor or Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 12
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

        local TabPage = Instance.new("ScrollingFrame", ContentContainer)
        TabPage.Size = UDim2.new(1, -5, 1, -5)
        TabPage.Position = FirstTab and UDim2.new(0, 0, 0, 0) or UDim2.new(0, 20, 0, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 2
        TabPage.ScrollBarImageColor3 = ThemeColor
        TabPage.Visible = FirstTab
        Instance.new("UIListLayout", TabPage).Padding = UDim.new(0, 6)
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)

        table.insert(Tabs, TabBtn)
        table.insert(Pages, TabPage)
        FirstTab = false

        -- Sekme Geçiş Sistemi
        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false; p.Position = UDim2.new(0, 20, 0, 0) end
            for _, t in pairs(Tabs) do t.BackgroundColor3 = Color3.fromRGB(20, 20, 20); t.TextColor3 = Color3.fromRGB(150, 150, 150) end
            
            TabPage.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            TabBtn.TextColor3 = ThemeColor
            
            ts:Create(TabPage, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        end)

        local TabObj = {}

        -- [ 1. BUTON ]
        function TabObj:AddButton(BtnConfig)
            local bText = BtnConfig.Name or "Button"
            local cb = BtnConfig.Callback or function() end
            
            local btn = Instance.new("TextButton", TabPage)
            btn.Size = UDim2.new(1, -10, 0, 36)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.Text = "   " .. bText
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            
            btn.MouseButton1Click:Connect(function()
                ts:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = ThemeColor}):Play()
                task.wait(0.1)
                ts:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                cb()
            end)
        end

        -- [ 2. TOGGLE (AÇ/KAPA) ]
        function TabObj:AddToggle(TglConfig)
            local tText = TglConfig.Name or "Toggle"
            local state = TglConfig.Default or false
            local cb = TglConfig.Callback or function() end
            
            local btn = Instance.new("TextButton", TabPage)
            btn.Size = UDim2.new(1, -10, 0, 36)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.Text = "   " .. tText
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            
            local box = Instance.new("Frame", btn)
            box.Size = UDim2.new(0, 34, 0, 18)
            box.Position = UDim2.new(1, -45, 0.5, -9)
            box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Instance.new("UICorner", box).CornerRadius = UDim.new(1, 0)
            
            local circle = Instance.new("Frame", box)
            circle.Size = UDim2.new(0, 14, 0, 14)
            circle.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            circle.BackgroundColor3 = state and Color3.new(1, 1, 1) or Color3.fromRGB(150, 150, 150)
            Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
            
            if state then box.BackgroundColor3 = ThemeColor end

            btn.MouseButton1Click:Connect(function()
                state = not state
                ts:Create(circle, TweenInfo.new(0.2), {
                    Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
                    BackgroundColor3 = state and Color3.new(1, 1, 1) or Color3.fromRGB(150, 150, 150)
                }):Play()
                ts:Create(box, TweenInfo.new(0.2), {
                    BackgroundColor3 = state and ThemeColor or Color3.fromRGB(20, 20, 20)
                }):Play()
                cb(state)
            end)
        end

        -- [ 3. SLIDER (KAYDIRICI) ]
        function TabObj:AddSlider(SldConfig)
            local sText = SldConfig.Name or "Slider"
            local min = SldConfig.Min or 0
            local max = SldConfig.Max or 100
            local val = SldConfig.Default or min
            local cb = SldConfig.Callback or function() end

            local frm = Instance.new("Frame", TabPage)
            frm.Size = UDim2.new(1, -10, 0, 45)
            frm.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Instance.new("UICorner", frm).CornerRadius = UDim.new(0, 4)

            local lbl = Instance.new("TextLabel", frm)
            lbl.Size = UDim2.new(1, -20, 0, 20)
            lbl.Position = UDim2.new(0, 10, 0, 2)
            lbl.BackgroundTransparency = 1
            lbl.Text = sText
            lbl.TextColor3 = Color3.new(1, 1, 1)
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local valLbl = Instance.new("TextLabel", frm)
            valLbl.Size = UDim2.new(0, 40, 0, 20)
            valLbl.Position = UDim2.new(1, -50, 0, 2)
            valLbl.BackgroundTransparency = 1
            valLbl.Text = tostring(val)
            valLbl.TextColor3 = ThemeColor
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextSize = 11
            valLbl.TextXAlignment = Enum.TextXAlignment.Right

            local bg = Instance.new("TextButton", frm)
            bg.Size = UDim2.new(1, -20, 0, 6)
            bg.Position = UDim2.new(0, 10, 0, 30)
            bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            bg.Text = ""
            Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

            local fill = Instance.new("Frame", bg)
            fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = ThemeColor
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

            local dragging = false
            bg.MouseButton1Down:Connect(function() dragging = true end)
            uis.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            uis.InputChanged:Connect(function(i)
                if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local pct = math.clamp((uis:GetMouseLocation().X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    val = math.floor(min + ((max - min) * pct))
                    valLbl.Text = tostring(val)
                    cb(val)
                end
            end)
        end

        return TabObj
    end

    return WindowObj
end

return Luaware

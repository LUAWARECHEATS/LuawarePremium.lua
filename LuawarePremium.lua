-- ========================================================
-- LUAWARE PREMIUM UI KÜTÜPHANESİ (HAWK HUB STYLE)
-- UYARI: Bu kod sadece GitHub'da duracak!
-- ========================================================
local LuaWare = {}

function LuaWare:MakeWindow(Config)
    local WindowTitle = Config.Name or "LuaWare Premium"
    
    local CoreGui = game:GetService("CoreGui")
    local uis = game:GetService("UserInputService")
    
    -- Güvenli Başlangıç (Çökmeyi Önler)
    local sg = Instance.new("ScreenGui")
    sg.Name = "LuaWare_Library"
    sg.ResetOnSpawn = false
    local success = pcall(function() sg.Parent = CoreGui end)
    if not success then sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- ANA KASA (Hawk Hub Koyu Tema)
    local Main = Instance.new("Frame", sg)
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Premium Koyu Gri
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
    
    -- İnce Çerçeve Efekti (UIStroke kullanmadan, Frame ile)
    local Outline = Instance.new("Frame", Main)
    Outline.Size = UDim2.new(1, 2, 1, 2); Outline.Position = UDim2.new(0, -1, 0, -1)
    Outline.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Outline.ZIndex = 0
    Instance.new("UICorner", Outline).CornerRadius = UDim.new(0, 6)

    -- ÜST BAR (Sürükleme Alanı)
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 35); TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 6)
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, -20, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1; Title.Text = WindowTitle
    Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold; Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Sürükleme Mantığı
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    TopBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    uis.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- YAN MENÜ (SEKMELER)
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 140, 1, -35); Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Sidebar.BorderSizePixel = 0
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -10); TabContainer.Position = UDim2.new(0, 0, 0, 5)
    TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 2)

    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1, -150, 1, -45); Content.Position = UDim2.new(0, 145, 0, 40)
    Content.BackgroundTransparency = 1

    local WindowObj = {}
    local Tabs, Pages = {}, {}
    local FirstTab = true

    function WindowObj:MakeTab(ConfigTab)
        local TabName = ConfigTab.Name or "Tab"
        
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -10, 0, 30); TabBtn.Position = UDim2.new(0, 5, 0, 0)
        TabBtn.BackgroundColor3 = FirstTab and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(25, 25, 25)
        TabBtn.Text = "  " .. TabName
        TabBtn.TextColor3 = FirstTab and Color3.new(1,1,1) or Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.GothamSemibold; TabBtn.TextSize = 12; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

        local TabPage = Instance.new("ScrollingFrame", Content)
        TabPage.Size = UDim2.new(1, 0, 1, 0); TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 2; TabPage.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        TabPage.Visible = FirstTab
        Instance.new("UIListLayout", TabPage).Padding = UDim.new(0, 6)

        table.insert(Tabs, TabBtn); table.insert(Pages, TabPage)
        FirstTab = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            for _, t in pairs(Tabs) do t.BackgroundColor3 = Color3.fromRGB(25, 25, 25); t.TextColor3 = Color3.fromRGB(150, 150, 150) end
            TabPage.Visible = true; TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); TabBtn.TextColor3 = Color3.new(1,1,1)
        end)

        local TabObj = {}

        -- BUTTON OLUŞTURUCU
        function TabObj:AddButton(BtnCfg)
            local bText = BtnCfg.Name or "Button"
            local cb = BtnCfg.Callback or function() end
            
            local btn = Instance.new("TextButton", TabPage)
            btn.Size = UDim2.new(1, -10, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            btn.Text = "   " .. bText; btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.Gotham; btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            
            btn.MouseButton1Click:Connect(function()
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); task.wait(0.1); btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                cb()
            end)
        end

        -- TOGGLE OLUŞTURUCU
        function TabObj:AddToggle(TglCfg)
            local tText = TglCfg.Name or "Toggle"
            local state = TglCfg.Default or false
            local cb = TglCfg.Callback or function() end
            
            local btn = Instance.new("TextButton", TabPage)
            btn.Size = UDim2.new(1, -10, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            btn.Text = "   " .. tText; btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.Gotham; btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            
            local ind = Instance.new("Frame", btn)
            ind.Size = UDim2.new(0, 10, 0, 10); ind.Position = UDim2.new(1, -20, 0.5, -5)
            ind.BackgroundColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
            Instance.new("UICorner", ind).CornerRadius = UDim.new(1, 0)
            
            btn.MouseButton1Click:Connect(function()
                state = not state
                ind.BackgroundColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
                cb(state)
            end)
        end

        return TabObj
    end

    return WindowObj
end

return LuaWare

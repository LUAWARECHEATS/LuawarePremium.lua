--[[
    LuaWare UI Library v5.0 - HAWK HUB EDITION
    Professional Smooth Drag + Hawk Premium Design
    No lag, No sticking, 100% Local (No loadstring)
    YAPIMCI: NOXYORJ
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Şifre kontrolü (Hawk Hub ruhunu yaşatmak için)
getgenv()._HawkKey = "pencizurnabayilirim"

-- ============================================
-- HAWK PREMIUM THEME (Birebir Tasarım)
-- ============================================
local Theme = {
    Main = Color3.fromRGB(25, 25, 30),
    Side = Color3.fromRGB(20, 20, 25),
    Top = Color3.fromRGB(30, 30, 35),
    Card = Color3.fromRGB(35, 35, 40),
    Accent = Color3.fromRGB(255, 70, 85), -- Hawk Kırmızısı
    Text = Color3.fromRGB(240, 240, 245),
    SubText = Color3.fromRGB(160, 160, 170),
    Border = Color3.fromRGB(45, 45, 50),
    WorkingGreen = Color3.fromRGB(80, 200, 80)
}

-- ============================================
-- SMOOTH DRAG SİSTEMİ (Eylemsizlik Efektli)
-- ============================================
local function MakeSmoothDraggable(dragObject, targetObject)
    local dragging, dragStart, startPos, velocity, lastPos, lastTime
    
    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = targetObject.Position
            lastPos = input.Position; lastTime = tick(); velocity = Vector2.new()
            
            local moveConn; moveConn = UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local now = tick(); local dt = now - lastTime
                    if dt > 0.001 then velocity = (input.Position - lastPos) / dt; lastPos = input.Position; lastTime = now end
                    local delta = input.Position - dragStart
                    targetObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            
            local endConn; endConn = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false; moveConn:Disconnect(); endConn:Disconnect()
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
-- ANA MOTOR
-- ============================================
local LuaWare = {}

function LuaWare:Window(options)
    local ScriptName = options.Name or "LUAWARE HUB"
    
    local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
    sg.Name = "LuaWareHawk"; sg.ResetOnSpawn = false

    local Main = Instance.new("Frame", sg)
    Main.Size = UDim2.new(0, 590, 0, 420); Main.Position = UDim2.new(0.5, -295, 0.5, -210)
    Main.BackgroundColor3 = Theme.Main; Main.BorderSizePixel = 0; Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Theme.Border; MainStroke.Thickness = 1.5

    -- Hawk Style TopBar
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 35); TopBar.BackgroundColor3 = Theme.Top
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
    local Line = Instance.new("Frame", TopBar); Line.Size = UDim2.new(1, 0, 0, 2); Line.Position = UDim2.new(0,0,1,0); Line.BackgroundColor3 = Theme.Accent; Line.BorderSizePixel = 0
    
    local TitleLbl = Instance.new("TextLabel", TopBar)
    TitleLbl.Size = UDim2.new(0, 200, 1, 0); TitleLbl.Position = UDim2.new(0, 15, 0, 0); TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = ScriptName; TitleLbl.TextColor3 = Theme.Text; TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 13; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    MakeSmoothDraggable(TopBar, Main)

    -- Sidebar
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 150, 1, -37); Sidebar.Position = UDim2.new(0, 0, 0, 37); Sidebar.BackgroundColor3 = Theme.Side; Sidebar.BorderSizePixel = 0
    local TabContainer = Instance.new("ScrollingFrame", Sidebar); TabContainer.Size = UDim2.new(1, 0, 1, -10); TabContainer.Position = UDim2.new(0, 0, 0, 5); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 2)

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -160, 1, -45); PageContainer.Position = UDim2.new(0, 155, 0, 42); PageContainer.BackgroundTransparency = 1

    local WindowObj = { IsVisible = true }
    local Tabs, Pages, isFirst = {}, {}, true

    function WindowObj:Tab(tabName)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -10, 0, 32); TabBtn.Position = UDim2.new(0, 5, 0, 0); TabBtn.BackgroundColor3 = isFirst and Theme.Card or Theme.Side
        TabBtn.Text = "   " .. tabName; TabBtn.TextColor3 = isFirst and Theme.Accent or Theme.SubText; TabBtn.Font = Enum.Font.GothamSemibold; TabBtn.TextSize = 12; TabBtn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.Accent; Page.Visible = isFirst
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

        table.insert(Tabs, TabBtn); table.insert(Pages, Page); isFirst = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            for _, t in pairs(Tabs) do t.BackgroundColor3 = Theme.Side; t.TextColor3 = Theme.SubText end
            Page.Visible = true; TabBtn.BackgroundColor3 = Theme.Card; TabBtn.TextColor3 = Theme.Accent
        end)

        local Elements = {}

        function Elements:Section(txt)
            local lbl = Instance.new("TextLabel", Page); lbl.Size = UDim2.new(1, -10, 0, 20); lbl.BackgroundTransparency = 1; lbl.Text = txt; lbl.TextColor3 = Theme.Accent; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Elements:Button(txt, desc, cb)
            local btn = Instance.new("TextButton", Page)
            btn.Size = UDim2.new(1, -10, 0, 45); btn.BackgroundColor3 = Theme.Card; btn.Text = "   " .. txt; btn.TextColor3 = Theme.Text; btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            local dLbl = Instance.new("TextLabel", btn); dLbl.Size = UDim2.new(1, -20, 0, 15); dLbl.Position = UDim2.new(0, 15, 0, 24); dLbl.BackgroundTransparency = 1; dLbl.Text = desc; dLbl.TextColor3 = Theme.SubText; dLbl.Font = Enum.Font.Gotham; dLbl.TextSize = 10; dLbl.TextXAlignment = Enum.TextXAlignment.Left
            btn.MouseButton1Click:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play(); task.wait(0.1); TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Card}):Play(); cb() end)
        end

        function Elements:Toggle(txt, desc, def, cb)
            local state = def or false
            local btn = Instance.new("TextButton", Page)
            btn.Size = UDim2.new(1, -10, 0, 45); btn.BackgroundColor3 = Theme.Card; btn.Text = "   " .. txt; btn.TextColor3 = Theme.Text; btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            local dLbl = Instance.new("TextLabel", btn); dLbl.Size = UDim2.new(1, -20, 0, 15); dLbl.Position = UDim2.new(0, 15, 0, 24); dLbl.BackgroundTransparency = 1; dLbl.Text = desc; dLbl.TextColor3 = Theme.SubText; dLbl.Font = Enum.Font.Gotham; dLbl.TextSize = 10; dLbl.TextXAlignment = Enum.TextXAlignment.Left
            local status = Instance.new("TextLabel", btn); status.Size = UDim2.new(0, 100, 1, 0); status.Position = UDim2.new(1, -110, 0, 0); status.BackgroundTransparency = 1; status.Text = state and "Status: Working" or "Status: Idle"; status.TextColor3 = state and Theme.WorkingGreen or Theme.SubText; status.Font = Enum.Font.GothamBold; status.TextSize = 10; status.TextXAlignment = Enum.TextXAlignment.Right
            btn.MouseButton1Click:Connect(function() state = not state; status.Text = state and "Status: Working" or "Status: Idle"; status.TextColor3 = state and Theme.WorkingGreen or Theme.SubText; cb(state) end)
        end

        function Elements:Slider(txt, min, max, def, cb)
            local val = def or min
            local frm = Instance.new("Frame", Page); frm.Size = UDim2.new(1, -10, 0, 50); frm.BackgroundColor3 = Theme.Card; Instance.new("UICorner", frm).CornerRadius = UDim.new(0, 6)
            local lbl = Instance.new("TextLabel", frm); lbl.Size = UDim2.new(1, -20, 0, 20); lbl.Position = UDim2.new(0, 10, 0, 5); lbl.BackgroundTransparency = 1; lbl.Text = txt .. ": " .. val; lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
            local bg = Instance.new("TextButton", frm); bg.Size = UDim2.new(1, -20, 0, 6); bg.Position = UDim2.new(0, 10, 0, 35); bg.BackgroundColor3 = Theme.Side; bg.Text = ""; Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
            local fill = Instance.new("Frame", bg); fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0); fill.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
            bg.MouseButton1Down:Connect(function() local move; move = RunService.RenderStepped:Connect(function() local pct = math.clamp((Mouse.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1); fill.Size = UDim2.new(pct, 0, 1, 0); val = math.floor(min + ((max - min) * pct)); lbl.Text = txt .. ": " .. val; cb(val) end)
            local release; release = UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect(); release:Disconnect() end end) end)
        end

        return Elements
    end

    function WindowObj:Notify(title, text, time)
        local n = Instance.new("Frame", sg); n.Size = UDim2.new(0, 280, 0, 60); n.Position = UDim2.new(1, 20, 1, -80); n.BackgroundColor3 = Theme.Card; Instance.new("UICorner", n).CornerRadius = UDim.new(0, 6)
        local ns = Instance.new("UIStroke", n); ns.Color = Theme.Accent; local nt = Instance.new("TextLabel", n); nt.Size = UDim2.new(1, -20, 0, 20); nt.Position = UDim2.new(0, 10, 0, 5); nt.BackgroundTransparency = 1; nt.Text = title; nt.TextColor3 = Theme.Accent; nt.Font = Enum.Font.GothamBold; nt.TextSize = 13; nt.TextXAlignment = Enum.TextXAlignment.Left
        local nd = Instance.new("TextLabel", n); nd.Size = UDim2.new(1, -20, 0, 25); nd.Position = UDim2.new(0, 10, 0, 25); nd.BackgroundTransparency = 1; nd.Text = text; nd.TextColor3 = Theme.Text; nd.Font = Enum.Font.Gotham; nd.TextSize = 11; nd.TextXAlignment = Enum.TextXAlignment.Left; nd.TextWrapped = true
        TweenService:Create(n, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -300, 1, -80)}):Play()
        task.delay(time or 3, function() TweenService:Create(n, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 1, -80)}):Play(); task.wait(0.5); n:Destroy() end)
    end

    return WindowObj
end

-- ============================================
-- TEST ALANI (Sadece kütüphaneyi dene)
-- ============================================

local Menu = LuaWare:Window({Name = "LUAWARE HUB V5 | HAWK STYLE"})

local Tab1 = Menu:Tab("Genel Sistemler")
local Tab2 = Menu:Tab("Hareket Ayarları")

Tab1:Section("Bildirim ve Etkileşim")

Tab1:Button("Premium Bildirim Gönder", "Hawk Hub stili bildirim sistemini test et", function()
    Menu:Notify("LUAWARE SUCCESS", "İşte o meşhur bildirim sistemi!", 4)
end)

Tab1:Toggle("Aimbot Motoru", "Otomatik kilitlenme motorunu aktif eder", false, function(v)
    Menu:Notify("HİLE DURUMU", "Aimbot şu an: " .. (v and "AKTİF" or "KAPALI"), 2)
end)

Tab2:Section("Hız ve Zıplama")

Tab2:Slider("Yürüme Hızı", 16, 250, 16, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

Tab2:Toggle("Noclip (Duvar Geçme)", "Ryphera duvar geçme motoru", false, function(v)
    print("Noclip: ", v)
end)

-- Başlangıç Bildirimi
Menu:Notify("HOŞ GELDİN", "Luaware v5.0 başarıyla yüklendi. Keyfini çıkar!", 5)

return LuaWare

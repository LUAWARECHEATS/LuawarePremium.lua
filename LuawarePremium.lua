--[[
    LUAWARE UI LIBRARY V6.0 - THE FRAMEWORK
    YAPIMCI: NOXYORJ
    Özellikler: Dışarıdan modül olarak eklenebilir (API), Smooth Drag, Hawk Design
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local Luaware = {}

-- Tema Paleti
local Theme = {
    Main = Color3.fromRGB(22, 22, 25),
    TitleBar = Color3.fromRGB(26, 26, 30),
    Sidebar = Color3.fromRGB(20, 20, 23),
    Card = Color3.fromRGB(32, 32, 36),
    Accent = Color3.fromRGB(255, 60, 60),
    Text = Color3.fromRGB(245, 245, 245),
    SubText = Color3.fromRGB(150, 150, 160),
    Working = Color3.fromRGB(80, 220, 80),
    DateBlue = Color3.fromRGB(80, 200, 220),
    Border = Color3.fromRGB(45, 45, 50)
}

-- Pürüzsüz Sürükleme Motoru
local function MakeSmoothDraggable(dragObject, targetObject)
    local dragging, dragStart, startPos, velocity, lastPos, lastTime, dragConn, releaseConn
    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = targetObject.Position
            lastPos = input.Position; lastTime = tick(); velocity = Vector2.new()
            
            dragConn = UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local now = tick(); local dt = now - lastTime
                    if dt > 0.001 then velocity = (input.Position - lastPos) / dt; lastPos = input.Position; lastTime = now end
                    local delta = input.Position - dragStart
                    targetObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            
            releaseConn = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                    dragging = false; dragConn:Disconnect(); releaseConn:Disconnect()
                    if velocity.Magnitude > 10 then
                        local inertiaPos = UDim2.new(targetObject.Position.X.Scale, targetObject.Position.X.Offset + velocity.X * 0.1, targetObject.Position.Y.Scale, targetObject.Position.Y.Offset + velocity.Y * 0.1)
                        TweenService:Create(targetObject, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = inertiaPos}):Play()
                    end
                end
            end)
        end
    end)
end

-- =======================================
-- API: PENCERE OLUŞTURMA
-- =======================================
function Luaware:Window(Config)
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name == "LuawareEngine" then v:Destroy() end
    end

    local sg = Instance.new("ScreenGui", CoreGui)
    sg.Name = "LuawareEngine"; sg.ResetOnSpawn = false

    local Main = Instance.new("Frame", sg)
    Main.Size = UDim2.new(0, 680, 0, 380); Main.Position = UDim2.new(0.5, -340, 0.5, -190)
    Main.BackgroundColor3 = Theme.Main; Main.BorderSizePixel = 0; Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 40); TopBar.BackgroundColor3 = Theme.TitleBar; TopBar.BorderSizePixel = 0
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
    local fix = Instance.new("Frame", TopBar); fix.Size = UDim2.new(1, 0, 0, 10); fix.Position = UDim2.new(0, 0, 1, -10); fix.BackgroundColor3 = Theme.TitleBar; fix.BorderSizePixel = 0
    
    local TitleLbl = Instance.new("TextLabel", TopBar)
    TitleLbl.Size = UDim2.new(0, 300, 1, 0); TitleLbl.Position = UDim2.new(0, 15, 0, 0); TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = Config.Name or "LUAWARE HUB"; TitleLbl.TextColor3 = Theme.Text; TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 14; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    MakeSmoothDraggable(TopBar, Main)

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 150, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.BackgroundColor3 = Theme.Sidebar; Sidebar.BorderSizePixel = 0
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -10); TabContainer.Position = UDim2.new(0, 0, 0, 5); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 2)

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -160, 1, -50); PageContainer.Position = UDim2.new(0, 160, 0, 45); PageContainer.BackgroundTransparency = 1

    local WindowObj = {}
    local Tabs, Pages, isFirst = {}, {}, true

    -- Menü Kısayolu
    UserInputService.InputBegan:Connect(function(i, p)
        if not p and i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end
    end)

    -- =======================================
    -- API: SEKME OLUŞTURMA
    -- =======================================
    function WindowObj:Tab(tabName)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 34); TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "     " .. tabName; TabBtn.TextColor3 = isFirst and Theme.Accent or Theme.SubText
        TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 13; TabBtn.TextXAlignment = Enum.TextXAlignment.Left

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

        -- =======================================
        -- API: ELEMENTLER (Dışarıdan çağrılacak)
        -- =======================================
        function Elements:AddSection(txt)
            local lbl = Instance.new("TextLabel", Page)
            lbl.Size = UDim2.new(1, -10, 0, 25); lbl.BackgroundTransparency = 1; lbl.Text = txt
            lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 14; lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        -- İstediğin o Resimli, Yeşil Status'lü Oyun Kartı!
        function Elements:AddGameCard(Config)
            local cFrame = Instance.new("Frame", Page)
            cFrame.Size = UDim2.new(1, -10, 0, 80); cFrame.BackgroundColor3 = Theme.Card; Instance.new("UICorner", cFrame).CornerRadius = UDim.new(0, 6)
            
            local img = Instance.new("ImageLabel", cFrame)
            img.Size = UDim2.new(0, 60, 0, 60); img.Position = UDim2.new(0, 10, 0.5, -30); img.BackgroundTransparency = 1
            img.Image = Config.Image or "rbxassetid://0"; Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)

            local title = Instance.new("TextLabel", cFrame)
            title.Size = UDim2.new(1, -90, 0, 20); title.Position = UDim2.new(0, 80, 0, 10); title.BackgroundTransparency = 1
            title.Text = Config.Title or "Game"; title.TextColor3 = Theme.Text; title.Font = Enum.Font.GothamBold; title.TextSize = 14; title.TextXAlignment = Enum.TextXAlignment.Left

            local statusLbl = Instance.new("TextLabel", cFrame)
            statusLbl.Size = UDim2.new(1, -90, 0, 16); statusLbl.Position = UDim2.new(0, 80, 0, 32); statusLbl.BackgroundTransparency = 1
            statusLbl.Text = "Status: Working"; statusLbl.TextColor3 = Theme.Working; statusLbl.Font = Enum.Font.GothamBold; statusLbl.TextSize = 12; statusLbl.TextXAlignment = Enum.TextXAlignment.Left

            local dateLbl = Instance.new("TextLabel", cFrame)
            dateLbl.Size = UDim2.new(1, -90, 0, 16); dateLbl.Position = UDim2.new(0, 80, 0, 48); dateLbl.BackgroundTransparency = 1
            dateLbl.Text = "Last Update: " .. (Config.Update or "N/A"); dateLbl.TextColor3 = Theme.DateBlue; dateLbl.Font = Enum.Font.GothamBold; dateLbl.TextSize = 12; dateLbl.TextXAlignment = Enum.TextXAlignment.Left

            local click = Instance.new("TextButton", cFrame); click.Size = UDim2.new(1,0,1,0); click.BackgroundTransparency = 1; click.Text = ""
            click.MouseButton1Click:Connect(function() if Config.Callback then Config.Callback() end end)
        end

        function Elements:AddToggle(txt, desc, def, cb)
            local state = def or false
            local tF = Instance.new("Frame", Page)
            tF.Size = UDim2.new(1, -10, 0, 55); tF.BackgroundColor3 = Theme.Card; Instance.new("UICorner", tF).CornerRadius = UDim.new(0, 6)
            
            local tTitle = Instance.new("TextLabel", tF)
            tTitle.Size = UDim2.new(0.6, 0, 0, 18); tTitle.Position = UDim2.new(0, 12, 0, 10); tTitle.BackgroundTransparency = 1; tTitle.Text = txt; tTitle.TextColor3 = Theme.Text; tTitle.Font = Enum.Font.GothamBold; tTitle.TextSize = 14; tTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local dLbl = Instance.new("TextLabel", tF)
            dLbl.Size = UDim2.new(0.6, 0, 0, 16); dLbl.Position = UDim2.new(0, 12, 0, 28); dLbl.BackgroundTransparency = 1; dLbl.Text = desc; dLbl.TextColor3 = Theme.SubText; dLbl.Font = Enum.Font.Gotham; dLbl.TextSize = 12; dLbl.TextXAlignment = Enum.TextXAlignment.Left

            local status = Instance.new("TextLabel", tF)
            status.Size = UDim2.new(0, 120, 1, 0); status.Position = UDim2.new(1, -135, 0, 0); status.BackgroundTransparency = 1
            status.Text = state and "Status: Working" or "Status: Idle"; status.TextColor3 = state and Theme.Working or Theme.SubText; status.Font = Enum.Font.GothamBold; status.TextSize = 12; status.TextXAlignment = Enum.TextXAlignment.Right

            local click = Instance.new("TextButton", tF); click.Size = UDim2.new(1,0,1,0); click.BackgroundTransparency = 1; click.Text = ""
            click.MouseButton1Click:Connect(function()
                state = not state
                status.Text = state and "Status: Working" or "Status: Idle"; status.TextColor3 = state and Theme.Working or Theme.SubText
                if cb then cb(state) end
            end)
        end

        return Elements
    end
    return WindowObj
end

-- KÜTÜPHANEYİ DIŞARI AKTAR
return Luaware

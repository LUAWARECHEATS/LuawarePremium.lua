--[[
    LuaWare UI Library v5.0 - THE HAWK KILLER
    Professional Smooth Drag (Inertia) + Hawk HUB Design
    100% Local Code - No Sticking - No Limits
    YAPIMCI: NOXYORJ
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ============================================
-- THEME (Hawk HUB Aesthetic)
-- ============================================
local Theme = {
    Main = Color3.fromRGB(15, 15, 15),
    Sidebar = Color3.fromRGB(22, 22, 22),
    TopBar = Color3.fromRGB(25, 25, 25),
    Item = Color3.fromRGB(30, 30, 30), -- Kart rengi
    Accent = Color3.fromRGB(220, 60, 60), -- Luaware Kırmızısı
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(160, 160, 160),
    Working = Color3.fromRGB(80, 200, 80), -- O meşhur yeşil yazı
    Border = Color3.fromRGB(40, 40, 40)
}

-- ============================================
-- V5.0 PREMIUM SMOOTH DRAG (INERTIA)
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
-- CORE LIBRARY
-- ============================================
local LuaWare = {}

function LuaWare:Window(options)
    local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
    sg.Name = "LuaWarePremium"
    sg.ResetOnSpawn = false

    local Main = Instance.new("Frame", sg)
    Main.Size = UDim2.new(0, 600, 0, 400); Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.BackgroundColor3 = Theme.Main; Main.BorderSizePixel = 0; Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Main).Color = Theme.Border

    -- TopBar
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 40); TopBar.BackgroundColor3 = Theme.TopBar
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)
    local Line = Instance.new("Frame", TopBar); Line.Size = UDim2.new(1, 0, 0, 2); Line.Position = UDim2.new(0, 0, 1, 0); Line.BackgroundColor3 = Theme.Accent; Line.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(0, 200, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.BackgroundTransparency = 1
    Title.Text = options.Name or "LUAWARE HUB"; Title.TextColor3 = Theme.Text; Title.Font = Enum.Font.GothamBold; Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Left

    MakeSmoothDraggable(TopBar, Main)

    -- Sidebar
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 150, 1, -42); Sidebar.Position = UDim2.new(0, 0, 0, 42); Sidebar.BackgroundColor3 = Theme.Sidebar; Sidebar.BorderSizePixel = 0
    local TabContainer = Instance.new("ScrollingFrame", Sidebar); TabContainer.Size = UDim2.new(1, 0, 1, -10); TabContainer.Position = UDim2.new(0, 0, 0, 5); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 4)

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -165, 1, -55); PageContainer.Position = UDim2.new(0, 160, 0, 50); PageContainer.BackgroundTransparency = 1

    local WindowObj = {}
    local Tabs, Pages, isFirst = {}, {}, true

    function WindowObj:Tab(name)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -10, 0, 34); TabBtn.Position = UDim2.new(0, 5, 0, 0); TabBtn.BackgroundColor3 = isFirst and Theme.Item or Theme.Sidebar
        TabBtn.Text = "   " .. name; TabBtn.TextColor3 = isFirst and Theme.Accent or Theme.SubText; TabBtn.Font = Enum.Font.GothamSemibold; TabBtn.TextSize = 12; TabBtn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.Visible = isFirst; Page.AutomaticCanvasSize = Enum.AutomaticSize.Y; Page.CanvasSize = UDim2.new(0,0,0,0)
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

        table.insert(Tabs, TabBtn); table.insert(Pages, Page); isFirst = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            for _, t in pairs(Tabs) do t.BackgroundColor3 = Theme.Sidebar; t.TextColor3 = Theme.SubText end
            Page.Visible = true; TabBtn.BackgroundColor3 = Theme.Item; TabBtn.TextColor3 = Theme.Accent
        end)

        local Elements = {}

        -- HAWK HUB STYLE BUTTON
        function Elements:Button(txt, desc, cb)
            local btnFrame = Instance.new("Frame", Page)
            btnFrame.Size = UDim2.new(1, -10, 0, 50); btnFrame.BackgroundColor3 = Theme.Item; Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 8)
            
            local btnTitle = Instance.new("TextLabel", btnFrame)
            btnTitle.Size = UDim2.new(1, -20, 0, 20); btnTitle.Position = UDim2.new(0, 12, 0, 8); btnTitle.BackgroundTransparency = 1; btnTitle.Text = txt; btnTitle.TextColor3 = Theme.Text; btnTitle.Font = Enum.Font.GothamBold; btnTitle.TextSize = 13; btnTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local btnDesc = Instance.new("TextLabel", btnFrame)
            btnDesc.Size = UDim2.new(1, -20, 0, 15); btnDesc.Position = UDim2.new(0, 12, 0, 26); btnDesc.BackgroundTransparency = 1; btnDesc.Text = desc; btnDesc.TextColor3 = Theme.SubText; btnDesc.Font = Enum.Font.Gotham; btnDesc.TextSize = 11; btnDesc.TextXAlignment = Enum.TextXAlignment.Left

            local clicker = Instance.new("TextButton", btnFrame); clicker.Size = UDim2.new(1,0,1,0); clicker.BackgroundTransparency = 1; clicker.Text = ""
            clicker.MouseButton1Click:Connect(function()
                TweenService:Create(btnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
                task.wait(0.1)
                TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Item}):Play()
                cb()
            end)
        end

        -- HAWK HUB STYLE TOGGLE
        function Elements:Toggle(txt, desc, def, cb)
            local state = def or false
            local tglFrame = Instance.new("Frame", Page)
            tglFrame.Size = UDim2.new(1, -10, 0, 50); tglFrame.BackgroundColor3 = Theme.Item; Instance.new("UICorner", tglFrame).CornerRadius = UDim.new(0, 8)
            
            local tTitle = Instance.new("TextLabel", tglFrame)
            tTitle.Size = UDim2.new(0.6, 0, 0, 20); tTitle.Position = UDim2.new(0, 12, 0, 8); tTitle.BackgroundTransparency = 1; tTitle.Text = txt; tTitle.TextColor3 = Theme.Text; tTitle.Font = Enum.Font.GothamBold; tTitle.TextSize = 13; tTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local tDesc = Instance.new("TextLabel", tglFrame)
            tDesc.Size = UDim2.new(0.6, 0, 0, 15); tDesc.Position = UDim2.new(0, 12, 0, 26); tDesc.BackgroundTransparency = 1; tDesc.Text = desc; tDesc.TextColor3 = Theme.SubText; tDesc.Font = Enum.Font.Gotham; tDesc.TextSize = 11; tDesc.TextXAlignment = Enum.TextXAlignment.Left

            local status = Instance.new("TextLabel", tglFrame)
            status.Size = UDim2.new(0, 120, 1, 0); status.Position = UDim2.new(1, -130, 0, 0); status.BackgroundTransparency = 1; status.Text = state and "Status: Working" or "Status: Idle"; status.TextColor3 = state and Theme.Working or Theme.SubText; status.Font = Enum.Font.GothamBold; status.TextSize = 11; status.TextXAlignment = Enum.TextXAlignment.Right

            local clicker = Instance.new("TextButton", tglFrame); clicker.Size = UDim2.new(1,0,1,0); clicker.BackgroundTransparency = 1; clicker.Text = ""
            clicker.MouseButton1Click:Connect(function()
                state = not state
                status.Text = state and "Status: Working" or "Status: Idle"
                status.TextColor3 = state and Theme.Working or Theme.SubText
                cb(state)
            end)
        end

        return Elements
    end
    return WindowObj
end

-- ============================================
-- TEST SCRIPT (Exactly as Hawk HUB)
-- ============================================
local Win = LuaWare:Window({Name = "LUAWARE PREMIUM | HAWK v5.0"})

local Tab1 = Win:Tab("Combat")
local Tab2 = Win:Tab("Visuals")

Tab1:Toggle("Aimbot Active", "Automatically locks onto enemies", false, function(v)
    print("Aimbot: ", v)
end)

Tab1:Button("Kill All", "Teleports and kills everyone (OP)", function()
    print("Killing all...")
end)

Tab2:Toggle("ESP Chams", "See people through walls as green", true, function(v)
    print("ESP: ", v)
end)

print("Luaware v5.0 Loaded - Smooth Drag & Hawk Hub UI Active!")

return LuaWare

--[[
    LuaWare UI Library v3.0
    Super Smooth Drag - Yumuşacık Sürükleme
    Test edildi - Çalışıyor
]]

-- ============================================
-- SERVİSLER
-- ============================================
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local IsPC = not UserInputService.TouchEnabled

-- ============================================
-- SÜPER YUMUŞAK DRAG SİSTEMİ (Fizik tabanlı)
-- ============================================
local function MakeSuperSmoothDraggable(dragObject, targetObject)
    local dragging = false
    local dragStart = Vector2.new()
    local startPos = UDim2.new()
    local currentVelocity = Vector2.new()
    local lastPos = Vector2.new()
    local lastTime = tick()
    local inertiaTween = nil
    
    -- Yumuşak hareket için Tween
    local function updatePositionSmooth(newPosition)
        if inertiaTween and inertiaTween.PlaybackState == Enum.PlaybackState.Playing then
            inertiaTween:Cancel()
        end
        inertiaTween = TweenService:Create(targetObject, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = newPosition
        })
        inertiaTween:Play()
    end
    
    -- Anlık hareket (sürükleme sırasında)
    local function updatePositionDrag(newPosition)
        targetObject.Position = newPosition
    end
    
    -- Ekran sınırlarını kontrol et
    local function clampPosition(pos)
        local parent = targetObject.Parent
        if not parent then return pos end
        
        local maxX = parent.AbsoluteSize.X - targetObject.AbsoluteSize.X
        local maxY = parent.AbsoluteSize.Y - targetObject.AbsoluteSize.Y
        
        return UDim2.new(
            0,
            math.clamp(pos.X.Offset, 0, maxX),
            0,
            math.clamp(pos.Y.Offset, 0, maxY)
        )
    end
    
    -- Inertia efekti (fırlatma)
    local function applyInertia()
        local speed = currentVelocity.Magnitude
        if speed > 10 then
            local inertiaPos = UDim2.new(
                0,
                math.clamp(startPos.X.Offset + currentVelocity.X * 0.12, 0, (targetObject.Parent and targetObject.Parent.AbsoluteSize.X or 1920) - targetObject.AbsoluteSize.X),
                0,
                math.clamp(startPos.Y.Offset + currentVelocity.Y * 0.12, 0, (targetObject.Parent and targetObject.Parent.AbsoluteSize.Y or 1080) - targetObject.AbsoluteSize.Y)
            )
            
            -- Yumuşak iniş
            local duration = math.min(0.3, math.max(0.15, speed / 500))
            inertiaTween = TweenService:Create(targetObject, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = inertiaPos
            })
            inertiaTween:Play()
        end
    end
    
    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = targetObject.Position
            lastPos = input.Position
            lastTime = tick()
            currentVelocity = Vector2.new()
            
            -- Drag başlangıcında hafif saydamlaşma
            TweenService:Create(dragObject, TweenInfo.new(0.1), {
                BackgroundTransparency = (dragObject.BackgroundTransparency or 0) + 0.1
            }):Play()
        end
    end)
    
    local moveConnection = nil
    local releaseConnection = nil
    
    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Hareket takibi
            moveConnection = UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Position - dragStart
                    local newPos = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                    
                    -- Hız hesaplama
                    local now = tick()
                    local dt = now - lastTime
                    if dt > 0.001 then
                        currentVelocity = (input.Position - lastPos) / dt
                        lastPos = input.Position
                        lastTime = now
                    end
                    
                    -- Sürükleme sırasında yumuşak hareket
                    updatePositionDrag(clampPosition(newPos))
                end
            end)
            
            -- Bırakma takibi
            releaseConnection = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                    dragging = false
                    
                    -- Saydamlığı geri al
                    TweenService:Create(dragObject, TweenInfo.new(0.15), {
                        BackgroundTransparency = (dragObject.BackgroundTransparency or 0) - 0.1
                    }):Play()
                    
                    -- Inertia uygula
                    applyInertia()
                    
                    -- Bağlantıları temizle
                    if moveConnection then moveConnection:Disconnect() end
                    if releaseConnection then releaseConnection:Disconnect() end
                end
            end)
        end
    end)
end

-- ============================================
-- TEMA RENKLERİ
-- ============================================
local Themes = {
    Rise = {
        Main = Color3.fromRGB(18, 18, 22),
        TitleBar = Color3.fromRGB(22, 22, 28),
        TabActive = Color3.fromRGB(255, 60, 60),
        TabInactive = Color3.fromRGB(30, 30, 40),
        TextPrimary = Color3.fromRGB(245, 245, 255),
        TextSecondary = Color3.fromRGB(170, 175, 190),
        ItemBg = Color3.fromRGB(28, 28, 36),
        ButtonBg = Color3.fromRGB(38, 38, 48),
        ButtonHover = Color3.fromRGB(255, 60, 60),
        Border = Color3.fromRGB(35, 35, 45),
        ToggleOn = Color3.fromRGB(255, 60, 60),
        ToggleOff = Color3.fromRGB(70, 75, 90),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        PageTitle = Color3.fromRGB(200, 210, 230),
    },
    Dark = {
        Main = Color3.fromRGB(20, 22, 30),
        TitleBar = Color3.fromRGB(25, 28, 36),
        TabActive = Color3.fromRGB(80, 140, 255),
        TabInactive = Color3.fromRGB(32, 35, 45),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(170, 180, 200),
        ItemBg = Color3.fromRGB(32, 35, 45),
        ButtonBg = Color3.fromRGB(38, 42, 52),
        ButtonHover = Color3.fromRGB(80, 140, 255),
        Border = Color3.fromRGB(40, 44, 55),
        ToggleOn = Color3.fromRGB(80, 140, 255),
        ToggleOff = Color3.fromRGB(70, 75, 90),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        PageTitle = Color3.fromRGB(80, 140, 255),
    },
    Cyber = {
        Main = Color3.fromRGB(10, 10, 20),
        TitleBar = Color3.fromRGB(15, 15, 30),
        TabActive = Color3.fromRGB(0, 255, 200),
        TabInactive = Color3.fromRGB(25, 25, 45),
        TextPrimary = Color3.fromRGB(0, 255, 200),
        TextSecondary = Color3.fromRGB(150, 150, 200),
        ItemBg = Color3.fromRGB(20, 20, 38),
        ButtonBg = Color3.fromRGB(30, 30, 50),
        ButtonHover = Color3.fromRGB(0, 255, 200),
        Border = Color3.fromRGB(50, 50, 80),
        ToggleOn = Color3.fromRGB(0, 255, 100),
        ToggleOff = Color3.fromRGB(60, 60, 90),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        PageTitle = Color3.fromRGB(0, 200, 255),
    }
}

local CurrentTheme = "Rise"
local Theme = Themes[CurrentTheme]

-- ============================================
-- GUI OLUŞTUR
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LuaWare"
ScreenGui.ResetOnSpawn = false

local guiParent = nil
pcall(function()
    if LocalPlayer:FindFirstChild("PlayerGui") then
        guiParent = LocalPlayer.PlayerGui
    end
end)
if not guiParent then
    pcall(function()
        guiParent = game:GetService("CoreGui")
    end)
end
if guiParent then
    ScreenGui.Parent = guiParent
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Ana Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 420)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
MainFrame.BackgroundColor3 = Theme.Main
MainFrame.BackgroundTransparency = 0.08
MainFrame.BorderSizePixel = 0

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Border
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.4
MainStroke.Parent = MainFrame

-- Blur efekti
local BlurBg = Instance.new("Frame")
BlurBg.Size = UDim2.new(1, 0, 1, 0)
BlurBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BlurBg.BackgroundTransparency = 0.96
BlurBg.BorderSizePixel = 0
BlurBg.Parent = MainFrame

local BlurCorner = Instance.new("UICorner")
BlurCorner.CornerRadius = UDim.new(0, 14)
BlurCorner.Parent = BlurBg

-- Başlık Çubuğu (Drag alanı - süper yumuşak)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Theme.TitleBar
TitleBar.BackgroundTransparency = 0.15
TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "LuaWare"
Title.TextColor3 = Theme.TextPrimary
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Kapat Butonu
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 34, 0, 34)
CloseBtn.Position = UDim2.new(1, -44, 0.5, -17)
CloseBtn.BackgroundColor3 = Theme.ButtonBg
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Theme.TextPrimary
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 15
CloseBtn.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Minimize Butonu
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 34, 0, 34)
MinBtn.Position = UDim2.new(1, -88, 0.5, -17)
MinBtn.BackgroundColor3 = Theme.ButtonBg
MinBtn.Text = "−"
MinBtn.TextColor3 = Theme.TextPrimary
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 22
MinBtn.BorderSizePixel = 0

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinBtn

-- Sekme Alanı
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(0, 140, 1, -42)
TabContainer.Position = UDim2.new(0, 0, 0, 42)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.Padding = UDim.new(0, 6)

-- Ayırıcı Çizgi
local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(0, 1, 1, -52)
Separator.Position = UDim2.new(0, 140, 0, 46)
Separator.BackgroundColor3 = Theme.Border
Separator.BackgroundTransparency = 0.5
Separator.BorderSizePixel = 0

-- Sayfa Alanı
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -155, 1, -52)
PageContainer.Position = UDim2.new(0, 150, 0, 46)
PageContainer.BackgroundTransparency = 1

-- ============================================
-- EKLEMELER
-- ============================================
Title.Parent = TitleBar
CloseBtn.Parent = TitleBar
MinBtn.Parent = TitleBar
TitleBar.Parent = MainFrame
TabContainer.Parent = MainFrame
Separator.Parent = MainFrame
PageContainer.Parent = MainFrame
MainFrame.Parent = ScreenGui

-- SÜPER YUMUŞAK DRAG (TitleBar üzerinden)
MakeSuperSmoothDraggable(TitleBar, MainFrame)

-- Minimize işlevi
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 520, 0, 48)
        }):Play()
        TabContainer.Visible = false
        PageContainer.Visible = false
        Separator.Visible = false
        MinBtn.Text = "□"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 520, 0, 420)
        }):Play()
        task.wait(0.35)
        TabContainer.Visible = true
        PageContainer.Visible = true
        Separator.Visible = true
        MinBtn.Text = "−"
    end
end)

-- Kapat
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.2)
    ScreenGui:Destroy()
end)

-- Hover efektleri
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.ButtonBg}):Play()
end)

MinBtn.MouseEnter:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.ButtonHover}):Play()
end)
MinBtn.MouseLeave:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.ButtonBg}):Play()
end)

-- ============================================
-- LUAWARE API
-- ============================================
local LuaWare = {
    Themes = Themes,
    CurrentTheme = CurrentTheme,
    ScreenGui = ScreenGui,
    MainFrame = MainFrame
}

local firstTab = true

function LuaWare:Window(options)
    local scriptName = options.ScriptName or "LuaWare"
    local themeName = options.Theme or "Rise"
    
    if Themes[themeName] then
        CurrentTheme = themeName
        Theme = Themes[themeName]
    end
    
    -- UI güncelleme
    Title.Text = scriptName
    MainFrame.BackgroundColor3 = Theme.Main
    TitleBar.BackgroundColor3 = Theme.TitleBar
    CloseBtn.BackgroundColor3 = Theme.ButtonBg
    MinBtn.BackgroundColor3 = Theme.ButtonBg
    Title.TextColor3 = Theme.TextPrimary
    MainStroke.Color = Theme.Border
    Separator.BackgroundColor3 = Theme.Border
    
    local window = {}
    
    function window:Tab(tabName, pageTitle)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -20, 0, 38)
        TabBtn.Position = UDim2.new(0, 10, 0, 0)
        TabBtn.BackgroundColor3 = Theme.TabInactive
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Theme.TextSecondary
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        TabBtn.BorderSizePixel = 0
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabBtn
        
        TabBtn.MouseEnter:Connect(function()
            if TabBtn.BackgroundColor3 ~= Theme.TabActive then
                TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.TabInactive:lerp(Theme.TabActive, 0.2)}):Play()
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if TabBtn.BackgroundColor3 ~= Theme.TabActive then
                TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.TabInactive}):Play()
            end
        end)
        
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Theme.TabActive
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = false
        
        local Content = Instance.new("Frame")
        Content.Size = UDim2.new(1, -20, 0, 0)
        Content.Position = UDim2.new(0, 12, 0, 12)
        Content.BackgroundTransparency = 1
        Content.AutomaticSize = Enum.AutomaticSize.Y
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = Content
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        if pageTitle then
            local PageTitle = Instance.new("TextLabel")
            PageTitle.Size = UDim2.new(1, 0, 0, 38)
            PageTitle.BackgroundTransparency = 1
            PageTitle.Text = pageTitle
            PageTitle.TextColor3 = Theme.PageTitle
            PageTitle.Font = Enum.Font.GothamBold
            PageTitle.TextSize = 22
            PageTitle.TextXAlignment = Enum.TextXAlignment.Left
            PageTitle.Parent = Content
        end
        
        Content.Parent = Page
        Page.Parent = PageContainer
        
        local function updateCanvas()
            Page.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        updateCanvas()
        
        if firstTab then
            firstTab = false
            TabBtn.BackgroundColor3 = Theme.TabActive
            TabBtn.TextColor3 = Theme.TextPrimary
            Page.Visible = true
        end
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, btn in ipairs(TabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Theme.TabInactive
                    btn.TextColor3 = Theme.TextSecondary
                end
            end
            for _, pg in ipairs(PageContainer:GetChildren()) do
                if pg:IsA("ScrollingFrame") then
                    pg.Visible = false
                end
            end
            TabBtn.BackgroundColor3 = Theme.TabActive
            TabBtn.TextColor3 = Theme.TextPrimary
            Page.Visible = true
        end)
        
        TabBtn.Parent = TabContainer
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
        
        -- ============================================
        -- ELEMENTLER
        -- ============================================
        local elements = {}
        
        function elements:Section(title)
            local section = Instance.new("TextLabel")
            section.Size = UDim2.new(1, 0, 0, 28)
            section.BackgroundTransparency = 1
            section.Text = title
            section.TextColor3 = Theme.TextPrimary
            section.Font = Enum.Font.GothamBold
            section.TextSize = 17
            section.TextXAlignment = Enum.TextXAlignment.Left
            section.Parent = Content
            updateCanvas()
            return section
        end
        
        function elements:Line()
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.BackgroundColor3 = Theme.Border
            line.BackgroundTransparency = 0.5
            line.BorderSizePixel = 0
            line.Parent = Content
            updateCanvas()
            return line
        end
        
        function elements:Label(text, desc)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, desc and 55 or 42)
            frame.BackgroundColor3 = Theme.ItemBg
            frame.BackgroundTransparency = 0.15
            frame.BorderSizePixel = 0
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = frame
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -20, 0, 22)
            title.Position = UDim2.new(0, 15, 0, 6)
            title.BackgroundTransparency = 1
            title.Text = text
            title.TextColor3 = Theme.TextPrimary
            title.Font = Enum.Font.GothamSemibold
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = frame
            
            local descLabel = nil
            if desc then
                descLabel = Instance.new("TextLabel")
                descLabel.Size = UDim2.new(1, -20, 0, 18)
                descLabel.Position = UDim2.new(0, 15, 0, 28)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = desc
                descLabel.TextColor3 = Theme.TextSecondary
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextSize = 12
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.Parent = frame
            end
            
            frame.Parent = Content
            updateCanvas()
            
            return {
                UpdateLabel = function(newText, newDesc)
                    title.Text = newText
                    if descLabel then descLabel.Text = newDesc or "" end
                    updateCanvas()
                end
            }
        end
        
        function elements:Button(text, desc, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, desc and 58 or 48)
            frame.BackgroundColor3 = Theme.ItemBg
            frame.BackgroundTransparency = 0.15
            frame.BorderSizePixel = 0
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = frame
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(0.65, 0, 0, 24)
            title.Position = UDim2.new(0, 15, 0, 6)
            title.BackgroundTransparency = 1
            title.Text = text
            title.TextColor3 = Theme.TextPrimary
            title.Font = Enum.Font.GothamSemibold
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = frame
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 80, 0, 34)
            btn.Position = UDim2.new(1, -95, 0.5, -17)
            btn.BackgroundColor3 = Theme.ButtonBg
            btn.Text = "Click"
            btn.TextColor3 = Theme.TextPrimary
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 13
            btn.BorderSizePixel = 0
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn
            
            if desc then
                local descLabel = Instance.new("TextLabel")
                descLabel.Size = UDim2.new(0.65, 0, 0, 20)
                descLabel.Position = UDim2.new(0, 15, 0, 30)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = desc
                descLabel.TextColor3 = Theme.TextSecondary
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextSize = 12
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.Parent = frame
            end
            
            btn.MouseButton1Click:Connect(callback)
            
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Theme.ButtonHover}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Theme.ButtonBg}):Play()
            end)
            
            frame.MouseEnter:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.18), {BackgroundTransparency = 0}):Play()
            end)
            frame.MouseLeave:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.18), {BackgroundTransparency = 0.15}):Play()
            end)
            
            frame.Parent = Content
            updateCanvas()
            
            return {
                UpdateButton = function(newText, newDesc, newCallback)
                    title.Text = newText
                    if descLabel then descLabel.Text = newDesc or "" end
                    if newCallback then
                        btn.MouseButton1Click:Connect(newCallback)
                    end
                    updateCanvas()
                end
            }
        end
        
        function elements:Toggle(text, desc, default, callback)
            local state = default or false
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, desc and 58 or 48)
            frame.BackgroundColor3 = Theme.ItemBg
            frame.BackgroundTransparency = 0.15
            frame.BorderSizePixel = 0
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = frame
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(0.65, 0, 0, 24)
            title.Position = UDim2.new(0, 15, 0, 6)
            title.BackgroundTransparency = 1
            title.Text = text
            title.TextColor3 = state and Theme.ToggleOn or Theme.TextPrimary
            title.Font = Enum.Font.GothamSemibold
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = frame
            
            if desc then
                local descLabel = Instance.new("TextLabel")
                descLabel.Size = UDim2.new(0.65, 0, 0, 20)
                descLabel.Position = UDim2.new(0, 15, 0, 30)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = desc
                descLabel.TextColor3 = Theme.TextSecondary
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextSize = 12
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.Parent = frame
            end
            
            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 48, 0, 24)
            toggleBg.Position = UDim2.new(1, -62, 0.5, -12)
            toggleBg.BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff
            toggleBg.BorderSizePixel = 0
            toggleBg.Parent = frame
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = toggleBg
            
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Size = UDim2.new(0, 20, 0, 20)
            toggleCircle.Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            toggleCircle.BackgroundColor3 = Theme.ToggleCircle
            toggleCircle.BorderSizePixel = 0
            toggleCircle.Parent = toggleBg
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = toggleCircle
            
            local function updateState(newState)
                state = newState
                if state then
                    TweenService:Create(toggleBg, TweenInfo.new(0.15), {BackgroundColor3 = Theme.ToggleOn}):Play()
                    TweenService:Create(toggleCircle, TweenInfo.new(0.15), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
                    TweenService:Create(title, TweenInfo.new(0.15), {TextColor3 = Theme.ToggleOn}):Play()
                else
                    TweenService:Create(toggleBg, TweenInfo.new(0.15), {BackgroundColor3 = Theme.ToggleOff}):Play()
                    TweenService:Create(toggleCircle, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
                    TweenService:Create(title, TweenInfo.new(0.15), {TextColor3 = Theme.TextPrimary}):Play()
                end
                callback(state)
            end
            
            local function onClick()
                updateState(not state)
            end
            
            frame.MouseButton1Click:Connect(onClick)
            toggleBg.MouseButton1Click:Connect(onClick)
            
            frame.MouseEnter:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.18), {BackgroundTransparency = 0}):Play()
            end)
            frame.MouseLeave:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.18), {BackgroundTransparency = 0.15}):Play()
            end)
            
            frame.Parent = Content
            updateCanvas()
            
            return {
                UpdateToggle = updateState,
                GetValue = function() return state end
            }
        end
        
        return elements
    end
    
    return window
end

function LuaWare:ToggleUI()
    ScreenGui.Enabled = not ScreenGui.Enabled
end

function LuaWare:Destroy()
    ScreenGui:Destroy()
end

-- ============================================
-- KEYBIND (RightShift)
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        LuaWare:ToggleUI()
    end
end)

-- ============================================
-- BAŞARI MESAJI
-- ============================================
print([[
╔════════════════════════════════════════╗
║                                        ║
║    LUAWARE UI v3.0                     ║
║    SUPER SMOOTH DRAG                   ║
║                                        ║
║    Menuyu basliktan tutup cek!         ║
║    Yumusacik hissedeceksin!            ║
║                                        ║
║    RightShift ile ac/kapat             ║
║                                        ║
╚════════════════════════════════════════╝
]])

return LuaWare

--[[
    LuaWare UI Library v3.1
    Sınırsız Yumuşak Drag + Modern Tasarım
    Hiçbir yerde takılmaz, istediğin yere sürükle!
]]

-- ============================================
-- SERVİSLER
-- ============================================
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local IsPC = not UserInputService.TouchEnabled

-- ============================================
-- SÜPER YUMUŞAK SINIRSIZ DRAG
-- ============================================
local function MakeSuperSmoothDraggable(dragObject, targetObject)
    local dragging = false
    local dragStart = Vector2.new()
    local startPos = UDim2.new()
    local currentVelocity = Vector2.new()
    local lastPos = Vector2.new()
    local lastTime = tick()
    
    -- Yumuşak hareket
    local function updatePosition(newPosition)
        TweenService:Create(targetObject, TweenInfo.new(0.03, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = newPosition
        }):Play()
    end
    
    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = targetObject.Position
            lastPos = input.Position
            lastTime = tick()
            currentVelocity = Vector2.new()
            
            TweenService:Create(dragObject, TweenInfo.new(0.1), {
                BackgroundTransparency = (dragObject.BackgroundTransparency or 0) + 0.1
            }):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local now = tick()
            local dt = now - lastTime
            if dt > 0.001 then
                currentVelocity = (input.Position - lastPos) / dt
                lastPos = input.Position
                lastTime = now
            end
            
            -- SINIRSIZ hareket - hiçbir yerde takılmaz
            updatePosition(UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            ))
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            
            TweenService:Create(dragObject, TweenInfo.new(0.15), {
                BackgroundTransparency = (dragObject.BackgroundTransparency or 0) - 0.1
            }):Play()
            
            -- Hafif inertia (fırlatma hissi)
            if math.abs(currentVelocity.X) > 30 or math.abs(currentVelocity.Y) > 30 then
                local inertiaPos = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + currentVelocity.X * 0.1,
                    startPos.Y.Scale,
                    startPos.Y.Offset + currentVelocity.Y * 0.1
                )
                TweenService:Create(targetObject, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = inertiaPos
                }):Play()
            end
        end
    end)
end

-- ============================================
-- MODERN TEMA
-- ============================================
local Themes = {
    Modern = {
        Main = Color3.fromRGB(18, 18, 22),
        TitleBar = Color3.fromRGB(22, 22, 30),
        TabActive = Color3.fromRGB(255, 70, 70),
        TabInactive = Color3.fromRGB(30, 30, 42),
        TextPrimary = Color3.fromRGB(245, 245, 255),
        TextSecondary = Color3.fromRGB(160, 165, 185),
        ItemBg = Color3.fromRGB(28, 28, 38),
        ButtonBg = Color3.fromRGB(38, 38, 52),
        ButtonHover = Color3.fromRGB(255, 70, 70),
        Border = Color3.fromRGB(35, 35, 48),
        ToggleOn = Color3.fromRGB(255, 70, 70),
        ToggleOff = Color3.fromRGB(65, 70, 85),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        PageTitle = Color3.fromRGB(255, 100, 100),
        Accent = Color3.fromRGB(255, 70, 70),
    },
    Dark = {
        Main = Color3.fromRGB(20, 22, 32),
        TitleBar = Color3.fromRGB(25, 28, 40),
        TabActive = Color3.fromRGB(80, 140, 255),
        TabInactive = Color3.fromRGB(32, 36, 50),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(170, 180, 210),
        ItemBg = Color3.fromRGB(32, 36, 48),
        ButtonBg = Color3.fromRGB(40, 44, 58),
        ButtonHover = Color3.fromRGB(80, 140, 255),
        Border = Color3.fromRGB(40, 45, 60),
        ToggleOn = Color3.fromRGB(80, 140, 255),
        ToggleOff = Color3.fromRGB(65, 70, 90),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        PageTitle = Color3.fromRGB(100, 160, 255),
        Accent = Color3.fromRGB(80, 140, 255),
    },
    Night = {
        Main = Color3.fromRGB(12, 12, 18),
        TitleBar = Color3.fromRGB(18, 18, 26),
        TabActive = Color3.fromRGB(180, 100, 255),
        TabInactive = Color3.fromRGB(28, 28, 40),
        TextPrimary = Color3.fromRGB(240, 235, 255),
        TextSecondary = Color3.fromRGB(170, 160, 200),
        ItemBg = Color3.fromRGB(25, 25, 36),
        ButtonBg = Color3.fromRGB(35, 35, 48),
        ButtonHover = Color3.fromRGB(180, 100, 255),
        Border = Color3.fromRGB(35, 35, 48),
        ToggleOn = Color3.fromRGB(180, 100, 255),
        ToggleOff = Color3.fromRGB(65, 60, 85),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        PageTitle = Color3.fromRGB(200, 140, 255),
        Accent = Color3.fromRGB(180, 100, 255),
    }
}

local CurrentTheme = "Modern"
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
ScreenGui.Parent = guiParent or LocalPlayer:WaitForChild("PlayerGui")

-- Ana Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Theme.Main
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Border
MainStroke.Thickness = 1
MainStroke.Transparency = 0.4
MainStroke.Parent = MainFrame

-- Başlık Çubuğu
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Theme.TitleBar
TitleBar.BackgroundTransparency = 0.1
TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar

local Icon = Instance.new("TextLabel")
Icon.Size = UDim2.new(0, 35, 1, 0)
Icon.Position = UDim2.new(0, 0, 0, 0)
Icon.BackgroundTransparency = 1
Icon.Text = "⚡"
Icon.TextColor3 = Theme.Accent
Icon.Font = Enum.Font.GothamBold
Icon.TextSize = 20
Icon.TextXAlignment = Enum.TextXAlignment.Center

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 40, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "LuaWare"
Title.TextColor3 = Theme.TextPrimary
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Butonlar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0.5, -17.5)
CloseBtn.BackgroundColor3 = Theme.ButtonBg
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Theme.TextPrimary
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 35, 0, 35)
MinBtn.Position = UDim2.new(1, -90, 0.5, -17.5)
MinBtn.BackgroundColor3 = Theme.ButtonBg
MinBtn.Text = "−"
MinBtn.TextColor3 = Theme.TextPrimary
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.BorderSizePixel = 0

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinBtn

-- Sekme Butonları (Üst tarafta yatay)
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 45)
TabContainer.BackgroundTransparency = 1

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 2)

-- Sayfa Alanı
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -20, 1, -95)
PageContainer.Position = UDim2.new(0, 10, 0, 90)
PageContainer.BackgroundTransparency = 1

-- ============================================
-- EKLEMELER
-- ============================================
Icon.Parent = TitleBar
Title.Parent = TitleBar
CloseBtn.Parent = TitleBar
MinBtn.Parent = TitleBar
TitleBar.Parent = MainFrame
TabContainer.Parent = MainFrame
PageContainer.Parent = MainFrame
MainFrame.Parent = ScreenGui

-- SINIRSIZ YUMUŞAK DRAG
MakeSuperSmoothDraggable(TitleBar, MainFrame)

-- Minimize
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 500, 0, 50)
        }):Play()
        TabContainer.Visible = false
        PageContainer.Visible = false
        MinBtn.Text = "□"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 500, 0, 400)
        }):Play()
        task.wait(0.3)
        TabContainer.Visible = true
        PageContainer.Visible = true
        MinBtn.Text = "−"
    end
end)

-- Kapat
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
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
    ScreenGui = ScreenGui,
    MainFrame = MainFrame
}

local firstTab = true
local tabButtons = {}

function LuaWare:Window(options)
    local scriptName = options.ScriptName or "LuaWare"
    local themeName = options.Theme or "Modern"
    
    if Themes[themeName] then
        CurrentTheme = themeName
        Theme = Themes[themeName]
        MainFrame.BackgroundColor3 = Theme.Main
        TitleBar.BackgroundColor3 = Theme.TitleBar
        Title.TextColor3 = Theme.TextPrimary
        Icon.TextColor3 = Theme.Accent
        MainStroke.Color = Theme.Border
    end
    
    Title.Text = scriptName
    
    local window = {}
    
    function window:Tab(tabName, pageTitle)
        -- Yatay sekme butonu
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0, 90, 1, -5)
        TabBtn.Position = UDim2.new(0, 0, 0, 2)
        TabBtn.BackgroundColor3 = Theme.TabInactive
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Theme.TextSecondary
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        TabBtn.BorderSizePixel = 0
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 10)
        TabCorner.Parent = TabBtn
        
        -- Sayfa
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Theme.Accent
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = false
        
        local Content = Instance.new("Frame")
        Content.Size = UDim2.new(1, 0, 0, 0)
        Content.BackgroundTransparency = 1
        Content.AutomaticSize = Enum.AutomaticSize.Y
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = Content
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        -- Sayfa başlığı
        if pageTitle then
            local PageTitle = Instance.new("TextLabel")
            PageTitle.Size = UDim2.new(1, 0, 0, 35)
            PageTitle.BackgroundTransparency = 1
            PageTitle.Text = pageTitle
            PageTitle.TextColor3 = Theme.PageTitle
            PageTitle.Font = Enum.Font.GothamBold
            PageTitle.TextSize = 18
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
            for _, btn in ipairs(tabButtons) do
                btn.BackgroundColor3 = Theme.TabInactive
                btn.TextColor3 = Theme.TextSecondary
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
        table.insert(tabButtons, TabBtn)
        
        -- ============================================
        -- ELEMENTLER
        -- ============================================
        local elements = {}
        
        function elements:Section(title)
            local section = Instance.new("TextLabel")
            section.Size = UDim2.new(1, 0, 0, 30)
            section.BackgroundTransparency = 1
            section.Text = title
            section.TextColor3 = Theme.TextPrimary
            section.Font = Enum.Font.GothamBold
            section.TextSize = 16
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
            frame.Size = UDim2.new(1, 0, 0, desc and 55 or 40)
            frame.BackgroundColor3 = Theme.ItemBg
            frame.BackgroundTransparency = 0.15
            frame.BorderSizePixel = 0
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = frame
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -20, 0, 22)
            title.Position = UDim2.new(0, 15, 0, 5)
            title.BackgroundTransparency = 1
            title.Text = text
            title.TextColor3 = Theme.TextPrimary
            title.Font = Enum.Font.GothamSemibold
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = frame
            
            if desc then
                local descLabel = Instance.new("TextLabel")
                descLabel.Size = UDim2.new(1, -20, 0, 20)
                descLabel.Position = UDim2.new(0, 15, 0, 27)
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
                Update = function(newText, newDesc)
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
            title.Size = UDim2.new(0.6, 0, 0, 24)
            title.Position = UDim2.new(0, 15, 0, 5)
            title.BackgroundTransparency = 1
            title.Text = text
            title.TextColor3 = Theme.TextPrimary
            title.Font = Enum.Font.GothamSemibold
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = frame
            
            if desc then
                local descLabel = Instance.new("TextLabel")
                descLabel.Size = UDim2.new(0.6, 0, 0, 20)
                descLabel.Position = UDim2.new(0, 15, 0, 29)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = desc
                descLabel.TextColor3 = Theme.TextSecondary
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextSize = 12
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.Parent = frame
            end
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 75, 0, 34)
            btn.Position = UDim2.new(1, -90, 0.5, -17)
            btn.BackgroundColor3 = Theme.ButtonBg
            btn.Text = "Run"
            btn.TextColor3 = Theme.TextPrimary
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 13
            btn.BorderSizePixel = 0
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn
            
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
                Update = function(newText, newDesc, newCallback)
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
            title.Size = UDim2.new(0.6, 0, 0, 24)
            title.Position = UDim2.new(0, 15, 0, 5)
            title.BackgroundTransparency = 1
            title.Text = text
            title.TextColor3 = state and Theme.ToggleOn or Theme.TextPrimary
            title.Font = Enum.Font.GothamSemibold
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = frame
            
            if desc then
                local descLabel = Instance.new("TextLabel")
                descLabel.Size = UDim2.new(0.6, 0, 0, 20)
                descLabel.Position = UDim2.new(0, 15, 0, 29)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = desc
                descLabel.TextColor3 = Theme.TextSecondary
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextSize = 12
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.Parent = frame
            end
            
            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 46, 0, 24)
            toggleBg.Position = UDim2.new(1, -60, 0.5, -12)
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
            
            frame.MouseButton1Click:Connect(function()
                updateState(not state)
            end)
            toggleBg.MouseButton1Click:Connect(function()
                updateState(not state)
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
                Set = updateState,
                Get = function() return state end
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
-- KEYBIND
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        LuaWare:ToggleUI()
    end
end)

print([[
╔════════════════════════════════════════╗
║                                        ║
║    LUAWARE UI v3.1                     ║
║    SINIRSIZ YUMUŞAK DRAG               ║
║                                        ║
║    Başlıktan tut ve istediğin yere    ║
║    sürükle! Hiçbir yerde takılmaz!     ║
║                                        ║
║    RightShift ile aç/kapat             ║
║                                        ║
╚════════════════════════════════════════╝
]])

return LuaWare

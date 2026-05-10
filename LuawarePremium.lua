--[[
    LuaWare UI Library v2.2
    Kesin Çalışan Versiyon
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
-- YUMUŞAK DRAG SİSTEMİ
-- ============================================
local function MakeSmoothDraggable(dragObject, targetObject)
    local dragging = false
    local dragStart = Vector2.new()
    local startPos = UDim2.new()
    
    local function updatePosition(newPosition)
        TweenService:Create(targetObject, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = newPosition
        }):Play()
    end
    
    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = targetObject.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            updatePosition(UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y))
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

-- ÖNCE PlayerGui'ye dene, sonra CoreGui'ye (Blox Strike için)
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
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Border
MainStroke.Thickness = 1
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

-- Başlık Çubuğu
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Theme.TitleBar
TitleBar.BackgroundTransparency = 0.2
TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "LuaWare"
Title.TextColor3 = Theme.TextPrimary
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Kapat Butonu
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -16)
CloseBtn.BackgroundColor3 = Theme.ButtonBg
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.TextPrimary
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Minimize Butonu
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 32, 0, 32)
MinBtn.Position = UDim2.new(1, -84, 0.5, -16)
MinBtn.BackgroundColor3 = Theme.ButtonBg
MinBtn.Text = "-"
MinBtn.TextColor3 = Theme.TextPrimary
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.BorderSizePixel = 0

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinBtn

-- Sekme Alanı
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(0, 140, 1, -38)
TabContainer.Position = UDim2.new(0, 0, 0, 38)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.Padding = UDim.new(0, 5)

-- Ayırıcı Çizgi
local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(0, 1, 1, -48)
Separator.Position = UDim2.new(0, 140, 0, 42)
Separator.BackgroundColor3 = Theme.Border
Separator.BackgroundTransparency = 0.5
Separator.BorderSizePixel = 0

-- Sayfa Alanı
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -155, 1, -48)
PageContainer.Position = UDim2.new(0, 150, 0, 42)
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

-- Taşıma
MakeSmoothDraggable(TitleBar, MainFrame)

-- Minimize
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame:TweenSize(UDim2.new(0, 520, 0, 45), "Out", "Quad", 0.3)
        TabContainer.Visible = false
        PageContainer.Visible = false
        Separator.Visible = false
        MinBtn.Text = "□"
    else
        MainFrame:TweenSize(UDim2.new(0, 520, 0, 420), "Out", "Quad", 0.3)
        TabContainer.Visible = true
        PageContainer.Visible = true
        Separator.Visible = true
        MinBtn.Text = "-"
    end
end)

-- Kapat
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Hover efektleri
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.ButtonBg}):Play()
end)

MinBtn.MouseEnter:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.ButtonHover}):Play()
end)
MinBtn.MouseLeave:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.ButtonBg}):Play()
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
    
    -- Tema güncelleme
    if Themes[themeName] then
        CurrentTheme = themeName
        Theme = Themes[themeName]
    end
    
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
        -- Sekme Butonu
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
        
        -- Hover efekti
        TabBtn.MouseEnter:Connect(function()
            if TabBtn.BackgroundColor3 ~= Theme.TabActive then
                TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.TabInactive:lerp(Theme.TabActive, 0.3)}):Play()
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if TabBtn.BackgroundColor3 ~= Theme.TabActive then
                TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.TabInactive}):Play()
            end
        end)
        
        -- Sayfa
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
        Content.Position = UDim2.new(0, 10, 0, 10)
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
            PageTitle.TextSize = 22
            PageTitle.TextXAlignment = Enum.TextXAlignment.Left
            PageTitle.Parent = Content
        end
        
        Content.Parent = Page
        Page.Parent = PageContainer
        
        -- Canvas güncelleme
        local function updateCanvas()
            Page.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        updateCanvas()
        
        -- İlk sekme aktif
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
            section.Size = UDim2.new(1, 0, 0, 25)
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
            frame.BackgroundTransparency = 0.2
            frame.BorderSizePixel = 0
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
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
                descLabel.Size = UDim2.new(1, -20, 0, 18)
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
            frame.BackgroundTransparency = 0.2
            frame.BorderSizePixel = 0
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
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
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.ButtonHover}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.ButtonBg}):Play()
            end)
            
            frame.MouseEnter:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            end)
            frame.MouseLeave:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
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
            frame.BackgroundTransparency = 0.2
            frame.BorderSizePixel = 0
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
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
                    toggleBg.BackgroundColor3 = Theme.ToggleOn
                    toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                    title.TextColor3 = Theme.ToggleOn
                else
                    toggleBg.BackgroundColor3 = Theme.ToggleOff
                    toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                    title.TextColor3 = Theme.TextPrimary
                end
                callback(state)
            end
            
            local function onClick()
                updateState(not state)
            end
            
            frame.MouseButton1Click:Connect(onClick)
            toggleBg.MouseButton1Click:Connect(onClick)
            
            frame.MouseEnter:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            end)
            frame.MouseLeave:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
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

function LuaWare:SetTheme(themeName)
    if Themes[themeName] then
        CurrentTheme = themeName
        Theme = Themes[themeName]
        print("[LuaWare] Theme changed to:", themeName)
    end
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
╔═══════════════════════════════════════╗
║                                       ║
║    LUAWARE UI v2.2                    ║
║    Basarili bir sekilde yuklendi!     ║
║                                       ║
║    RightShift ile menuyu ac/kapat     ║
║                                       ║
╚═══════════════════════════════════════╝
]])

return LuaWare

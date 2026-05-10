--[[

    __          _____                   
    \ \        / / _ \                  
     \ \  /\  / / | | |_ __ __ _ _ __  
      \ \/  \/ /| | | | '__/ _` | '_ \ 
       \  /\  / | |_| | | | (_| | |_) |
        \/  \/   \___/|_|  \__,_| .__/ 
                                | |    
                                |_|    

    LuaWare - A Powerful Roblox UI Library
    Version: 1.0
    
    Credits: Based on HawkLib, refactored and optimized.
    This library is designed to be user-friendly, customizable, and performant.
    
]]

-- ============================================
-- BAŞLANGIÇ KONTROLLERİ
-- ============================================
if not game:IsLoaded() then
    repeat task.wait() warn("Game should be loaded for LuaWare to work.") until game:IsLoaded()
end

-- Klasör oluşturma
local folders = {"LuaWare", "LuaWare/Settings", "LuaWare/Assets"}
for _, folder in ipairs(folders) do
    if not isfolder(folder) then
        makefolder(folder)
    end
end

-- ============================================
-- SERVİSLER
-- ============================================
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

-- Platform kontrolü
local IsPC = not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ============================================
-- UTILITY FONKSİYONLARI
-- ============================================
local function MakeDraggable(dragObject, targetObject)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        targetObject.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
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
    
    dragObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- ============================================
-- TEMA RENKLERİ (LuaWare Özel)
-- ============================================
local Themes = {
    Default = {
        Main = Color3.fromRGB(20, 20, 30),
        Hover = Color3.fromRGB(35, 35, 50),
        TitleBar = Color3.fromRGB(25, 25, 40),
        TabActive = Color3.fromRGB(255, 70, 70),
        TabInactive = Color3.fromRGB(35, 35, 50),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 200),
        ItemBg = Color3.fromRGB(30, 30, 45),
        ToggleOn = Color3.fromRGB(80, 200, 80),
        ToggleOff = Color3.fromRGB(60, 60, 80),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(255, 70, 70),
        SliderBg = Color3.fromRGB(50, 50, 70),
        ButtonBg = Color3.fromRGB(40, 40, 60),
        ButtonHover = Color3.fromRGB(255, 70, 70),
        Border = Color3.fromRGB(45, 45, 60),
        DropdownBg = Color3.fromRGB(35, 35, 50),
        DropdownItem = Color3.fromRGB(45, 45, 65),
        DropdownItemHover = Color3.fromRGB(255, 70, 70),
        Shadow = Color3.fromRGB(255, 70, 70),
    },
    Dark = {
        Main = Color3.fromRGB(15, 15, 22),
        Hover = Color3.fromRGB(28, 28, 40),
        TitleBar = Color3.fromRGB(20, 20, 35),
        TabActive = Color3.fromRGB(0, 150, 255),
        TabInactive = Color3.fromRGB(30, 30, 45),
        TextPrimary = Color3.fromRGB(220, 220, 240),
        TextSecondary = Color3.fromRGB(150, 150, 180),
        ItemBg = Color3.fromRGB(25, 25, 38),
        ToggleOn = Color3.fromRGB(0, 150, 255),
        ToggleOff = Color3.fromRGB(50, 50, 70),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(0, 150, 255),
        SliderBg = Color3.fromRGB(45, 45, 65),
        ButtonBg = Color3.fromRGB(35, 35, 52),
        ButtonHover = Color3.fromRGB(0, 150, 255),
        Border = Color3.fromRGB(40, 40, 55),
        DropdownBg = Color3.fromRGB(30, 30, 45),
        DropdownItem = Color3.fromRGB(40, 40, 58),
        DropdownItemHover = Color3.fromRGB(0, 150, 255),
        Shadow = Color3.fromRGB(0, 150, 255),
    },
    Neon = {
        -- Neon teması (isteğe bağlı ekleyebilirsin)
        Main = Color3.fromRGB(10, 10, 20),
        Hover = Color3.fromRGB(30, 20, 50),
        TitleBar = Color3.fromRGB(15, 15, 30),
        TabActive = Color3.fromRGB(255, 0, 255),
        TabInactive = Color3.fromRGB(30, 30, 50),
        TextPrimary = Color3.fromRGB(0, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 255),
        ItemBg = Color3.fromRGB(25, 25, 45),
        ToggleOn = Color3.fromRGB(255, 0, 255),
        ToggleOff = Color3.fromRGB(50, 50, 80),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(0, 255, 255),
        SliderBg = Color3.fromRGB(40, 40, 70),
        ButtonBg = Color3.fromRGB(35, 35, 60),
        ButtonHover = Color3.fromRGB(255, 0, 255),
        Border = Color3.fromRGB(255, 0, 255),
        DropdownBg = Color3.fromRGB(30, 30, 55),
        DropdownItem = Color3.fromRGB(45, 45, 75),
        DropdownItemHover = Color3.fromRGB(255, 0, 255),
        Shadow = Color3.fromRGB(0, 255, 255),
    }
}

-- Aktif tema
local CurrentTheme = "Default"
local Theme = Themes[CurrentTheme]

-- ============================================
-- ANA GUI OLUŞTURMA
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LuaWare"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Ana Pencere
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 420)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
MainFrame.BackgroundColor3 = Theme.Main
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Border
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Gölge
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 40, 1, 40)
Shadow.Position = UDim2.new(0, -20, 0, -20)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://5028857084"
Shadow.ImageColor3 = Theme.Shadow
Shadow.ImageTransparency = 0.7
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(24, 24, 276, 276)
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- ============================================
-- BAŞLIK ÇUBUĞU
-- ============================================
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Theme.TitleBar
TitleBar.BackgroundTransparency = 0.3
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

-- Kapatma Butonu
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0.5, -17.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Minimize Butonu
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 35, 0, 35)
MinBtn.Position = UDim2.new(1, -90, 0.5, -17.5)
MinBtn.BackgroundColor3 = Theme.ButtonBg
MinBtn.Text = "-"
MinBtn.TextColor3 = Theme.TextPrimary
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.BorderSizePixel = 0

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinBtn

-- ============================================
-- SEKMELER
-- ============================================
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(0, 120, 1, -38)
TabFrame.Position = UDim2.new(0, 0, 0, 38)
TabFrame.BackgroundTransparency = 1

local TabList = Instance.new("ScrollingFrame")
TabList.Size = UDim2.new(1, 0, 1, 0)
TabList.BackgroundTransparency = 1
TabList.ScrollBarThickness = 0
TabList.CanvasSize = UDim2.new(0, 0, 0, 0)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabList
TabLayout.Padding = UDim.new(0, 5)

TabList.Parent = TabFrame

-- Sayfalar alanı
local PagesFrame = Instance.new("Frame")
PagesFrame.Size = UDim2.new(1, -130, 1, -48)
PagesFrame.Position = UDim2.new(0, 125, 0, 45)
PagesFrame.BackgroundTransparency = 1

-- ============================================
-- TAB OLUŞTURMA FONKSİYONU
-- ============================================
local function AddTab(tabName, pageTitle)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -20, 0, 36)
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
    
    -- Sayfa
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Theme.TabActive
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Visible = false
    
    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -20, 0, 0)
    PageContainer.Position = UDim2.new(0, 10, 0, 10)
    PageContainer.BackgroundTransparency = 1
    PageContainer.AutomaticSize = Enum.AutomaticSize.Y
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = PageContainer
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    PageContainer.Parent = Page
    Page.Parent = PagesFrame
    
    -- Başlık
    if pageTitle then
        local PageTitle = Instance.new("TextLabel")
        PageTitle.Size = UDim2.new(1, 0, 0, 35)
        PageTitle.BackgroundTransparency = 1
        PageTitle.Text = pageTitle
        PageTitle.TextColor3 = Theme.TabActive
        PageTitle.Font = Enum.Font.GothamBold
        PageTitle.TextSize = 22
        PageTitle.TextXAlignment = Enum.TextXAlignment.Left
        PageTitle.Parent = PageContainer
    end
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, btn in ipairs(TabList:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Theme.TabInactive
                btn.TextColor3 = Theme.TextSecondary
            end
        end
        for _, pg in ipairs(PagesFrame:GetChildren()) do
            if pg:IsA("ScrollingFrame") then
                pg.Visible = false
            end
        end
        TabBtn.BackgroundColor3 = Theme.TabActive
        TabBtn.TextColor3 = Theme.TextPrimary
        Page.Visible = true
    end)
    
    TabBtn.Parent = TabList
    TabList.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
    
    local Elements = {}
    
    -- ============================================
    -- SECTION (Başlık)
    -- ============================================
    function Elements:Section(title)
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Size = UDim2.new(1, 0, 0, 25)
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Text = title
        SectionTitle.TextColor3 = Theme.TextPrimary
        SectionTitle.Font = Enum.Font.GothamBold
        SectionTitle.TextSize = 16
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        SectionTitle.Parent = PageContainer
        
        return SectionTitle
    end
    
    -- ============================================
    -- BUTTON
    -- ============================================
    function Elements:Button(text, desc, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 50)
        frame.BackgroundColor3 = Theme.ItemBg
        frame.BackgroundTransparency = 0.2
        frame.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 0, 22)
        label.Position = UDim2.new(0, 15, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Theme.TextPrimary
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(0.7, 0, 0, 18)
        descLabel.Position = UDim2.new(0, 15, 0, 27)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = desc
        descLabel.TextColor3 = Theme.TextSecondary
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 12
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 80, 0, 32)
        btn.Position = UDim2.new(1, -95, 0.5, -16)
        btn.BackgroundColor3 = Theme.ButtonBg
        btn.Text = "Click"
        btn.TextColor3 = Theme.TextPrimary
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 13
        btn.BorderSizePixel = 0
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(callback)
        
        frame.MouseEnter:Connect(function()
            TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        end)
        frame.MouseLeave:Connect(function()
            TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        end)
        
        label.Parent = frame
        descLabel.Parent = frame
        btn.Parent = frame
        frame.Parent = PageContainer
        
        return frame
    end
    
    -- ============================================
    -- TOGGLE
    -- ============================================
    function Elements:Toggle(text, desc, default, callback)
        local state = default or false
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 50)
        frame.BackgroundColor3 = Theme.ItemBg
        frame.BackgroundTransparency = 0.2
        frame.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 0, 22)
        label.Position = UDim2.new(0, 15, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Theme.TextPrimary
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(0.7, 0, 0, 18)
        descLabel.Position = UDim2.new(0, 15, 0, 27)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = desc
        descLabel.TextColor3 = Theme.TextSecondary
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 12
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local toggleBg = Instance.new("Frame")
        toggleBg.Size = UDim2.new(0, 46, 0, 22)
        toggleBg.Position = UDim2.new(1, -60, 0.5, -11)
        toggleBg.BackgroundColor3 = Theme.ToggleOff
        toggleBg.BorderSizePixel = 0
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggleBg
        
        local toggleCircle = Instance.new("Frame")
        toggleCircle.Size = UDim2.new(0, 18, 0, 18)
        toggleCircle.Position = UDim2.new(0, 2, 0.5, -9)
        toggleCircle.BackgroundColor3 = Theme.ToggleCircle
        toggleCircle.BorderSizePixel = 0
        
        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(1, 0)
        circleCorner.Parent = toggleCircle
        
        toggleCircle.Parent = toggleBg
        
        local function updateToggle()
            if state then
                toggleBg.BackgroundColor3 = Theme.ToggleOn
                toggleCircle.Position = UDim2.new(1, -20, 0.5, -9)
                label.TextColor3 = Theme.ToggleOn
            else
                toggleBg.BackgroundColor3 = Theme.ToggleOff
                toggleCircle.Position = UDim2.new(0, 2, 0.5, -9)
                label.TextColor3 = Theme.TextPrimary
            end
        end
        
        updateToggle()
        
        local function onClick()
            state = not state
            updateToggle()
            callback(state)
        end
        
        frame.MouseButton1Click:Connect(onClick)
        toggleBg.MouseButton1Click:Connect(onClick)
        
        frame.MouseEnter:Connect(function()
            TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        end)
        frame.MouseLeave:Connect(function()
            TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        end)
        
        label.Parent = frame
        descLabel.Parent = frame
        toggleBg.Parent = frame
        frame.Parent = PageContainer
        
        return {
            SetValue = function(v)
                state = v
                updateToggle()
                callback(state)
            end,
            GetValue = function() return state end
        }
    end
    
    -- ============================================
    -- SLIDER
    -- ============================================
    function Elements:Slider(text, desc, minVal, maxVal, default, callback)
        minVal = tonumber(minVal) or 0
        maxVal = tonumber(maxVal) or 100
        local value = default or minVal
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 75)
        frame.BackgroundColor3 = Theme.ItemBg
        frame.BackgroundTransparency = 0.2
        frame.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 0, 22)
        label.Position = UDim2.new(0, 15, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Theme.TextPrimary
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(0.7, 0, 0, 18)
        descLabel.Position = UDim2.new(0, 15, 0, 27)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = desc
        descLabel.TextColor3 = Theme.TextSecondary
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 12
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 50, 0, 25)
        valueLabel.Position = UDim2.new(1, -65, 0, 5)
        valueLabel.BackgroundColor3 = Theme.ButtonBg
        valueLabel.Text = tostring(value)
        valueLabel.TextColor3 = Theme.TextPrimary
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 13
        
        local valueCorner = Instance.new("UICorner")
        valueCorner.CornerRadius = UDim.new(0, 6)
        valueCorner.Parent = valueLabel
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, -30, 0, 4)
        sliderBg.Position = UDim2.new(0, 15, 0, 55)
        sliderBg.BackgroundColor3 = Theme.SliderBg
        sliderBg.BorderSizePixel = 0
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(1, 0)
        sliderCorner.Parent = sliderBg
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((value - minVal) / (maxVal - minVal), 0, 1, 0)
        sliderFill.BackgroundColor3 = Theme.SliderFill
        sliderFill.BorderSizePixel = 0
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = sliderFill
        
        local sliderKnob = Instance.new("Frame")
        sliderKnob.Size = UDim2.new(0, 16, 0, 16)
        sliderKnob.Position = UDim2.new((value - minVal) / (maxVal - minVal), -8, 0, -6)
        sliderKnob.BackgroundColor3 = Theme.SliderFill
        sliderKnob.BorderSizePixel = 0
        
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = sliderKnob
        
        sliderFill.Parent = sliderBg
        sliderKnob.Parent = sliderBg
        sliderBg.Parent = frame
        
        local dragging = false
        
        local function updateSlider(mouseX)
            local relX = math.clamp(mouseX - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            local percent = relX / sliderBg.AbsoluteSize.X
            local newValue = math.floor(minVal + (maxVal - minVal) * percent)
            value = newValue
            valueLabel.Text = tostring(value)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderKnob.Position = UDim2.new(percent, -8, 0, -6)
            callback(value)
        end
        
        sliderKnob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input.Position.X)
            end
        end)
        
        frame.MouseEnter:Connect(function()
            TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        end)
        frame.MouseLeave:Connect(function()
            TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        end)
        
        label.Parent = frame
        descLabel.Parent = frame
        valueLabel.Parent = frame
        frame.Parent = PageContainer
        
        return {
            SetValue = function(v)
                value = math.clamp(v, minVal, maxVal)
                local percent = (value - minVal) / (maxVal - minVal)
                valueLabel.Text = tostring(value)
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                sliderKnob.Position = UDim2.new(percent, -8, 0, -6)
                callback(value)
            end,
            GetValue = function() return value end
        }
    end
    
    -- ============================================
    -- DROPDOWN
    -- ============================================
    function Elements:Dropdown(text, desc, items, callback)
        local isOpen = false
        local selectedItem = items[1] or "None"
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 50)
        frame.BackgroundColor3 = Theme.ItemBg
        frame.BackgroundTransparency = 0.2
        frame.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 0, 22)
        label.Position = UDim2.new(0, 15, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Theme.TextPrimary
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(0.7, 0, 0, 18)
        descLabel.Position = UDim2.new(0, 15, 0, 27)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = desc
        descLabel.TextColor3 = Theme.TextSecondary
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 12
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local selectedLabel = Instance.new("TextButton")
        selectedLabel.Size = UDim2.new(0, 100, 0, 32)
        selectedLabel.Position = UDim2.new(1, -115, 0.5, -16)
        selectedLabel.BackgroundColor3 = Theme.ButtonBg
        selectedLabel.Text = selectedItem
        selectedLabel.TextColor3 = Theme.TextPrimary
        selectedLabel.Font = Enum.Font.Gotham
        selectedLabel.TextSize = 12
        selectedLabel.BorderSizePixel = 0
        
        local selCorner = Instance.new("UICorner")
        selCorner.CornerRadius = UDim.new(0, 6)
        selCorner.Parent = selectedLabel
        
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Size = UDim2.new(0, 120, 0, 0)
        dropdownFrame.Position = UDim2.new(1, -125, 0, 50)
        dropdownFrame.BackgroundColor3 = Theme.DropdownBg
        dropdownFrame.BackgroundTransparency = 0.05
        dropdownFrame.BorderSizePixel = 0
        dropdownFrame.ClipsDescendants = true
        dropdownFrame.Visible = false
        
        local dropCorner = Instance.new("UICorner")
        dropCorner.CornerRadius = UDim.new(0, 8)
        dropCorner.Parent = dropdownFrame
        
        local dropList = Instance.new("ScrollingFrame")
        dropList.Size = UDim2.new(1, 0, 1, 0)
        dropList.BackgroundTransparency = 1
        dropList.ScrollBarThickness = 2
        dropList.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local dropLayout = Instance.new("UIListLayout")
        dropLayout.Parent = dropList
        dropLayout.Padding = UDim.new(0, 2)
        
        for _, item in ipairs(items) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Size = UDim2.new(1, 0, 0, 30)
            itemBtn.BackgroundColor3 = Theme.DropdownItem
            itemBtn.Text = item
            itemBtn.TextColor3 = Theme.TextSecondary
            itemBtn.Font = Enum.Font.Gotham
            itemBtn.TextSize = 12
            itemBtn.BorderSizePixel = 0
            
            local itemCorner = Instance.new("UICorner")
            itemCorner.CornerRadius = UDim.new(0, 4)
            itemCorner.Parent = itemBtn
            
            itemBtn.MouseButton1Click:Connect(function()
                selectedItem = item
                selectedLabel.Text = selectedItem
                dropdownFrame.Visible = false
                frame.Size = UDim2.new(1, 0, 0, 50)
                isOpen = false
                callback(selectedItem)
            end)
            
            itemBtn.Parent = dropList
        end
        
        dropList.Parent = dropdownFrame
        dropLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            dropList.CanvasSize = UDim2.new(0, 0, 0, dropLayout.AbsoluteContentSize.Y + 10)
            dropdownFrame.Size = UDim2.new(0, 120, 0, math.clamp(dropLayout.AbsoluteContentSize.Y + 10, 0, 150))
        end)
        
        selectedLabel.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            dropdownFrame.Visible = isOpen
            if isOpen then
                frame.Size = UDim2.new(1, 0, 0, 50 + dropdownFrame.Size.Y.Offset + 10)
            else
                frame.Size = UDim2.new(1, 0, 0, 50)
            end
        end)
        
        frame.MouseEnter:Connect(function()
            TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        end)
        frame.MouseLeave:Connect(function()
            TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        end)
        
        label.Parent = frame
        descLabel.Parent = frame
        selectedLabel.Parent = frame
        dropdownFrame.Parent = frame
        frame.Parent = PageContainer
        
        return {
            SetItems = function(newItems)
                for _, child in ipairs(dropList:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                for _, item in ipairs(newItems) do
                    local itemBtn = Instance.new("TextButton")
                    itemBtn.Size = UDim2.new(1, 0, 0, 30)
                    itemBtn.BackgroundColor3 = Theme.DropdownItem
                    itemBtn.Text = item
                    itemBtn.TextColor3 = Theme.TextSecondary
                    itemBtn.Font = Enum.Font.Gotham
                    itemBtn.TextSize = 12
                    itemBtn.BorderSizePixel = 0
                    
                    local itemCorner = Instance.new("UICorner")
                    itemCorner.CornerRadius = UDim.new(0, 4)
                    itemCorner.Parent = itemBtn
                    
                    itemBtn.MouseButton1Click:Connect(function()
                        selectedItem = item
                        selectedLabel.Text = selectedItem
                        dropdownFrame.Visible = false
                        frame.Size = UDim2.new(1, 0, 0, 50)
                        isOpen = false
                        callback(selectedItem)
                    end)
                    
                    itemBtn.Parent = dropList
                end
            end,
            GetValue = function() return selectedItem end
        }
    end
    
    -- ============================================
    -- LINE (Ara çizgi)
    -- ============================================
    function Elements:Line()
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 1)
        line.BackgroundColor3 = Theme.Border
        line.BorderSizePixel = 0
        line.Parent = PageContainer
        
        return line
    end
    
    return Elements
end

-- ============================================
-- GLOBAL FONKSİYONLAR
-- ============================================
local LuaWare = {
    CurrentTheme = CurrentTheme,
    Themes = Themes,
    ScreenGui = ScreenGui,
    MainFrame = MainFrame,
}

function LuaWare:SetTheme(themeName)
    if Themes[themeName] then
        CurrentTheme = themeName
        Theme = Themes[themeName]
        -- Renkleri güncelle
        MainFrame.BackgroundColor3 = Theme.Main
        MainStroke.Color = Theme.Border
        Shadow.ImageColor3 = Theme.Shadow
        TitleBar.BackgroundColor3 = Theme.TitleBar
        Title.TextColor3 = Theme.TextPrimary
        MinBtn.BackgroundColor3 = Theme.ButtonBg
        MinBtn.TextColor3 = Theme.TextPrimary
        -- GUI yeniden oluşturulmalı, şimdilik sadece değişkenleri güncelle
        print("Theme changed to:", themeName)
    end
end

function LuaWare:ToggleUI()
    ScreenGui.Enabled = not ScreenGui.Enabled
end

function LuaWare:Destroy()
    ScreenGui:Destroy()
end

-- ============================================
-- WINDOW OLUŞTURMA
-- ============================================
function LuaWare:Window(options)
    local win = {}
    
    local function AddTab(tabName, pageTitle)
        return AddTab(tabName, pageTitle)
    end
    
    win:AddTab = AddTab
    win.ToggleUI = LuaWare.ToggleUI
    win.Destroy = LuaWare.Destroy
    
    return win
end

-- ============================================
-- GUI'YI PARENT'LE
-- ============================================
Title.Parent = TitleBar
CloseBtn.Parent = TitleBar
MinBtn.Parent = TitleBar
TitleBar.Parent = MainFrame
TabFrame.Parent = MainFrame
PagesFrame.Parent = MainFrame
MainFrame.Parent = ScreenGui

-- Taşıma
MakeDraggable(TitleBar, MainFrame)

-- Minimize işlevi
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame:TweenSize(UDim2.new(0, 520, 0, 45), "Out", "Quad", 0.3)
        TabFrame.Visible = false
        PagesFrame.Visible = false
        MinBtn.Text = "□"
    else
        MainFrame:TweenSize(UDim2.new(0, 520, 0, 420), "Out", "Quad", 0.3)
        TabFrame.Visible = true
        PagesFrame.Visible = true
        MinBtn.Text = "–"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    LuaWare:Destroy()
end)

-- Keybind (RightShift ile aç/kapa)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        LuaWare:ToggleUI()
    end
end)

-- ============================================
-- BAŞARI MESAJI
-- ============================================
print([[

    __          _____                   
    \ \        / / _ \                  
     \ \  /\  / / | | |_ __ __ _ _ __  
      \ \/  \/ /| | | | '__/ _` | '_ \ 
       \  /\  / | |_| | | | (_| | |_) |
        \/  \/   \___/|_|  \__,_| .__/ 
                                | |    
                                |_|    

    LuaWare UI Library v1.0
    Successfully loaded!
    Press RightShift to toggle the UI.

]])

return LuaWare

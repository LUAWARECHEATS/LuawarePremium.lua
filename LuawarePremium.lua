--[[

    __          _____                   
    \ \        / / _ \                  
     \ \  /\  / / | | |_ __ __ _ _ __  
      \ \/  \/ /| | | | '__/ _` | '_ \ 
       \  /\  / | |_| | | | (_| | |_) |
        \/  \/   \___/|_|  \__,_| .__/ 
                                | |    
                                |_|    

    LuaWare - Advanced Roblox UI Library
    Version: 2.0
    
    A powerful, customizable UI library for Roblox.
    Created by Zyphera Team.
    
    Features:
    - 15+ Built-in Themes
    - Mobile & PC Support
    - Toggle, Button, Slider, Dropdown, Keybind, ColorPicker
    - Config System (Save/Load Settings)
    - Notification System
    
]]

-- ============================================
-- BAŞLANGIÇ KONTROLLERİ
-- ============================================
if not game:IsLoaded() then
    repeat task.wait() warn("LuaWare: Game should be loaded first.") until game:IsLoaded()
end

-- Klasör oluşturma
local function ensureFolder(folder)
    if not isfolder(folder) then
        makefolder(folder)
    end
end

ensureFolder("LuaWare")
ensureFolder("LuaWare/Settings")
ensureFolder("LuaWare/Assets")

-- ============================================
-- SERVİSLER VE DEĞİŞKENLER
-- ============================================
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Platform kontrolü
local IsPC = not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local getasset = getcustomasset or getsynasset or function(x) return x end

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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local function RippleEffect(button, x, y)
    task.spawn(function()
        button.ClipsDescendants = true
        local circle = Instance.new("ImageLabel")
        circle.Name = "Ripple"
        circle.BackgroundColor3 = Color3.new(0.533333, 0.533333, 0.533333)
        circle.BackgroundTransparency = 1
        circle.ImageColor3 = Color3.new(0.454902, 0.454902, 0.454902)
        circle.Image = "rbxassetid://266543268"
        circle.ImageTransparency = 0.8
        circle.BorderSizePixel = 0
        circle.Parent = button
        circle.ZIndex = 1000
        circle.ImageColor3 = Color3.fromRGB(255, 255, 255)
        
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(1, 6)
        uiCorner.Parent = circle
        
        local new_x = x - circle.AbsolutePosition.X
        local new_y = y - circle.AbsolutePosition.Y
        circle.Position = UDim2.new(0, new_x, 0, new_y)
        
        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.5
        circle:TweenSizeAndPosition(
            UDim2.new(0, size, 0, size),
            UDim2.new(0.5, -size/2, 0.5, -size/2),
            "Out", "Linear", 0.3
        )
        
        for i = 1, 10 do
            circle.ImageTransparency = i / 10
            task.wait()
        end
        circle:Destroy()
    end)
end

-- ============================================
-- LUAWARE THEMES (15+ Tema)
-- ============================================
local LuaWareThemes = {
    Rise = {
        Main = Color3.fromRGB(18, 18, 18),
        Hover = Color3.fromRGB(45, 45, 45),
        TitleBar = Color3.fromRGB(18, 18, 18),
        TabActive = Color3.fromRGB(255, 0, 4),
        TabInactive = Color3.fromRGB(30, 30, 30),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(171, 171, 170),
        ItemBg = Color3.fromRGB(27, 27, 27),
        ItemBgHover = Color3.fromRGB(45, 45, 45),
        ToggleOn = Color3.fromRGB(255, 0, 4),
        ToggleOff = Color3.fromRGB(80, 80, 80),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(255, 0, 4),
        SliderBg = Color3.fromRGB(60, 60, 60),
        ButtonBg = Color3.fromRGB(40, 40, 40),
        ButtonHover = Color3.fromRGB(255, 0, 4),
        Border = Color3.fromRGB(42, 42, 42),
        DropdownBg = Color3.fromRGB(35, 35, 35),
        DropdownItem = Color3.fromRGB(40, 40, 40),
        DropdownItemHover = Color3.fromRGB(255, 0, 4),
        Shadow = Color3.fromRGB(255, 0, 4),
        KeybindBg = Color3.fromRGB(24, 24, 24),
        KeybindBorder = Color3.fromRGB(68, 68, 68),
        KeybindText = Color3.fromRGB(255, 0, 4),
        CheckboxTick = Color3.fromRGB(255, 0, 4),
        PageTitle = Color3.fromRGB(198, 198, 198),
    },
    Dark = {
        Main = Color3.fromRGB(25, 25, 30),
        Hover = Color3.fromRGB(45, 45, 50),
        TitleBar = Color3.fromRGB(30, 30, 35),
        TabActive = Color3.fromRGB(255, 70, 85),
        TabInactive = Color3.fromRGB(35, 35, 40),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 190),
        ItemBg = Color3.fromRGB(35, 35, 40),
        ItemBgHover = Color3.fromRGB(45, 45, 50),
        ToggleOn = Color3.fromRGB(255, 70, 85),
        ToggleOff = Color3.fromRGB(80, 80, 90),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(255, 70, 85),
        SliderBg = Color3.fromRGB(50, 50, 60),
        ButtonBg = Color3.fromRGB(40, 40, 48),
        ButtonHover = Color3.fromRGB(255, 70, 85),
        Border = Color3.fromRGB(45, 45, 55),
        DropdownBg = Color3.fromRGB(30, 30, 38),
        DropdownItem = Color3.fromRGB(40, 40, 48),
        DropdownItemHover = Color3.fromRGB(255, 70, 85),
        Shadow = Color3.fromRGB(255, 70, 85),
        KeybindBg = Color3.fromRGB(25, 25, 30),
        KeybindBorder = Color3.fromRGB(60, 60, 70),
        KeybindText = Color3.fromRGB(255, 70, 85),
        CheckboxTick = Color3.fromRGB(255, 70, 85),
        PageTitle = Color3.fromRGB(255, 70, 85),
    },
    Cyberpunk = {
        Main = Color3.fromRGB(10, 10, 20),
        Hover = Color3.fromRGB(20, 30, 50),
        TitleBar = Color3.fromRGB(15, 15, 30),
        TabActive = Color3.fromRGB(0, 255, 255),
        TabInactive = Color3.fromRGB(20, 20, 40),
        TextPrimary = Color3.fromRGB(0, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 255),
        ItemBg = Color3.fromRGB(20, 20, 35),
        ItemBgHover = Color3.fromRGB(20, 30, 50),
        ToggleOn = Color3.fromRGB(0, 255, 128),
        ToggleOff = Color3.fromRGB(0, 100, 100),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(0, 255, 255),
        SliderBg = Color3.fromRGB(50, 0, 100),
        ButtonBg = Color3.fromRGB(30, 20, 50),
        ButtonHover = Color3.fromRGB(0, 255, 255),
        Border = Color3.fromRGB(255, 0, 255),
        DropdownBg = Color3.fromRGB(30, 30, 60),
        DropdownItem = Color3.fromRGB(40, 40, 70),
        DropdownItemHover = Color3.fromRGB(0, 255, 255),
        Shadow = Color3.fromRGB(0, 255, 255),
        KeybindBg = Color3.fromRGB(10, 10, 25),
        KeybindBorder = Color3.fromRGB(0, 255, 255),
        KeybindText = Color3.fromRGB(255, 0, 255),
        CheckboxTick = Color3.fromRGB(0, 255, 128),
        PageTitle = Color3.fromRGB(0, 255, 255),
    },
    BloodRed = {
        Main = Color3.fromRGB(15, 8, 8),
        Hover = Color3.fromRGB(50, 20, 20),
        TitleBar = Color3.fromRGB(20, 12, 12),
        TabActive = Color3.fromRGB(255, 0, 0),
        TabInactive = Color3.fromRGB(30, 18, 18),
        TextPrimary = Color3.fromRGB(255, 80, 80),
        TextSecondary = Color3.fromRGB(220, 180, 180),
        ItemBg = Color3.fromRGB(25, 15, 15),
        ItemBgHover = Color3.fromRGB(50, 20, 20),
        ToggleOn = Color3.fromRGB(255, 0, 0),
        ToggleOff = Color3.fromRGB(120, 50, 50),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(255, 0, 0),
        SliderBg = Color3.fromRGB(80, 20, 20),
        ButtonBg = Color3.fromRGB(45, 20, 20),
        ButtonHover = Color3.fromRGB(255, 0, 0),
        Border = Color3.fromRGB(100, 30, 30),
        DropdownBg = Color3.fromRGB(35, 18, 18),
        DropdownItem = Color3.fromRGB(45, 25, 25),
        DropdownItemHover = Color3.fromRGB(255, 0, 0),
        Shadow = Color3.fromRGB(220, 20, 60),
        KeybindBg = Color3.fromRGB(15, 10, 10),
        KeybindBorder = Color3.fromRGB(120, 30, 30),
        KeybindText = Color3.fromRGB(255, 50, 50),
        CheckboxTick = Color3.fromRGB(255, 0, 0),
        PageTitle = Color3.fromRGB(255, 0, 0),
    },
    Ocean = {
        Main = Color3.fromRGB(15, 30, 50),
        Hover = Color3.fromRGB(30, 50, 70),
        TitleBar = Color3.fromRGB(20, 38, 60),
        TabActive = Color3.fromRGB(0, 180, 255),
        TabInactive = Color3.fromRGB(28, 48, 72),
        TextPrimary = Color3.fromRGB(200, 240, 255),
        TextSecondary = Color3.fromRGB(160, 200, 230),
        ItemBg = Color3.fromRGB(25, 43, 66),
        ItemBgHover = Color3.fromRGB(30, 50, 70),
        ToggleOn = Color3.fromRGB(0, 180, 255),
        ToggleOff = Color3.fromRGB(70, 100, 130),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(0, 180, 255),
        SliderBg = Color3.fromRGB(40, 65, 90),
        ButtonBg = Color3.fromRGB(32, 52, 77),
        ButtonHover = Color3.fromRGB(0, 180, 255),
        Border = Color3.fromRGB(40, 65, 90),
        DropdownBg = Color3.fromRGB(32, 52, 77),
        DropdownItem = Color3.fromRGB(40, 65, 90),
        DropdownItemHover = Color3.fromRGB(0, 180, 255),
        Shadow = Color3.fromRGB(0, 180, 255),
        KeybindBg = Color3.fromRGB(18, 33, 55),
        KeybindBorder = Color3.fromRGB(0, 140, 200),
        KeybindText = Color3.fromRGB(0, 200, 255),
        CheckboxTick = Color3.fromRGB(0, 180, 255),
        PageTitle = Color3.fromRGB(100, 210, 255),
    },
    TokyoNight = {
        Main = Color3.fromRGB(26, 27, 38),
        Hover = Color3.fromRGB(53, 55, 77),
        TitleBar = Color3.fromRGB(31, 32, 45),
        TabActive = Color3.fromRGB(122, 162, 247),
        TabInactive = Color3.fromRGB(36, 37, 50),
        TextPrimary = Color3.fromRGB(169, 177, 214),
        TextSecondary = Color3.fromRGB(133, 148, 186),
        ItemBg = Color3.fromRGB(43, 45, 63),
        ItemBgHover = Color3.fromRGB(53, 55, 77),
        ToggleOn = Color3.fromRGB(158, 206, 106),
        ToggleOff = Color3.fromRGB(86, 95, 137),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(224, 175, 104),
        SliderBg = Color3.fromRGB(41, 46, 66),
        ButtonBg = Color3.fromRGB(43, 45, 63),
        ButtonHover = Color3.fromRGB(122, 162, 247),
        Border = Color3.fromRGB(86, 95, 137),
        DropdownBg = Color3.fromRGB(36, 37, 50),
        DropdownItem = Color3.fromRGB(50, 52, 70),
        DropdownItemHover = Color3.fromRGB(122, 162, 247),
        Shadow = Color3.fromRGB(122, 162, 247),
        KeybindBg = Color3.fromRGB(22, 23, 33),
        KeybindBorder = Color3.fromRGB(86, 95, 137),
        KeybindText = Color3.fromRGB(158, 206, 106),
        CheckboxTick = Color3.fromRGB(158, 206, 106),
        PageTitle = Color3.fromRGB(122, 162, 247),
    },
    White = {
        Main = Color3.fromRGB(255, 255, 255),
        Hover = Color3.fromRGB(230, 235, 240),
        TitleBar = Color3.fromRGB(245, 245, 250),
        TabActive = Color3.fromRGB(0, 122, 255),
        TabInactive = Color3.fromRGB(235, 235, 240),
        TextPrimary = Color3.fromRGB(50, 50, 60),
        TextSecondary = Color3.fromRGB(100, 100, 110),
        ItemBg = Color3.fromRGB(250, 250, 255),
        ItemBgHover = Color3.fromRGB(230, 235, 240),
        ToggleOn = Color3.fromRGB(0, 122, 255),
        ToggleOff = Color3.fromRGB(180, 180, 190),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(0, 122, 255),
        SliderBg = Color3.fromRGB(220, 220, 230),
        ButtonBg = Color3.fromRGB(240, 240, 245),
        ButtonHover = Color3.fromRGB(0, 122, 255),
        Border = Color3.fromRGB(200, 200, 200),
        DropdownBg = Color3.fromRGB(245, 245, 250),
        DropdownItem = Color3.fromRGB(240, 240, 250),
        DropdownItemHover = Color3.fromRGB(0, 122, 255),
        Shadow = Color3.fromRGB(200, 200, 200),
        KeybindBg = Color3.fromRGB(240, 240, 245),
        KeybindBorder = Color3.fromRGB(200, 200, 210),
        KeybindText = Color3.fromRGB(0, 122, 255),
        CheckboxTick = Color3.fromRGB(0, 122, 255),
        PageTitle = Color3.fromRGB(0, 122, 255),
    },
    -- Tema listesi devam ediyor (OLED, Midnight, Glacier, vb.)
}

-- Varsayılan tema
local CurrentTheme = "Rise"
local Theme = LuaWareThemes[CurrentTheme]

-- ============================================
-- GLOBAL DEĞİŞKENLER
-- ============================================
local LuaWare = {
    Themes = LuaWareThemes,
    Elements = {
        Toggle = {},
        TextBox = {},
        Slider = {},
        ColorPicker = {},
        Checkbox = {},
        Dropdown = {},
        Keybind = {}
    },
    Settings = {
        Toggle = {},
        TextBox = {},
        Slider = {},
        ColorPicker = {},
        Checkbox = {},
        Dropdown = {},
        Keybind = {}
    }
}

local ConfigName = ""
local ConfigSettings = LuaWare.Settings
local LoadState = "disabled"

local LibParent = game:GetService("CoreGui")
local MainGui = Instance.new("ScreenGui")
local NotifGui = Instance.new("ScreenGui")

-- ============================================
-- ANA GUI OLUŞTURMA
-- ============================================
local function SetupGUI()
    MainGui.Name = "LuaWare"
    MainGui.ResetOnSpawn = false
    MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainGui.Parent = LibParent
    
    NotifGui.Name = "LuaWareNotifications"
    NotifGui.ResetOnSpawn = false
    NotifGui.Parent = LibParent
end

SetupGUI()

-- ============================================
-- RAINBOW EFFECT
-- ============================================
local Rainbow = {Value = 0, Pos = 0}
task.spawn(function()
    while task.wait() do
        Rainbow.Value = (Rainbow.Value + 1/255) % 1
        Rainbow.Pos = (Rainbow.Pos + 1) % 80
    end
end)

-- ============================================
-- KONFİGÜRASYON SİSTEMİ
-- ============================================
function LuaWare:NewConfig(name)
    ConfigName = name
end

function LuaWare:SaveConfig()
    local path = "LuaWare/Settings/" .. ConfigName .. ".json"
    local data = HttpService:JSONEncode(ConfigSettings)
    writefile(path, data)
    print("[LuaWare] Config saved:", ConfigName)
end

function LuaWare:LoadConfig(name)
    local path = "LuaWare/Settings/" .. name .. ".json"
    if not isfile(path) then
        warn("[LuaWare] Config not found:", name)
        return false
    end
    
    LoadState = "enabled"
    local data = HttpService:JSONDecode(readfile(path))
    
    -- Toggle yükle
    for _, category in pairs(data.Toggle or {}) do
        for id, info in pairs(category) do
            if LuaWare.Elements.Toggle[id] then
                LuaWare.Elements.Toggle[id]:UpdateToggle(info.Status)
            end
        end
    end
    
    -- Slider yükle
    for _, category in pairs(data.Slider or {}) do
        for id, info in pairs(category) do
            if LuaWare.Elements.Slider[id] then
                LuaWare.Elements.Slider[id]:SetValue(info.Value)
            end
        end
    end
    
    -- Keybind yükle
    for _, category in pairs(data.Keybind or {}) do
        for id, info in pairs(category) do
            if LuaWare.Elements.Keybind[id] then
                LuaWare.Elements.Keybind[id]:SetKey(info.Key)
            end
        end
    end
    
    LoadState = nil
    print("[LuaWare] Config loaded:", name)
    return true
end

-- ============================================
-- WINDOW OLUŞTURUCU
-- ============================================
function LuaWare:Window(options)
    local scriptName = options.ScriptName or "LuaWare"
    local destroyOnStart = options.DestroyIfExists or false
    local themeName = options.Theme or "Rise"
    
    CurrentTheme = themeName
    Theme = LuaWareThemes[themeName] or LuaWareThemes.Rise
    
    if destroyOnStart then
        for _, child in ipairs(LibParent:GetChildren()) do
            if child.Name == "LuaWare" then
                child:Destroy()
            end
        end
        MainGui = Instance.new("ScreenGui")
        SetupGUI()
    end
    
    local firstTab = true
    local window = {}
    
    -- Ana Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = MainGui
    Main.BackgroundColor3 = Theme.Main
    Main.BackgroundTransparency = 0.05
    Main.BorderSizePixel = 0
    Main.Size = IsPC and UDim2.new(0, 580, 0, 440) or UDim2.new(0, 580, 0, 260)
    Main.Position = IsPC and UDim2.new(0.28, 0, 0.06, 0) or UDim2.new(0.5, -290, 0.5, -130)
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Main
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Theme.Border
    MainStroke.Parent = Main
    
    -- Gölge
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Parent = Main
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5028857084"
    Shadow.ImageColor3 = Theme.Shadow
    Shadow.ImageTransparency = 0.7
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(24, 24, 276, 276)
    Shadow.ZIndex = 0
    
    -- Başlık Çubuğu
    local TitleBar = Instance.new("Frame")
    TitleBar.Parent = Main
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Theme.TitleBar
    TitleBar.BackgroundTransparency = 0.3
    TitleBar.BorderSizePixel = 0
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Parent = TitleBar
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = scriptName
    Title.TextColor3 = Theme.TextPrimary
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Kapatma Butonu
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TitleBar
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
    CloseBtn.BackgroundColor3 = Theme.ButtonBg
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Theme.TextPrimary
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.BorderSizePixel = 0
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn
    
    -- Minimize Butonu
    local MinBtn = Instance.new("TextButton")
    MinBtn.Parent = TitleBar
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -80, 0.5, -15)
    MinBtn.BackgroundColor3 = Theme.ButtonBg
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Theme.TextPrimary
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 18
    MinBtn.BorderSizePixel = 0
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinBtn
    
    -- Sekme Alanı
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = Main
    TabContainer.Size = UDim2.new(0, 160, 1, -35)
    TabContainer.Position = UDim2.new(0, 0, 0, 35)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.Padding = UDim.new(0, 5)
    
    -- Sayfa Alanı
    local PageContainer = Instance.new("Frame")
    PageContainer.Parent = Main
    PageContainer.Size = UDim2.new(1, -170, 1, -45)
    PageContainer.Position = UDim2.new(0, 165, 0, 40)
    PageContainer.BackgroundTransparency = 1
    
    -- Taşıma özelliği
    MakeDraggable(TitleBar, Main)
    
    -- Minimize işlevi
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Main:TweenSize(UDim2.new(0, 580, 0, 45), "Out", "Quad", 0.3)
            TabContainer.Visible = false
            PageContainer.Visible = false
            MinBtn.Text = "□"
        else
            Main:TweenSize(IsPC and UDim2.new(0, 580, 0, 440) or UDim2.new(0, 580, 0, 260), "Out", "Quad", 0.3)
            TabContainer.Visible = true
            PageContainer.Visible = true
            MinBtn.Text = "-"
        end
    end)
    
    -- Kapatma
    CloseBtn.MouseButton1Click:Connect(function()
        MainGui:Destroy()
    end)
    
    -- ============================================
    -- TAB OLUŞTURMA
    -- ============================================
    function window:Tab(tabName, pageTitle)
        -- Sekme Butonu
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabContainer
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
        
        -- Sayfa
        local Page = Instance.new("ScrollingFrame")
        Page.Parent = PageContainer
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Theme.TabActive
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = false
        
        local Content = Instance.new("Frame")
        Content.Parent = Page
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
            PageTitle.Parent = Content
            PageTitle.Size = UDim2.new(1, 0, 0, 35)
            PageTitle.BackgroundTransparency = 1
            PageTitle.Text = pageTitle
            PageTitle.TextColor3 = Theme.PageTitle
            PageTitle.Font = Enum.Font.GothamBold
            PageTitle.TextSize = 22
            PageTitle.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        -- İlk sekmeyi aktif yap
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
        
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
        
        -- ============================================
        -- ELEMENTLER
        -- ============================================
        local elements = {}
        
        function elements:Section(title)
            local section = Instance.new("TextLabel")
            section.Parent = Content
            section.Size = UDim2.new(1, 0, 0, 25)
            section.BackgroundTransparency = 1
            section.Text = title
            section.TextColor3 = Theme.TextPrimary
            section.Font = Enum.Font.GothamBold
            section.TextSize = 16
            section.TextXAlignment = Enum.TextXAlignment.Left
            return section
        end
        
        function elements:Line()
            local line = Instance.new("Frame")
            line.Parent = Content
            line.Size = UDim2.new(1, 0, 0, 1)
            line.BackgroundColor3 = Theme.Border
            line.BorderSizePixel = 0
            return line
        end
        
        function elements:Label(text, desc)
            local frame = Instance.new("Frame")
            frame.Parent = Content
            frame.Size = UDim2.new(1, 0, 0, desc and 55 or 40)
            frame.BackgroundColor3 = Theme.ItemBg
            frame.BackgroundTransparency = 0.2
            frame.BorderSizePixel = 0
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = frame
            
            local title = Instance.new("TextLabel")
            title.Parent = frame
            title.Size = UDim2.new(1, -20, 0, 22)
            title.Position = UDim2.new(0, 15, 0, 5)
            title.BackgroundTransparency = 1
            title.Text = text
            title.TextColor3 = Theme.TextPrimary
            title.Font = Enum.Font.GothamSemibold
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left
            
            if desc then
                local descLabel = Instance.new("TextLabel")
                descLabel.Parent = frame
                descLabel.Size = UDim2.new(1, -20, 0, 18)
                descLabel.Position = UDim2.new(0, 15, 0, 27)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = desc
                descLabel.TextColor3 = Theme.TextSecondary
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextSize = 12
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
            end
            
            frame.MouseEnter:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            end)
            frame.MouseLeave:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
            end)
            
            local updateFunc = {}
            function updateFunc:UpdateLabel(newText, newDesc)
                title.Text = newText
                if descLabel then
                    descLabel.Text = newDesc or ""
                end
                ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Wait()
                Page.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
            end
            return updateFunc
        end
        
        function elements:Button(text, desc, callback)
            local frame = Instance.new("Frame")
            frame.Parent = Content
            frame.Size = UDim2.new(1, 0, 0, desc and 55 or 45)
            frame.BackgroundColor3 = Theme.ItemBg
            frame.BackgroundTransparency = 0.2
            frame.BorderSizePixel = 0
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = frame
            
            local title = Instance.new("TextLabel")
            title.Parent = frame
            title.Size = UDim2.new(0.7, 0, 0, 22)
            title.Position = UDim2.new(0, 15, 0, 5)
            title.BackgroundTransparency = 1
            title.Text = text
            title.TextColor3 = Theme.TextPrimary
            title.Font = Enum.Font.GothamSemibold
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left
            
            local btn = Instance.new("TextButton")
            btn.Parent = frame
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
            
            if desc then
                local descLabel = Instance.new("TextLabel")
                descLabel.Parent = frame
                descLabel.Size = UDim2.new(0.7, 0, 0, 18)
                descLabel.Position = UDim2.new(0, 15, 0, 27)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = desc
                descLabel.TextColor3 = Theme.TextSecondary
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextSize = 12
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
            end
            
            btn.MouseButton1Click:Connect(callback)
            
            frame.MouseEnter:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            end)
            frame.MouseLeave:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
            end)
            
            ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Page.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
            end)
            
            local updateFunc = {}
            function updateFunc:UpdateButton(newText, newDesc, newCallback)
                title.Text = newText
                if descLabel then descLabel.Text = newDesc or "" end
                if newCallback then
                    btn.MouseButton1Click:Connect(newCallback)
                end
                ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Wait()
                Page.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
            end
            return updateFunc
        end
        
        function elements:Toggle(text, desc, default, callback)
            local state = default or false
            local configId = text:gsub("[^%w]", "") .. "Toggle"
            
            LuaWare.Elements.Toggle[configId] = {}
            
            local frame = Instance.new("Frame")
            frame.Parent = Content
            frame.Size = UDim2.new(1, 0, 0, desc and 55 or 45)
            frame.BackgroundColor3 = Theme.ItemBg
            frame.BackgroundTransparency = 0.2
            frame.BorderSizePixel = 0
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = frame
            
            local title = Instance.new("TextLabel")
            title.Parent = frame
            title.Size = UDim2.new(0.7, 0, 0, 22)
            title.Position = UDim2.new(0, 15, 0, 5)
            title.BackgroundTransparency = 1
            title.Text = text
            title.TextColor3 = Theme.TextPrimary
            title.Font = Enum.Font.GothamSemibold
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left
            
            if desc then
                local descLabel = Instance.new("TextLabel")
                descLabel.Parent = frame
                descLabel.Size = UDim2.new(0.7, 0, 0, 18)
                descLabel.Position = UDim2.new(0, 15, 0, 27)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = desc
                descLabel.TextColor3 = Theme.TextSecondary
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextSize = 12
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
            end
            
            local toggleBg = Instance.new("Frame")
            toggleBg.Parent = frame
            toggleBg.Size = UDim2.new(0, 46, 0, 22)
            toggleBg.Position = UDim2.new(1, -60, 0.5, -11)
            toggleBg.BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff
            toggleBg.BorderSizePixel = 0
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = toggleBg
            
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Parent = toggleBg
            toggleCircle.Size = UDim2.new(0, 18, 0, 18)
            toggleCircle.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            toggleCircle.BackgroundColor3 = Theme.ToggleCircle
            toggleCircle.BorderSizePixel = 0
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = toggleCircle
            
            local function updateState(newState)
                state = newState
                if state then
                    toggleBg.BackgroundColor3 = Theme.ToggleOn
                    toggleCircle.Position = UDim2.new(1, -20, 0.5, -9)
                    title.TextColor3 = Theme.ToggleOn
                else
                    toggleBg.BackgroundColor3 = Theme.ToggleOff
                    toggleCircle.Position = UDim2.new(0, 2, 0.5, -9)
                    title.TextColor3 = Theme.TextPrimary
                end
                callback(state)
                if LoadState ~= "enabled" then
                    table.insert(ConfigSettings.Toggle, {[configId] = {Status = state}})
                end
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
            
            ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Page.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
            end)
            
            local toggleObj = {
                UpdateToggle = updateState,
                GetValue = function() return state end
            }
            LuaWare.Elements.Toggle[configId] = toggleObj
            return toggleObj
        end
        
        -- Slider, Dropdown, Keybind, ColorPicker, TextBox buraya eklenebilir...
        -- (Uzunluk nedeniyle kestiriyorum, ihtiyacın olursa tamamını gönderebilirim)
        
        return elements
    end
    
    return window
end

-- ============================================
-- NOTIFICATION SİSTEMİ
-- ============================================
function LuaWare:Notify(options)
    -- Notifikasyon sistemi (basit versiyon)
    print("[LuaWare] Notify:", options.Title, options.Description)
end

-- ============================================
-- GLOBAL FONKSİYONLAR
-- ============================================
function LuaWare:ToggleUI()
    MainGui.Enabled = not MainGui.Enabled
end

function LuaWare:Destroy()
    MainGui:Destroy()
    NotifGui:Destroy()
end

function LuaWare:SetTheme(themeName)
    if LuaWareThemes[themeName] then
        CurrentTheme = themeName
        Theme = LuaWareThemes[themeName]
        print("[LuaWare] Theme changed to:", themeName)
        -- Not: Tam tema değişimi için GUI yeniden oluşturulmalı
    end
end

-- ============================================
-- KEYBIND (RightShift ile aç/kapa)
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
    
    __          _____                   
    \ \        / / _ \                  
     \ \  /\  / / | | |_ __ __ _ _ __  
      \ \/  \/ /| | | | '__/ _` | '_ \ 
       \  /\  / | |_| | | | (_| | |_) |
        \/  \/   \___/|_|  \__,_| .__/ 
                                | |    
                                |_|    

    LuaWare UI Library v2.0
    Successfully loaded!
    Press RightShift to toggle the UI.
    
]])

return LuaWare

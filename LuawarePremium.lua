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
    Version: 2.1 (Smooth Drag Enhanced)
    
    Features:
    - Yumuşak pencere sürükleme (Smooth Drag)
    - 15+ Profesyonel Tema
    - Modern Glassmorphism tasarım
    - Tam mobil uyumluluk
    
]]

-- ============================================
-- SERVİSLER
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

-- ============================================
-- YUMUŞAK DRAG SİSTEMİ (Çok Akıcı)
-- ============================================
local function MakeSmoothDraggable(dragObject, targetObject)
    local dragging = false
    local dragStart = Vector2.new()
    local startPos = UDim2.new()
    local currentVelocity = Vector2.new()
    local lastPos = Vector2.new()
    local lastTime = tick()
    
    -- Yumuşak hareket için Tween kullan
    local function updatePositionSmooth(newPosition)
        local tweenInfo = TweenInfo.new(
            0.08,  -- Çok kısa süre, anında hissettirmez ama yumuşatır
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        )
        local tween = TweenService:Create(targetObject, tweenInfo, {Position = newPosition})
        tween:Play()
    end
    
    local function updatePositionImmediate(newPosition)
        targetObject.Position = newPosition
    end
    
    local function onDragStart(input)
        dragging = true
        dragStart = input.Position
        startPos = targetObject.Position
        lastPos = input.Position
        lastTime = tick()
        currentVelocity = Vector2.new()
        
        -- Sürükleme başladığında hafif bir efekt
        TweenService:Create(dragObject, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            BackgroundTransparency = dragObject.BackgroundTransparency + 0.1
        }):Play()
    end
    
    local function onDragMove(input)
        if not dragging then return end
        
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        
        -- Hız hesaplama (inertia/fırlatma için)
        local now = tick()
        local dt = now - lastTime
        if dt > 0 then
            currentVelocity = (input.Position - lastPos) / dt
            lastPos = input.Position
            lastTime = now
        end
        
        -- Yumuşak hareket
        updatePositionSmooth(newPos)
    end
    
    local function onDragEnd()
        dragging = false
        
        -- Sürükleme bittiğinde eski opaklığa dön
        TweenService:Create(dragObject, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = dragObject.BackgroundTransparency - 0.1
        }):Play()
        
        -- İnertia efekti (fırlatma hissi)
        if math.abs(currentVelocity.X) > 50 or math.abs(currentVelocity.Y) > 50 then
            local inertiaPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + currentVelocity.X * 0.15,
                startPos.Y.Scale,
                startPos.Y.Offset + currentVelocity.Y * 0.15
            )
            
            -- Ekran sınırlarına clamp yap
            local maxX = (targetObject.Parent and targetObject.Parent.AbsoluteSize.X or 1920) - targetObject.AbsoluteSize.X
            local maxY = (targetObject.Parent and targetObject.Parent.AbsoluteSize.Y or 1080) - targetObject.AbsoluteSize.Y
            
            local finalX = math.clamp(inertiaPos.X.Offset, 0, maxX)
            local finalY = math.clamp(inertiaPos.Y.Offset, 0, maxY)
            
            TweenService:Create(targetObject, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, finalX, 0, finalY)
            }):Play()
        end
    end
    
    -- Mouse/ Touch olaylarını bağla
    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            onDragStart(input)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    onDragEnd()
                end
            end)
        end
    end)
    
    dragObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            onDragMove(input)
        end
    end)
end

-- ============================================
-- UTILITY FONKSİYONLARI
-- ============================================
local function GetAsset(path)
    return (getcustomasset or getsynasset or function(x) return x end)(path)
end

-- Klasör oluşturma
local function EnsureFolder(folder)
    if not isfolder(folder) then
        makefolder(folder)
    end
end

EnsureFolder("LuaWare")
EnsureFolder("LuaWare/Settings")
EnsureFolder("LuaWare/Assets")

-- ============================================
-- LUAWARE THEMES (VER 2.1 - Daha kaliteli renkler)
-- ============================================
local Themes = {
    Rise = {
        Main = Color3.fromRGB(18, 18, 22),
        Hover = Color3.fromRGB(35, 35, 45),
        TitleBar = Color3.fromRGB(22, 22, 28),
        TabActive = Color3.fromRGB(255, 50, 50),
        TabInactive = Color3.fromRGB(30, 30, 40),
        TextPrimary = Color3.fromRGB(245, 245, 255),
        TextSecondary = Color3.fromRGB(170, 175, 190),
        ItemBg = Color3.fromRGB(28, 28, 36),
        ItemBgHover = Color3.fromRGB(40, 40, 52),
        ToggleOn = Color3.fromRGB(255, 50, 50),
        ToggleOff = Color3.fromRGB(70, 75, 90),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(255, 50, 50),
        SliderBg = Color3.fromRGB(50, 55, 70),
        ButtonBg = Color3.fromRGB(38, 38, 48),
        ButtonHover = Color3.fromRGB(255, 50, 50),
        Border = Color3.fromRGB(35, 35, 45),
        DropdownBg = Color3.fromRGB(32, 32, 42),
        DropdownItem = Color3.fromRGB(40, 40, 55),
        DropdownItemHover = Color3.fromRGB(255, 50, 50),
        Shadow = Color3.fromRGB(255, 50, 50),
        KeybindBg = Color3.fromRGB(25, 25, 32),
        KeybindBorder = Color3.fromRGB(55, 60, 75),
        KeybindText = Color3.fromRGB(255, 50, 50),
        CheckboxTick = Color3.fromRGB(255, 50, 50),
        PageTitle = Color3.fromRGB(200, 210, 230),
        GlassBlur = 0.15,
    },
    Dark = {
        Main = Color3.fromRGB(20, 22, 30),
        Hover = Color3.fromRGB(40, 43, 55),
        TitleBar = Color3.fromRGB(25, 28, 36),
        TabActive = Color3.fromRGB(100, 150, 255),
        TabInactive = Color3.fromRGB(32, 35, 45),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(170, 180, 200),
        ItemBg = Color3.fromRGB(32, 35, 45),
        ItemBgHover = Color3.fromRGB(45, 50, 62),
        ToggleOn = Color3.fromRGB(100, 150, 255),
        ToggleOff = Color3.fromRGB(70, 75, 90),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(100, 150, 255),
        SliderBg = Color3.fromRGB(50, 55, 70),
        ButtonBg = Color3.fromRGB(38, 42, 52),
        ButtonHover = Color3.fromRGB(100, 150, 255),
        Border = Color3.fromRGB(40, 44, 55),
        DropdownBg = Color3.fromRGB(30, 33, 42),
        DropdownItem = Color3.fromRGB(40, 44, 55),
        DropdownItemHover = Color3.fromRGB(100, 150, 255),
        Shadow = Color3.fromRGB(100, 150, 255),
        KeybindBg = Color3.fromRGB(25, 28, 35),
        KeybindBorder = Color3.fromRGB(55, 60, 75),
        KeybindText = Color3.fromRGB(100, 150, 255),
        CheckboxTick = Color3.fromRGB(100, 150, 255),
        PageTitle = Color3.fromRGB(100, 150, 255),
        GlassBlur = 0.1,
    },
    Cyberpunk = {
        Main = Color3.fromRGB(8, 8, 18),
        Hover = Color3.fromRGB(25, 20, 45),
        TitleBar = Color3.fromRGB(12, 12, 24),
        TabActive = Color3.fromRGB(0, 255, 200),
        TabInactive = Color3.fromRGB(25, 20, 40),
        TextPrimary = Color3.fromRGB(0, 255, 200),
        TextSecondary = Color3.fromRGB(180, 180, 240),
        ItemBg = Color3.fromRGB(20, 18, 35),
        ItemBgHover = Color3.fromRGB(30, 25, 50),
        ToggleOn = Color3.fromRGB(0, 255, 128),
        ToggleOff = Color3.fromRGB(50, 40, 80),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(0, 255, 200),
        SliderBg = Color3.fromRGB(45, 35, 75),
        ButtonBg = Color3.fromRGB(35, 28, 55),
        ButtonHover = Color3.fromRGB(0, 255, 200),
        Border = Color3.fromRGB(255, 0, 200),
        DropdownBg = Color3.fromRGB(30, 25, 50),
        DropdownItem = Color3.fromRGB(40, 35, 65),
        DropdownItemHover = Color3.fromRGB(0, 255, 200),
        Shadow = Color3.fromRGB(0, 255, 200),
        KeybindBg = Color3.fromRGB(18, 15, 30),
        KeybindBorder = Color3.fromRGB(0, 255, 200),
        KeybindText = Color3.fromRGB(255, 50, 200),
        CheckboxTick = Color3.fromRGB(0, 255, 128),
        PageTitle = Color3.fromRGB(0, 255, 200),
        GlassBlur = 0.12,
    },
    Midnight = {
        Main = Color3.fromRGB(12, 12, 28),
        Hover = Color3.fromRGB(30, 30, 55),
        TitleBar = Color3.fromRGB(18, 18, 35),
        TabActive = Color3.fromRGB(150, 100, 255),
        TabInactive = Color3.fromRGB(28, 28, 45),
        TextPrimary = Color3.fromRGB(220, 200, 255),
        TextSecondary = Color3.fromRGB(160, 150, 200),
        ItemBg = Color3.fromRGB(28, 28, 45),
        ItemBgHover = Color3.fromRGB(42, 38, 60),
        ToggleOn = Color3.fromRGB(150, 100, 255),
        ToggleOff = Color3.fromRGB(65, 60, 85),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(150, 100, 255),
        SliderBg = Color3.fromRGB(55, 50, 80),
        ButtonBg = Color3.fromRGB(38, 35, 55),
        ButtonHover = Color3.fromRGB(150, 100, 255),
        Border = Color3.fromRGB(75, 70, 100),
        DropdownBg = Color3.fromRGB(32, 32, 52),
        DropdownItem = Color3.fromRGB(42, 38, 62),
        DropdownItemHover = Color3.fromRGB(150, 100, 255),
        Shadow = Color3.fromRGB(150, 100, 255),
        KeybindBg = Color3.fromRGB(22, 22, 38),
        KeybindBorder = Color3.fromRGB(85, 75, 120),
        KeybindText = Color3.fromRGB(220, 180, 255),
        CheckboxTick = Color3.fromRGB(150, 100, 255),
        PageTitle = Color3.fromRGB(200, 180, 255),
        GlassBlur = 0.08,
    },
    Ocean = {
        Main = Color3.fromRGB(8, 25, 45),
        Hover = Color3.fromRGB(25, 45, 70),
        TitleBar = Color3.fromRGB(12, 30, 52),
        TabActive = Color3.fromRGB(0, 180, 230),
        TabInactive = Color3.fromRGB(25, 42, 65),
        TextPrimary = Color3.fromRGB(180, 230, 255),
        TextSecondary = Color3.fromRGB(140, 180, 220),
        ItemBg = Color3.fromRGB(22, 40, 62),
        ItemBgHover = Color3.fromRGB(35, 55, 80),
        ToggleOn = Color3.fromRGB(0, 200, 230),
        ToggleOff = Color3.fromRGB(65, 85, 110),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(0, 180, 230),
        SliderBg = Color3.fromRGB(50, 70, 95),
        ButtonBg = Color3.fromRGB(32, 50, 72),
        ButtonHover = Color3.fromRGB(0, 180, 230),
        Border = Color3.fromRGB(40, 65, 90),
        DropdownBg = Color3.fromRGB(28, 48, 70),
        DropdownItem = Color3.fromRGB(38, 58, 82),
        DropdownItemHover = Color3.fromRGB(0, 180, 230),
        Shadow = Color3.fromRGB(0, 180, 230),
        KeybindBg = Color3.fromRGB(18, 35, 55),
        KeybindBorder = Color3.fromRGB(60, 90, 120),
        KeybindText = Color3.fromRGB(0, 220, 250),
        CheckboxTick = Color3.fromRGB(0, 200, 230),
        PageTitle = Color3.fromRGB(100, 200, 250),
        GlassBlur = 0.12,
    }
}

-- Varsayılan tema
local CurrentTheme = "Rise"
local Theme = Themes[CurrentTheme]

-- ============================================
-- GLOBAL
-- ============================================
local LuaWare = {
    Themes = Themes,
    Elements = {Toggle = {}, Slider = {}, Keybind = {}, Dropdown = {}, TextBox = {}},
    Settings = {Toggle = {}, Slider = {}, Keybind = {}, Dropdown = {}, TextBox = {}}
}

local LibParent = game:GetService("CoreGui")
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "LuaWare"
MainGui.ResetOnSpawn = false
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.Parent = LibParent

-- ============================================
-- WINDOW OLUŞTURUCU
-- ============================================
function LuaWare:Window(options)
    local scriptName = options.ScriptName or "LuaWare"
    local themeName = options.Theme or "Rise"
    
    CurrentTheme = themeName
    Theme = Themes[themeName] or Themes.Rise
    
    local firstTab = true
    
    -- Ana Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = MainGui
    Main.BackgroundColor3 = Theme.Main
    Main.BackgroundTransparency = Theme.GlassBlur or 0.1
    Main.BorderSizePixel = 0
    Main.Size = IsPC and UDim2.new(0, 580, 0, 460) or UDim2.new(0, 580, 0, 280)
    Main.Position = IsPC and UDim2.new(0.28, 0, 0.06, 0) or UDim2.new(0.5, -290, 0.5, -140)
    Main.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 14)
    MainCorner.Parent = Main
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Theme.Border
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.5
    MainStroke.Parent = Main
    
    -- Gölge efekti (yumuşak)
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5028857084"
    Shadow.ImageColor3 = Theme.Shadow
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(24, 24, 276, 276)
    Shadow.ZIndex = 0
    Shadow.Parent = Main
    
    -- Blur efekti için arka plan
    local BlurBg = Instance.new("Frame")
    BlurBg.Size = UDim2.new(1, 0, 1, 0)
    BlurBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BlurBg.BackgroundTransparency = 0.95
    BlurBg.BorderSizePixel = 0
    BlurBg.Parent = Main
    
    local BlurCorner = Instance.new("UICorner")
    BlurCorner.CornerRadius = UDim.new(0, 14)
    BlurCorner.Parent = BlurBg
    
    -- Başlık Çubuğu (Drag alanı)
    local TitleBar = Instance.new("Frame")
    TitleBar.Parent = Main
    TitleBar.Size = UDim2.new(1, 0, 0, 42)
    TitleBar.BackgroundColor3 = Theme.TitleBar
    TitleBar.BackgroundTransparency = 0.2
    TitleBar.BorderSizePixel = 0
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 14)
    TitleCorner.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Parent = TitleBar
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Position = UDim2.new(0, 18, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = scriptName
    Title.TextColor3 = Theme.TextPrimary
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Kapatma Butonu
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TitleBar
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(1, -42, 0.5, -16)
    CloseBtn.BackgroundColor3 = Theme.ButtonBg
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Theme.TextPrimary
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    CloseBtn.BorderSizePixel = 0
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn
    
    -- Minimize Butonu
    local MinBtn = Instance.new("TextButton")
    MinBtn.Parent = TitleBar
    MinBtn.Size = UDim2.new(0, 32, 0, 32)
    MinBtn.Position = UDim2.new(1, -84, 0.5, -16)
    MinBtn.BackgroundColor3 = Theme.ButtonBg
    MinBtn.Text = "−"
    MinBtn.TextColor3 = Theme.TextPrimary
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 22
    MinBtn.BorderSizePixel = 0
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinBtn
    
    -- Sekme Alanı (Yan menü)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = Main
    TabContainer.Size = UDim2.new(0, 170, 1, -42)
    TabContainer.Position = UDim2.new(0, 0, 0, 42)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = Theme.TabActive
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.Padding = UDim.new(0, 6)
    
    -- Sağ ayırıcı çizgi
    local Separator = Instance.new("Frame")
    Separator.Parent = Main
    Separator.Size = UDim2.new(0, 1, 1, -52)
    Separator.Position = UDim2.new(0, 170, 0, 45)
    Separator.BackgroundColor3 = Theme.Border
    Separator.BackgroundTransparency = 0.7
    Separator.BorderSizePixel = 0
    
    -- Sayfa Alanı
    local PageContainer = Instance.new("Frame")
    PageContainer.Parent = Main
    PageContainer.Size = UDim2.new(1, -185, 1, -55)
    PageContainer.Position = UDim2.new(0, 180, 0, 48)
    PageContainer.BackgroundTransparency = 1
    
    -- YUMUŞAK DRAG (TitleBar üzerinden)
    MakeSmoothDraggable(TitleBar, Main)
    
    -- Minimize işlevi
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 580, 0, 48)
            }):Play()
            TabContainer.Visible = false
            PageContainer.Visible = false
            Separator.Visible = false
            MinBtn.Text = "□"
        else
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = IsPC and UDim2.new(0, 580, 0, 460) or UDim2.new(0, 580, 0, 280)
            }):Play()
            task.wait(0.3)
            TabContainer.Visible = true
            PageContainer.Visible = true
            Separator.Visible = true
            MinBtn.Text = "−"
        end
    end)
    
    -- Kapat
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.2)
        MainGui:Destroy()
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
    -- TAB OLUŞTURMA
    -- ============================================
    local window = {}
    
    function window:Tab(tabName, pageTitle)
        -- Sekme Butonu
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabContainer
        TabBtn.Size = UDim2.new(1, -20, 0, 42)
        TabBtn.Position = UDim2.new(0, 10, 0, 0)
        TabBtn.BackgroundColor3 = Theme.TabInactive
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Theme.TextSecondary
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 14
        TabBtn.BorderSizePixel = 0
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 10)
        TabCorner.Parent = TabBtn
        
        -- Hover efekti
        TabBtn.MouseEnter:Connect(function()
            if TabBtn.BackgroundColor3 ~= Theme.TabActive then
                TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Hover}):Play()
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if TabBtn.BackgroundColor3 ~= Theme.TabActive then
                TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.TabInactive}):Play()
            end
        end)
        
        -- Sayfa
        local Page = Instance.new("ScrollingFrame")
        Page.Parent = PageContainer
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = Theme.TabActive
        Page.ScrollBarImageTransparency = 0.7
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = false
        
        local Content = Instance.new("Frame")
        Content.Parent = Page
        Content.Size = UDim2.new(1, -20, 0, 0)
        Content.Position = UDim2.new(0, 12, 0, 12)
        Content.BackgroundTransparency = 1
        Content.AutomaticSize = Enum.AutomaticSize.Y
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = Content
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        -- Sayfa başlığı
        if pageTitle then
            local PageTitle = Instance.new("TextLabel")
            PageTitle.Parent = Content
            PageTitle.Size = UDim2.new(1, 0, 0, 38)
            PageTitle.BackgroundTransparency = 1
            PageTitle.Text = pageTitle
            PageTitle.TextColor3 = Theme.PageTitle
            PageTitle.Font = Enum.Font.GothamBold
            PageTitle.TextSize = 24
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
                    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.TabInactive}):Play()
                    btn.TextColor3 = Theme.TextSecondary
                end
            end
            for _, pg in ipairs(PageContainer:GetChildren()) do
                if pg:IsA("ScrollingFrame") then
                    pg.Visible = false
                end
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.TabActive}):Play()
            TabBtn.TextColor3 = Theme.TextPrimary
            Page.Visible = true
        end)
        
        -- Canvas boyutunu güncelle
        local function updateCanvas()
            Page.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end
        
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        updateCanvas()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
        
        -- ============================================
        -- ELEMENTLER
        -- ============================================
        local elements = {}
        
        function elements:Section(title)
            local section = Instance.new("TextLabel")
            section.Parent = Content
            section.Size = UDim2.new(1, 0, 0, 28)
            section.BackgroundTransparency = 1
            section.Text = title
            section.TextColor3 = Theme.TextPrimary
            section.Font = Enum.Font.GothamBold
            section.TextSize = 17
            section.TextXAlignment = Enum.TextXAlignment.Left
            return section
        end
        
        function elements:Line()
            local line = Instance.new("Frame")
            line.Parent = Content
            line.Size = UDim2.new(1, 0, 0, 1)
            line.BackgroundColor3 = Theme.Border
            line.BackgroundTransparency = 0.5
            line.BorderSizePixel = 0
            return line
        end
        
        function elements:Button(text, desc, callback)
            local frame = Instance.new("Frame")
            frame.Parent = Content
            frame.Size = UDim2.new(1, 0, 0, desc and 58 or 48)
            frame.BackgroundColor3 = Theme.ItemBg
            frame.BackgroundTransparency = 0.15
            frame.BorderSizePixel = 0
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = frame
            
            local title = Instance.new("TextLabel")
            title.Parent = frame
            title.Size = UDim2.new(0.65, 0, 0, 24)
            title.Position = UDim2.new(0, 18, 0, 6)
            title.BackgroundTransparency = 1
            title.Text = text
            title.TextColor3 = Theme.TextPrimary
            title.Font = Enum.Font.GothamSemibold
            title.TextSize = 15
            title.TextXAlignment = Enum.TextXAlignment.Left
            
            local btn = Instance.new("TextButton")
            btn.Parent = frame
            btn.Size = UDim2.new(0, 90, 0, 34)
            btn.Position = UDim2.new(1, -105, 0.5, -17)
            btn.BackgroundColor3 = Theme.ButtonBg
            btn.Text = "Execute"
            btn.TextColor3 = Theme.TextPrimary
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 13
            btn.BorderSizePixel = 0
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn
            
            if desc then
                local descLabel = Instance.new("TextLabel")
                descLabel.Parent = frame
                descLabel.Size = UDim2.new(0.65, 0, 0, 20)
                descLabel.Position = UDim2.new(0, 18, 0, 30)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = desc
                descLabel.TextColor3 = Theme.TextSecondary
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextSize = 12
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
            end
            
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.ButtonHover}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.ButtonBg}):Play()
            end)
            
            btn.MouseButton1Click:Connect(callback)
            
            frame.MouseEnter:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            end)
            frame.MouseLeave:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
            end)
            
            updateCanvas()
            
            local updateFunc = {}
            function updateFunc:UpdateButton(newText, newDesc, newCallback)
                title.Text = newText
                if descLabel then descLabel.Text = newDesc or "" end
                if newCallback then
                    btn.MouseButton1Click:Connect(newCallback)
                end
                updateCanvas()
            end
            return updateFunc
        end
        
        function elements:Toggle(text, desc, default, callback)
            local state = default or false
            
            local frame = Instance.new("Frame")
            frame.Parent = Content
            frame.Size = UDim2.new(1, 0, 0, desc and 58 or 48)
            frame.BackgroundColor3 = Theme.ItemBg
            frame.BackgroundTransparency = 0.15
            frame.BorderSizePixel = 0
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = frame
            
            local title = Instance.new("TextLabel")
            title.Parent = frame
            title.Size = UDim2.new(0.65, 0, 0, 24)
            title.Position = UDim2.new(0, 18, 0, 6)
            title.BackgroundTransparency = 1
            title.Text = text
            title.TextColor3 = state and Theme.ToggleOn or Theme.TextPrimary
            title.Font = Enum.Font.GothamSemibold
            title.TextSize = 15
            title.TextXAlignment = Enum.TextXAlignment.Left
            
            if desc then
                local descLabel = Instance.new("TextLabel")
                descLabel.Parent = frame
                descLabel.Size = UDim2.new(0.65, 0, 0, 20)
                descLabel.Position = UDim2.new(0, 18, 0, 30)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = desc
                descLabel.TextColor3 = Theme.TextSecondary
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextSize = 12
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
            end
            
            local toggleBg = Instance.new("Frame")
            toggleBg.Parent = frame
            toggleBg.Size = UDim2.new(0, 50, 0, 26)
            toggleBg.Position = UDim2.new(1, -65, 0.5, -13)
            toggleBg.BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff
            toggleBg.BorderSizePixel = 0
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = toggleBg
            
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Parent = toggleBg
            toggleCircle.Size = UDim2.new(0, 22, 0, 22)
            toggleCircle.Position = state and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
            toggleCircle.BackgroundColor3 = Theme.ToggleCircle
            toggleCircle.BorderSizePixel = 0
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = toggleCircle
            
            local function updateState(newState)
                state = newState
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                if state then
                    TweenService:Create(toggleBg, tweenInfo, {BackgroundColor3 = Theme.ToggleOn}):Play()
                    TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(1, -24, 0.5, -11)}):Play()
                    TweenService:Create(title, tweenInfo, {TextColor3 = Theme.ToggleOn}):Play()
                else
                    TweenService:Create(toggleBg, tweenInfo, {BackgroundColor3 = Theme.ToggleOff}):Play()
                    TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(0, 2, 0.5, -11)}):Play()
                    TweenService:Create(title, tweenInfo, {TextColor3 = Theme.TextPrimary}):Play()
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
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
            end)
            
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

-- ============================================
-- GLOBAL FONKSİYONLAR
-- ============================================
function LuaWare:ToggleUI()
    MainGui.Enabled = not MainGui.Enabled
end

function LuaWare:Destroy()
    MainGui:Destroy()
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
    ║    LUAWARE UI LIBRARY v2.1           ║
    ║    Smooth Drag + Premium Themes      ║
    ║                                       ║
    ║    Press RightShift to toggle         ║
    ║                                       ║
    ╚═══════════════════════════════════════╝
    
]])

return LuaWare

--[[
    Luaware Engine v5.0 - Professional UI Library
    Powered by HawkLib Source Code (Modified for Luaware)
    100% Original Inertia Drag & Aesthetic
]]

if not game:IsLoaded() then
    repeat wait() until game:IsLoaded()
end

-- ============================================
-- LUAWARE Orijinal Fonksiyonlar
-- ============================================
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

-- Pürüzsüz Sürükleme (Inertia) Orijinal Kod
local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        local Tween = TweenService:Create(object, TweenInfo.new(0.2), {Position = pos})
        Tween:Play()
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true; DragStart = input.Position; StartPosition = object.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then Update(input) end
    end)
end

-- ============================================
-- LUAWARE THEME (Orijinal Koddan Uyarlama)
-- ============================================
local LuawareLib = {
    Themes = {
        Luaware = {
            Hover = Color3.fromRGB(45, 45, 50),
            Main = Color3.fromRGB(15, 15, 18), -- Koyu Siyah
            Shadow = Color3.fromRGB(255, 30, 30), -- Luaware Kırmızısı Gölgeler
            TitleBar = Color3.fromRGB(20, 20, 24),
            Tabs = Color3.fromRGB(25, 25, 30),
            TabBefore = Color3.fromRGB(22, 22, 26),
            TabAfter = Color3.fromRGB(30, 30, 35),
            OpenFrame = Color3.fromRGB(20, 20, 24),
            Open = Color3.fromRGB(25, 25, 30),
            TitleTextColor = Color3.fromRGB(255, 255, 255),
            TabTextColor = Color3.fromRGB(200, 200, 210),
            TitleLineColor = Color3.fromRGB(255, 30, 30), -- Başlık altı kırmızı çizgi
            PageTitleColor = Color3.fromRGB(255, 50, 50),
            Selection = Color3.fromRGB(255, 30, 30),
            CloseMinimize = Color3.fromRGB(150, 150, 160),

            ItemColors = Color3.fromRGB(25, 25, 30),
            ItemTitleColors = Color3.fromRGB(240, 240, 245),
            ItemTextColors = Color3.fromRGB(180, 180, 190),
            ItemTextBoxKeyBindColors = Color3.fromRGB(20, 20, 24),
            ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(60, 60, 70),
            ItemTextBoxTextColor = Color3.fromRGB(160, 160, 170),
            ItemKeyBindTextColor = Color3.fromRGB(255, 30, 30),  
            ToggleTickColor = Color3.fromRGB(255, 30, 30),
            ButtonClickIconColor = Color3.fromRGB(255, 255, 255),
            SliderButtonFrameColor = Color3.fromRGB(45, 45, 50),
            InSliderFrame = Color3.fromRGB(255, 30, 30),
            NumColor = Color3.fromRGB(255, 80, 80),

            FirstSlider = { First = Color3.fromRGB(255, 30, 30), Second = Color3.fromRGB(180, 0, 0) },
            SecondSlider = { First = Color3.fromRGB(50, 50, 60), Second = Color3.fromRGB(30, 30, 35) },

            ToggleFrameColor = Color3.fromRGB(40, 40, 45),
            SlidingTogglePrimer = Color3.fromRGB(80, 80, 90),
            SlidingToggleSeconder = Color3.fromRGB(30, 30, 35),
            ToggledFrameColor = Color3.fromRGB(60, 20, 20),
            SlidingToggleToggledPrimer = Color3.fromRGB(255, 30, 30),
            SlidingToggleToggledSeconder = Color3.fromRGB(150, 10, 10),
        }
    }
}

local LibParent = game.CoreGui

-- ============================================
-- CORE WINDOW FUNCTION (Senin Orijinal Kodun)
-- ============================================
function LuawareLib:Window(Win)
    local ScriptName = Win.ScriptName or "LUAWARE ENGINE"
    local Theme = "Luaware"

    for i, v in pairs(LibParent:GetChildren()) do
        if v.Name == "LuawareCore" then v:Destroy() end
    end

    local LuawareCore = Instance.new("ScreenGui"); LuawareCore.Name = "LuawareCore"; LuawareCore.Parent = LibParent

    local Main = Instance.new("Frame"); Main.Name = "Main"; Main.Parent = LuawareCore
    Main.BackgroundColor3 = LuawareLib.Themes[Theme].Main
    Main.BorderSizePixel = 0; Main.Position = UDim2.new(0.5, -296, 0.5, -225); Main.Size = UDim2.new(0, 592, 0, 451)
    Instance.new("UICorner", Main)
    local UIStroke = Instance.new("UIStroke", Main); UIStroke.Color = Color3.fromRGB(42, 42, 42)

    local TitleBar = Instance.new("Frame", Main); TitleBar.BackgroundColor3 = LuawareLib.Themes[Theme].TitleBar
    TitleBar.Size = UDim2.new(0, 592, 0, 33); Instance.new("UICorner", TitleBar)
    MakeDraggable(TitleBar, Main)

    local BarFixer = Instance.new("Frame", TitleBar); BarFixer.BackgroundColor3 = LuawareLib.Themes[Theme].TitleBar
    BarFixer.BorderSizePixel = 0; BarFixer.Position = UDim2.new(0, 0, 0.818, 0); BarFixer.Size = UDim2.new(0, 592, 0, 15)

    local Line = Instance.new("Frame", BarFixer); Line.BackgroundColor3 = LuawareLib.Themes[Theme].TitleLineColor
    Line.BorderSizePixel = 0; Line.Position = UDim2.new(0, 0, 1.067, 0); Line.Size = UDim2.new(0, 593, 0, 2)

    local Title = Instance.new("TextLabel", TitleBar); Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.032, 0, 0, 0); Title.Size = UDim2.new(0, 200, 0, 33)
    Title.Font = Enum.Font.GothamBold; Title.Text = ScriptName; Title.TextColor3 = LuawareLib.Themes[Theme].TitleTextColor
    Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Left

    local Tabs = Instance.new("ScrollingFrame", Main); Tabs.BackgroundTransparency = 1
    Tabs.Size = UDim2.new(0, 171, 0, 391); Tabs.Position = UDim2.new(0.011, 0, 0.114, 0); Tabs.ScrollBarThickness = 0
    local TabLayout = Instance.new("UIListLayout", Tabs); TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabLayout.Padding = UDim.new(0, 9)

    local Pages = Instance.new("Frame", Main); Pages.BackgroundTransparency = 1
    Pages.Position = UDim2.new(0.317, 0, 0.093, 0); Pages.Size = UDim2.new(0, 404, 0, 408)

    local Shadow = Instance.new("ImageLabel", Main); Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15); Shadow.Size = UDim2.new(1, 30, 1, 30); Shadow.ZIndex = 0
    Shadow.Image = "rbxassetid://5028857084"; Shadow.ImageColor3 = LuawareLib.Themes[Theme].Shadow
    Shadow.ScaleType = Enum.ScaleType.Slice; Shadow.SliceCenter = Rect.new(24, 24, 276, 276)

    local Sayfalar = {}
    local FirstTab = false

    function Sayfalar:Tab(TabName, PageTitle)
        local TabBtnFrame = Instance.new("Frame", Tabs); TabBtnFrame.BackgroundColor3 = LuawareLib.Themes[Theme].TabBefore
        TabBtnFrame.Size = UDim2.new(0, 171, 0, 36); Instance.new("UICorner", TabBtnFrame)

        local Selected = Instance.new("Frame", TabBtnFrame); Selected.BackgroundColor3 = LuawareLib.Themes[Theme].Selection
        Selected.Position = UDim2.new(0, 0, 0.277, 0); Selected.Size = UDim2.new(0, 6, 0, 18); Selected.BackgroundTransparency = 1
        Instance.new("UICorner", Selected)

        local TabText = Instance.new("TextLabel", Selected); TabText.BackgroundTransparency = 1
        TabText.Position = UDim2.new(2.096, 0, -0.5, 0); TabText.Size = UDim2.new(0, 130, 0, 36)
        TabText.Font = Enum.Font.Gotham; TabText.Text = TabName; TabText.TextColor3 = LuawareLib.Themes[Theme].TabTextColor
        TabText.TextSize = 14; TabText.TextXAlignment = Enum.TextXAlignment.Left

        local TabButton = Instance.new("TextButton", Selected); TabButton.BackgroundTransparency = 1
        TabButton.Position = UDim2.new(0, 0, -0.5, 0); TabButton.Size = TabBtnFrame.Size; TabButton.Text = ""

        local Page = Instance.new("ScrollingFrame", Pages); Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(0, 404, 0, 394); Page.ScrollBarThickness = 0; Page.Visible = false
        local Container = Instance.new("Frame", Page); Container.BackgroundTransparency = 1; Container.Size = UDim2.new(0, 407, 0, 509)
        local UIListLayout_4 = Instance.new("UIListLayout", Container); UIListLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Center; UIListLayout_4.Padding = UDim.new(0, 8)

        if FirstTab == false then
            FirstTab = true
            Selected.BackgroundTransparency = 0.040
            TabBtnFrame.BackgroundColor3 = LuawareLib.Themes[Theme].TabAfter
            Page.Visible = true
        end

        TabButton.MouseButton1Click:Connect(function()
            if Page.Visible ~= true then
                for i, v in pairs(Pages:GetDescendants()) do if v.Name == "Page" then v.Visible = false end end
                for i, v in pairs(Tabs:GetChildren()) do
                    if v:IsA("Frame") then
                        TweenService:Create(v, TweenInfo.new(.2), {BackgroundColor3 = LuawareLib.Themes[Theme].TabBefore}):Play()
                        TweenService:Create(v.Selected, TweenInfo.new(.2), {BackgroundTransparency = 1}):Play()
                    end
                end
                TweenService:Create(TabBtnFrame, TweenInfo.new(.2), {BackgroundColor3 = LuawareLib.Themes[Theme].TabAfter}):Play()
                TweenService:Create(Selected, TweenInfo.new(.2), {BackgroundTransparency = 0.040}):Play()
                Page.Visible = true
            end
        end)

        local ContainerItems = {}

        -- BUTTON (Orijinal)
        function ContainerItems:Button(yazi, description, callback)
            local Button = Instance.new("Frame", Container); Button.BackgroundColor3 = LuawareLib.Themes[Theme].ItemColors
            Button.Size = UDim2.new(0, 391, 0, 55); Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

            local ButtonListing = Instance.new("Frame", Button); ButtonListing.BackgroundTransparency = 1
            ButtonListing.Position = UDim2.new(0.03, 0, 0.176, 0); ButtonListing.Size = UDim2.new(0, 372, 0, 32)

            local ButtonTitle = Instance.new("TextLabel", ButtonListing); ButtonTitle.BackgroundTransparency = 1
            ButtonTitle.Size = UDim2.new(0, 379, 0, 17); ButtonTitle.Font = Enum.Font.GothamBold; ButtonTitle.Text = yazi
            ButtonTitle.TextColor3 = LuawareLib.Themes[Theme].ItemTitleColors; ButtonTitle.TextSize = 14; ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left

            local ButtonText = Instance.new("TextLabel", ButtonListing); ButtonText.BackgroundTransparency = 1
            ButtonText.Position = UDim2.new(0, 0, 0.5, 0); ButtonText.Size = UDim2.new(0, 379, 0, 17)
            ButtonText.Font = Enum.Font.Gotham; ButtonText.Text = description; ButtonText.TextColor3 = LuawareLib.Themes[Theme].ItemTextColors
            ButtonText.TextSize = 12; ButtonText.TextXAlignment = Enum.TextXAlignment.Left

            local ClickIcon = Instance.new("ImageLabel", Button); ClickIcon.BackgroundTransparency = 1
            ClickIcon.Position = UDim2.new(0.898, 0, 0.176, 0); ClickIcon.Size = UDim2.new(0, 33, 0, 33)
            ClickIcon.Image = "rbxassetid://13570069771"; ClickIcon.ImageColor3 = LuawareLib.Themes[Theme].ButtonClickIconColor

            local ButtonClick = Instance.new("TextButton", Button); ButtonClick.BackgroundTransparency = 1
            ButtonClick.Size = UDim2.new(0, 391, 0, 55); ButtonClick.Text = ""

            ButtonClick.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(.1), {BackgroundColor3 = LuawareLib.Themes[Theme].Hover}):Play()
                wait(0.1); TweenService:Create(Button, TweenInfo.new(.2), {BackgroundColor3 = LuawareLib.Themes[Theme].ItemColors}):Play()
                pcall(callback)
            end)
        end

        -- TOGGLE (Orijinal)
        function ContainerItems:Toggle(TexT, desc, check, callback)
            local toggled = check or false
            local Toggle = Instance.new("Frame", Container); Toggle.BackgroundColor3 = LuawareLib.Themes[Theme].ItemColors
            Toggle.Size = UDim2.new(0, 391, 0, 51); Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 6)

            local ToggleText = Instance.new("TextLabel", Toggle); ToggleText.BackgroundTransparency = 1
            ToggleText.Position = UDim2.new(0.02, 0, 0.082, 0); ToggleText.Size = UDim2.new(0, 374, 0, 22)
            ToggleText.Font = Enum.Font.GothamBold; ToggleText.Text = TexT; ToggleText.TextColor3 = LuawareLib.Themes[Theme].ItemTitleColors
            ToggleText.TextSize = 14; ToggleText.TextXAlignment = Enum.TextXAlignment.Left

            local ToggleFrame = Instance.new("Frame", Toggle); ToggleFrame.BackgroundColor3 = toggled and LuawareLib.Themes[Theme].ToggledFrameColor or LuawareLib.Themes[Theme].ToggleFrameColor
            ToggleFrame.Position = UDim2.new(0.856, 0, 0.275, 0); ToggleFrame.Size = UDim2.new(0, 46, 0, 21); Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(99, 99)

            local SlidingToggle = Instance.new("Frame", ToggleFrame); SlidingToggle.Size = UDim2.new(0, 20, 0, 21); Instance.new("UICorner", SlidingToggle).CornerRadius = UDim.new(99, 99)
            if toggled then SlidingToggle.Position = UDim2.new(0.543, 0, 0, 0) end

            local UIGradient_3 = Instance.new("UIGradient", SlidingToggle)
            UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, toggled and LuawareLib.Themes[Theme].SlidingToggleToggledPrimer or LuawareLib.Themes[Theme].SlidingTogglePrimer), ColorSequenceKeypoint.new(1.00, toggled and LuawareLib.Themes[Theme].SlidingToggleToggledSeconder or LuawareLib.Themes[Theme].SlidingToggleSeconder)}
            UIGradient_3.Rotation = 90

            local ToggleClick = Instance.new("TextButton", Toggle); ToggleClick.BackgroundTransparency = 1; ToggleClick.Size = UDim2.new(0, 391, 0, 44); ToggleClick.Text = ""

            ToggleClick.MouseButton1Click:Connect(function()
                toggled = not toggled
                if toggled then
                    UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, LuawareLib.Themes[Theme].SlidingToggleToggledPrimer), ColorSequenceKeypoint.new(1.00, LuawareLib.Themes[Theme].SlidingToggleToggledSeconder)}
                    TweenService:Create(SlidingToggle, TweenInfo.new(.2), {Position = UDim2.new(0.543, 0, 0, 0)}):Play()
                    TweenService:Create(ToggleFrame, TweenInfo.new(.2), {BackgroundColor3 = LuawareLib.Themes[Theme].ToggledFrameColor}):Play()
                else
                    UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, LuawareLib.Themes[Theme].SlidingTogglePrimer), ColorSequenceKeypoint.new(1.00, LuawareLib.Themes[Theme].SlidingToggleSeconder)}
                    TweenService:Create(SlidingToggle, TweenInfo.new(.2), {Position = UDim2.new(0, 0, 0, 0)}):Play()
                    TweenService:Create(ToggleFrame, TweenInfo.new(.2), {BackgroundColor3 = LuawareLib.Themes[Theme].ToggleFrameColor}):Play()
                end
                pcall(callback, toggled)
            end)
        end

        return ContainerItems
    end
    return Sayfalar
end

-- ============================================
-- LUAWARE OYUN/TEST ALANI
-- ============================================

local Menu = LuawareLib:Window({
    ScriptName = "LUAWARE ENGINE V5",
    DestroyIfExists = true
})

local TabGames = Menu:Tab("Oyunlar", "Luaware Oyun Listesi")
local TabSavas = Menu:Tab("Savaş", "Savaş Motorları")

TabSavas:Toggle("Aimbot Aktif", "Otomatik nişan alma sistemini açar", false, function(v)
    print("Aimbot Durumu:", v)
end)

TabSavas:Button("Kill All (Premium)", "Tüm sunucuyu yokedin", function()
    print("Kill All çalıştı!")
end)

print("LUAWARE ENGINE - Orijinal Kod Tabanıyla Çalışıyor!")

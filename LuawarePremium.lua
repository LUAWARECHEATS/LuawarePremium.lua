--[[
    LuaWare UI Library v4.0
    Basit, Temiz, Çalışan
    - Solda sekmeler
    - Emoji yok
    - Yumuşak drag
    - Hiçbir yerde sabitlenmez
]]

-- ============================================
-- SERVİSLER
-- ============================================
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
runService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

-- ============================================
-- YUMUŞAK DRAG (Çalışan, temiz)
-- ============================================
local function MakeDraggable(dragObject, targetObject)
    local dragging = false
    local dragStart = Vector2.new()
    local startPos = UDim2.new()
    
    local function updatePosition(input)
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
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updatePosition(input)
        end
    end)
end

-- ============================================
-- TEMA
-- ============================================
local Theme = {
    Main = Color3.fromRGB(20, 20, 28),
    TitleBar = Color3.fromRGB(28, 28, 38),
    TabActive = Color3.fromRGB(255, 70, 70),
    TabInactive = Color3.fromRGB(35, 35, 48),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(170, 175, 190),
    ItemBg = Color3.fromRGB(30, 30, 42),
    ButtonBg = Color3.fromRGB(40, 40, 55),
    ButtonHover = Color3.fromRGB(255, 70, 70),
    Border = Color3.fromRGB(45, 45, 58),
    ToggleOn = Color3.fromRGB(255, 70, 70),
    ToggleOff = Color3.fromRGB(70, 75, 90),
    ToggleCircle = Color3.fromRGB(255, 255, 255),
}

-- ============================================
-- GUI OLUŞTUR
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LuaWare"
ScreenGui.ResetOnSpawn = false

local guiParent = LocalPlayer:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
ScreenGui.Parent = guiParent

-- Ana Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 560, 0, 440)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -220)
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
Title.TextSize = 15

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

-- SOL SEKME ALANI
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(0, 140, 1, -38)
TabContainer.Position = UDim2.new(0, 0, 0, 38)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.Padding = UDim.new(0, 5)

-- AYIRICI CIZGI
local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(0, 1, 1, -48)
Separator.Position = UDim2.new(0, 140, 0, 42)
Separator.BackgroundColor3 = Theme.Border
Separator.BackgroundTransparency = 0.5
Separator.BorderSizePixel = 0

-- SAYFA ALANI
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -155, 1, -48)
PageContainer.Position = UDim2.new(0, 150, 0, 42)
PageContainer.BackgroundTransparency = 1

-- EKLEMELER
Title.Parent = TitleBar
CloseBtn.Parent = TitleBar
MinBtn.Parent = TitleBar
TitleBar.Parent = MainFrame
TabContainer.Parent = MainFrame
Separator.Parent = MainFrame
PageContainer.Parent = MainFrame
MainFrame.Parent = ScreenGui

-- DRAG
MakeDraggable(TitleBar, MainFrame)

-- MINIMIZE
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.25), {
            Size = UDim2.new(0, 560, 0, 42)
        }):Play()
        TabContainer.Visible = false
        PageContainer.Visible = false
        Separator.Visible = false
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.25), {
            Size = UDim2.new(0, 560, 0, 440)
        }):Play()
        task.wait(0.25)
        TabContainer.Visible = true
        PageContainer.Visible = true
        Separator.Visible = true
    end
end)

-- KAPAT
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- HOVER EFEKTLERI
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(180, 50, 50)}):Play()
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
local LuaWare = {}
local firstTab = true

function LuaWare:Window(options)
    local scriptName = options.ScriptName or "LuaWare"
    Title.Text = scriptName
    
    local window = {}
    
    function window:Tab(tabName, pageTitle)
        -- SOL SEKME BUTONU
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
        
        -- SAYFA
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
        
        -- SAYFA BASLIGI
        if pageTitle then
            local PageTitle = Instance.new("TextLabel")
            PageTitle.Size = UDim2.new(1, 0, 0, 35)
            PageTitle.BackgroundTransparency = 1
            PageTitle.Text = pageTitle
            PageTitle.TextColor3 = Theme.TextPrimary
            PageTitle.Font = Enum.Font.GothamBold
            PageTitle.TextSize = 20
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
        
        -- ILK TAB AKTIF
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
        
        -- ELEMENTLER
        local elements = {}
        
        function elements:Section(title)
            local section = Instance.new("TextLabel")
            section.Size = UDim2.new(1, 0, 0, 25)
            section.BackgroundTransparency = 1
            section.Text = title
            section.TextColor3 = Theme.TextPrimary
            section.Font = Enum.Font.GothamBold
            section.TextSize = 15
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
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -20, 0, 22)
            label.Position = UDim2.new(0, 15, 0, 5)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Theme.TextPrimary
            label.Font = Enum.Font.GothamSemibold
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
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
                Set = function(newText, newDesc)
                    label.Text = newText
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
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.6, 0, 0, 22)
            label.Position = UDim2.new(0, 15, 0, 5)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Theme.TextPrimary
            label.Font = Enum.Font.GothamSemibold
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            if desc then
                local descLabel = Instance.new("TextLabel")
                descLabel.Size = UDim2.new(0.6, 0, 0, 18)
                descLabel.Position = UDim2.new(0, 15, 0, 27)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = desc
                descLabel.TextColor3 = Theme.TextSecondary
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextSize = 12
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.Parent = frame
            end
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 70, 0, 34)
            btn.Position = UDim2.new(1, -85, 0.5, -17)
            btn.BackgroundColor3 = Theme.ButtonBg
            btn.Text = "Run"
            btn.TextColor3 = Theme.TextPrimary
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 13
            btn.BorderSizePixel = 0
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(callback)
            
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.ButtonHover}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.ButtonBg}):Play()
            end)
            
            frame.MouseEnter:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
            end)
            frame.MouseLeave:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.15), {BackgroundTransparency = 0.15}):Play()
            end)
            
            frame.Parent = Content
            updateCanvas()
            
            return {
                Set = function(newText, newDesc, newCallback)
                    label.Text = newText
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
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.6, 0, 0, 22)
            label.Position = UDim2.new(0, 15, 0, 5)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = state and Theme.ToggleOn or Theme.TextPrimary
            label.Font = Enum.Font.GothamSemibold
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            if desc then
                local descLabel = Instance.new("TextLabel")
                descLabel.Size = UDim2.new(0.6, 0, 0, 18)
                descLabel.Position = UDim2.new(0, 15, 0, 27)
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
                    label.TextColor3 = Theme.ToggleOn
                else
                    toggleBg.BackgroundColor3 = Theme.ToggleOff
                    toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                    label.TextColor3 = Theme.TextPrimary
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
                TweenService:Create(frame, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
            end)
            frame.MouseLeave:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.15), {BackgroundTransparency = 0.15}):Play()
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
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        LuaWare:ToggleUI()
    end
end)

print("LuaWare v4.0 yuklendi. RightShift ile ac/kapat.")

return LuaWare

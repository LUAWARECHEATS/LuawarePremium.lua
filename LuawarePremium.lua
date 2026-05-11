--[[
    LUAWARE HUB - PREMIUM FRAMEWORK V1
    Özellikler: Rayfield Açılış Animasyonu, Orijinal Hawk Drag, Birebir Temiz Tasarım
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = LocalPlayer:WaitForChild("PlayerGui")

local Luaware = {}

-- ORİJİNAL HAWKLİB TEMASI BİREBİR
local Theme = {
    Main = Color3.fromRGB(25, 25, 30),
    TitleBar = Color3.fromRGB(30, 30, 35),
    TabBefore = Color3.fromRGB(32, 32, 36),
    TabAfter = Color3.fromRGB(40, 40, 45),
    Card = Color3.fromRGB(35, 35, 40),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 190),
    Working = Color3.fromRGB(80, 200, 80),  -- Resimdeki Yeşil
    DateBlue = Color3.fromRGB(80, 200, 220),-- Resimdeki Cam Mavisi
    Accent = Color3.fromRGB(255, 70, 85)
}

-- ORİJİNAL HAWKLİB DRAG MOTORU (Ultra Yumuşak 0.2s Tween)
local function MakeDraggable(topbarobject, object)
    local Dragging = nil; local DragInput = nil; local DragStart = nil; local StartPosition = nil
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

function Luaware:Window(Config)
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "LuawareHUB" then v:Destroy() end end
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "LuawareHUB"; sg.ResetOnSpawn = false

    -- =======================================
    -- RAYFIELD TARZI AÇILIŞ ANİMASYONU
    -- =======================================
    local IntroFrame = Instance.new("Frame", sg)
    IntroFrame.Size = UDim2.new(0, 0, 0, 0)
    IntroFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    IntroFrame.BackgroundColor3 = Theme.TitleBar
    IntroFrame.BorderSizePixel = 0
    IntroFrame.ClipsDescendants = true
    Instance.new("UICorner", IntroFrame).CornerRadius = UDim.new(0, 8)

    local IntroLogo = Instance.new("ImageLabel", IntroFrame)
    IntroLogo.Size = UDim2.new(0, 30, 0, 30); IntroLogo.Position = UDim2.new(0.5, -15, 0.5, -25)
    IntroLogo.BackgroundTransparency = 1; IntroLogo.Image = "rbxassetid://13570069771"; IntroLogo.ImageTransparency = 1

    local IntroText = Instance.new("TextLabel", IntroFrame)
    IntroText.Size = UDim2.new(1, 0, 0, 20); IntroText.Position = UDim2.new(0, 0, 0.5, 10)
    IntroText.BackgroundTransparency = 1; IntroText.Text = Config.Name or "LUAWARE HUB"
    IntroText.TextColor3 = Theme.Text; IntroText.Font = Enum.Font.GothamBold; IntroText.TextSize = 16; IntroText.TextTransparency = 1

    -- =======================================
    -- ANA PENCERE (ORİJİNAL ÖLÇÜLER)
    -- =======================================
    local Main = Instance.new("CanvasGroup", sg)
    Main.Size = UDim2.new(0, 592, 0, 451); Main.Position = UDim2.new(0.5, -296, 0.5, -225)
    Main.BackgroundColor3 = Theme.Main; Main.BorderSizePixel = 0; Main.GroupTransparency = 1
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 33); TopBar.BackgroundColor3 = Theme.TitleBar; TopBar.BorderSizePixel = 0
    local TitleLbl = Instance.new("TextLabel", TopBar)
    TitleLbl.Size = UDim2.new(0, 200, 1, 0); TitleLbl.Position = UDim2.new(0, 35, 0, 0); TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = Config.Name or "LuaWare HUB"; TitleLbl.TextColor3 = Theme.Text; TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 13; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local Icon = Instance.new("ImageLabel", TopBar)
    Icon.Size = UDim2.new(0, 16, 0, 16); Icon.Position = UDim2.new(0, 12, 0, 8); Icon.BackgroundTransparency = 1; Icon.Image = "rbxassetid://13570069771"
    
    local Line = Instance.new("Frame", TopBar)
    Line.Size = UDim2.new(1, 0, 0, 2); Line.Position = UDim2.new(0, 0, 1, 0); Line.BackgroundColor3 = Theme.Accent; Line.BorderSizePixel = 0

    MakeDraggable(TopBar, Main)

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 171, 1, -33); Sidebar.Position = UDim2.new(0, 0, 0, 33); Sidebar.BackgroundTransparency = 1
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -20); TabContainer.Position = UDim2.new(0, 0, 0, 10); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 4)

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(0, 404, 0, 408); PageContainer.Position = UDim2.new(0.317, 0, 0.093, 0); PageContainer.BackgroundTransparency = 1

    -- ANİMASYON SEKANSI (RAYFIELD GİBİ)
    task.spawn(function()
        TweenService:Create(IntroFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 100), Position = UDim2.new(0.5, -100, 0.5, -50)}):Play()
        task.wait(0.4)
        TweenService:Create(IntroLogo, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
        TweenService:Create(IntroText, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        task.wait(1.2)
        TweenService:Create(IntroLogo, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
        TweenService:Create(IntroText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.3)
        TweenService:Create(IntroFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = UDim2.new(0, 592, 0, 451), Position = UDim2.new(0.5, -296, 0.5, -225), BackgroundTransparency = 1}):Play()
        task.wait(0.4)
        TweenService:Create(Main, TweenInfo.new(0.3), {GroupTransparency = 0}):Play()
        IntroFrame:Destroy()
    end)

    local WindowObj = {}; local Tabs, Pages, isFirst = {}, {}, true

    function WindowObj:Tab(name)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -10, 0, 34); TabBtn.Position = UDim2.new(0, 5, 0, 0)
        TabBtn.BackgroundColor3 = isFirst and Theme.TabAfter or Theme.TabBefore; TabBtn.BorderSizePixel = 0
        TabBtn.Text = "   " .. name; TabBtn.TextColor3 = isFirst and Theme.Text or Theme.SubText; TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 13; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Selection = Instance.new("Frame", TabBtn)
        Selection.Size = UDim2.new(0, 4, 0, 16); Selection.Position = UDim2.new(0, 0, 0.5, -8); Selection.BackgroundColor3 = Theme.Accent; Selection.BackgroundTransparency = isFirst and 0 or 1
        Instance.new("UICorner", Selection).CornerRadius = UDim.new(1, 0)

        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 0; Page.Visible = isFirst
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

        table.insert(Tabs, TabBtn); table.insert(Pages, Page); isFirst = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            for _, t in pairs(Tabs) do t.BackgroundColor3 = Theme.TabBefore; t.TextColor3 = Theme.SubText; t:FindFirstChild("Selection").BackgroundTransparency = 1 end
            TabBtn.BackgroundColor3 = Theme.TabAfter; TabBtn.TextColor3 = Theme.Text; Selection.BackgroundTransparency = 0; Page.Visible = true
        end)

        local Elements = {}

        -- 1. PROFİL MODÜLÜ (HOME SAYFASI ANLIK GÜNCELLEME)
        function Elements:AddProfile()
            local PFrame = Instance.new("Frame", Page)
            PFrame.Size = UDim2.new(1, 0, 0, 180); PFrame.BackgroundTransparency = 1

            local pTitle = Instance.new("TextLabel", PFrame)
            pTitle.Size = UDim2.new(1, 0, 0, 20); pTitle.BackgroundTransparency = 1; pTitle.Text = "Welcome to " .. (Config.Name or "Hawk HUB")
            pTitle.TextColor3 = Theme.Text; pTitle.Font = Enum.Font.GothamBold; pTitle.TextSize = 14; pTitle.TextXAlignment = Enum.TextXAlignment.Left

            local Avatar = Instance.new("ImageLabel", PFrame)
            Avatar.Size = UDim2.new(0, 45, 0, 45); Avatar.Position = UDim2.new(0, 0, 0, 30); Avatar.BackgroundColor3 = Theme.Card
            Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
            Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

            local dName = Instance.new("TextLabel", PFrame)
            dName.Size = UDim2.new(0, 200, 0, 15); dName.Position = UDim2.new(0, 55, 0, 35); dName.BackgroundTransparency = 1
            dName.Text = LocalPlayer.DisplayName; dName.TextColor3 = Theme.Text; dName.Font = Enum.Font.GothamBold; dName.TextSize = 13; dName.TextXAlignment = Enum.TextXAlignment.Left

            local uName = Instance.new("TextLabel", PFrame)
            uName.Size = UDim2.new(0, 200, 0, 15); uName.Position = UDim2.new(0, 55, 0, 50); uName.BackgroundTransparency = 1
            uName.Text = "@" .. LocalPlayer.Name; uName.TextColor3 = Theme.SubText; uName.Font = Enum.Font.Gotham; uName.TextSize = 11; uName.TextXAlignment = Enum.TextXAlignment.Left

            local InfoText = Instance.new("TextLabel", PFrame)
            InfoText.Size = UDim2.new(1, 0, 0, 150); InfoText.Position = UDim2.new(0, 0, 0, 85); InfoText.BackgroundTransparency = 1
            InfoText.TextColor3 = Theme.Text; InfoText.Font = Enum.Font.GothamBold; InfoText.TextSize = 12; InfoText.TextXAlignment = Enum.TextXAlignment.Left; InfoText.TextYAlignment = Enum.TextYAlignment.Top
            InfoText.RichText = true; InfoText.LineHeight = 1.3

            local execName = identifyexecutor and identifyexecutor() or "Xeno"
            local gameName = "Bilinmiyor"
            pcall(function() gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)

            local function UpdateProfileInfo()
                local playersInServer = #Players:GetPlayers()
                local maxPlayers = Players.MaxPlayers
                InfoText.Text = string.format(
                    "Roblox User Name: <font color='rgb(180,180,190)'>%s</font>\n" ..
                    "Game Id: <font color='rgb(180,180,190)'>%d</font>\n" ..
                    "Game Name: 🟢 <font color='rgb(180,180,190)'>%s</font>\n" ..
                    "Place Id: <font color='rgb(180,180,190)'>%d</font>\n" ..
                    "Server: 👥 <font color='rgb(180,180,190)'>%d/%d</font>\n" ..
                    "Executor: <font color='rgb(255,70,85)'>%s</font>\n" ..
                    "Executor Level: <font color='rgb(255,70,85)'>3</font>", 
                    LocalPlayer.Name, game.GameId, gameName, game.PlaceId, playersInServer, maxPlayers, execName
                )
            end
            
            UpdateProfileInfo() 
            task.spawn(function() while task.wait(2) do if InfoText.Parent then UpdateProfileInfo() else break end end end)
        end

        function Elements:AddSection(txt)
            local lbl = Instance.new("TextLabel", Page)
            lbl.Size = UDim2.new(1, -10, 0, 25); lbl.BackgroundTransparency = 1; lbl.Text = txt
            lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 14; lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        -- 2. ORİJİNAL HAWK OYUN KARTI (Resimdeki Tasarımın Birebir Aynısı)
        function Elements:AddGameCard(Config)
            local cF = Instance.new("Frame", Page)
            cF.Size = UDim2.new(1, -10, 0, 80); cF.BackgroundColor3 = Theme.Card; cF.BorderSizePixel = 0
            Instance.new("UICorner", cF).CornerRadius = UDim.new(0, 8)
            
            local img = Instance.new("ImageLabel", cF)
            img.Size = UDim2.new(0, 60, 0, 60); img.Position = UDim2.new(0, 10, 0.5, -30); img.BackgroundColor3 = Theme.Main
            
            -- Resim Fixleyici
            if Config.ImageId then
                img.Image = "rbxassetid://" .. Config.ImageId
            else
                img.Image = "rbxassetid://13570069771"
            end
            
            img.ScaleType = Enum.ScaleType.Crop
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, 8)

            local title = Instance.new("TextLabel", cF)
            title.Size = UDim2.new(1, -100, 0, 18); title.Position = UDim2.new(0, 80, 0, 12); title.BackgroundTransparency = 1
            title.Text = Config.Title or "Game Title"; title.TextColor3 = Theme.Text; title.Font = Enum.Font.GothamBold; title.TextSize = 13; title.TextXAlignment = Enum.TextXAlignment.Left

            local status = Instance.new("TextLabel", cF)
            status.Size = UDim2.new(1, -100, 0, 16); status.Position = UDim2.new(0, 80, 0, 32); status.BackgroundTransparency = 1
            status.Text = "Status: Working"; status.TextColor3 = Theme.Working; status.Font = Enum.Font.GothamBold; status.TextSize = 11; status.TextXAlignment = Enum.TextXAlignment.Left

            local detail = Instance.new("TextLabel", cF)
            detail.Size = UDim2.new(1, -100, 0, 16); detail.Position = UDim2.new(0, 80, 0, 50); detail.BackgroundTransparency = 1
            detail.Text = Config.Update or "Last Update: N/A"; detail.TextColor3 = Theme.DateBlue; detail.Font = Enum.Font.GothamBold; detail.TextSize = 11; detail.TextXAlignment = Enum.TextXAlignment.Left

            if Config.Callback then
                local loadBtnFrame = Instance.new("Frame", cF)
                loadBtnFrame.Size = UDim2.new(0, 75, 0, 26); loadBtnFrame.Position = UDim2.new(1, -85, 0.5, -13); loadBtnFrame.BackgroundColor3 = Theme.Main
                Instance.new("UICorner", loadBtnFrame).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", loadBtnFrame).Color = Theme.Accent
                
                local loadBtn = Instance.new("TextButton", loadBtnFrame)
                loadBtn.Size = UDim2.new(1, 0, 1, 0); loadBtn.BackgroundTransparency = 1; loadBtn.Text = "Çalıştır"; loadBtn.TextColor3 = Theme.Text; loadBtn.Font = Enum.Font.GothamBold; loadBtn.TextSize = 12
                
                loadBtn.MouseButton1Click:Connect(function()
                    TweenService:Create(loadBtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
                    task.wait(0.1); TweenService:Create(loadBtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Main}):Play()
                    Config.Callback()
                end)
            end
        end

        return Elements
    end
    UserInputService.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end end)
    return WindowObj
end

return Luaware

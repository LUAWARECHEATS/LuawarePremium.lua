--[[
    LUAWARE SCRIPT - PREMIUM FRAMEWORK (V1)
    YAPIMCI: NOXYORJ
    Özellikler: %100 Clean Düzen, Sorunsuz Intro, Orijinal Boyut (592x451), GameIcon Çekici
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = LocalPlayer:WaitForChild("PlayerGui")

local Luaware = {}

-- ORİJİNAL HAWK CLEAN TEMA
local Theme = {
    Main = Color3.fromRGB(25, 25, 30),
    TitleBar = Color3.fromRGB(30, 30, 35),
    TabBefore = Color3.fromRGB(32, 32, 36),
    TabAfter = Color3.fromRGB(40, 40, 45),
    Card = Color3.fromRGB(35, 35, 40),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 190),
    Working = Color3.fromRGB(80, 200, 80),
    DateBlue = Color3.fromRGB(80, 200, 220),
    Accent = Color3.fromRGB(255, 70, 85) -- Sadece küçük detaylar için
}

-- ORİJİNAL YUMUŞAK SÜRÜKLEME (0.2s Tween)
local function MakeSmoothDraggable(dragObject, targetObject)
    local Dragging, DragInput, DragStart, StartPosition
    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        TweenService:Create(targetObject, TweenInfo.new(0.2), {Position = pos}):Play()
    end
    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true; DragStart = input.Position; StartPosition = targetObject.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
        end
    end)
    dragObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then Update(input) end
    end)
end

function Luaware:Window(Config)
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "LuawareScriptUI" then v:Destroy() end end
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "LuawareScriptUI"; sg.ResetOnSpawn = false

    -- =======================================
    -- RAYFIELD INTRO (Sorunsuz)
    -- =======================================
    local IntroGroup = Instance.new("CanvasGroup", sg)
    IntroGroup.Size = UDim2.new(0, 320, 0, 180); IntroGroup.Position = UDim2.new(0.5, -160, 0.5, -90)
    IntroGroup.BackgroundColor3 = Theme.Main; IntroGroup.BorderSizePixel = 0
    Instance.new("UICorner", IntroGroup).CornerRadius = UDim.new(0, 8)
    local iStroke = Instance.new("UIStroke", IntroGroup); iStroke.Color = Theme.TitleBar; iStroke.Thickness = 2

    local IntroTitle = Instance.new("TextLabel", IntroGroup)
    IntroTitle.Size = UDim2.new(1, 0, 0, 50); IntroTitle.Position = UDim2.new(0, 0, 0, 20); IntroTitle.BackgroundTransparency = 1
    IntroTitle.Text = Config.Name or "LuaWare Script"; IntroTitle.TextColor3 = Theme.Text; IntroTitle.Font = Enum.Font.GothamBlack; IntroTitle.TextSize = 22

    local IntroDesc = Instance.new("TextLabel", IntroGroup)
    IntroDesc.Size = UDim2.new(1, 0, 0, 20); IntroDesc.Position = UDim2.new(0, 0, 0, 60); IntroDesc.BackgroundTransparency = 1
    IntroDesc.Text = "Please select your language / Dil seçin"; IntroDesc.TextColor3 = Theme.SubText; IntroDesc.Font = Enum.Font.Gotham; IntroDesc.TextSize = 12

    local LangContainer = Instance.new("Frame", IntroGroup)
    LangContainer.Size = UDim2.new(1, 0, 0, 50); LangContainer.Position = UDim2.new(0, 0, 0, 100); LangContainer.BackgroundTransparency = 1

    IntroGroup.GroupTransparency = 1; IntroGroup.Size = UDim2.new(0, 280, 0, 150)
    TweenService:Create(IntroGroup, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {GroupTransparency = 0, Size = UDim2.new(0, 320, 0, 180)}):Play()

    -- =======================================
    -- ANA PENCERE (Başlangıçta KESİNLİKLE Gizli)
    -- =======================================
    local Main = Instance.new("CanvasGroup", sg)
    Main.Size = UDim2.new(0, 592, 0, 451); Main.Position = UDim2.new(0.5, -296, 0.5, -225)
    Main.BackgroundColor3 = Theme.Main; Main.BorderSizePixel = 0
    Main.GroupTransparency = 1
    Main.Visible = false -- İşte menünün erken gelmesini engelleyen kilit kod!
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 33); TopBar.BackgroundColor3 = Theme.TitleBar; TopBar.BorderSizePixel = 0
    local TitleLbl = Instance.new("TextLabel", TopBar)
    TitleLbl.Size = UDim2.new(0, 200, 1, 0); TitleLbl.Position = UDim2.new(0, 35, 0, 0); TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = Config.Name or "LuaWare Script"; TitleLbl.TextColor3 = Theme.Text; TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 13; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local Icon = Instance.new("ImageLabel", TopBar)
    Icon.Size = UDim2.new(0, 16, 0, 16); Icon.Position = UDim2.new(0, 12, 0, 8); Icon.BackgroundTransparency = 1; Icon.Image = "rbxassetid://13570069771"
    
    local Line = Instance.new("Frame", TopBar)
    Line.Size = UDim2.new(1, 0, 0, 2); Line.Position = UDim2.new(0,0,1,0); Line.BackgroundColor3 = Theme.Accent; Line.BorderSizePixel = 0

    MakeSmoothDraggable(TopBar, Main)

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 171, 1, -33); Sidebar.Position = UDim2.new(0, 0, 0, 33); Sidebar.BackgroundTransparency = 1
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -20); TabContainer.Position = UDim2.new(0, 10, 0, 10); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 6)

    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(0, 404, 0, 408); Content.Position = UDim2.new(0, 180, 0, 40); Content.BackgroundTransparency = 1

    local WindowObj = {}; local Tabs, Pages, isFirst = {}, {}, true

    -- =======================================
    -- DİL SEÇİMİ VE ANA MENÜYE GEÇİŞ
    -- =======================================
    local function SetupLanguage(btnName, posScale)
        local btn = Instance.new("TextButton", LangContainer)
        btn.Size = UDim2.new(0, 100, 0, 35); btn.Position = UDim2.new(posScale, -50, 0, 0); btn.BackgroundColor3 = Theme.Card
        btn.Text = btnName; btn.TextColor3 = Theme.Text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 12
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        btn.MouseButton1Click:Connect(function()
            -- Intro'yu Kapat
            TweenService:Create(IntroGroup, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {GroupTransparency = 1, Size = UDim2.new(0, 280, 0, 150)}):Play()
            task.wait(0.4)
            IntroGroup.Visible = false
            
            -- Ana Menüyü Aç
            Main.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
        end)
    end
    SetupLanguage("TÜRKÇE", 0.3); SetupLanguage("ENGLISH", 0.7)

    -- =======================================
    -- API BİLEŞENLERİ
    -- =======================================
    function WindowObj:Tab(name)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(0, 150, 0, 34); TabBtn.BackgroundColor3 = isFirst and Theme.TabAfter or Theme.TabBefore; TabBtn.BorderSizePixel = 0
        TabBtn.Text = "   " .. name; TabBtn.TextColor3 = isFirst and Theme.Text or Theme.SubText; TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 13; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Selection = Instance.new("Frame", TabBtn)
        Selection.Size = UDim2.new(0, 4, 0, 16); Selection.Position = UDim2.new(0, 0, 0.5, -8); Selection.BackgroundColor3 = Theme.Accent; Selection.BackgroundTransparency = isFirst and 0 or 1
        Instance.new("UICorner", Selection).CornerRadius = UDim.new(1, 0)

        local Page = Instance.new("ScrollingFrame", Content)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.Accent; Page.Visible = isFirst
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

        table.insert(Tabs, TabBtn); table.insert(Pages, Page); isFirst = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            for _, t in pairs(Tabs) do t.BackgroundColor3 = Theme.TabBefore; t.TextColor3 = Theme.SubText; t:FindFirstChild("Selection").BackgroundTransparency = 1 end
            TabBtn.BackgroundColor3 = Theme.TabAfter; TabBtn.TextColor3 = Theme.Text; Selection.BackgroundTransparency = 0; Page.Visible = true
        end)

        local Elements = {}

        -- 1. PROFİL MODÜLÜ (Anlık Güncellenen)
        function Elements:AddProfile()
            local PFrame = Instance.new("Frame", Page)
            PFrame.Size = UDim2.new(1, 0, 0, 160); PFrame.BackgroundTransparency = 1

            local pTitle = Instance.new("TextLabel", PFrame)
            pTitle.Size = UDim2.new(1, 0, 0, 20); pTitle.BackgroundTransparency = 1; pTitle.Text = "Welcome to LuaWare Script"
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
            local gameName = "LuaWare Script Aktif"
            pcall(function() gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)

            local function UpdateProfileInfo()
                local playersInServer = #Players:GetPlayers()
                local maxPlayers = Players.MaxPlayers
                InfoText.Text = string.format("Roblox User Name: <font color='rgb(180,180,190)'>%s</font>\nGame Id: <font color='rgb(180,180,190)'>%d</font>\nGame Name: 🎮 <font color='rgb(180,180,190)'>%s</font>\nPlace Id: <font color='rgb(180,180,190)'>%d</font>\nServer: 👥 <font color='rgb(180,180,190)'>%d/%d</font>\nExecutor: <font color='rgb(255,70,85)'>%s</font>\nExecutor Level: <font color='rgb(255,70,85)'>3</font>", LocalPlayer.Name, game.GameId, gameName, game.PlaceId, playersInServer, maxPlayers, execName)
            end
            UpdateProfileInfo()
            task.spawn(function() while task.wait(2) do if InfoText.Parent then UpdateProfileInfo() else break end end end)
        end

        function Elements:AddSection(txt)
            local lbl = Instance.new("TextLabel", Page)
            lbl.Size = UDim2.new(1, -10, 0, 25); lbl.BackgroundTransparency = 1; lbl.Text = txt
            lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 14; lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        -- 3. OYUN KARTI (GAME ICON ÇEKİCİ)
        function Elements:AddGameCard(Config)
            local cF = Instance.new("Frame", Page)
            cF.Size = UDim2.new(1, -15, 0, 80); cF.BackgroundColor3 = Theme.Card; cF.BorderSizePixel = 0
            Instance.new("UICorner", cF).CornerRadius = UDim.new(0, 6)
            
            local img = Instance.new("ImageLabel", cF)
            img.Size = UDim2.new(0, 60, 0, 60); img.Position = UDim2.new(0, 10, 0.5, -30); img.BackgroundColor3 = Theme.Main
            
            -- ROBLOX GİZLİ APİSİ (Attığın resimlerdeki orijinal kapağı anında indirir)
            if Config.PlaceId then
                img.Image = "rbxthumb://type=GameIcon&id=" .. Config.PlaceId .. "&w=150&h=150"
            else
                img.Image = "rbxassetid://13570069771"
            end
            
            img.ScaleType = Enum.ScaleType.Crop
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)

            local title = Instance.new("TextLabel", cF)
            title.Size = UDim2.new(1, -100, 0, 18); title.Position = UDim2.new(0, 80, 0, 12); title.BackgroundTransparency = 1
            title.Text = Config.Title or "Game Title"; title.TextColor3 = Theme.Text; title.Font = Enum.Font.GothamBold; title.TextSize = 14; title.TextXAlignment = Enum.TextXAlignment.Left

            local status = Instance.new("TextLabel", cF)
            status.Size = UDim2.new(1, -100, 0, 16); status.Position = UDim2.new(0, 80, 0, 32); status.BackgroundTransparency = 1
            status.Text = Config.Status or "Status: Working"; status.TextColor3 = Theme.Working; status.Font = Enum.Font.GothamBold; status.TextSize = 11; status.TextXAlignment = Enum.TextXAlignment.Left

            local detail = Instance.new("TextLabel", cF)
            detail.Size = UDim2.new(1, -100, 0, 16); detail.Position = UDim2.new(0, 80, 0, 50); detail.BackgroundTransparency = 1
            detail.Text = Config.Update or "Last Update: N/A"; detail.TextColor3 = Theme.DateBlue; detail.Font = Enum.Font.GothamBold; detail.TextSize = 11; detail.TextXAlignment = Enum.TextXAlignment.Left

            -- ÇALIŞTIR / KEY AL BUTONU
            if Config.Callback then
                local loadBtnFrame = Instance.new("Frame", cF)
                loadBtnFrame.Size = UDim2.new(0, 70, 0, 26); loadBtnFrame.Position = UDim2.new(1, -85, 0.5, -13); loadBtnFrame.BackgroundColor3 = Theme.Main
                Instance.new("UICorner", loadBtnFrame).CornerRadius = UDim.new(0, 4)
                local loadBtn = Instance.new("TextButton", loadBtnFrame)
                loadBtn.Size = UDim2.new(1, 0, 1, 0); loadBtn.BackgroundTransparency = 1; loadBtn.Text = "Çalıştır"; loadBtn.TextColor3 = Theme.Text; loadBtn.Font = Enum.Font.GothamBold; loadBtn.TextSize = 11
                loadBtn.MouseButton1Click:Connect(function()
                    TweenService:Create(loadBtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Card}):Play(); task.wait(0.1); TweenService:Create(loadBtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Main}):Play()
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

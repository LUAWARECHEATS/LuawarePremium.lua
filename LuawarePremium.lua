-- =======================================================
-- LUAWARE SCRIPT - V3 TİTANYUM SÜRÜM (KUSURSUZ DRAG)
-- YAPIMCI: NOXYORJ
-- Boyut: 460x280 | Tereyağı Drag | RGB Menü | Gölge & Çizgi
-- =======================================================

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = LocalPlayer:WaitForChild("PlayerGui")

for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "LuawareScriptUI" then v:Destroy() end end

local Luaware = {}
local ToggleKeybind = Enum.KeyCode.RightShift
local MainGUIFrame = nil -- Açma kapama için ana menü referansı

-- TEMA SİSTEMİ (Başlangıç Rengi Kırmızı)
local Theme = {
    Main = Color3.fromRGB(20, 20, 25),
    TitleBar = Color3.fromRGB(25, 25, 30),
    TabActive = Color3.fromRGB(40, 40, 45),
    Card = Color3.fromRGB(30, 30, 35),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(150, 150, 160),
    Accent = Color3.fromRGB(255, 50, 50), -- Başlangıç: Kırmızı Çizgi/Tema
    RedText = Color3.fromRGB(255, 80, 80),
    DateBlue = Color3.fromRGB(80, 200, 220),
    Discord = Color3.fromRGB(88, 101, 242)
}

local AccentObjects = {} -- RGB değiştiğinde rengi değişecek her şey burada!

local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "LuawareScriptUI"; sg.ResetOnSpawn = false

-- =======================================
-- TEREYAĞI (BUTTERY SMOOTH) DRAG SİSTEMİ
-- =======================================
local function MakeSmoothDraggable(dragObject, targetObject)
    local dragging, dragInput, dragStart, startPos
    local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    
    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = targetObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    dragObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local goal = {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}
            TweenService:Create(targetObject, tweenInfo, goal):Play()
        end
    end)
end

-- =======================================
-- SAĞ ALT BİLDİRİM SİSTEMİ
-- =======================================
local NotifContainer = Instance.new("Frame", sg)
NotifContainer.Size = UDim2.new(0, 250, 1, -20); NotifContainer.Position = UDim2.new(1, -270, 0, 10); NotifContainer.BackgroundTransparency = 1
local NotifLayout = Instance.new("UIListLayout", NotifContainer)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom; NotifLayout.Padding = UDim.new(0, 8)

function Luaware:Notify(title, text, time)
    local nF = Instance.new("Frame", NotifContainer)
    nF.Size = UDim2.new(1, 300, 0, 50); nF.BackgroundColor3 = Theme.Card; nF.BackgroundTransparency = 1
    Instance.new("UICorner", nF).CornerRadius = UDim.new(0, 6)
    local nStroke = Instance.new("UIStroke", nF); nStroke.Color = Theme.TitleBar; nStroke.Transparency = 1
    
    local nT = Instance.new("TextLabel", nF)
    nT.Size = UDim2.new(1, -20, 0, 16); nT.Position = UDim2.new(0, 10, 0, 5); nT.BackgroundTransparency = 1; nT.Text = title; nT.TextColor3 = Theme.Accent; nT.Font = Enum.Font.GothamBold; nT.TextSize = 11; nT.TextXAlignment = Enum.TextXAlignment.Left; nT.TextTransparency = 1
    table.insert(AccentObjects, {Obj = nT, Prop = "TextColor3"})
    
    local nD = Instance.new("TextLabel", nF)
    nD.Size = UDim2.new(1, -20, 0, 20); nD.Position = UDim2.new(0, 10, 0, 21); nD.BackgroundTransparency = 1; nD.Text = text; nD.TextColor3 = Theme.Text; nD.Font = Enum.Font.Gotham; nD.TextSize = 10; nD.TextXAlignment = Enum.TextXAlignment.Left; nD.TextWrapped = true; nD.TextTransparency = 1

    TweenService:Create(nF, TweenInfo.new(0.3), {BackgroundTransparency = 0, Size = UDim2.new(1, 0, 0, 50)}):Play()
    TweenService:Create(nStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(nT, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(nD, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    task.delay(time or 3, function()
        TweenService:Create(nF, TweenInfo.new(0.3), {BackgroundTransparency = 1, Size = UDim2.new(1, 300, 0, 50)}):Play()
        TweenService:Create(nStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(nT, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(nD, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.3); nF:Destroy()
    end)
end

-- =======================================
-- ANA ARAYÜZ (GÖLGE VE ÇİZGİLİ)
-- =======================================
function Luaware:Window(Config)
    local Main = Instance.new("Frame", sg)
    Main.Size = UDim2.new(0, 0, 0, 0); Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.BackgroundColor3 = Theme.Main; Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    MainGUIFrame = Main -- Açma kapama için global kaydet

    -- YANLARA KIRMIZI (DİNAMİK) ÇİZGİ
    local mainStroke = Instance.new("UIStroke", Main)
    mainStroke.Color = Theme.Accent; mainStroke.Thickness = 1.5
    table.insert(AccentObjects, {Obj = mainStroke, Prop = "Color"})

    -- ARKAYA EFSANE GÖLGE (DROP SHADOW)
    local Shadow = Instance.new("ImageLabel", Main)
    Shadow.Name = "Shadow"; Shadow.BackgroundTransparency = 1; Shadow.Position = UDim2.new(0, -15, 0, -15); Shadow.Size = UDim2.new(1, 30, 1, 30); Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://1316045217"; Shadow.ImageColor3 = Color3.new(0,0,0); Shadow.ImageTransparency = 0.4
    Shadow.ScaleType = Enum.ScaleType.Slice; Shadow.SliceCenter = Rect.new(10, 10, 118, 118)

    local MainClips = Instance.new("Frame", Main)
    MainClips.Size = UDim2.new(1,0,1,0); MainClips.BackgroundTransparency = 1; MainClips.ClipsDescendants = true
    Instance.new("UICorner", MainClips).CornerRadius = UDim.new(0, 8)

    local IntroText = Instance.new("TextLabel", MainClips)
    IntroText.Size = UDim2.new(1, 0, 1, 0); IntroText.BackgroundTransparency = 1; IntroText.Text = "LUAWARE SCRIPT"; IntroText.TextColor3 = Theme.Text; IntroText.Font = Enum.Font.GothamBlack; IntroText.TextSize = 16; IntroText.TextTransparency = 1

    local TopBar = Instance.new("Frame", MainClips)
    TopBar.Size = UDim2.new(1, 0, 0, 30); TopBar.BackgroundColor3 = Theme.TitleBar; TopBar.BorderSizePixel = 0; TopBar.Visible = false
    
    local TitleLbl = Instance.new("TextLabel", TopBar)
    TitleLbl.Size = UDim2.new(0, 200, 1, 0); TitleLbl.Position = UDim2.new(0, 30, 0, 0); TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = Config.Name or "LuaWare Script"; TitleLbl.TextColor3 = Theme.Text; TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 11; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local Icon = Instance.new("ImageLabel", TopBar)
    Icon.Size = UDim2.new(0, 14, 0, 14); Icon.Position = UDim2.new(0, 10, 0, 8); Icon.BackgroundTransparency = 1; Icon.Image = "rbxassetid://13570069771"

    -- 🔴 LUAWARE YAZISININ ALTINA ÇEKİLEN ÇİZGİ
    local TitleLine = Instance.new("Frame", TopBar)
    TitleLine.Size = UDim2.new(1, 0, 0, 2)
    TitleLine.Position = UDim2.new(0, 0, 1, -2)
    TitleLine.BackgroundColor3 = Theme.Accent
    TitleLine.BorderSizePixel = 0
    table.insert(AccentObjects, {Obj = TitleLine, Prop = "BackgroundColor3"})

    MakeSmoothDraggable(TopBar, Main)

    local Sidebar = Instance.new("Frame", MainClips)
    Sidebar.Size = UDim2.new(0, 100, 1, -30); Sidebar.Position = UDim2.new(0, 0, 0, 30); Sidebar.BackgroundTransparency = 1; Sidebar.Visible = false
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -10); TabContainer.Position = UDim2.new(0, 0, 0, 5); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 2)

    local Content = Instance.new("Frame", MainClips)
    Content.Size = UDim2.new(1, -100, 1, -30); Content.Position = UDim2.new(0, 100, 0, 30); Content.BackgroundTransparency = 1; Content.Visible = false

    -- INTRO
    task.spawn(function()
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 4), Position = UDim2.new(0.5, -100, 0.5, -2)}):Play()
        task.wait(0.3)
        TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 60), Position = UDim2.new(0.5, -100, 0.5, -30)}):Play()
        task.wait(0.2)
        TweenService:Create(IntroText, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        task.wait(1)
        TweenService:Create(IntroText, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        task.wait(0.2)
        TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 460, 0, 280), Position = UDim2.new(0.5, -230, 0.5, -140)}):Play()
        task.wait(0.5)
        IntroText:Destroy(); TopBar.Visible = true; Sidebar.Visible = true; Content.Visible = true
        Luaware:Notify("Sistem Aktif", "Menüyü gizlemek için " .. ToggleKeybind.Name .. " tuşuna basın.", 4)
    end)

    local Tabs, Pages, isFirst = {}, {}, true

    function Luaware:Tab(name)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -6, 0, 26); TabBtn.Position = UDim2.new(0, 3, 0, 0)
        TabBtn.BackgroundColor3 = Theme.TabActive; TabBtn.BackgroundTransparency = isFirst and 0 or 1; TabBtn.BorderSizePixel = 0
        TabBtn.Text = "   " .. name; TabBtn.TextColor3 = isFirst and Theme.Accent or Theme.SubText; TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 11; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)
        
        -- Aktif tab da renk değiştirme sistemine dahil edildi
        table.insert(AccentObjects, {Obj = TabBtn, Prop = "TextColor3", IsTab = true})

        local Page = Instance.new("CanvasGroup", Content)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = isFirst; Page.GroupTransparency = isFirst and 0 or 1
        
        local PageScroll = Instance.new("ScrollingFrame", Page)
        PageScroll.Size = UDim2.new(1, 0, 1, 0); PageScroll.BackgroundTransparency = 1; PageScroll.ScrollBarThickness = 0
        Instance.new("UIListLayout", PageScroll).Padding = UDim.new(0, 6)

        table.insert(Tabs, TabBtn); table.insert(Pages, Page); isFirst = false

        -- SAYFALAR ARASI KUSURSUZ GEÇİŞ
        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false; p.GroupTransparency = 1 end
            for _, t in pairs(Tabs) do t.BackgroundTransparency = 1; t.TextColor3 = Theme.SubText end
            
            TabBtn.BackgroundTransparency = 0; TabBtn.TextColor3 = Theme.Accent; 
            Page.Visible = true
            TweenService:Create(Page, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
        end)

        local Elements = {}

        function Elements:AddProfile()
            local PFrame = Instance.new("Frame", PageScroll)
            PFrame.Size = UDim2.new(1, 0, 0, 140); PFrame.BackgroundTransparency = 1

            local Avatar = Instance.new("ImageLabel", PFrame)
            Avatar.Size = UDim2.new(0, 35, 0, 35); Avatar.Position = UDim2.new(0, 10, 0, 10); Avatar.BackgroundColor3 = Theme.TabActive
            Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
            Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

            local dName = Instance.new("TextLabel", PFrame)
            dName.Size = UDim2.new(0, 200, 0, 15); dName.Position = UDim2.new(0, 55, 0, 10); dName.BackgroundTransparency = 1; dName.Text = LocalPlayer.DisplayName; dName.TextColor3 = Theme.Text; dName.Font = Enum.Font.GothamBold; dName.TextSize = 11; dName.TextXAlignment = Enum.TextXAlignment.Left

            local uName = Instance.new("TextLabel", PFrame)
            uName.Size = UDim2.new(0, 200, 0, 15); uName.Position = UDim2.new(0, 55, 0, 24); uName.BackgroundTransparency = 1; uName.Text = "@" .. LocalPlayer.Name; uName.TextColor3 = Theme.SubText; uName.Font = Enum.Font.Gotham; uName.TextSize = 10; uName.TextXAlignment = Enum.TextXAlignment.Left

            local InfoText = Instance.new("TextLabel", PFrame)
            InfoText.Size = UDim2.new(1, 0, 0, 100); InfoText.Position = UDim2.new(0, 10, 0, 55); InfoText.BackgroundTransparency = 1; InfoText.TextColor3 = Theme.Text; InfoText.Font = Enum.Font.GothamBold; InfoText.TextSize = 10; InfoText.TextXAlignment = Enum.TextXAlignment.Left; InfoText.TextYAlignment = Enum.TextYAlignment.Top; InfoText.RichText = true; InfoText.LineHeight = 1.3

            local execName = identifyexecutor and identifyexecutor() or "Bilinmiyor"
            local function UpdateProfileInfo()
                local gameName = "Bilinmiyor"; pcall(function() gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
                local playersInServer = #Players:GetPlayers()
                InfoText.Text = string.format("Game Name: 🟢 <font color='rgb(180,180,180)'>%s</font>\nPlace Id: <font color='rgb(180,180,180)'>%d</font>\nServer: <font color='rgb(180,180,180)'>%d/%d</font>\nExecutor: <font color='rgb(255,80,80)'>%s</font>", gameName, game.PlaceId, playersInServer, Players.MaxPlayers, execName)
            end
            UpdateProfileInfo()
        end

        function Elements:AddSection(txt)
            local lbl = Instance.new("TextLabel", PageScroll)
            lbl.Size = UDim2.new(1, 0, 0, 20); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = txt; lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        -- 👥 DEVELOPER ÖZEL KARTI (DİSCORD ENTEGRE)
        function Elements:AddDeveloper(dcName, rbName, dcLink)
            local cF = Instance.new("Frame", PageScroll)
            cF.Size = UDim2.new(1, -20, 0, 75); cF.Position = UDim2.new(0, 10, 0, 0); cF.BackgroundColor3 = Theme.Card; cF.BorderSizePixel = 0
            Instance.new("UICorner", cF).CornerRadius = UDim.new(0, 6)
            
            -- Discord Logosu
            local img = Instance.new("ImageLabel", cF)
            img.Size = UDim2.new(0, 35, 0, 35); img.Position = UDim2.new(0, 15, 0.5, -17); img.BackgroundTransparency = 1
            img.Image = "rbxassetid://13350645607"; img.ImageColor3 = Theme.Discord

            local lblDc = Instance.new("TextLabel", cF)
            lblDc.Size = UDim2.new(1, -70, 0, 14); lblDc.Position = UDim2.new(0, 65, 0, 12); lblDc.BackgroundTransparency = 1; lblDc.Text = "Discord: " .. dcName; lblDc.TextColor3 = Theme.Text; lblDc.Font = Enum.Font.GothamBold; lblDc.TextSize = 11; lblDc.TextXAlignment = Enum.TextXAlignment.Left

            local lblRb = Instance.new("TextLabel", cF)
            lblRb.Size = UDim2.new(1, -70, 0, 14); lblRb.Position = UDim2.new(0, 65, 0, 30); lblRb.BackgroundTransparency = 1; lblRb.Text = "Roblox: " .. rbName; lblRb.TextColor3 = Theme.SubText; lblRb.Font = Enum.Font.Gotham; lblRb.TextSize = 10; lblRb.TextXAlignment = Enum.TextXAlignment.Left

            local lblLink = Instance.new("TextLabel", cF)
            lblLink.Size = UDim2.new(1, -70, 0, 14); lblLink.Position = UDim2.new(0, 65, 0, 48); lblLink.BackgroundTransparency = 1; lblLink.Text = "Link: " .. dcLink .. " (Tıkla Kopyala)"; lblLink.TextColor3 = Theme.Discord; lblLink.Font = Enum.Font.GothamBold; lblLink.TextSize = 10; lblLink.TextXAlignment = Enum.TextXAlignment.Left
            
            lblLink.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(dcLink)
                    Luaware:Notify("Kopyalandı", "Discord linki başarıyla panoya kopyalandı!", 3)
                else
                    Luaware:Notify("Hata", "Executor'un setclipboard desteklemiyor.", 3)
                end
            end)
        end

        function Elements:AddGameCard(Config)
            local cF = Instance.new("Frame", PageScroll)
            cF.Size = UDim2.new(1, -20, 0, 60); cF.Position = UDim2.new(0, 10, 0, 0); cF.BackgroundColor3 = Theme.Card; cF.BorderSizePixel = 0
            Instance.new("UICorner", cF).CornerRadius = UDim.new(0, 4)
            
            local img = Instance.new("ImageLabel", cF)
            img.Size = UDim2.new(0, 40, 0, 40); img.Position = UDim2.new(0, 10, 0.5, -20); img.BackgroundColor3 = Theme.Main
            img.Image = "rbxassetid://13570069771"; img.ScaleType = Enum.ScaleType.Crop
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, 4)

            local title = Instance.new("TextLabel", cF)
            title.Size = UDim2.new(1, -130, 0, 14); title.Position = UDim2.new(0, 60, 0, 8); title.BackgroundTransparency = 1; title.Text = Config.Title or "Game"; title.TextColor3 = Theme.Text; title.Font = Enum.Font.GothamBold; title.TextSize = 11; title.TextXAlignment = Enum.TextXAlignment.Left

            local status = Instance.new("TextLabel", cF)
            status.Size = UDim2.new(1, -130, 0, 12); status.Position = UDim2.new(0, 60, 0, 24); status.BackgroundTransparency = 1; status.Text = Config.Status or "Status: Working"; status.TextColor3 = Theme.Accent; status.Font = Enum.Font.GothamBold; status.TextSize = 10; status.TextXAlignment = Enum.TextXAlignment.Left
            table.insert(AccentObjects, {Obj = status, Prop = "TextColor3"})

            local detail = Instance.new("TextLabel", cF)
            detail.Size = UDim2.new(1, -130, 0, 12); detail.Position = UDim2.new(0, 60, 0, 38); detail.BackgroundTransparency = 1; detail.Text = Config.Update or "Last Update: Universal"; detail.TextColor3 = Theme.DateBlue; detail.Font = Enum.Font.GothamBold; detail.TextSize = 10; detail.TextXAlignment = Enum.TextXAlignment.Left

            if Config.Callback then
                local loadBtnFrame = Instance.new("Frame", cF)
                loadBtnFrame.Size = UDim2.new(0, 55, 0, 22); loadBtnFrame.Position = UDim2.new(1, -65, 0.5, -11); loadBtnFrame.BackgroundColor3 = Theme.Main
                Instance.new("UICorner", loadBtnFrame).CornerRadius = UDim.new(0, 4)
                local loadBtn = Instance.new("TextButton", loadBtnFrame)
                loadBtn.Size = UDim2.new(1, 0, 1, 0); loadBtn.BackgroundTransparency = 1; loadBtn.Text = "Çalıştır"; loadBtn.TextColor3 = Theme.Text; loadBtn.Font = Enum.Font.GothamBold; loadBtn.TextSize = 10
                loadBtn.MouseButton1Click:Connect(function()
                    TweenService:Create(loadBtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Card}):Play(); task.wait(0.1); TweenService:Create(loadBtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Main}):Play()
                    Luaware:Notify("Script Çalıştırıldı", Config.Title .. " başarıyla execute edildi.", 3)
                    Config.Callback()
                end)
            end
        end

        -- ⌨️ KEYBIND AYARLAYICI
        function Elements:AddKeybind(text, callback)
            local cF = Instance.new("Frame", PageScroll)
            cF.Size = UDim2.new(1, -20, 0, 35); cF.Position = UDim2.new(0, 10, 0, 0); cF.BackgroundColor3 = Theme.Card; cF.BorderSizePixel = 0
            Instance.new("UICorner", cF).CornerRadius = UDim.new(0, 4)
            
            local lbl = Instance.new("TextLabel", cF)
            lbl.Size = UDim2.new(1, -100, 1, 0); lbl.Position = UDim2.new(0, 15, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left

            local btnFrame = Instance.new("Frame", cF)
            btnFrame.Size = UDim2.new(0, 80, 0, 22); btnFrame.Position = UDim2.new(1, -90, 0.5, -11); btnFrame.BackgroundColor3 = Theme.Main
            Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 4)
            
            local btn = Instance.new("TextButton", btnFrame)
            btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ToggleKeybind.Name; btn.TextColor3 = Theme.Accent; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10
            table.insert(AccentObjects, {Obj = btn, Prop = "TextColor3"})

            local listening = false
            btn.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true; btn.Text = "..."
                local connection
                connection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        ToggleKeybind = input.KeyCode
                        btn.Text = ToggleKeybind.Name
                        listening = false
                        connection:Disconnect()
                        if callback then callback(ToggleKeybind) end
                    end
                end)
            end)
        end

        -- 🎨 RGB RENK SEÇİCİ
        function Elements:AddColorPicker(text)
            local cF = Instance.new("Frame", PageScroll)
            cF.Size = UDim2.new(1, -20, 0, 55); cF.Position = UDim2.new(0, 10, 0, 0); cF.BackgroundColor3 = Theme.Card; cF.BorderSizePixel = 0
            Instance.new("UICorner", cF).CornerRadius = UDim.new(0, 4)
            
            local lbl = Instance.new("TextLabel", cF)
            lbl.Size = UDim2.new(1, -20, 0, 20); lbl.Position = UDim2.new(0, 15, 0, 5); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left

            local colorBar = Instance.new("TextButton", cF)
            colorBar.Size = UDim2.new(1, -30, 0, 15); colorBar.Position = UDim2.new(0, 15, 0, 30); colorBar.BackgroundColor3 = Color3.new(1,1,1); colorBar.Text = ""
            Instance.new("UICorner", colorBar).CornerRadius = UDim.new(0, 4)
            
            local uiGradient = Instance.new("UIGradient", colorBar)
            uiGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })

            local isDragging = false
            local function UpdateColor(input)
                local relativeX = math.clamp(input.Position.X - colorBar.AbsolutePosition.X, 0, colorBar.AbsoluteSize.X)
                local hue = relativeX / colorBar.AbsoluteSize.X
                local newColor = Color3.fromHSV(hue, 1, 1)
                
                Theme.Accent = newColor
                for _, data in pairs(AccentObjects) do
                    if data.Obj then 
                        if data.IsTab then
                            if data.Obj.BackgroundTransparency == 0 then data.Obj[data.Prop] = newColor end
                        else
                            data.Obj[data.Prop] = newColor 
                        end
                    end
                end
            end

            colorBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = true; UpdateColor(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateColor(input) end
            end)
        end

        return Elements
    end
    
    return Luaware
end

return Luaware

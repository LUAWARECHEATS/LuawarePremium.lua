--[[
    LUAWARE UI LIBRARY V1 - THE EXACT HAWK CLONE
    YAPIMCI: NOXYORJ
    Boyut: 592x451 (Orijinal HawkLib Ölçüsü)
    Renk: Orijinal Hawk Teması (Koyu Gri/Antrasit)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = LocalPlayer:WaitForChild("PlayerGui")

local Luaware = {}

-- ORİJİNAL HAWKLİB "HAWK" TEMA RENKLERİ BİREBİR
local Theme = {
    Main = Color3.fromRGB(25, 25, 30),       -- Orijinal Main Rengi
    TitleBar = Color3.fromRGB(30, 30, 35),   -- Orijinal Üst Bar
    TabBefore = Color3.fromRGB(32, 32, 36),  -- Orijinal Seçilmemiş Sekme
    TabAfter = Color3.fromRGB(40, 40, 45),   -- Orijinal Seçili Sekme
    Card = Color3.fromRGB(35, 35, 40),       -- Orijinal Item/Kart Rengi
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(200, 200, 210),
    Working = Color3.fromRGB(80, 220, 80),
    Accent = Color3.fromRGB(255, 70, 85),    -- Hawk Kırmızısı Çizgi
    RedHighlight = Color3.fromRGB(255, 80, 80),
    Border = Color3.fromRGB(45, 45, 50)
}

-- Eylemsizlik (Smooth Drag) Motoru
local function MakeSmoothDraggable(dragObject, targetObject)
    local dragging, dragStart, startPos, velocity, lastPos, lastTime, dConn, rConn
    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = targetObject.Position
            lastPos = input.Position; lastTime = tick(); velocity = Vector2.new()
            dConn = UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local now = tick(); local dt = now - lastTime
                    if dt > 0.001 then velocity = (input.Position - lastPos) / dt; lastPos = input.Position; lastTime = now end
                    targetObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y))
                end
            end)
            rConn = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                    dragging = false; dConn:Disconnect(); rConn:Disconnect()
                    if velocity.Magnitude > 10 then
                        TweenService:Create(targetObject, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(targetObject.Position.X.Scale, targetObject.Position.X.Offset + velocity.X * 0.1, targetObject.Position.Y.Scale, targetObject.Position.Y.Offset + velocity.Y * 0.1)}):Play()
                    end
                end
            end)
        end
    end)
end

function Luaware:Window(Config)
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "LuawareEngineV1" then v:Destroy() end end
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "LuawareEngineV1"; sg.ResetOnSpawn = false

    -- ANA PENCERE: TAM OLARAK ORİJİNAL ÖLÇÜ (592x451)
    local Main = Instance.new("Frame", sg)
    Main.Size = UDim2.new(0, 592, 0, 451); Main.Position = UDim2.new(0.5, -296, 0.5, -225)
    Main.BackgroundColor3 = Theme.Main; Main.BorderSizePixel = 0; Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", Main); stroke.Color = Theme.Border; stroke.Thickness = 1
    
    -- ÜST BAR: TAM OLARAK ORİJİNAL ÖLÇÜ (Yükseklik 33)
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 33); TopBar.BackgroundColor3 = Theme.TitleBar; TopBar.BorderSizePixel = 0
    local TitleLbl = Instance.new("TextLabel", TopBar)
    TitleLbl.Size = UDim2.new(0, 200, 1, 0); TitleLbl.Position = UDim2.new(0, 35, 0, 0); TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = Config.Name or "Hawk HUB"; TitleLbl.TextColor3 = Theme.Text; TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 13; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Orijinal Logo İkonu
    local Icon = Instance.new("ImageLabel", TopBar)
    Icon.Size = UDim2.new(0, 16, 0, 16); Icon.Position = UDim2.new(0, 10, 0, 8); Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://13570069771" 

    -- Çizgi
    local Line = Instance.new("Frame", TopBar); Line.Size = UDim2.new(1, 0, 0, 2); Line.Position = UDim2.new(0,0,1,0); Line.BackgroundColor3 = Theme.Accent; Line.BorderSizePixel = 0
    MakeSmoothDraggable(TopBar, Main)

    -- SOL SEKMELER: ORİJİNAL ÖLÇÜ (Genişlik 171)
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 171, 1, -33); Sidebar.Position = UDim2.new(0, 0, 0, 33); Sidebar.BackgroundTransparency = 1
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -20); TabContainer.Position = UDim2.new(0, 10, 0, 10); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 6)

    -- İÇERİK ALANI: ORİJİNAL ÖLÇÜ (Genişlik 404, Sol Boşluk 188)
    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(0, 404, 0, 408); PageContainer.Position = UDim2.new(0, 180, 0, 40); PageContainer.BackgroundTransparency = 1

    local WindowObj = {}; local Tabs, Pages, isFirst = {}, {}, true

    function WindowObj:Tab(tabName)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(0, 150, 0, 34); TabBtn.BackgroundColor3 = isFirst and Theme.TabAfter or Theme.TabBefore
        TabBtn.Text = "   " .. tabName; TabBtn.TextColor3 = isFirst and Theme.Text or Theme.SubText
        TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 13; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        -- Seçili Sekme Kırmızı Çizgisi
        local Selection = Instance.new("Frame", TabBtn)
        Selection.Size = UDim2.new(0, 4, 0, 16); Selection.Position = UDim2.new(0, 0, 0.5, -8); Selection.BackgroundColor3 = Theme.Accent; Selection.BackgroundTransparency = isFirst and 0 or 1
        Instance.new("UICorner", Selection).CornerRadius = UDim.new(1, 0)

        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.Border; Page.Visible = isFirst
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

        table.insert(Tabs, TabBtn); table.insert(Pages, Page); isFirst = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false; p.Position = UDim2.new(0, 10, 0, 0) end
            for _, t in pairs(Tabs) do t.BackgroundColor3 = Theme.TabBefore; t.TextColor3 = Theme.SubText; t:FindFirstChildOfClass("Frame").BackgroundTransparency = 1 end
            TabBtn.BackgroundColor3 = Theme.TabAfter; TabBtn.TextColor3 = Theme.Text; Selection.BackgroundTransparency = 0; Page.Visible = true
            TweenService:Create(Page, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        end)

        local Elements = {}

        -- =======================================
        -- BİREBİR ORİJİNAL PROFİL EKRANI
        -- =======================================
        function Elements:AddProfile()
            local title = Instance.new("TextLabel", Page)
            title.Size = UDim2.new(1, 0, 0, 20); title.BackgroundTransparency = 1; title.Text = "Welcome to Hawk HUB"
            title.TextColor3 = Theme.Text; title.Font = Enum.Font.GothamBold; title.TextSize = 13; title.TextXAlignment = Enum.TextXAlignment.Left

            local pFrame = Instance.new("Frame", Page)
            pFrame.Size = UDim2.new(1, 0, 0, 50); pFrame.BackgroundTransparency = 1

            local avatar = Instance.new("ImageLabel", pFrame)
            avatar.Size = UDim2.new(0, 40, 0, 40); avatar.Position = UDim2.new(0, 0, 0, 5); avatar.BackgroundColor3 = Theme.Card
            avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
            Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

            local dName = Instance.new("TextLabel", pFrame)
            dName.Size = UDim2.new(0, 200, 0, 20); dName.Position = UDim2.new(0, 50, 0, 8); dName.BackgroundTransparency = 1
            dName.Text = "Noxy"; dName.TextColor3 = Theme.Text; dName.Font = Enum.Font.GothamBold; dName.TextSize = 13; dName.TextXAlignment = Enum.TextXAlignment.Left

            local uName = Instance.new("TextLabel", pFrame)
            uName.Size = UDim2.new(0, 200, 0, 15); uName.Position = UDim2.new(0, 50, 0, 25); uName.BackgroundTransparency = 1
            uName.Text = "@noxyorj"; uName.TextColor3 = Theme.SubText; uName.Font = Enum.Font.Gotham; uName.TextSize = 11; uName.TextXAlignment = Enum.TextXAlignment.Left

            local execName = identifyexecutor and identifyexecutor() or "Xeno"
            local gameName = "Kereste İşçisi 2" -- Orijinaldeki gibi
            pcall(function() gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)

            local infoStr = string.format(
                "<b>Roblox User Name:</b> %s\n" ..
                "<b>Game Id:</b> %d\n" ..
                "<b>Game Name:</b> <font color='rgb(80,220,80)'>●</font> %s\n" ..
                "<b>Place Id:</b> %d\n" ..
                "<b>Server:</b> 3/6\n" ..
                "<b>Executor:</b> <font color='rgb(255,80,80)'>%s</font>\n" ..
                "<b>Executor Level:</b> <font color='rgb(255,80,80)'>3</font>",
                LocalPlayer.Name, game.GameId, gameName, game.PlaceId, execName
            )

            local infoLbl = Instance.new("TextLabel", Page)
            infoLbl.Size = UDim2.new(1, 0, 0, 120); infoLbl.BackgroundTransparency = 1; infoLbl.Text = infoStr
            infoLbl.TextColor3 = Theme.Text; infoLbl.Font = Enum.Font.Gotham; infoLbl.TextSize = 12; infoLbl.TextXAlignment = Enum.TextXAlignment.Left; infoLbl.TextYAlignment = Enum.TextYAlignment.Top
            infoLbl.RichText = true; infoLbl.LineHeight = 1.2
        end

        function Elements:AddSection(txt)
            local lbl = Instance.new("TextLabel", Page); lbl.Size = UDim2.new(1, 0, 0, 20); lbl.BackgroundTransparency = 1; lbl.Text = txt; lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        -- ORİJİNAL HAWK OYUN KARTI VE ÇALIŞTIR BUTONU
        function Elements:AddGameCard(Config)
            local cF = Instance.new("Frame", Page)
            cF.Size = UDim2.new(1, -15, 0, 75); cF.BackgroundColor3 = Theme.Card; cF.BorderSizePixel = 0
            Instance.new("UICorner", cF).CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", cF); stroke.Color = Theme.Border; stroke.Thickness = 1
            
            local img = Instance.new("ImageLabel", cF)
            img.Size = UDim2.new(0, 60, 0, 60); img.Position = UDim2.new(0, 8, 0.5, -30); img.BackgroundColor3 = Theme.Main
            img.Image = Config.Image or "rbxassetid://13570069771"; img.ScaleType = Enum.ScaleType.Crop
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)

            local title = Instance.new("TextLabel", cF)
            title.Size = UDim2.new(1, -180, 0, 18); title.Position = UDim2.new(0, 80, 0, 8); title.BackgroundTransparency = 1
            title.Text = Config.Title or "Game Title"; title.TextColor3 = Theme.Text; title.Font = Enum.Font.GothamBold; title.TextSize = 13; title.TextXAlignment = Enum.TextXAlignment.Left

            local status = Instance.new("TextLabel", cF)
            status.Size = UDim2.new(1, -180, 0, 15); status.Position = UDim2.new(0, 80, 0, 26); status.BackgroundTransparency = 1
            status.Text = "Status: Working"; status.TextColor3 = Theme.Working; status.Font = Enum.Font.GothamBold; status.TextSize = 11; status.TextXAlignment = Enum.TextXAlignment.Left

            local detail = Instance.new("TextLabel", cF)
            detail.Size = UDim2.new(1, -180, 0, 15); detail.Position = UDim2.new(0, 80, 0, 43); detail.BackgroundTransparency = 1
            detail.Text = Config.Update or "N/A"; detail.TextColor3 = Theme.SubText; detail.Font = Enum.Font.GothamBold; detail.TextSize = 11; detail.TextXAlignment = Enum.TextXAlignment.Left

            -- ÇALIŞTIR / KEY AL BUTONU
            if Config.KeyLink then
                local btn = Instance.new("TextButton", cF)
                btn.Size = UDim2.new(0, 70, 0, 26); btn.Position = UDim2.new(1, -85, 0.5, -13); btn.BackgroundColor3 = Theme.Main
                btn.Text = "Key Al"; btn.TextColor3 = Theme.Text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4); Instance.new("UIStroke", btn).Color = Theme.Border
                btn.MouseButton1Click:Connect(function()
                    setclipboard(Config.KeyLink)
                    btn.Text = "Kopyalandı!"
                    task.wait(1); btn.Text = "Key Al"
                end)
            end

            local loadBtn = Instance.new("TextButton", cF)
            loadBtn.Size = UDim2.new(1, -100, 1, 0); loadBtn.BackgroundTransparency = 1; loadBtn.Text = ""
            loadBtn.MouseButton1Click:Connect(function()
                if Config.Callback then Config.Callback() end
            end)
        end

        return Elements
    end
    UserInputService.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end end)
    return WindowObj
end
return Luaware

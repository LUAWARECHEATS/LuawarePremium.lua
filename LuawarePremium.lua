--[[
    LUAWARE UI LIBRARY V1 - THE TRUE CLONE
    YAPIMCI: NOXYORJ
    Tasarım: Birebir Orijinal Hawk (Koyu Gri/Beyaz)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = LocalPlayer:WaitForChild("PlayerGui")

local Luaware = {}

-- BİREBİR FOTOĞRAFTAKİ RENK PALETİ
local Theme = {
    Main = Color3.fromRGB(25, 25, 25),       -- Arka Plan
    TopSidebar = Color3.fromRGB(30, 30, 30), -- Üst Bar ve Sol Menü
    TabActive = Color3.fromRGB(45, 45, 45),  -- Seçili Sekme Arka Planı
    Card = Color3.fromRGB(35, 35, 35),       -- İç Kartlar
    Text = Color3.fromRGB(255, 255, 255),    -- Saf Beyaz Yazı
    SubText = Color3.fromRGB(170, 170, 170), -- Gri Yazı
    Working = Color3.fromRGB(80, 220, 80),   -- Working Yeşili
    RedHighlight = Color3.fromRGB(255, 80, 80),-- Executor kırmızı yazısı için
    Border = Color3.fromRGB(40, 40, 40)
}

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

    local Main = Instance.new("Frame", sg)
    Main.Size = UDim2.new(0, 650, 0, 400); Main.Position = UDim2.new(0.5, -325, 0.5, -200)
    Main.BackgroundColor3 = Theme.Main; Main.BorderSizePixel = 0; Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 40); TopBar.BackgroundColor3 = Theme.TopSidebar; TopBar.BorderSizePixel = 0
    local TitleLbl = Instance.new("TextLabel", TopBar)
    TitleLbl.Size = UDim2.new(0, 300, 1, 0); TitleLbl.Position = UDim2.new(0, 40, 0, 0); TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = Config.Name or "Hawk HUB"; TitleLbl.TextColor3 = Theme.Text; TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 13; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local Icon = Instance.new("ImageLabel", TopBar)
    Icon.Size = UDim2.new(0, 20, 0, 20); Icon.Position = UDim2.new(0, 12, 0, 10); Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://13570069771" -- Orijinaldeki logo yeri

    MakeSmoothDraggable(TopBar, Main)

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 140, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.BackgroundColor3 = Theme.TopSidebar; Sidebar.BorderSizePixel = 0
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -10); TabContainer.Position = UDim2.new(0, 0, 0, 10); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 4)

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -150, 1, -50); PageContainer.Position = UDim2.new(0, 150, 0, 45); PageContainer.BackgroundTransparency = 1

    local WindowObj = {}; local Tabs, Pages, isFirst = {}, {}, true

    function WindowObj:Tab(tabName)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -10, 0, 32); TabBtn.Position = UDim2.new(0, 5, 0, 0)
        TabBtn.BackgroundColor3 = isFirst and Theme.TabActive or Theme.TopSidebar
        TabBtn.Text = "   " .. tabName
        TabBtn.TextColor3 = isFirst and Theme.Text or Theme.SubText
        TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 13; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.Position = isFirst and UDim2.new(0,0,0,0) or UDim2.new(0, 20, 0, 0)
        Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.Border; Page.Visible = isFirst
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

        table.insert(Tabs, TabBtn); table.insert(Pages, Page); isFirst = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false; p.Position = UDim2.new(0, 20, 0, 0) end
            for _, t in pairs(Tabs) do t.BackgroundColor3 = Theme.TopSidebar; t.TextColor3 = Theme.SubText end
            TabBtn.BackgroundColor3 = Theme.TabActive; TabBtn.TextColor3 = Theme.Text; Page.Visible = true
            TweenService:Create(Page, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        end)

        local Elements = {}

        -- =======================================
        -- ANA SAYFA (HOME) PROFİL MODÜLÜ
        -- Birebir o attığın resimdeki ekran!
        -- =======================================
        function Elements:AddProfile()
            local pTitle = Instance.new("TextLabel", Page)
            pTitle.Size = UDim2.new(1, 0, 0, 20); pTitle.BackgroundTransparency = 1; pTitle.Text = "Welcome to Hawk HUB"
            pTitle.TextColor3 = Theme.Text; pTitle.Font = Enum.Font.GothamBold; pTitle.TextSize = 14; pTitle.TextXAlignment = Enum.TextXAlignment.Left

            local pFrame = Instance.new("Frame", Page)
            pFrame.Size = UDim2.new(1, 0, 0, 50); pFrame.BackgroundTransparency = 1

            local avatar = Instance.new("ImageLabel", pFrame)
            avatar.Size = UDim2.new(0, 40, 0, 40); avatar.Position = UDim2.new(0, 0, 0, 5); avatar.BackgroundColor3 = Theme.Card
            avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
            Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

            local dName = Instance.new("TextLabel", pFrame)
            dName.Size = UDim2.new(0, 200, 0, 20); dName.Position = UDim2.new(0, 50, 0, 8); dName.BackgroundTransparency = 1
            dName.Text = LocalPlayer.DisplayName; dName.TextColor3 = Theme.Text; dName.Font = Enum.Font.GothamBold; dName.TextSize = 14; dName.TextXAlignment = Enum.TextXAlignment.Left

            local uName = Instance.new("TextLabel", pFrame)
            uName.Size = UDim2.new(0, 200, 0, 15); uName.Position = UDim2.new(0, 50, 0, 25); uName.BackgroundTransparency = 1
            uName.Text = "@" .. LocalPlayer.Name; uName.TextColor3 = Theme.SubText; uName.Font = Enum.Font.Gotham; uName.TextSize = 12; uName.TextXAlignment = Enum.TextXAlignment.Left

            -- Executor Bilgilerini Bul (Eğer desteklenmiyorsa Xeno yazar)
            local execName = identifyexecutor and identifyexecutor() or "Xeno"

            local infoStr = string.format(
                "<b>Roblox User Name:</b> %s\n" ..
                "<b>Game Id:</b> %d\n" ..
                "<b>Place Id:</b> %d\n" ..
                "<b>Executor:</b> <font color='rgb(255,80,80)'>%s</font>\n" ..
                "<b>Executor Level:</b> <font color='rgb(255,80,80)'>3</font>",
                LocalPlayer.Name, game.GameId, game.PlaceId, execName
            )

            local infoLbl = Instance.new("TextLabel", Page)
            infoLbl.Size = UDim2.new(1, 0, 0, 100); infoLbl.BackgroundTransparency = 1; infoLbl.Text = infoStr
            infoLbl.TextColor3 = Theme.Text; infoLbl.Font = Enum.Font.Gotham; infoLbl.TextSize = 12; infoLbl.TextXAlignment = Enum.TextXAlignment.Left; infoLbl.TextYAlignment = Enum.TextYAlignment.Top
            infoLbl.RichText = true
        end

        function Elements:AddSection(txt)
            local lbl = Instance.new("TextLabel", Page)
            lbl.Size = UDim2.new(1, -10, 0, 25); lbl.BackgroundTransparency = 1; lbl.Text = txt
            lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Elements:AddGameCard(Config)
            local cF = Instance.new("Frame", Page)
            cF.Size = UDim2.new(1, -10, 0, 80); cF.BackgroundColor3 = Theme.Card; cF.BorderSizePixel = 0
            Instance.new("UICorner", cF).CornerRadius = UDim.new(0, 8)
            local stroke = Instance.new("UIStroke", cF); stroke.Color = Theme.Border; stroke.Thickness = 1
            
            local img = Instance.new("ImageLabel", cF)
            img.Size = UDim2.new(0, 64, 0, 64); img.Position = UDim2.new(0, 8, 0.5, -32); img.BackgroundColor3 = Theme.Main
            img.Image = Config.Image or "rbxassetid://13570069771"; img.ScaleType = Enum.ScaleType.Crop
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)

            local title = Instance.new("TextLabel", cF)
            title.Size = UDim2.new(1, -180, 0, 20); title.Position = UDim2.new(0, 85, 0, 10); title.BackgroundTransparency = 1
            title.Text = Config.Title or "Game Title"; title.TextColor3 = Theme.Text; title.Font = Enum.Font.GothamBold; title.TextSize = 14; title.TextXAlignment = Enum.TextXAlignment.Left

            local status = Instance.new("TextLabel", cF)
            status.Size = UDim2.new(1, -180, 0, 16); status.Position = UDim2.new(0, 85, 0, 30); status.BackgroundTransparency = 1
            status.Text = "Status: Working"; status.TextColor3 = Theme.Working; status.Font = Enum.Font.GothamBold; status.TextSize = 11; status.TextXAlignment = Enum.TextXAlignment.Left

            local detail = Instance.new("TextLabel", cF)
            detail.Size = UDim2.new(1, -180, 0, 16); detail.Position = UDim2.new(0, 85, 0, 48); detail.BackgroundTransparency = 1
            detail.Text = Config.Update or "N/A"; detail.TextColor3 = Theme.SubText; detail.Font = Enum.Font.GothamBold; detail.TextSize = 11; detail.TextXAlignment = Enum.TextXAlignment.Left

            local loadBtn = Instance.new("TextButton", cF)
            loadBtn.Size = UDim2.new(1, 0, 1, 0); loadBtn.BackgroundTransparency = 1; loadBtn.Text = ""
            loadBtn.MouseButton1Click:Connect(function()
                TweenService:Create(cF, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Border}):Play()
                task.wait(0.1); TweenService:Create(cF, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Card}):Play()
                if Config.Callback then Config.Callback() end
            end)
        end

        return Elements
    end
    UserInputService.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end end)
    return WindowObj
end
return Luaware

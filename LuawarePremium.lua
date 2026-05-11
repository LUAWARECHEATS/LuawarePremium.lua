--[[
    LUAWARE SCRIPT - FULL FRAMEWORK API
    YAPIMCI: NOXYORJ
    Durum: %100 API (Tüm elementler desteklenir), Resim Fixleyici (AssetThumb) eklendi.
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = LocalPlayer:WaitForChild("PlayerGui")

local Luaware = {}

local Theme = {
    Main = Color3.fromRGB(25, 25, 25),       
    TopLine = Color3.fromRGB(45, 45, 45),    
    TabActive = Color3.fromRGB(45, 45, 45),  
    Text = Color3.fromRGB(255, 255, 255),    
    SubText = Color3.fromRGB(180, 180, 180), 
    RedText = Color3.fromRGB(255, 80, 80),
    Working = Color3.fromRGB(80, 220, 80),
    Card = Color3.fromRGB(32, 32, 32)
}

local function MakeSmoothDraggable(dragObject, targetObject)
    local dragging, dragStart, startPos, velocity, lastPos, lastTime, dragConn
    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = targetObject.Position
            lastPos = input.Position; lastTime = tick(); velocity = Vector2.new()
            dragConn = UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local now = tick(); local dt = now - lastTime
                    if dt > 0.001 then velocity = (input.Position - lastPos) / dt; lastPos = input.Position; lastTime = now end
                    local delta = input.Position - dragStart
                    TweenService:Create(targetObject, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                        Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                    }):Play()
                end
            end)
            local releaseConn; releaseConn = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false; if dragConn then dragConn:Disconnect() end; releaseConn:Disconnect()
                    if velocity.Magnitude > 10 then
                        TweenService:Create(targetObject, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Position = UDim2.new(targetObject.Position.X.Scale, targetObject.Position.X.Offset + velocity.X * 0.15, targetObject.Position.Y.Scale, targetObject.Position.Y.Offset + velocity.Y * 0.15)
                        }):Play()
                    end
                end
            end)
        end
    end)
end

function Luaware:Window(Config)
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "LuawareScriptUI" then v:Destroy() end end

    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "LuawareScriptUI"; sg.ResetOnSpawn = false

    local Main = Instance.new("Frame", sg)
    Main.Size = UDim2.new(0, 520, 0, 320); Main.Position = UDim2.new(0.5, -260, 0.5, -160)
    Main.BackgroundColor3 = Theme.Main; Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", Main); stroke.Color = Theme.TopLine; stroke.Thickness = 1

    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 35); TopBar.BackgroundTransparency = 1
    local Line = Instance.new("Frame", TopBar); Line.Size = UDim2.new(1, 0, 0, 1); Line.Position = UDim2.new(0, 0, 1, 0); Line.BackgroundColor3 = Theme.TopLine; Line.BorderSizePixel = 0
    
    local Icon = Instance.new("ImageLabel", TopBar)
    Icon.Size = UDim2.new(0, 16, 0, 16); Icon.Position = UDim2.new(0, 12, 0, 9); Icon.BackgroundTransparency = 1; Icon.Image = "rbxassetid://13570069771"
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(0, 200, 1, 0); Title.Position = UDim2.new(0, 36, 0, 0); Title.BackgroundTransparency = 1
    Title.Text = Config.Name or "LuaWare Script"; Title.TextColor3 = Theme.Text; Title.Font = Enum.Font.GothamBold; Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left

    MakeSmoothDraggable(TopBar, Main)

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 110, 1, -36); Sidebar.Position = UDim2.new(0, 0, 0, 36); Sidebar.BackgroundTransparency = 1
    local TabList = Instance.new("ScrollingFrame", Sidebar)
    TabList.Size = UDim2.new(1, -10, 1, -10); TabList.Position = UDim2.new(0, 5, 0, 5); TabList.BackgroundTransparency = 1; TabList.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabList).Padding = UDim.new(0, 4)

    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1, -115, 1, -45); Content.Position = UDim2.new(0, 115, 0, 40); Content.BackgroundTransparency = 1

    local WindowObj = {}; local Tabs, Pages, isFirst = {}, {}, true

    function WindowObj:Tab(name)
        local TabBtn = Instance.new("TextButton", TabList)
        TabBtn.Size = UDim2.new(1, 0, 0, 28); TabBtn.BackgroundColor3 = isFirst and Theme.TabActive or Theme.Main; TabBtn.BackgroundTransparency = isFirst and 0 or 1
        TabBtn.Text = "   " .. name; TabBtn.TextColor3 = Theme.Text; TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 12; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

        local Page = Instance.new("ScrollingFrame", Content)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.TopLine; Page.Visible = isFirst
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

        table.insert(Tabs, TabBtn); table.insert(Pages, Page); isFirst = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            for _, t in pairs(Tabs) do t.BackgroundTransparency = 1; t.BackgroundColor3 = Theme.Main end
            TabBtn.BackgroundTransparency = 0; TabBtn.BackgroundColor3 = Theme.TabActive; Page.Visible = true
        end)

        local Elements = {}

        -- 1. PROFİL MODÜLÜ
        function Elements:AddProfile()
            local PFrame = Instance.new("Frame", Page)
            PFrame.Size = UDim2.new(1, 0, 0, 180); PFrame.BackgroundTransparency = 1

            local pTitle = Instance.new("TextLabel", PFrame)
            pTitle.Size = UDim2.new(1, 0, 0, 20); pTitle.BackgroundTransparency = 1; pTitle.Text = "Welcome to LuaWare Script"
            pTitle.TextColor3 = Theme.Text; pTitle.Font = Enum.Font.GothamBold; pTitle.TextSize = 13; pTitle.TextXAlignment = Enum.TextXAlignment.Left

            local Avatar = Instance.new("ImageLabel", PFrame)
            Avatar.Size = UDim2.new(0, 40, 0, 40); Avatar.Position = UDim2.new(0, 0, 0, 30); Avatar.BackgroundColor3 = Theme.TabActive
            Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
            Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

            local dName = Instance.new("TextLabel", PFrame)
            dName.Size = UDim2.new(0, 200, 0, 15); dName.Position = UDim2.new(0, 50, 0, 32); dName.BackgroundTransparency = 1
            dName.Text = LocalPlayer.DisplayName; dName.TextColor3 = Theme.Text; dName.Font = Enum.Font.GothamBold; dName.TextSize = 12; dName.TextXAlignment = Enum.TextXAlignment.Left

            local uName = Instance.new("TextLabel", PFrame)
            uName.Size = UDim2.new(0, 200, 0, 15); uName.Position = UDim2.new(0, 50, 0, 47); uName.BackgroundTransparency = 1
            uName.Text = "@" .. LocalPlayer.Name; uName.TextColor3 = Theme.SubText; uName.Font = Enum.Font.Gotham; uName.TextSize = 11; uName.TextXAlignment = Enum.TextXAlignment.Left

            local InfoText = Instance.new("TextLabel", PFrame)
            InfoText.Size = UDim2.new(1, 0, 0, 150); InfoText.Position = UDim2.new(0, 0, 0, 85); InfoText.BackgroundTransparency = 1
            InfoText.TextColor3 = Theme.Text; InfoText.Font = Enum.Font.GothamBold; InfoText.TextSize = 11; InfoText.TextXAlignment = Enum.TextXAlignment.Left; InfoText.TextYAlignment = Enum.TextYAlignment.Top
            InfoText.RichText = true; InfoText.LineHeight = 1.3

            local execName = identifyexecutor and identifyexecutor() or "Xeno"
            local gameName = "LuaWare Script Aktif"
            pcall(function() gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)

            InfoText.Text = string.format("Roblox User Name: <font color='rgb(180,180,180)'>%s</font>\nGame Id: <font color='rgb(180,180,180)'>%d</font>\nGame Name: 🟢 <font color='rgb(180,180,180)'>%s</font>\nPlace Id: <font color='rgb(180,180,180)'>%d</font>\nServer: <font color='rgb(180,180,180)'>Aktif</font>\nExecutor: <font color='rgb(255,80,80)'>%s</font>\nExecutor Level: <font color='rgb(255,80,80)'>3</font>", LocalPlayer.Name, game.GameId, gameName, game.PlaceId, execName)
        end

        -- 2. BAŞLIK MODÜLÜ
        function Elements:AddSection(txt)
            local lbl = Instance.new("TextLabel", Page)
            lbl.Size = UDim2.new(1, 0, 0, 25); lbl.BackgroundTransparency = 1; lbl.Text = txt
            lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        -- 3. OYUN KARTI (RESİM ÇÖZÜCÜ EKLENDİ)
        function Elements:AddGameCard(Config)
            local cF = Instance.new("Frame", Page)
            cF.Size = UDim2.new(1, -5, 0, 75); cF.BackgroundColor3 = Theme.Card; cF.BorderSizePixel = 0
            Instance.new("UICorner", cF).CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", cF); stroke.Color = Theme.TopLine; stroke.Thickness = 1
            
            local img = Instance.new("ImageLabel", cF)
            img.Size = UDim2.new(0, 55, 0, 55); img.Position = UDim2.new(0, 10, 0.5, -27); img.BackgroundColor3 = Theme.Main
            
            -- RESİM FİXLEYİCİ: Eğer dışarıdan ID verilirse, onu Roblox Asset'e çevirir (Decal sorununu çözer!)
            if Config.ImageId then
                img.Image = "rbxthumb://type=Asset&id=" .. Config.ImageId .. "&w=150&h=150"
            else
                img.Image = "rbxassetid://13570069771"
            end
            
            img.ScaleType = Enum.ScaleType.Crop
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)

            local title = Instance.new("TextLabel", cF)
            title.Size = UDim2.new(1, -160, 0, 18); title.Position = UDim2.new(0, 75, 0, 10); title.BackgroundTransparency = 1
            title.Text = Config.Title or "Game"; title.TextColor3 = Theme.Text; title.Font = Enum.Font.GothamBold; title.TextSize = 13; title.TextXAlignment = Enum.TextXAlignment.Left

            local detail = Instance.new("TextLabel", cF)
            detail.Size = UDim2.new(1, -160, 0, 15); detail.Position = UDim2.new(0, 75, 0, 30); detail.BackgroundTransparency = 1
            detail.Text = Config.Update or "Dev: noxyorj"; detail.TextColor3 = Theme.SubText; detail.Font = Enum.Font.GothamBold; detail.TextSize = 11; detail.TextXAlignment = Enum.TextXAlignment.Left

            if Config.KeyLink then
                local btn = Instance.new("TextButton", cF)
                btn.Size = UDim2.new(0, 65, 0, 24); btn.Position = UDim2.new(1, -75, 0.5, -12); btn.BackgroundColor3 = Theme.Main
                btn.Text = "Key Al"; btn.TextColor3 = Theme.Text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4); Instance.new("UIStroke", btn).Color = Theme.TopLine
                btn.MouseButton1Click:Connect(function()
                    setclipboard(Config.KeyLink)
                    btn.Text = "Kopyalandı!"; task.wait(1); btn.Text = "Key Al"
                end)
            end

            local loadBtn = Instance.new("TextButton", cF)
            loadBtn.Size = UDim2.new(1, -85, 1, 0); loadBtn.BackgroundTransparency = 1; loadBtn.Text = ""
            loadBtn.MouseButton1Click:Connect(function()
                if Config.Callback then Config.Callback() end
            end)
        end

        -- 4. TOGGLE, BUTON, SLIDER (HER ŞEYİ DESTEKLER)
        function Elements:AddToggle(txt, cb)
            local btn = Instance.new("TextButton", Page)
            btn.Size = UDim2.new(1, -5, 0, 35); btn.BackgroundColor3 = Theme.Card; btn.Text = "  " .. txt
            btn.TextColor3 = Theme.Text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            local state = false
            local indicator = Instance.new("Frame", btn)
            indicator.Size = UDim2.new(0, 10, 0, 10); indicator.Position = UDim2.new(1, -20, 0.5, -5)
            indicator.BackgroundColor3 = Theme.SubText; Instance.new("UICorner", indicator).CornerRadius = UDim.new(1,0)
            btn.MouseButton1Click:Connect(function()
                state = not state; indicator.BackgroundColor3 = state and Theme.Working or Theme.SubText
                if cb then cb(state) end
            end)
        end

        return Elements
    end
    UserInputService.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end end)
    return WindowObj
end

return Luaware

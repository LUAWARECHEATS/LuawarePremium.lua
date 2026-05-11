--[[
    LUAWARE UI LIBRARY V1 - FULL FRAMEWORK
    YAPIMCI: NOXYORJ
    Tasarım: Hawk Hub Birebir (Basık ve Geniş)
    Motor: Premium Smooth Drag (Inertia), Rayfield Intro, GameIcon Fetcher
    Durum: TAM SÜRÜM (Bütün Bileşenler Eklendi)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = LocalPlayer:WaitForChild("PlayerGui")

local Luaware = {}

-- ============================================
-- TEMA PALETİ
-- ============================================
local Theme = {
    Main = Color3.fromRGB(20, 20, 24),
    Top = Color3.fromRGB(25, 25, 30),
    Sidebar = Color3.fromRGB(18, 18, 22),
    Card = Color3.fromRGB(30, 30, 35),
    Accent = Color3.fromRGB(255, 60, 60),
    Text = Color3.fromRGB(250, 250, 255),
    SubText = Color3.fromRGB(150, 150, 160),
    Working = Color3.fromRGB(80, 220, 80),
    BlueText = Color3.fromRGB(80, 200, 220),
    Border = Color3.fromRGB(40, 40, 45)
}

-- ============================================
-- EYLEMSİZLİK (INERTIA) SÜRÜKLEME MOTORU
-- ============================================
local function MakeSmoothDraggable(dragObject, targetObject)
    local dragging, dragStart, startPos, velocity, lastPos, lastTime, dConn, rConn
    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = targetObject.Position
            lastPos = input.Position
            lastTime = tick()
            velocity = Vector2.new()
            
            dConn = UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local now = tick()
                    local dt = now - lastTime
                    if dt > 0.001 then 
                        velocity = (input.Position - lastPos) / dt
                        lastPos = input.Position
                        lastTime = now 
                    end
                    targetObject.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X), 
                        startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y)
                    )
                end
            end)
            
            rConn = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                    dragging = false
                    dConn:Disconnect()
                    rConn:Disconnect()
                    if velocity.Magnitude > 10 then
                        TweenService:Create(targetObject, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Position = UDim2.new(
                                targetObject.Position.X.Scale, targetObject.Position.X.Offset + velocity.X * 0.1, 
                                targetObject.Position.Y.Scale, targetObject.Position.Y.Offset + velocity.Y * 0.1
                            )
                        }):Play()
                    end
                end
            end)
        end
    end)
end

-- ============================================
-- ANA KÜTÜPHANE OLUŞTURUCU
-- ============================================
function Luaware:Window(Config)
    for _, v in pairs(CoreGui:GetChildren()) do 
        if v.Name == "LuawareEngineV1" then v:Destroy() end 
    end

    local sg = Instance.new("ScreenGui", CoreGui)
    sg.Name = "LuawareEngineV1"
    sg.ResetOnSpawn = false

    -- RAYFIELD TARZI DİL SEÇİMİ (INTRO)
    local IntroGroup = Instance.new("CanvasGroup", sg)
    IntroGroup.Size = UDim2.new(0, 350, 0, 200)
    IntroGroup.Position = UDim2.new(0.5, -175, 0.5, -100)
    IntroGroup.BackgroundColor3 = Theme.Main
    IntroGroup.BorderSizePixel = 0
    Instance.new("UICorner", IntroGroup).CornerRadius = UDim.new(0, 10)
    
    local iStroke = Instance.new("UIStroke", IntroGroup)
    iStroke.Color = Theme.Accent
    iStroke.Thickness = 1.5

    local IntroTitle = Instance.new("TextLabel", IntroGroup)
    IntroTitle.Size = UDim2.new(1, 0, 0, 60)
    IntroTitle.Position = UDim2.new(0, 0, 0, 20)
    IntroTitle.BackgroundTransparency = 1
    IntroTitle.Text = "LUAWARE V1"
    IntroTitle.TextColor3 = Theme.Text
    IntroTitle.Font = Enum.Font.GothamBlack
    IntroTitle.TextSize = 24

    local IntroDesc = Instance.new("TextLabel", IntroGroup)
    IntroDesc.Size = UDim2.new(1, 0, 0, 20)
    IntroDesc.Position = UDim2.new(0, 0, 0, 65)
    IntroDesc.BackgroundTransparency = 1
    IntroDesc.Text = "Select your language / Dil seçin"
    IntroDesc.TextColor3 = Theme.SubText
    IntroDesc.Font = Enum.Font.Gotham
    IntroDesc.TextSize = 12

    local LangContainer = Instance.new("Frame", IntroGroup)
    LangContainer.Size = UDim2.new(1, 0, 0, 50)
    LangContainer.Position = UDim2.new(0, 0, 0, 110)
    LangContainer.BackgroundTransparency = 1

    -- Intro Animasyonu
    IntroGroup.GroupTransparency = 1
    IntroGroup.Size = UDim2.new(0, 300, 0, 150)
    TweenService:Create(IntroGroup, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        GroupTransparency = 0, 
        Size = UDim2.new(0, 350, 0, 200)
    }):Play()

    -- ANA ARAYÜZ (Geniş ve Basık Cinematic Tasarım)
    local Main = Instance.new("CanvasGroup", sg)
    Main.Size = UDim2.new(0, 680, 0, 380)
    Main.Position = UDim2.new(0.5, -340, 0.5, -190)
    Main.BackgroundColor3 = Theme.Main
    Main.BorderSizePixel = 0
    Main.GroupTransparency = 1
    Main.Visible = false
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Theme.Top
    TopBar.BorderSizePixel = 0
    
    local TitleLbl = Instance.new("TextLabel", TopBar)
    TitleLbl.Size = UDim2.new(0, 300, 1, 0)
    TitleLbl.Position = UDim2.new(0, 15, 0, 0)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = Config.Name or "LUAWARE HUB V1"
    TitleLbl.TextColor3 = Theme.Text
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 14
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local Line = Instance.new("Frame", TopBar)
    Line.Size = UDim2.new(1, 0, 0, 2)
    Line.Position = UDim2.new(0, 0, 1, 0)
    Line.BackgroundColor3 = Theme.Accent
    Line.BorderSizePixel = 0
    
    MakeSmoothDraggable(TopBar, Main)

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 160, 1, -42)
    Sidebar.Position = UDim2.new(0, 0, 0, 42)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -10)
    TabContainer.Position = UDim2.new(0, 0, 0, 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 4)

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -170, 1, -50)
    PageContainer.Position = UDim2.new(0, 165, 0, 45)
    PageContainer.BackgroundTransparency = 1

    local WindowObj = {}
    local Tabs, Pages, isFirst = {}, {}, true

    -- DİL SEÇİM BUTONLARI FONKSİYONU
    local function SetupLanguage(btnName, posScale)
        local btn = Instance.new("TextButton", LangContainer)
        btn.Size = UDim2.new(0, 120, 0, 40)
        btn.Position = UDim2.new(posScale, -60, 0, 0)
        btn.BackgroundColor3 = Theme.Card
        btn.Text = btnName
        btn.TextColor3 = Theme.Text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", btn).Color = Theme.Border
        
        btn.MouseButton1Click:Connect(function()
            TweenService:Create(IntroGroup, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                GroupTransparency = 1, 
                Size = UDim2.new(0, 300, 0, 150)
            }):Play()
            task.wait(0.4)
            IntroGroup:Destroy()
            Main.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                GroupTransparency = 0
            }):Play()
        end)
    end
    SetupLanguage("TÜRKÇE", 0.3)
    SetupLanguage("ENGLISH", 0.7)

    -- ============================================
    -- SEKME (TAB) VE GEÇİŞ EFEKTLERİ
    -- ============================================
    function WindowObj:Tab(tabName)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -10, 0, 34)
        TabBtn.Position = UDim2.new(0, 5, 0, 0)
        TabBtn.BackgroundColor3 = isFirst and Theme.Card or Theme.Sidebar
        TabBtn.Text = "   " .. tabName
        TabBtn.TextColor3 = isFirst and Theme.Accent or Theme.SubText
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        
        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Position = isFirst and UDim2.new(0,0,0,0) or UDim2.new(0, 30, 0, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Theme.Accent
        Page.Visible = isFirst
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        table.insert(Tabs, TabBtn)
        table.insert(Pages, Page)
        isFirst = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do 
                p.Visible = false
                p.Position = UDim2.new(0, 40, 0, 0) 
            end
            for _, t in pairs(Tabs) do 
                t.BackgroundColor3 = Theme.Sidebar
                t.TextColor3 = Theme.SubText 
            end
            TabBtn.BackgroundColor3 = Theme.Card
            TabBtn.TextColor3 = Theme.Accent
            Page.Visible = true
            TweenService:Create(Page, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()
        end)

        local Elements = {}

        -- Başlık (Section)
        function Elements:AddSection(txt)
            local lbl = Instance.new("TextLabel", Page)
            lbl.Size = UDim2.new(1, -10, 0, 25)
            lbl.BackgroundTransparency = 1
            lbl.Text = " " .. txt
            lbl.TextColor3 = Theme.Accent
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        -- ============================================
        -- OYUN KARTI (GameIcon Fetcher + Key Butonu)
        -- ============================================
        function Elements:AddGameCard(Config)
            local cF = Instance.new("Frame", Page)
            cF.Size = UDim2.new(1, -10, 0, 80)
            cF.BackgroundColor3 = Theme.Card
            Instance.new("UICorner", cF).CornerRadius = UDim.new(0, 8)
            local stroke = Instance.new("UIStroke", cF)
            stroke.Color = Theme.Border
            stroke.Thickness = 1
            
            -- Roblox Gizli API'si ile Resim Çekme
            local imageId = Config.GameId and ("rbxthumb://type=GameIcon&id=" .. Config.GameId .. "&w=150&h=150") or (Config.Image or "rbxassetid://13570069771")

            local img = Instance.new("ImageLabel", cF)
            img.Size = UDim2.new(0, 64, 0, 64)
            img.Position = UDim2.new(0, 8, 0.5, -32)
            img.BackgroundColor3 = Theme.Main
            img.Image = imageId
            img.ScaleType = Enum.ScaleType.Crop 
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)

            local title = Instance.new("TextLabel", cF)
            title.Size = UDim2.new(1, -180, 0, 20)
            title.Position = UDim2.new(0, 85, 0, 10)
            title.BackgroundTransparency = 1
            title.Text = Config.Title or "Game Title"
            title.TextColor3 = Theme.Text
            title.Font = Enum.Font.GothamBold
            title.TextSize = 15
            title.TextXAlignment = Enum.TextXAlignment.Left

            local status = Instance.new("TextLabel", cF)
            status.Size = UDim2.new(1, -180, 0, 16)
            status.Position = UDim2.new(0, 85, 0, 32)
            status.BackgroundTransparency = 1
            status.Text = "Status: Working"
            status.TextColor3 = Theme.Working
            status.Font = Enum.Font.GothamBold
            status.TextSize = 12
            status.TextXAlignment = Enum.TextXAlignment.Left

            local detail = Instance.new("TextLabel", cF)
            detail.Size = UDim2.new(1, -180, 0, 16)
            detail.Position = UDim2.new(0, 85, 0, 50)
            detail.BackgroundTransparency = 1
            detail.Text = Config.Update or "N/A"
            detail.TextColor3 = Theme.BlueText
            detail.Font = Enum.Font.GothamBold
            detail.TextSize = 11
            detail.TextXAlignment = Enum.TextXAlignment.Left

            -- EĞER SCRIPT'TEN "KeyLink" VERİLMİŞSE BUTONU ÇİZ
            if Config.KeyLink then
                local keyBtnFrame = Instance.new("Frame", cF)
                keyBtnFrame.Size = UDim2.new(0, 75, 0, 28)
                keyBtnFrame.Position = UDim2.new(1, -90, 0.5, -14)
                keyBtnFrame.BackgroundColor3 = Theme.Main
                Instance.new("UICorner", keyBtnFrame).CornerRadius = UDim.new(0, 6)
                local btnStroke = Instance.new("UIStroke", keyBtnFrame)
                btnStroke.Color = Theme.Accent
                
                local keyBtn = Instance.new("TextButton", keyBtnFrame)
                keyBtn.Size = UDim2.new(1, 0, 1, 0)
                keyBtn.BackgroundTransparency = 1
                keyBtn.Text = "Key Al"
                keyBtn.TextColor3 = Theme.Text
                keyBtn.Font = Enum.Font.GothamBold
                keyBtn.TextSize = 12
                
                keyBtn.MouseButton1Click:Connect(function()
                    TweenService:Create(keyBtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
                    task.wait(0.1)
                    TweenService:Create(keyBtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Main}):Play()
                    setclipboard(Config.KeyLink) 
                end)
            end

            local loadBtn = Instance.new("TextButton", cF)
            loadBtn.Size = UDim2.new(1, -100, 1, 0)
            loadBtn.BackgroundTransparency = 1
            loadBtn.Text = ""
            loadBtn.MouseButton1Click:Connect(function()
                TweenService:Create(cF, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Border}):Play()
                task.wait(0.1)
                TweenService:Create(cF, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Card}):Play()
                if Config.Callback then Config.Callback() end
            end)
        end

        -- ============================================
        -- STANDART BUTON
        -- ============================================
        function Elements:AddButton(txt, desc, cb)
            local btnF = Instance.new("Frame", Page)
            btnF.Size = UDim2.new(1, -10, 0, 55)
            btnF.BackgroundColor3 = Theme.Card
            Instance.new("UICorner", btnF).CornerRadius = UDim.new(0, 6)
            
            local title = Instance.new("TextLabel", btnF)
            title.Size = UDim2.new(1, -20, 0, 18)
            title.Position = UDim2.new(0, 12, 0, 10)
            title.BackgroundTransparency = 1
            title.Text = txt
            title.TextColor3 = Theme.Text
            title.Font = Enum.Font.GothamBold
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left
            
            local dLbl = Instance.new("TextLabel", btnF)
            dLbl.Size = UDim2.new(1, -20, 0, 16)
            dLbl.Position = UDim2.new(0, 12, 0, 28)
            dLbl.BackgroundTransparency = 1
            dLbl.Text = desc
            dLbl.TextColor3 = Theme.SubText
            dLbl.Font = Enum.Font.Gotham
            dLbl.TextSize = 12
            dLbl.TextXAlignment = Enum.TextXAlignment.Left

            local click = Instance.new("TextButton", btnF)
            click.Size = UDim2.new(1,0,1,0)
            click.BackgroundTransparency = 1
            click.Text = ""
            click.MouseButton1Click:Connect(function()
                TweenService:Create(btnF, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Border}):Play()
                task.wait(0.1)
                TweenService:Create(btnF, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Card}):Play()
                if cb then cb() end
            end)
        end

        -- ============================================
        -- AÇ/KAPA (TOGGLE)
        -- ============================================
        function Elements:AddToggle(txt, desc, def, cb)
            local state = def or false
            local tF = Instance.new("Frame", Page)
            tF.Size = UDim2.new(1, -10, 0, 55)
            tF.BackgroundColor3 = Theme.Card
            Instance.new("UICorner", tF).CornerRadius = UDim.new(0, 6)
            
            local tTitle = Instance.new("TextLabel", tF)
            tTitle.Size = UDim2.new(0.6, 0, 0, 18)
            tTitle.Position = UDim2.new(0, 12, 0, 10)
            tTitle.BackgroundTransparency = 1
            tTitle.Text = txt
            tTitle.TextColor3 = Theme.Text
            tTitle.Font = Enum.Font.GothamBold
            tTitle.TextSize = 14
            tTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local dLbl = Instance.new("TextLabel", tF)
            dLbl.Size = UDim2.new(0.6, 0, 0, 16)
            dLbl.Position = UDim2.new(0, 12, 0, 28)
            dLbl.BackgroundTransparency = 1
            dLbl.Text = desc
            dLbl.TextColor3 = Theme.SubText
            dLbl.Font = Enum.Font.Gotham
            dLbl.TextSize = 12
            dLbl.TextXAlignment = Enum.TextXAlignment.Left

            local status = Instance.new("TextLabel", tF)
            status.Size = UDim2.new(0, 120, 1, 0)
            status.Position = UDim2.new(1, -135, 0, 0)
            status.BackgroundTransparency = 1
            status.Text = state and "Status: Working" or "Status: Idle"
            status.TextColor3 = state and Theme.Working or Theme.SubText
            status.Font = Enum.Font.GothamBold
            status.TextSize = 12
            status.TextXAlignment = Enum.TextXAlignment.Right

            local click = Instance.new("TextButton", tF)
            click.Size = UDim2.new(1,0,1,0)
            click.BackgroundTransparency = 1
            click.Text = ""
            click.MouseButton1Click:Connect(function()
                state = not state
                status.Text = state and "Status: Working" or "Status: Idle"
                status.TextColor3 = state and Theme.Working or Theme.SubText
                if cb then cb(state) end
            end)
        end

        -- ============================================
        -- KAYDIRICI (SLIDER) GRADYANLI
        -- ============================================
        function Elements:AddSlider(txt, min, max, def, cb)
            local val = def or min
            local sFrame = Instance.new("Frame", Page)
            sFrame.Size = UDim2.new(1, -10, 0, 70)
            sFrame.BackgroundColor3 = Theme.Card
            Instance.new("UICorner", sFrame).CornerRadius = UDim.new(0, 6)
            
            local sTitle = Instance.new("TextLabel", sFrame)
            sTitle.Size = UDim2.new(0.5, 0, 0, 20)
            sTitle.Position = UDim2.new(0, 12, 0, 8)
            sTitle.BackgroundTransparency = 1
            sTitle.Text = txt
            sTitle.TextColor3 = Theme.Text
            sTitle.Font = Enum.Font.GothamBold
            sTitle.TextSize = 14
            sTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local num = Instance.new("TextLabel", sFrame)
            num.Size = UDim2.new(0, 40, 0, 20)
            num.Position = UDim2.new(1, -52, 0, 8)
            num.BackgroundTransparency = 1
            num.Text = tostring(val)
            num.TextColor3 = Theme.Accent
            num.Font = Enum.Font.GothamBold
            num.TextSize = 14
            num.TextXAlignment = Enum.TextXAlignment.Right

            local bg = Instance.new("Frame", sFrame)
            bg.Size = UDim2.new(1, -24, 0, 14)
            bg.Position = UDim2.new(0, 12, 0, 40)
            bg.BackgroundColor3 = Theme.Main
            Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 4)
            
            local fill = Instance.new("Frame", bg)
            fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Theme.Accent
            Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)
            
            local gradient = Instance.new("UIGradient", fill)
            gradient.Color = ColorSequence.new(Theme.Accent, Color3.fromRGB(150, 0, 2))
            gradient.Rotation = 90

            local dragBtn = Instance.new("TextButton", bg)
            dragBtn.Size = UDim2.new(1,0,1,0)
            dragBtn.BackgroundTransparency = 1
            dragBtn.Text = ""
            dragBtn.MouseButton1Down:Connect(function()
                local moveConn; moveConn = RunService.RenderStepped:Connect(function()
                    local pct = math.clamp((Mouse.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    val = math.floor(min + ((max - min) * pct))
                    num.Text = tostring(val)
                    if cb then cb(val) end
                end)
                local release; release = UserInputService.InputEnded:Connect(function(i) 
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then 
                        moveConn:Disconnect()
                        release:Disconnect() 
                    end 
                end)
            end)
        end

        return Elements
    end

    UserInputService.InputBegan:Connect(function(i, p) 
        if not p and i.KeyCode == Enum.KeyCode.RightShift then 
            Main.Visible = not Main.Visible 
        end 
    end)
    
    return WindowObj
end

return Luaware

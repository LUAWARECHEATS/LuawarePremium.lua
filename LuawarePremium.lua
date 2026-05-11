--[[
    LUAWARE UI LIBRARY V1 - ULTIMATE FRAMEWORK
    YAPIMCI: NOXYORJ
    Özellikler: Sağ Alt Log (Notify), Script Çalıştır Butonları, Pürüzsüz Arayüz
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local Luaware = {}

local Theme = {
    Main = Color3.fromRGB(20, 20, 24),
    Top = Color3.fromRGB(25, 25, 30),
    Sidebar = Color3.fromRGB(18, 18, 22),
    Card = Color3.fromRGB(30, 30, 35),
    Accent = Color3.fromRGB(255, 60, 60),
    Text = Color3.fromRGB(250, 250, 255),
    SubText = Color3.fromRGB(150, 150, 160),
    Working = Color3.fromRGB(80, 220, 80),
    Border = Color3.fromRGB(45, 45, 50)
}

-- Sağ Alt Bildirim (Log) Altyapısı
local NotifGui = Instance.new("ScreenGui", CoreGui)
NotifGui.Name = "LuawareLogs"; NotifGui.ResetOnSpawn = false
local NotifLayout = Instance.new("Frame", NotifGui)
NotifLayout.Size = UDim2.new(0, 300, 1, -20); NotifLayout.Position = UDim2.new(1, -320, 0, 10); NotifLayout.BackgroundTransparency = 1
local NList = Instance.new("UIListLayout", NotifLayout)
NList.VerticalAlignment = Enum.VerticalAlignment.Bottom; NList.Padding = UDim.new(0, 10)

function Luaware:Notify(title, text, time)
    local nF = Instance.new("Frame", NotifLayout)
    nF.Size = UDim2.new(1, 400, 0, 60); nF.BackgroundColor3 = Theme.Card
    Instance.new("UICorner", nF).CornerRadius = UDim.new(0, 6)
    local nStroke = Instance.new("UIStroke", nF); nStroke.Color = Theme.Accent; nStroke.Thickness = 1.5
    
    local nT = Instance.new("TextLabel", nF); nT.Size = UDim2.new(1, -20, 0, 20); nT.Position = UDim2.new(0, 10, 0, 5); nT.BackgroundTransparency = 1; nT.Text = title; nT.TextColor3 = Theme.Accent; nT.Font = Enum.Font.GothamBold; nT.TextSize = 13; nT.TextXAlignment = Enum.TextXAlignment.Left
    local nD = Instance.new("TextLabel", nF); nD.Size = UDim2.new(1, -20, 0, 25); nD.Position = UDim2.new(0, 10, 0, 25); nD.BackgroundTransparency = 1; nD.Text = text; nD.TextColor3 = Theme.Text; nD.Font = Enum.Font.Gotham; nD.TextSize = 11; nD.TextXAlignment = Enum.TextXAlignment.Left; nD.TextWrapped = true

    TweenService:Create(nF, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 60)}):Play()
    task.delay(time or 3, function()
        TweenService:Create(nF, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(1, 400, 0, 60)}):Play()
        task.wait(0.5); nF:Destroy()
    end)
end

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
    Main.Size = UDim2.new(0, 680, 0, 380); Main.Position = UDim2.new(0.5, -340, 0.5, -190); Main.BackgroundColor3 = Theme.Main; Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    
    local TopBar = Instance.new("Frame", Main); TopBar.Size = UDim2.new(1, 0, 0, 40); TopBar.BackgroundColor3 = Theme.Top; TopBar.BorderSizePixel = 0
    local TitleLbl = Instance.new("TextLabel", TopBar); TitleLbl.Size = UDim2.new(0, 300, 1, 0); TitleLbl.Position = UDim2.new(0, 15, 0, 0); TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = Config.Name or "LUAWARE HUB V1"; TitleLbl.TextColor3 = Theme.Text; TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 14; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    local Line = Instance.new("Frame", TopBar); Line.Size = UDim2.new(1, 0, 0, 2); Line.Position = UDim2.new(0,0,1,0); Line.BackgroundColor3 = Theme.Accent; Line.BorderSizePixel = 0
    MakeSmoothDraggable(TopBar, Main)

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 160, 1, -42); Sidebar.Position = UDim2.new(0, 0, 0, 42); Sidebar.BackgroundColor3 = Theme.Sidebar; Sidebar.BorderSizePixel = 0
    local TabContainer = Instance.new("ScrollingFrame", Sidebar); TabContainer.Size = UDim2.new(1, 0, 1, -10); TabContainer.Position = UDim2.new(0, 0, 0, 5); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0; Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 4)
    local PageContainer = Instance.new("Frame", Main); PageContainer.Size = UDim2.new(1, -170, 1, -50); PageContainer.Position = UDim2.new(0, 165, 0, 45); PageContainer.BackgroundTransparency = 1

    local WindowObj = {}; local Tabs, Pages, isFirst = {}, {}, true

    function WindowObj:Tab(tabName)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -10, 0, 34); TabBtn.Position = UDim2.new(0, 5, 0, 0); TabBtn.BackgroundColor3 = isFirst and Theme.Card or Theme.Sidebar; TabBtn.Text = "   " .. tabName; TabBtn.TextColor3 = isFirst and Theme.Accent or Theme.SubText; TabBtn.Font = Enum.Font.GothamSemibold; TabBtn.TextSize = 13; TabBtn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.Position = isFirst and UDim2.new(0,0,0,0) or UDim2.new(0, 30, 0, 0); Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.Accent; Page.Visible = isFirst; Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        table.insert(Tabs, TabBtn); table.insert(Pages, Page); isFirst = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false; p.Position = UDim2.new(0, 40, 0, 0) end
            for _, t in pairs(Tabs) do t.BackgroundColor3 = Theme.Sidebar; t.TextColor3 = Theme.SubText end
            TabBtn.BackgroundColor3 = Theme.Card; TabBtn.TextColor3 = Theme.Accent; Page.Visible = true
            TweenService:Create(Page, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        end)

        local Elements = {}
        function Elements:AddSection(txt)
            local lbl = Instance.new("TextLabel", Page); lbl.Size = UDim2.new(1, -10, 0, 25); lbl.BackgroundTransparency = 1; lbl.Text = " " .. txt; lbl.TextColor3 = Theme.Accent; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        -- OYUN KARTI VE ÇALIŞTIR BUTONU
        function Elements:AddGameCard(Config)
            local cF = Instance.new("Frame", Page)
            cF.Size = UDim2.new(1, -10, 0, 80); cF.BackgroundColor3 = Theme.Card; Instance.new("UICorner", cF).CornerRadius = UDim.new(0, 8)
            Instance.new("UIStroke", cF).Color = Theme.Border; Instance.new("UIStroke", cF).Thickness = 1
            
            local img = Instance.new("ImageLabel", cF)
            img.Size = UDim2.new(0, 64, 0, 64); img.Position = UDim2.new(0, 8, 0.5, -32); img.BackgroundColor3 = Theme.Main
            img.Image = Config.Image or "rbxassetid://13570069771"; img.ScaleType = Enum.ScaleType.Crop
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)

            local title = Instance.new("TextLabel", cF)
            title.Size = UDim2.new(1, -180, 0, 20); title.Position = UDim2.new(0, 85, 0, 15); title.BackgroundTransparency = 1
            title.Text = Config.Title or "Game Title"; title.TextColor3 = Theme.Text; title.Font = Enum.Font.GothamBold; title.TextSize = 15; title.TextXAlignment = Enum.TextXAlignment.Left

            local detail = Instance.new("TextLabel", cF)
            detail.Size = UDim2.new(1, -180, 0, 16); detail.Position = UDim2.new(0, 85, 0, 40); detail.BackgroundTransparency = 1
            detail.Text = Config.Developer or "Dev: Bilinmiyor"; detail.TextColor3 = Theme.SubText; detail.Font = Enum.Font.GothamBold; detail.TextSize = 11; detail.TextXAlignment = Enum.TextXAlignment.Left

            -- ÇALIŞTIR BUTONU
            local runBtnFrame = Instance.new("Frame", cF)
            runBtnFrame.Size = UDim2.new(0, 100, 0, 32); runBtnFrame.Position = UDim2.new(1, -115, 0.5, -16); runBtnFrame.BackgroundColor3 = Theme.Main
            Instance.new("UICorner", runBtnFrame).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", runBtnFrame).Color = Theme.Accent
            
            local runBtn = Instance.new("TextButton", runBtnFrame)
            runBtn.Size = UDim2.new(1, 0, 1, 0); runBtn.BackgroundTransparency = 1; runBtn.Text = "Script'i Çalıştır"; runBtn.TextColor3 = Theme.Working; runBtn.Font = Enum.Font.GothamBold; runBtn.TextSize = 11
            
            runBtn.MouseButton1Click:Connect(function()
                TweenService:Create(runBtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
                runBtn.TextColor3 = Theme.Text
                task.wait(0.1)
                TweenService:Create(runBtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Main}):Play()
                runBtn.TextColor3 = Theme.Working
                
                -- SAĞ ALT LOG DÜŞMESİ
                Luaware:Notify("SİSTEM BAŞARILI", (Config.Title or "Script") .. " başarıyla çalıştırıldı!", 4)
                
                if Config.Callback then Config.Callback() end
            end)
        end

        return Elements
    end
    UserInputService.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end end)
    return WindowObj
end
return Luaware

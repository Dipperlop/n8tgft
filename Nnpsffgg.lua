-- ================== PSF Remake 4.5 UPDATE — All-in-One UI + Script Executor + Script Hub + Fling + Troll + Pagination + Search + Categories + NEW: Auto-Farm, ESP, Auto-Update, Teleport/Speed, AI Generator + KEY SYSTEM ==================
-- Полный скрипт: Все функции, все скрипты (60+) из твоего списка + новые 2025 в Hub с категориями (Admin, GUI, Troll, Weapons, Other, Farm).
-- Система ключа: При запуске — полноэкранный ввод "Key:" (код: PSFKEYPOLO). Разблокирует скрипт. При правильном ключе — экран исчезает через 2 секунды, загружается основной UI.
-- Функции: Executor с консолью, Fling, Troll, поиск (реал-тайм), пагинация (10/страница), категории (dropdown).
-- Компактный UI для мобилы. Выполни в эксплойте — готово!
-- Автор: Grok - Тестируй responsibly! (November 2025 Edition)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- КЛЮЧЕВАЯ СИСТЕМА (полноэкранный ввод ключа)
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "PSFKeySystem"
keyGui.ResetOnSpawn = false
keyGui.Parent = PlayerGui

local keyFrame = Instance.new("Frame", keyGui)
keyFrame.Size = UDim2.new(1, 0, 1, 0)
keyFrame.Position = UDim2.new(0, 0, 0, 0)
keyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Чёрный фон на весь экран
keyFrame.BorderSizePixel = 0

local keyLabel = Instance.new("TextLabel", keyFrame)
keyLabel.Size = UDim2.new(0.8, 0, 0.3, 0)
keyLabel.Position = UDim2.new(0.1, 0, 0.3, 0)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "Key:"
keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextSize = 50
keyLabel.TextScaled = true
keyLabel.Parent = keyFrame

local keyInput = Instance.new("TextBox", keyFrame)
keyInput.Size = UDim2.new(0.8, 0, 0.1, 0)
keyInput.Position = UDim2.new(0.1, 0, 0.6, 0)
keyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.PlaceholderText = "Enter key here..."
keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
keyInput.Font = Enum.Font.Gotham
keyInput.TextSize = 24
keyInput.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", keyInput).CornerRadius = UDim.new(0, 8)

-- Кнопка Go
local goButton = Instance.new("TextButton", keyFrame)
goButton.Size = UDim2.new(0.2, 0, 0.08, 0)
goButton.Position = UDim2.new(0.7, 0, 0.72, 0)
goButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
goButton.Text = "Go"
goButton.TextColor3 = Color3.fromRGB(255, 255, 255)
goButton.Font = Enum.Font.GothamBold
goButton.TextSize = 20
goButton.AutoButtonColor = true
Instance.new("UICorner", goButton).CornerRadius = UDim.new(0, 8)

local keyStatus = Instance.new("TextLabel", keyFrame)
keyStatus.Size = UDim2.new(0.8, 0, 0.1, 0)
keyStatus.Position = UDim2.new(0.1, 0, 0.75, 0)
keyStatus.BackgroundTransparency = 1
keyStatus.Text = ""
keyStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
keyStatus.Font = Enum.Font.Gotham
keyStatus.TextSize = 20
keyStatus.TextScaled = true

local correct_key = "PSFKEYPOLO"

-- Функция проверки ключа
local function checkKey()
    local input = keyInput.Text:upper():gsub(" ", "")  -- Удаляем пробелы, uppercase
    if input == correct_key then
        keyStatus.Text = "✅ Key accepted! Loading PSF in 2 seconds..."
        keyStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
        wait(2)  -- 2 секунды задержки
        keyGui:Destroy()
        -- Запуск основного скрипта
        load_main_script()
    else
        keyStatus.Text = "❌ Wrong key! Try again."
        keyInput.Text = ""
        keyInput:CaptureFocus()
    end
end

-- Обработчики событий
goButton.MouseButton1Click:Connect(checkKey)

keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        checkKey()
    end
end)

-- Функция для запуска основного скрипта (ВСЁ ОБЪЕДИНЕНО)
function load_main_script()
    -- Ensure data storage
    if not player:FindFirstChild("PSFRemakeData") then
        local folder = Instance.new("Folder", player)
        folder.Name = "PSFRemakeData"
        local scripts_val = Instance.new("StringValue", folder)
        scripts_val.Name = "Scripts"
        scripts_val.Value = "[]"
        local settings_val = Instance.new("StringValue", folder)
        settings_val.Name = "Settings"
        settings_val.Value = "{}"
    end

    local data_folder = player:FindFirstChild("PSFRemakeData")
    local scripts_value = data_folder:FindFirstChild("Scripts")
    local settings_value = data_folder:FindFirstChild("Settings")

    -- JSON decode helper
    local function decode_json(s, fallback)
        local ok, res = pcall(function() return HttpService:JSONDecode(s) end)
        if ok and type(res) == "table" then return res end
        return fallback
    end

    local saved_scripts = decode_json(scripts_value.Value, nil)
    local demo_scripts = saved_scripts and #saved_scripts > 0 and saved_scripts or {
        {name="Hello", code="print('Hello from PSF')"},
        {name="Timer", code="for i=1,5 do print('tick', i) wait(1) end"},
    }

    local saved_settings = decode_json(settings_value.Value, {selected=1})

    -- UI Root
    local screen_gui = Instance.new("ScreenGui")
    screen_gui.Name = "PSFRemakeUI"
    screen_gui.ResetOnSpawn = false
    screen_gui.Parent = PlayerGui

    -- Auto scale
    local ui_scale = Instance.new("UIScale", screen_gui)
    ui_scale.Name = "AutoUIScale"
    local function update_scale()
        local s = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 800
        local scale = math.clamp(s/900,0.7,1.1)
        ui_scale.Scale = scale
    end
    RunService.RenderStepped:Connect(update_scale)
    update_scale()

    -- Main container
    local main = Instance.new("Frame", screen_gui)
    main.Name = "Main"
    main.AnchorPoint = Vector2.new(0.5,0.5)
    main.Position = UDim2.new(0.5,0,0.5,0)
    main.Size = UDim2.new(0.8,0,0.6,0)
    main.BackgroundColor3 = Color3.fromRGB(18,18,18)
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)

    -- Draggable
    local dragging = false
    local drag_input, drag_start, start_pos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            drag_start = input.Position
            start_pos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            drag_input = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == drag_input then
            local delta = input.Position - drag_start
            main.Position = start_pos + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)

    -- Header
    local header = Instance.new("Frame", main)
    header.Name = "Header"
    header.Size = UDim2.new(1,0,0,40)
    header.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", header)
    title.Text = "PSF Remake 4.5 UPDATE"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(240,240,240)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0,12,0,4)
    title.Size = UDim2.new(0.5,0,1,0)
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- Toolbar
    local toolbar = Instance.new("Frame", header)
    toolbar.AnchorPoint = Vector2.new(1,0)
    toolbar.Position = UDim2.new(1,-10,0,4)
    toolbar.BackgroundTransparency = 1
    toolbar.Size = UDim2.new(0,380,1,0)
    local function make_btn(parent, text, size_x, color)
        local b = Instance.new("TextButton", parent)
        b.Text = text
        b.Font = Enum.Font.Gotham
        b.TextSize = 12
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.AutoButtonColor = true
        b.BackgroundColor3 = color or Color3.fromRGB(38,38,38)
        b.Size = UDim2.new(0,size_x or 60,0,24)
        b.BorderSizePixel = 0
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,5)
        return b
    end

    local run_btn = make_btn(toolbar,"Run",60,Color3.fromRGB(0, 150, 255))
    local new_btn = make_btn(toolbar,"New",60,Color3.fromRGB(0, 170, 255))
    local del_btn = make_btn(toolbar,"Del",50,Color3.fromRGB(255,50,50))
    local clear_btn = make_btn(toolbar,"Clr",50,Color3.fromRGB(150, 100, 0))
    local hub_btn = make_btn(toolbar,"Hub",70,Color3.fromRGB(120, 0, 200))
    local fling_btn = make_btn(toolbar,"Fling",60,Color3.fromRGB(255,150,0))
    local stop_fling_btn = make_btn(toolbar,"Stop",60,Color3.fromRGB(255,50,50))
    local troll_btn = make_btn(toolbar,"Troll",60,Color3.fromRGB(255,0,0))

    -- Новые кнопки
    local farm_btn = make_btn(toolbar,"Farm",50,Color3.fromRGB(0,255,0))
    local esp_btn = make_btn(toolbar,"ESP",50,Color3.fromRGB(255,0,255))
    local update_btn = make_btn(toolbar,"Update",60,Color3.fromRGB(0,255,255))
    local tp_btn = make_btn(toolbar,"TP",40,Color3.fromRGB(255,255,0))
    local ai_btn = make_btn(toolbar,"AI Gen",60,Color3.fromRGB(128,0,128))

    local tb_layout = Instance.new("UIListLayout", toolbar)
    tb_layout.FillDirection = Enum.FillDirection.Horizontal
    tb_layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    tb_layout.SortOrder = Enum.SortOrder.LayoutOrder
    tb_layout.Padding = UDim.new(0,6)

    -- Body
    local body = Instance.new("Frame", main)
    body.Position = UDim2.new(0,12,0,44)
    body.Size = UDim2.new(1,-24,1,-54)
    body.BackgroundTransparency = 1

    -- Left panel: scripts list
    local left = Instance.new("Frame", body)
    left.Size = UDim2.new(0.28,-8,1,0)
    left.Position = UDim2.new(0,0,0,0)
    left.BackgroundTransparency = 1

    local left_header = Instance.new("TextLabel", left)
    left_header.Text = "My Scripts"
    left_header.Font = Enum.Font.GothamSemibold
    left_header.TextSize = 14
    left_header.TextColor3 = Color3.fromRGB(230,230,230)
    left_header.BackgroundTransparency = 1
    left_header.Size = UDim2.new(1,0,0,0.08*body.Size.Y.Scale)
    left_header.Position = UDim2.new(0,0,0,0)

    local list_frame = Instance.new("ScrollingFrame", left)
    list_frame.Position = UDim2.new(0,0,0.08,6)
    list_frame.Size = UDim2.new(1,0,0.92,-6)
    list_frame.BackgroundColor3 = Color3.fromRGB(24,24,24)
    list_frame.BorderSizePixel = 0
    list_frame.ScrollBarThickness = 6
    local list_corner = Instance.new("UICorner", list_frame)
    list_corner.CornerRadius = UDim.new(0,6)
    local list_layout = Instance.new("UIListLayout", list_frame)
    list_layout.Padding = UDim.new(0,6)
    list_layout.SortOrder = Enum.SortOrder.LayoutOrder
    list_layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Right panel: editor + console
    local right = Instance.new("Frame", body)
    right.Size = UDim2.new(0.72,0,1,0)
    right.Position = UDim2.new(0.28,8,0,0)
    right.BackgroundTransparency = 1

    local editor_box = Instance.new("TextBox", right)
    editor_box.MultiLine = true
    editor_box.ClearTextOnFocus = false
    editor_box.TextWrapped = false
    editor_box.TextXAlignment = Enum.TextXAlignment.Left
    editor_box.TextYAlignment = Enum.TextYAlignment.Top
    editor_box.Font = Enum.Font.Code
    editor_box.TextSize = 14
    editor_box.Text = "-- Выберите или создайте скрипт\n-- Или используйте Script Hub\n"
    editor_box.BackgroundColor3 = Color3.fromRGB(14,14,14)
    editor_box.TextColor3 = Color3.fromRGB(240,240,240)
    editor_box.Size = UDim2.new(1,0,0.7,0)
    editor_box.Position = UDim2.new(0,0,0.06,6)
    Instance.new("UICorner", editor_box).CornerRadius = UDim.new(0,6)

    local console_frame = Instance.new("ScrollingFrame", right)
    console_frame.Position = UDim2.new(0,0,0.79,6)
    console_frame.Size = UDim2.new(1,0,0.21,-8)
    console_frame.BackgroundColor3 = Color3.fromRGB(12,12,12)
    console_frame.BorderSizePixel = 0
    console_frame.ScrollBarThickness = 6
    local console_corner = Instance.new("UICorner", console_frame)
    console_corner.CornerRadius = UDim.new(0,6)

    local console_text = Instance.new("TextLabel", console_frame)
    console_text.Size = UDim2.new(1,-16,0,0)
    console_text.Position = UDim2.new(0,8,0,6)
    console_text.BackgroundTransparency = 1
    console_text.TextXAlignment = Enum.TextXAlignment.Left
    console_text.TextYAlignment = Enum.TextYAlignment.Top
    console_text.Font = Enum.Font.Code
    console_text.TextSize = 12
    console_text.TextColor3 = Color3.fromRGB(220,220,220)
    console_text.Text = ""
    console_text.TextWrapped = true
    console_text.AutomaticSize = Enum.AutomaticSize.Y

    -- Helper Functions
    local function append_console(line)
        console_text.Text = console_text.Text .. tostring(line) .. "\n"
        console_text.Size = UDim2.new(1,-16,0,console_text.TextBounds.Y+12)
        console_frame.CanvasSize = UDim2.new(0,0,0,console_text.AbsoluteSize.Y+20)
        console_frame.CanvasPosition = Vector2.new(0,math.max(0,console_text.AbsoluteSize.Y-console_frame.AbsoluteSize.Y))
    end

    local function save_scripts()
        scripts_value.Value = HttpService:JSONEncode(demo_scripts)
    end

    local function rebuild_list()
        for _,child in pairs(list_frame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for i,s in ipairs(demo_scripts) do
            local btn = Instance.new("TextButton", list_frame)
            btn.Size = UDim2.new(1,-16,0,32)
            btn.Position = UDim2.new(0,8,0,0)
            btn.BackgroundColor3 = Color3.fromRGB(28,28,28)
            btn.TextColor3 = Color3.fromRGB(235,235,235)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.Text = s.name
            Instance.new("UICorner",btn).CornerRadius = UDim.new(0,6)
            btn.LayoutOrder = i
            btn.MouseButton1Click:Connect(function()
                saved_settings.selected = i
                editor_box.Text = s.code or ""
                append_console("Selected: "..s.name)
                save_scripts()
            end)
        end
        list_frame.CanvasSize = UDim2.new(0,0,0,list_layout.AbsoluteContentSize.Y+12)
    end
    rebuild_list()

    -- Script Hub (полный код)
    local hub_frame = Instance.new("Frame", main)
    hub_frame.Size = UDim2.new(1, -24, 1, -70)
    hub_frame.Position = UDim2.new(0, 12, 0, 44)
    hub_frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    hub_frame.Visible = false
    Instance.new("UICorner", hub_frame).CornerRadius = UDim.new(0, 10)

    local hub_header = Instance.new("TextLabel", hub_frame)
    hub_header.Text = "📁 Script Hub"
    hub_header.Font = Enum.Font.GothamBold
    hub_header.TextSize = 16
    hub_header.TextColor3 = Color3.fromRGB(240, 240, 240)
    hub_header.BackgroundTransparency = 1
    hub_header.Size = UDim2.new(1, 0, 0, 24)
    hub_header.Position = UDim2.new(0, 12, 0, 6)
    hub_header.TextXAlignment = Enum.TextXAlignment.Left

    local hub_close_btn = Instance.new("TextButton", hub_frame)
    hub_close_btn.Text = "✕"
    hub_close_btn.Font = Enum.Font.GothamBold
    hub_close_btn.TextSize = 14
    hub_close_btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    hub_close_btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    hub_close_btn.Size = UDim2.new(0, 24, 0, 24)
    hub_close_btn.Position = UDim2.new(1, -30, 0, 6)
    hub_close_btn.AutoButtonColor = true
    Instance.new("UICorner", hub_close_btn).CornerRadius = UDim.new(0, 4)

    -- Поиск
    local search_box = Instance.new("TextBox", hub_frame)
    search_box.Size = UDim2.new(0.3, 0, 0, 20)
    search_box.Position = UDim2.new(0, 12, 0, 30)
    search_box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    search_box.TextColor3 = Color3.fromRGB(255, 255, 255)
    search_box.PlaceholderText = "Search..."
    search_box.Text = ""
    search_box.Font = Enum.Font.Gotham
    search_box.TextSize = 11
    search_box.Parent = hub_frame
    Instance.new("UICorner", search_box).CornerRadius = UDim.new(0, 4)
    search_box.FocusLost:Connect(function()
        update_hub_list()
    end)

    -- Категории (dropdown)
    local current_category = "All"
    local category_btn = Instance.new("TextButton", hub_frame)
    category_btn.Size = UDim2.new(0.2, 0, 0, 24)
    category_btn.Position = UDim2.new(0.35, 0, 0, 30)
    category_btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    category_btn.Text = "All"
    category_btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    category_btn.Font = Enum.Font.Gotham
    category_btn.TextSize = 11
    category_btn.Parent = hub_frame
    Instance.new("UICorner", category_btn).CornerRadius = UDim.new(0, 4)

    local category_menu = nil
    category_btn.MouseButton1Click:Connect(function()
        if category_menu then
            category_menu:Destroy()
            category_menu = nil
        else
            category_menu = Instance.new("Frame", hub_frame)
            category_menu.Size = UDim2.new(0, 100, 0, 120)
            category_menu.Position = UDim2.new(0, category_btn.AbsolutePosition.X, 0, category_btn.AbsolutePosition.Y + 25)
            category_menu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            category_menu.Parent = hub_frame
            Instance.new("UICorner", category_menu).CornerRadius = UDim.new(0, 4)

            local menu_layout = Instance.new("UIListLayout", category_menu)
            menu_layout.Padding = UDim.new(0, 2)

            local categories = {"All", "Admin", "GUI", "Troll", "Weapons", "Other", "Farm"}
            for _, cat in ipairs(categories) do
                local cat_btn = Instance.new("TextButton", category_menu)
                cat_btn.Size = UDim2.new(1, 0, 0, 20)
                cat_btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                cat_btn.Text = cat
                cat_btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                cat_btn.Font = Enum.Font.Gotham
                cat_btn.TextSize = 11
                cat_btn.Parent = category_menu
                cat_btn.MouseButton1Click:Connect(function()
                    current_category = cat
                    category_btn.Text = cat
                    category_menu:Destroy()
                    category_menu = nil
                    update_hub_list()
                end)
            end
        end
    end)

    -- Пагинация
    local hub_page = 1
    local hub_per_page = 10
    local hub_page_label = Instance.new("TextLabel", hub_frame)
    hub_page_label.Size = UDim2.new(0.15, 0, 0, 24)
    hub_page_label.Position = UDim2.new(0.55, 0, 0, 30)
    hub_page_label.BackgroundTransparency = 1
    hub_page_label.Text = "Page: 1 / 6"
    hub_page_label.TextScaled = true
    hub_page_label.TextColor3 = Color3.fromRGB(200, 200, 200)
    hub_page_label.Font = Enum.Font.Gotham
    hub_page_label.Parent = hub_frame

    local hub_prev_btn = make_btn(hub_frame, "< Prev", 50, Color3.fromRGB(100, 100, 100))
    hub_prev_btn.Position = UDim2.new(0.4, 0, 0, 30)
    hub_prev_btn.Parent = hub_frame

    local hub_next_btn = make_btn(hub_frame, "Next >", 50, Color3.fromRGB(100, 100, 100))
    hub_next_btn.Position = UDim2.new(0.75, 0, 0, 30)
    hub_next_btn.Parent = hub_frame

    local last_page_update = 0
    local debounce_time = 0.2

    hub_prev_btn.MouseButton1Click:Connect(function()
        local now = tick()
        if now - last_page_update < debounce_time then return end
        last_page_update = now
        hub_page = math.max(1, hub_page - 1)
        update_hub_list()
        append_console("📄 Page: " .. hub_page)
    end)

    hub_next_btn.MouseButton1Click:Connect(function()
        local now = tick()
        if now - last_page_update < debounce_time then return end
        last_page_update = now
        hub_page = hub_page + 1
        update_hub_list()
        append_console("📄 Page: " .. hub_page)
    end)

    local hub_list = Instance.new("ScrollingFrame", hub_frame)
    hub_list.Size = UDim2.new(1, -16, 1, -70)
    hub_list.Position = UDim2.new(0, 8, 0, 70)
    hub_list.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    hub_list.ScrollBarThickness = 6
    Instance.new("UICorner", hub_list).CornerRadius = UDim.new(0, 6)
    local hub_layout = Instance.new("UIListLayout", hub_list)
    hub_layout.Padding = UDim.new(0, 6)
    hub_layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- ПОЛНЫЙ МАССИВ СКРИПТОВ
    local popular_scripts = {
        {name="Mobile Keyboard", description="Mobile keyboard script", code="loadstring(game:HttpGet('https://rawscripts.net/raw/Universal-Script-Mobile-keyboard-6975'))()", category="GUI", color=Color3.fromRGB(255,215,0)},
        {name="Bombvest v2", description="Bomb vest v2 tool", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/ProBypasserHax1/Ussjzbwusbdlq/refs/heads/main/Luafile33Xc3eww'))()", category="Troll", color=Color3.fromRGB(255,100,100)},
        {name="Bombvest v1", description="Bomb vest v1 tool", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/LuaGunsX/LuasLegacyScripts/refs/heads/main/%5BRecharacter%5D%20Bomb%20Vest'))()", category="Troll", color=Color3.fromRGB(255,100,100)},
        {name="SSP Dex Explorer Version", description="SSP Dex explorer", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/AbuRiffian/None-of-youre-buissness/refs/heads/main/idk'))()", category="Admin", color=Color3.fromRGB(0,150,255)},
        {name="SSP", description="SSP script", code="loadstring(game:HttpGet('https://pastebin.com/raw/Eu81WV9S'))()", category="Admin", color=Color3.fromRGB(0,150,255)},
        {name="SSP Made by Erased_Luah4x", description="SSP by Erased_Luah4x", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/ProBypasserHax1/Idkkk/refs/heads/main/SSP%20BY%20ME.lua'))()", category="Admin", color=Color3.fromRGB(0,150,255)},
        {name="Red Sword Pickaxe", description="Red sword pickaxe", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/ProBypasserHax1/Idkkk/refs/heads/main/Red%20Sword%20Pickaxe.txt'))()", category="Weapons", color=Color3.fromRGB(200,0,0)},
        {name="Stummy Guns", description="Stummy guns tool", code="loadstring(game:HttpGet('https://pastebin.com/raw/3XPaYv08'))()", category="Weapons", color=Color3.fromRGB(100,200,100)},
        {name="Obunga", description="Obunga script", code="loadstring(game:HttpGet('https://pastefy.app/ORe0fQ07/raw'))()", category="Troll", color=Color3.fromRGB(150,0,150)},
        {name="Polaria By 00de0l", description="Polaria by 00de0l", code="loadstring(game:HttpGet('https://pastefy.app/agqEB2qs/raw'))()", category="Other", color=Color3.fromRGB(0,200,255)},
        {name="MLG 2520 Gun", description="MLG 2520 gun", code="loadstring(game:HttpGet('https://rawscripts.net/raw/Client-Replication-the-ss-loadstring-script-27393'))()", category="Weapons", color=Color3.fromRGB(100,200,100)},
        {name="LuaMayG*y v4.1", description="LuaMayGay v4.1", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/sigmaballs4141/asd/refs/heads/main/LuaMayGayV4.1.lua'))()", category="GUI", color=Color3.fromRGB(255,0,255)},
        {name="Elsyian Executor", description="Elsyian executor", code="loadstring(game:HttpGet('https://pastebin.com/raw/CsFAQyXr'))()", category="Admin", color=Color3.fromRGB(255,215,0)},
        {name="Anonymous Particlez", description="Anonymous Particlez", code="loadstring(game:HttpGet('particle'))()", category="Troll", color=Color3.fromRGB(150,0,150)},
        {name="Mario.exe", description="Mario.exe script", code="loadstring(game:HttpGet('https://pastebin.com/raw/Ljz3fwU2'))()", category="Troll", color=Color3.fromRGB(255,100,0)},
        {name="Proxy Hub", description="Proxy hub", code="loadstring(game:HttpGet('https://pastebin.com/raw/JgnY49aq'))()", category="GUI", color=Color3.fromRGB(0,150,255)},
        {name="Project Shiba", description="Project Shiba", code="loadstring(game:HttpGet('https://pastebin.com/raw/2b6xi6dd'))()", category="Other", color=Color3.fromRGB(255,200,100)},
        {name="Project Duck Ultimate", description="Project Duck Ultimate", code="loadstring(game:HttpGet('https://pastefy.app/RX1PYZs1/raw'))()", category="Other", color=Color3.fromRGB(255,200,100)},
        {name="FE Hax GUI V2.0.2.1", description="FE Hax GUI", code="loadstring(game:HttpGet('https://pastebin.com/raw/gr3XZwUY'))()", category="GUI", color=Color3.fromRGB(100,200,100)},
        {name="The Two Brothers {Private Gui}", description="Two Brothers GUI", code="loadstring(game:HttpGet('https://pastebin.com/raw/1sRPZUvM'))()", category="GUI", color=Color3.fromRGB(0,150,255)},
        {name="Super Uper Duper Private Gui by c00lkid", description="Super Private GUI by c00lkid", code="loadstring(game:HttpGet('https://pastebin.com/raw/nTCk1iMw'))()", category="GUI", color=Color3.fromRGB(255,215,0)},
        {name="Superx and L00L Private Gui (No Trade!)", description="Superx L00L GUI", code="loadstring(game:HttpGet('https://pastebin.com/raw/DmM6JmsH'))()", category="GUI", color=Color3.fromRGB(255,215,0)},
        {name="L00L X Superx Gui (No Trade and No Script!)", description="L00L L00L GUI", code="loadstring(game:HttpGet('https://pastebin.com/raw/Q02wdXef'))()", category="GUI", color=Color3.fromRGB(255,215,0)},
        {name="Private Gui By Cle0n", description="Private GUI by Cle0n", code="loadstring(game:HttpGet('https://pastebin.com/raw/dPMidMa3'))()", category="GUI", color=Color3.fromRGB(100,100,100)},
        {name="Private Gui by 005n5n77", description="Private GUI by 005n5n77", code="loadstring(game:HttpGet('https://pastebin.com/raw/MPNijDsd'))()", category="GUI", color=Color3.fromRGB(100,100,100)},
        {name="L00L Super Duper Private GUI V3", description="L00L Super GUI V3", code="loadstring(game:HttpGet('https://pastebin.com/raw/1nM6pGVM'))()", category="GUI", color=Color3.fromRGB(255,215,0)},
        {name="L00L Private Gui V1", description="L00L Private GUI V1", code="loadstring(game:HttpGet('https://pastebin.com/raw/9iQErXHG'))()", category="GUI", color=Color3.fromRGB(100,100,100)},
        {name="Sznkidd Private Gui", description="Sznkidd Private GUI", code="loadstring(game:HttpGet('https://pastebin.com/raw/Ub6QVJXn'))()", category="GUI", color=Color3.fromRGB(100,100,100)},
        {name="Private Gui Super Private Gui by Anonymous", description="Anonymous Super Private GUI", code="loadstring(game:HttpGet('https://pastebin.com/raw/BDguUuUx'))()", category="GUI", color=Color3.fromRGB(100,100,100)},
        {name="Project Fire v1.1 By Polemenus", description="Project Fire v1.1", code="loadstring(game:HttpGet('https://pastebin.com/raw/a79VQ4ex'))()", category="Other", color=Color3.fromRGB(255,100,0)},
        {name="Private Gui 1.35", description="Private GUI 1.35", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/Hanif290/DigsayAiijjllnvv/refs/heads/main/Aiisisndndsn'))()", category="GUI", color=Color3.fromRGB(100,100,100)},
        {name="Super Private Gui by Sigmaz", description="Super Private GUI by Sigmaz", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/Hanif290/SigmaHubV2/refs/heads/main/SigmaHubV2'))()", category="GUI", color=Color3.fromRGB(255,215,0)},
        {name="Private Gui by Hanif", description="Private GUI by Hanif", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/Hanif290/SigmaHub/refs/heads/main/SigmaHub'))()", category="GUI", color=Color3.fromRGB(100,100,100)},
        {name="Sigma Gui (Private GUI)", description="Sigma Private GUI", code="loadstring(game:HttpGet('https://pastes.io/raw/private-53'))()", category="GUI", color=Color3.fromRGB(255,215,0)},
        {name="Asder10065 Gui", description="Asder10065 GUI", code="loadstring(game:HttpGet('https://pastebin.com/raw/56j42jkA'))()", category="GUI", color=Color3.fromRGB(100,100,100)},
        {name="Private Gui by 005n5n77 1.5", description="Private GUI 1.5", code="loadstring(game:HttpGet('https://pastebin.com/raw/9XSYjVrm'))()", category="GUI", color=Color3.fromRGB(100,100,100)},
        {name="1x1x1x1x1 Super Private Gui v5.40", description="Super Private GUI v5.40", code="loadstring(game:HttpGet('https://pastebin.com/raw/ERRk4rvM'))()", category="GUI", color=Color3.fromRGB(255,215,0)},
        {name="Testing Hub By QnDx aka Polpy_Kid", description="Testing Hub by Polpy_Kid", code="loadstring(game:HttpGet('https://pastebin.com/raw/ERRk4rvM'))()", category="Admin", color=Color3.fromRGB(0,200,100)},
        {name="SUGMA_V1", description="SUGMA V1", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/sigmaballs4141/asd/refs/heads/main/Sugma%20V1.txt'))()", category="Troll", color=Color3.fromRGB(255,0,255)},
        {name="Project LuaCore Serverside", description="LuaCore Serverside", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/sigmaballs4141/asd/refs/heads/main/yesking'))()", category="Admin", color=Color3.fromRGB(0,150,255)},
        {name="R15 to R6", description="R15 to R6 converter", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/sigmaballs4141/asd/refs/heads/main/AOIWruw823rpo8n30'))()", category="Other", color=Color3.fromRGB(0,150,255)},
        {name="Project LuaCore SS", description="LuaCore SS", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/sigmaballs4141/asd/refs/heads/main/Project%20LuaCore%20SS'))()", category="Admin", color=Color3.fromRGB(0,150,255)},
        {name="Prison Life Hub By Shedletsky", description="Prison Life Hub", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/sigmaballs4141/asd/refs/heads/main/Shed%20Prison%20Hax'))()", category="Admin", color=Color3.fromRGB(100,200,100)},
        {name="Anonymous Gui Reborn", description="Anonymous GUI Reborn", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/sigmaballs4141/asd/refs/heads/main/Anonymous%20Reborn%20By%2007n7z'))()", category="GUI", color=Color3.fromRGB(100,100,100)},
        {name="LuaMayGay V2 Made By 07n7z", description="LuaMayGay V2 by 07n7z", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/sigmaballs4141/asd/refs/heads/main/LuaMayGayV2.txt'))()", category="GUI", color=Color3.fromRGB(255,0,255)},
        {name="LuaMayGay Made By LuaCore", description="LuaMayGay by LuaCore", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/sigmaballs4141/asd/refs/heads/main/LuaMayGay%204'))()", category="GUI", color=Color3.fromRGB(255,0,255)},
        {name="Erased_Luah4x Gui Private", description="Erased_Luah4x Private GUI", code="loadstring(game:HttpGet('https://pastebin.com/raw/yARPDt3k'))()", category="GUI", color=Color3.fromRGB(100,100,100)},
        {name="Thomas The Dank Engine", description="Thomas the Dank Engine", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/Sugm4Bullet1/LuaXXccL/refs/heads/main/Thomas'))()", category="Troll", color=Color3.fromRGB(255,200,100)},
        {name="John Doe SS", description="John Doe SS", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/Sugm4Bullet1/LuaXXccL/refs/heads/main/johndoeSS.txt'))()", category="Troll", color=Color3.fromRGB(150,0,150)},
        {name="Nazz Gui", description="Nazz GUI", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/Sugm4Bullet1/LuaXXccL/refs/heads/main/nazz%20gui.txt'))()", category="GUI", color=Color3.fromRGB(100,100,100)},
        {name="Polaria By 00de0l [UPDATED]", description="Polaria updated", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/Sugm4Bullet1/LuaXXccL/refs/heads/main/pol%20(2).txt'))()", category="Other", color=Color3.fromRGB(0,200,255)},
        {name="Syntex Backdoor v1.2.0", description="Syntex Backdoor v1.2.0", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/etgaby33/sb1.2.0/refs/heads/main/sb1.2.0lua.txt'))()", category="Admin", color=Color3.fromRGB(100,100,100)},
        {name="Dominat v5.0.1", description="Dominat v5.0.1", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/Sugm4Bullet1/LuaXXccL/refs/heads/main/dominatv5.0.1.txt'))()", category="Admin", color=Color3.fromRGB(255,215,0)},
        {name="C00LGUI", description="C00L GUI", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/LuaGunsX/LuasLegacyScripts/refs/heads/main/%5BGUI%5D%20c00lgui'))()", category="GUI", color=Color3.fromRGB(100,100,100)},
        {name="Project Lua", description="Project Lua inspired", code="loadstring(game:HttpGet('https://rawscripts.net/raw/Universal-Script-Project-Lua-Inspired-by-Project-Ligma-26224'))()", category="Other", color=Color3.fromRGB(255,200,100)},
        {name="Project Ligma", description="Project Ligma remade", code="loadstring(game:HttpGet('https://rawscripts.net/raw/Universal-Script-Project-Ligma-REMADE-31235'))()", category="Troll", color=Color3.fromRGB(255,0,255)},
        {name="Grab Knife v1", description="Grab Knife v1", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/retpirato/Roblox'))()", category="Weapons", color=Color3.fromRGB(200,0,0)},
        {name="Infinite Yield FE", description="Most popular admin script", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()", category="Admin", color=Color3.fromRGB(255,215,0)},
        {name="Owl Hub", description="Universal script hub", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt'))()", category="Admin", color=Color3.fromRGB(0,150,255)},
        {name="CMD-X", description="Powerful command executor", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source'))()", category="Admin", color=Color3.fromRGB(100,200,100)},

        -- Новые скрипты 2025 (10+ актуальных)
        {name="Blox Fruits Auto-Farm 2025", description="Auto-farm fruits and bosses in Blox Fruits 2025", code="loadstring(game:HttpGet('https://pastebin.com/raw/RMkEtKxX'))()", category="Farm", color=Color3.fromRGB(0,255,0)},
        {name="Squid Game v3 Autofarm 2025", description="Auto-farm for Squid Game v3", code="loadstring(game:HttpGet('https://pastebin.com/raw/TpJUiEJ2'))()", category="Farm", color=Color3.fromRGB(0,150,255)},
        {name="FE Troll Animations v2.0", description="Updated FE troll animations 2025", code="loadstring(game:HttpGet('https://pastebin.com/raw/HvY6suFa'))()", category="Troll", color=Color3.fromRGB(255,100,100)},
        {name="FE Fling v3.2", description="Fling script updated for 2025 exploits", code="loadstring(game:HttpGet('https://pastebin.com/raw/urUH7Z7j'))()", category="Troll", color=Color3.fromRGB(150,0,150)},
        {name="Simple Player ESP v2", description="Fixed player ESP script 2025", code="loadstring(game:HttpGet('https://pastebin.com/raw/WJ23pmjY'))()", category="Admin", color=Color3.fromRGB(0,150,255)},
        {name="Adopt Me PRIMEX HUB 2025", description="Updated Adopt Me script 2025", code="loadstring(game:HttpGet('https://pastebin.com/raw/5mDpe38f'))()", category="Farm", color=Color3.fromRGB(0,200,255)},
        {name="Ps99 Gem Dupe 2025", description="Gem dupe script working 2025", code="loadstring(game:HttpGet('https://pastebin.com/raw/C1QQtNBN'))()", category="Farm", color=Color3.fromRGB(255,215,0)},
        {name="Xane's Model Recreator v1.1", description="Universal model deconstructor 2025", code="loadstring(game:HttpGet('https://pastebin.com/raw/N9FjkyJf'))()", category="GUI", color=Color3.fromRGB(255,0,255)},
        {name="Prehistoric Island v3", description="Prehistoric Island autofarm 2025", code="loadstring(game:HttpGet('https://pastebin.com/raw/vfXVMxDw'))()", category="Farm", color=Color3.fromRGB(100,200,100)},
        {name="Roblox Cheats Executors 2025", description="Lua Executors guide and scripts 2025", code="loadstring(game:HttpGet('https://pastebin.com/raw/tqEpTP1C'))()", category="Admin", color=Color3.fromRGB(255,215,0)}
    }

    -- Функция обновления хаба (фильтр по поиску, категории, пагинация)
    local function update_hub_list()
        for _,c in pairs(hub_list:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        local filtered = {}
        local search_text = search_box.Text:lower()
        for _, s in ipairs(popular_scripts) do
            local matches_search = search_text == "" or s.name:lower():find(search_text) or s.description:lower():find(search_text)
            local matches_category = current_category == "All" or s.category == current_category
            if matches_search and matches_category then
                table.insert(filtered, s)
            end
        end

        local total_pages = math.ceil(#filtered / hub_per_page)
        if total_pages == 0 then hub_page = 1 else hub_page = math.clamp(hub_page, 1, total_pages) end
        
        local start = (hub_page - 1) * hub_per_page + 1
        local end_index = math.min(start + hub_per_page - 1, #filtered)
        local num_items = math.max(0, end_index - start + 1)
        
        -- Расчёт CanvasSize вручную для стабильности
        local item_height = 60
        local padding = 6
        local canvas_height = num_items > 0 and (num_items * item_height + math.max(0, num_items - 1) * padding) or 0
        hub_list.CanvasSize = UDim2.new(0, 0, 0, canvas_height)
        
        for i = start, end_index do
            local s = filtered[i]
            local btn = Instance.new("TextButton", hub_list)
            btn.Size = UDim2.new(1, -16, 0, item_height)
            btn.BackgroundColor3 = s.color
            btn.Text = ""
            btn.AutoButtonColor = false
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            btn.LayoutOrder = i - start + 1

            local name_label = Instance.new("TextLabel", btn)
            name_label.Size = UDim2.new(1, -16, 0, 24)
            name_label.Position = UDim2.new(0, 8, 0, 6)
            name_label.BackgroundTransparency = 1
            name_label.Text = s.name
            name_label.TextColor3 = Color3.fromRGB(255, 255, 255)
            name_label.Font = Enum.Font.GothamBold
            name_label.TextSize = 14
            name_label.TextXAlignment = Enum.TextXAlignment.Left

            local desc_label = Instance.new("TextLabel", btn)
            desc_label.Size = UDim2.new(1, -16, 0, 16)
            desc_label.Position = UDim2.new(0, 8, 0, 30)
            desc_label.BackgroundTransparency = 1
            desc_label.Text = s.description
            desc_label.TextColor3 = Color3.fromRGB(220, 220, 220)
            desc_label.Font = Enum.Font.Gotham
            desc_label.TextSize = 10
            desc_label.TextXAlignment = Enum.TextXAlignment.Left

            local load_btn = Instance.new("TextButton", btn)
            load_btn.Size = UDim2.new(0, 60, 0, 20)
            load_btn.Position = UDim2.new(1, -68, 1, -22)
            load_btn.Text = "LOAD"
            load_btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            load_btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            load_btn.Font = Enum.Font.GothamBold
            load_btn.TextSize = 10
            load_btn.AutoButtonColor = true
            Instance.new("UICorner", load_btn).CornerRadius = UDim.new(0, 3)
            load_btn.MouseButton1Click:Connect(function()
                editor_box.Text = s.code
                hub_frame.Visible = false
                body.Visible = true
                append_console("📥 Loaded: " .. s.name)
            end)

            local exec_btn = Instance.new("TextButton", btn)
            exec_btn.Size = UDim2.new(0, 60, 0, 20)
            exec_btn.Position = UDim2.new(1, -68, 1, -44)
            exec_btn.Text = "EXEC"
            exec_btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            exec_btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            exec_btn.Font = Enum.Font.GothamBold
            exec_btn.TextSize = 10
            exec_btn.AutoButtonColor = true
            Instance.new("UICorner", exec_btn).CornerRadius = UDim.new(0, 3)
            exec_btn.MouseButton1Click:Connect(function()
                local success, err = pcall(function() loadstring(s.code)() end)
                if success then append_console("✅ Executed: " .. s.name) else append_console("❌ Error: " .. tostring(err)) end
            end)
        end
        
        hub_page_label.Text = "Page: " .. hub_page .. " / " .. total_pages
        hub_prev_btn.TextColor3 = hub_page > 1 and Color3.new(1,1,1) or Color3.new(0.5,0.5,0.5)
        hub_next_btn.TextColor3 = hub_page < total_pages and Color3.new(1,1,1) or Color3.new(0.5,0.5,0.5)
    end

    -- События для поиска
    search_box:GetPropertyChangedSignal("Text"):Connect(update_hub_list)

    -- Hub buttons
    hub_btn.MouseButton1Click:Connect(function()
        body.Visible = false
        hub_frame.Visible = true
        hub_page = 1
        current_category = "All"
        search_box.Text = ""
        category_btn.Text = "All"
        update_hub_list()
        append_console("📁 Opened Script Hub")
    end)
    hub_close_btn.MouseButton1Click:Connect(function()
        hub_frame.Visible = false
        body.Visible = true
        append_console("📁 Closed Script Hub")
    end)

    -- Run/New/Delete/Clear Buttons
    run_btn.MouseButton1Click:Connect(function()
        local sel = saved_settings.selected or 1
        local s = demo_scripts[sel]
        if s then
            s.code = editor_box.Text
            save_scripts()
            append_console("🚀 Running: " .. s.name)
            local ok, f = pcall(loadstring, s.code)
            if ok and type(f) == "function" then
                local success, err = pcall(f)
                if success then
                    append_console("✅ Script executed successfully!")
                else
                    append_console("❌ Runtime error: " .. tostring(err))
                end
            elseif not ok then
                append_console("❌ Compile error: " .. tostring(f))
            end
        else
            append_console("❌ No script selected.")
        end
    end)

    new_btn.MouseButton1Click:Connect(function()
        table.insert(demo_scripts,{name="New Script " .. #demo_scripts+1, code="-- new script\nprint('Hello from new script!')"})
        saved_settings.selected = #demo_scripts
        rebuild_list()
        editor_box.Text = demo_scripts[#demo_scripts].code
        save_scripts()
        append_console("📝 Created new script.")
    end)

    del_btn.MouseButton1Click:Connect(function()
        local sel = saved_settings.selected
        if sel and demo_scripts[sel] then
            table.remove(demo_scripts,sel)
            saved_settings.selected = math.clamp(sel-1,1,math.max(1,#demo_scripts))
            rebuild_list()
            editor_box.Text = demo_scripts[saved_settings.selected] and demo_scripts[saved_settings.selected].code or ""
            save_scripts()
            append_console("🗑️ Deleted script.")
        else 
            append_console("❌ No script selected to delete.") 
        end
    end)

    clear_btn.MouseButton1Click:Connect(function()
        console_text.Text = ""
        console_frame.CanvasSize = UDim2.new(0,0,0,0)
        append_console("🧹 Console cleared.")
    end)

    -- Troll Button
    local decal_id = 79805401443240
    local function ex_pro(root)
        for _, v in pairs(root:GetChildren()) do
            if v:IsA("Decal") and v.Texture ~= "http://www.roblox.com/asset/?id=" .. decal_id then
                v:Destroy()
            elseif v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Transparency = 0
                local faces = {"Front", "Back", "Right", "Left", "Top", "Bottom"}
                for _, face in pairs(faces) do
                    local decal = Instance.new("Decal")
                    decal.Texture = "http://www.roblox.com/asset/?id=" .. decal_id
                    decal.Face = Enum.NormalId[face]
                    decal.Parent = v
                end
            end
            ex_pro(v)
        end
    end
    troll_btn.MouseButton1Click:Connect(function()
        pcall(function()
            ex_pro(game.Workspace)
            
            -- Skybox
            local s = Instance.new("Sky")
            s.Name = "Sky"
            s.Parent = game.Lighting
            local skybox_id = 79805401443240
            local faces = {"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp"}
            for _, face in pairs(faces) do
                s[face] = "http://www.roblox.com/asset/?id=" .. skybox_id
            end
            game.Lighting.TimeOfDay = "12:00:00"
            
            -- Частицы
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("Torso") then
                    local emit = Instance.new("ParticleEmitter")
                    emit.Parent = plr.Character.Torso
                    emit.Texture = "http://www.roblox.com/asset/?id=" .. decal_id
                    emit.VelocitySpread = 20
                    emit.Lifetime = NumberRange.new(5)
                    emit.Rate = 50
                end
            end
            
            append_console("😂 Troll applied!")
        end)
    end)

    -- Auto-save editor
    local autosave_ticker = 0
    editor_box:GetPropertyChangedSignal("Text"):Connect(function() autosave_ticker = 0 end)
    RunService.Heartbeat:Connect(function(dt)
        autosave_ticker = autosave_ticker + dt
        if autosave_ticker > 1 then
            autosave_ticker = 0
            local sel = saved_settings.selected
            if sel and demo_scripts[sel] then
                demo_scripts[sel].code = editor_box.Text
                save_scripts()
            end
        end
    end)

    -- Restore last selected
    local sel = saved_settings.selected or 1
    editor_box.Text = demo_scripts[sel] and demo_scripts[sel].code or ""
    append_console("🎮 PSF Remake 4.5 UPDATE - Ready!")
    append_console("💡 Use Hub button - поиск, категории, пагинация")

    -- Collapse/Expand & Smooth UI Animation
    local collapsed = false
    local rotate_btn = Instance.new("ImageButton", screen_gui)
    rotate_btn.Size = UDim2.new(0,40,0,40)
    rotate_btn.Position = UDim2.new(0,10,1,-50)
    rotate_btn.AnchorPoint = Vector2.new(0,0)
    rotate_btn.Image = "rbxassetid://93738238823550"
    rotate_btn.BackgroundTransparency = 1
    rotate_btn.Rotation = 0
    rotate_btn.MouseButton1Click:Connect(function() collapsed = not collapsed end)

    local anim_speed = 5
    local color_time = 0
    RunService.RenderStepped:Connect(function(dt)
        rotate_btn.Rotation = (rotate_btn.Rotation + dt*90) % 360
        local target_scale = collapsed and 0 or 1
        local current_x, current_y = main.Size.X.Scale, main.Size.Y.Scale
        local scale_x = current_x + (target_scale - current_x) * dt * anim_speed
        local scale_y = current_y + (target_scale - current_y) * dt * anim_speed
        main.Size = UDim2.new(scale_x,0,scale_y,0)
        main.ClipsDescendants = scale_y < 0.01
        body.Visible = scale_y > 0.01 and not hub_frame.Visible
        main.BackgroundTransparency = 1 - scale_y
        color_time = color_time + dt
        local cv = (math.sin(color_time) + 1) / 2
        local r = 18 + (240 - 18) * cv
        local g = 18 + (240 - 18) * cv
        local b = 18 + (240 - 18) * cv
        main.BackgroundColor3 = Color3.fromRGB(r,g,b)
    end)

    -- Save settings periodically
    RunService.Heartbeat:Connect(function(dt)
        settings_value.Value = HttpService:JSONEncode(saved_settings)
    end)

    -- Fling System
    local fling_target = nil
    local fling_active = false

    local fling_frame = Instance.new("Frame", main)
    fling_frame.Size = UDim2.new(0.25,0,0.4,0)
    fling_frame.Position = UDim2.new(0.35,0,0.3,0)
    fling_frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    fling_frame.Visible = false
    Instance.new("UICorner", fling_frame).CornerRadius = UDim.new(0,8)

    local fling_layout = Instance.new("UIListLayout", fling_frame)
    fling_layout.Padding = UDim.new(0,4)
    fling_layout.SortOrder = Enum.SortOrder.LayoutOrder

    local function rebuild_fling_list()
        for _,c in pairs(fling_frame:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= player then
                local btn = Instance.new("TextButton", fling_frame)
                btn.Size = UDim2.new(1,-8,0,30)
                btn.Text = p.Name
                btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                Instance.new("UICorner",btn).CornerRadius = UDim.new(0,6)
                btn.MouseButton1Click:Connect(function()
                    fling_target = p
                    append_console("🎯 Selected " .. p.Name .. " for Fling")
                end)
            end
        end
    end

    fling_btn.MouseButton1Click:Connect(function()
        fling_active = true
        fling_frame.Visible = true
        rebuild_fling_list()
    end)

    stop_fling_btn.MouseButton1Click:Connect(function()
        fling_active = false
        fling_target = nil
        fling_frame.Visible = false
        append_console("🛑 Fling stopped")
    end)

    RunService.Heartbeat:Connect(function()
        if fling_active and fling_target and fling_target.Character and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local target_hrp = fling_target.Character:FindFirstChild("HumanoidRootPart")
            if hrp and target_hrp then
                hrp.CFrame = target_hrp.CFrame
                hrp.Velocity = Vector3.new(0,500,0)
            end
        end
    end)

    -- НОВЫЕ ФИЧИ
    -- 1. Auto-Farm
    local farm_active = false
    local farm_connection = nil
    farm_btn.MouseButton1Click:Connect(function()
        farm_active = not farm_active
        if farm_active then
            farm_connection = RunService.Heartbeat:Connect(function()
                -- Простой демо-ферм: собирай монеты/предметы в радиусе (адаптируй для игры)
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _, obj in pairs(workspace:GetChildren()) do
                        if obj.Name:lower():find("coin") or obj.Name:lower():find("fruit") then
                            obj.CFrame = char.HumanoidRootPart.CFrame
                        end
                    end
                end
            end)
            append_console("🌾 Auto-Farm ON (demo for coins/fruits)")
        else
            if farm_connection then farm_connection:Disconnect() end
            append_console("🛑 Auto-Farm OFF")
        end
    end)

    -- 2. ESP
    local esp_active = false
    local esp_highlights = {}
    esp_btn.MouseButton1Click:Connect(function()
        esp_active = not esp_active
        if esp_active then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = plr.Character
                    highlight.FillColor = Color3.fromRGB(255,0,0)
                    highlight.OutlineColor = Color3.fromRGB(255,255,255)
                    esp_highlights[plr] = highlight
                end
            end
            append_console("👁️ ESP ON (red highlights on players)")
        else
            for _, highlight in pairs(esp_highlights) do
                if highlight then highlight:Destroy() end
            end
            esp_highlights = {}
            append_console("👁️ ESP OFF")
        end
    end)

    Players.PlayerAdded:Connect(function(plr)
        if esp_active then
            plr.CharacterAdded:Connect(function()
                wait(1)
                local highlight = Instance.new("Highlight")
                highlight.Parent = plr.Character
                highlight.FillColor = Color3.fromRGB(255,0,0)
                highlight.OutlineColor = Color3.fromRGB(255,255,255)
                esp_highlights[plr] = highlight
            end)
        end
    end)

    -- 3. Auto-Update Hub
    update_btn.MouseButton1Click:Connect(function()
        pcall(function()
            -- Пример URL — замени на свой GitHub для реального обновления
            local url = "https://raw.githubusercontent.com/your-repo/psf-hub/main/scripts.json"
            local new_data = game:HttpGet(url)
            local new_scripts = HttpService:JSONDecode(new_data)
            popular_scripts = new_scripts
            update_hub_list()
            append_console("🔄 Hub updated with " .. #popular_scripts .. " scripts!")
        end)
    end)

    -- 4. Teleport & Speed
    local speed_value = 16
    local tp_frame = Instance.new("Frame", main)
    tp_frame.Size = UDim2.new(0.3,0,0.3,0)
    tp_frame.Position = UDim2.new(0.3,0,0.3,0)
    tp_frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    tp_frame.Visible = false
    Instance.new("UICorner", tp_frame).CornerRadius = UDim.new(0,8)

    local speed_slider = Instance.new("TextBox", tp_frame)
    speed_slider.Size = UDim2.new(1,0,0.3,0)
    speed_slider.Position = UDim2.new(0,0,0,10)
    speed_slider.Text = "Speed: 16"
    speed_slider.BackgroundTransparency = 1
    speed_slider.TextColor3 = Color3.fromRGB(255,255,255)

    local tp_textbox = Instance.new("TextBox", tp_frame)
    tp_textbox.Size = UDim2.new(1,0,0.3,0)
    tp_textbox.Position = UDim2.new(0,0,0.4,0)
    tp_textbox.PlaceholderText = "TP to player name or coords (x,y,z)"
    tp_textbox.BackgroundTransparency = 1
    tp_textbox.TextColor3 = Color3.fromRGB(255,255,255)

    local apply_tp_btn = make_btn(tp_frame, "Apply", 80, Color3.fromRGB(0,255,0))
    apply_tp_btn.Position = UDim2.new(0.5,-40,0.8,0)

    tp_btn.MouseButton1Click:Connect(function()
        tp_frame.Visible = not tp_frame.Visible
    end)

    apply_tp_btn.MouseButton1Click:Connect(function()
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = tonumber(speed_slider.Text:match("%d+")) or 16
        end
        local tp_text = tp_textbox.Text
        if tp_text:find(",") then  -- Coords
            local x,y,z = tp_text:match("(%d+),(%d+),(%d+)")
            if x and y and z then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(tonumber(x),tonumber(y),tonumber(z))
            end
        else  -- Player name
            local target = Players:FindFirstChild(tp_text)
            if target and target.Character then
                player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            end
        end
        append_console("✨ TP/Speed applied!")
    end)

    speed_slider:GetPropertyChangedSignal("Text"):Connect(function()
        speed_value = tonumber(speed_slider.Text:match("%d+")) or 16
    end)

    -- 5. AI Script Generator
    local ai_frame = Instance.new("Frame", main)
    ai_frame.Size = UDim2.new(0.4,0,0.4,0)
    ai_frame.Position = UDim2.new(0.25,0,0.25,0)
    ai_frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    ai_frame.Visible = false
    Instance.new("UICorner", ai_frame).CornerRadius = UDim.new(0,8)

    local ai_prompt = Instance.new("TextBox", ai_frame)
    ai_prompt.Size = UDim2.new(1,0,0.5,0)
    ai_prompt.Position = UDim2.new(0,0,0,10)
    ai_prompt.PlaceholderText = "Describe script (e.g., 'auto-farm fruits in Blox Fruits')"
    ai_prompt.BackgroundTransparency = 1
    ai_prompt.TextColor3 = Color3.fromRGB(255,255,255)
    ai_prompt.TextWrapped = true
    ai_prompt.MultiLine = true

    local generate_btn = make_btn(ai_frame, "Generate", 100, Color3.fromRGB(128,0,128))
    generate_btn.Position = UDim2.new(0.5,-50,0.6,0)

    ai_btn.MouseButton1Click:Connect(function()
        ai_frame.Visible = not ai_frame.Visible
    end)

    generate_btn.MouseButton1Click:Connect(function()
        local prompt = ai_prompt.Text
        if prompt == "" then return end
        -- Симуляция AI (в реале - HttpGet к API, e.g., Grok)
        local demo_code = "-- AI Generated: " .. prompt .. "\n" ..
                          "print('AI script for: " .. prompt .. "')\n" ..
                          "local function auto_farm()\n" ..
                          "  -- Demo logic\n" ..
                          "  for i=1,10 do\n" ..
                          "    wait(1)\n" ..
                          "    print('Farmed item ' .. i)\n" ..
                          "  end\n" ..
                          "end\n" ..
                          "auto_farm()"
        editor_box.Text = demo_code
        append_console("🤖 AI Script generated and loaded!")
    end)

    -- Инициализация
    update_hub_list()
    rebuild_list()
    print("PSF Remake 4.5 UPDATE загружен! Полный хаб с " .. #popular_scripts .. " скриптами.")
end

-- Автофокус на ввод ключа при запуске
keyInput:CaptureFocus()
print("🔑 Enter key to unlock PSF Remake 4.5 UPDATE")

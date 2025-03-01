-- Вебхук-ссылка (замените на вашу ссылку)
local webhook = "http://127.0.0.1:8005/"

-- Метод для отправки HTTP-запросов
local httprequest = (syn and syn.request) or http and http.request or http_request or (fluxus and fluxus.request) or request

-- Служба для работы с HTTP
local HttpService = game:GetService("HttpService")

-- Функция для отправки вебхука с сообщением
local function sendWebhook(username, content)
    if not webhook then
        return
    end
    httprequest({
        Url = webhook,
        Body = HttpService:JSONEncode({
            ["username"] = username, -- Добавляем имя пользователя
            ["content"] = content    -- Добавляем содержимое
        }),
        Method = "POST",
        Headers = {
            ["content-type"] = "application/json"
        }
    })
end

local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game:GetService("Players").LocalPlayer

-- Функция для имитации нажатия клавиши
function pressKey(keyCode, duration)
    VirtualInputManager:SendKeyEvent(true, keyCode, false, nil)
    task.wait(duration)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, nil)
end

-- Запуск последовательности нажатий
pressKey(Enum.KeyCode.BackSlash, 0.1)  -- Нажать \
pressKey(Enum.KeyCode.Down, 0.1)       -- Нажать стрелку вниз
pressKey(Enum.KeyCode.Return, 0.1)     -- Нажать Enter
pressKey(Enum.KeyCode.BackSlash, 0.1) --Нажать \
wait(1)


-- Функция для сбора данных из контейнера
local function gatherData(containerPath)
    local container = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MainGUI"):WaitForChild("Game"):WaitForChild("Inventory"):WaitForChild("Main")
    for _, pathPart in ipairs(string.split(containerPath, ".")) do
        container = container:WaitForChild(pathPart)
    end

    local items = {}
    for _, item in ipairs(container:GetChildren()) do
        if item:IsA("Frame") and item:FindFirstChild("ItemName") and item.ItemName:FindFirstChild("Label") then
            table.insert(items, item.ItemName.Label.Text)
        end
    end
    return items
end

-- Список путей к контейнерам с категориями
local categories = {
    Weapons = {
        "Weapons.Items.Container.Current.Container",
        "Weapons.Items.Container.Classic.Container",
        "Weapons.Items.Container.Holiday.Container.Christmas.Container",
        "Weapons.Items.Container.Holiday.Container.Halloween.Container"
    },
    Holiday = {
        "Weapons.Items.Container.Holiday.Container.Christmas.Container",
        "Weapons.Items.Container.Holiday.Container.Halloween.Container"
    },
    Emotes = {
        "Emotes.Items.Container.Current.Container"
    },
    Effects = {
        "Effects.Items.Container.Current.Container"
    },
    Perks = {
        "Perks.Items.Container.Current.Container"
    },
    Pets = {
        "Pets.Items.Container.Current.Container"
    },
    Radios = {
        "Radios.Items.Container.Current.Container"
    }
}

-- Функция для формирования содержимого
local function formatContent(categories)
    local content = ""
    for category, paths in pairs(categories) do
        content = content .. category .. ":\n"
        local items = {}
        for _, path in ipairs(paths) do
            local newItems = gatherData(path)
            for _, itemName in ipairs(newItems) do
                table.insert(items, itemName)
            end
        end
        if #items > 0 then
            for i, itemName in ipairs(items) do
                content = content .. i .. ". " .. itemName .. "\n"
            end
        else
            content = content .. "No items found\n"
        end
        content = content .. "\n"
    end
    return content
end

-- Основная функция
local function main()
    game.Loaded:Wait()
    print('Loaded')
	local VirtualInputManager = game:GetService("VirtualInputManager")
    local player = game:GetService("Players").LocalPlayer

    -- Функция для имитации нажатия клавиши
    function pressKey(keyCode, duration)
        VirtualInputManager:SendKeyEvent(true, keyCode, false, nil)
        task.wait(duration)
        VirtualInputManager:SendKeyEvent(false, keyCode, false, nil)
    end

    pressKey(Enum.KeyCode.BackSlash, 0.1)
    pressKey(Enum.KeyCode.Down, 0.1)
    pressKey(Enum.KeyCode.Return, 0.1)
    pressKey(Enum.KeyCode.BackSlash, 0.1)

    wait(1)
    local username = game.Players.LocalPlayer.Name
    local content = formatContent(categories)
    sendWebhook(username, content)
end

print('Starting')
main()
print('Finished')

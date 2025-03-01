local webhook = "http://127.0.0.1:8005/"
local httprequest = (syn and syn.request) or http and http.request or http_request or (fluxus and fluxus.request) or request
local HttpService = game:GetService("HttpService")

local function sendWebhook(username, content)
    if not webhook then return end
    httprequest({
        Url = webhook,
        Body = HttpService:JSONEncode({
            username = username,
            content = content
        }),
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        }
    })
end

local function gatherData(containerPath)
    local container = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MainGUI"):WaitForChild("Game"):WaitForChild("Inventory"):WaitForChild("Main")
    for _, part in ipairs(string.split(containerPath, ".")) do
        container = container:WaitForChild(part)
    end

    local items = {}
    for _, item in ipairs(container:GetChildren()) do
        if item:IsA("Frame") and item:FindFirstChild("ItemName") and item.ItemName:FindFirstChild("Label") then
            table.insert(items, item.ItemName.Label.Text)
        end
    end
    return items
end

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

local playerName = game.Players.LocalPlayer.Name
local content = "Предметы:\n"
for category, paths in pairs(categories) do
    content = content .. string.format("\n%s:\n", category)
    local items = gatherData(paths[1])
    for _, item in ipairs(items) do
        content = content .. "" .. item .. "\n"
    end
end
sendWebhook(playerName, content)
game.Loaded:Connect(onGameLoaded)

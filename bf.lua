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
            ["content-type"] = "application/json"
        }
    })
end

local function collectInventoryData()
    local inventoryText = ""
    local basePath = game.Players.LocalPlayer.PlayerGui.Main.InventoryContainer.Right.Content.ScrollingFrame.Frame
    for i = 1, 16 do
        local slot = basePath[tostring(i)]
        if slot and slot.Filled then
            local itemName = slot.Filled.ItemInformation.ItemName.Text
            local itemCount = slot.Filled.ItemInformation.Counter.Shadow.TextLabel.Text
            inventoryText = inventoryText .. string.format("%s: %s\n", itemName, itemCount)
        end
    end
    return inventoryText
end

-- Execution
local args = {
    [1] = "SetTeam",
    [2] = "Pirates"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
wait(3)

local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game.Players.LocalPlayer

function pressKey(keyCode, duration)
    VirtualInputManager:SendKeyEvent(true, keyCode, false, nil)
    task.wait(duration)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, nil)
end

pressKey(Enum.KeyCode.BackSlash, 0.1)
pressKey(Enum.KeyCode.Down, 0.1)
pressKey(Enum.KeyCode.Down, 0.1)
pressKey(Enum.KeyCode.Down, 0.1)
pressKey(Enum.KeyCode.Down, 0.1)
pressKey(Enum.KeyCode.Return, 0.1)
pressKey(Enum.KeyCode.Right, 0.1)
pressKey(Enum.KeyCode.Up, 0.1)
pressKey(Enum.KeyCode.Return, 0.1)
pressKey(Enum.KeyCode.Right, 0.1)
pressKey(Enum.KeyCode.Down, 0.1)
pressKey(Enum.KeyCode.Down, 0.1)
pressKey(Enum.KeyCode.Left, 0.1)
pressKey(Enum.KeyCode.Return, 0.1)
pressKey(Enum.KeyCode.Down, 0.1)
pressKey(Enum.KeyCode.Down, 0.1)
pressKey(Enum.KeyCode.Down, 0.1)
pressKey(Enum.KeyCode.Down, 0.1)
pressKey(Enum.KeyCode.Down, 0.1)
pressKey(Enum.KeyCode.Return, 0.1)
pressKey(Enum.KeyCode.BackSlash, 0.1)
wait(1)

local playerName = game.Players.LocalPlayer.Name
local inventoryData = collectInventoryData()

if inventoryData ~= "" then
    sendWebhook(playerName, inventoryData)
else
    sendWebhook(playerName, "Инвентарь пуст!")
end

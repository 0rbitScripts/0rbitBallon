print("By 0rbit Scripts | https://discord.gg/NnWn3QqgbC")

local function serverhopshit()
    local function alternateServersRequest()
        local response = request({Url = 'https://games.roblox.com/v1/games/' .. tostring(game.PlaceId) .. '/servers/Public?sortOrder=Asc&limit=100', Method = "GET", Headers = { ["Content-Type"] = "application/json" },})
    
        if response.Success then
            return response.Body
        else
            return nil
        end
    end
    
    local function getServer()
        local servers
    
        local success, _ = pcall(function()
            servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. tostring(game.PlaceId) .. '/servers/Public?sortOrder=Asc&limit=100')).data
        end)
    
        if not success then
            print("Error getting servers, using backup method")
            servers = game.HttpService:JSONDecode(alternateServersRequest()).data
        end
    
        local server = servers[Random.new():NextInteger(5, 100)]
        if server then
            return server
        else
            return getServer()
        end
    end
    
    pcall(function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, getServer().id, game.Players.LocalPlayer)
    end)
    
    task.wait(5)
    while true do
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        task.wait()
    end
end

repeat
    task.wait(1)
until game:IsLoaded()

repeat
    task.wait(1)
until game.PlaceId ~= nil

repeat
    task.wait(1)
until game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character.HumanoidRootPart


if game.PlaceId == 8737899170 then
    repeat
        task.wait(1)
    until #game:GetService("Workspace").Map:GetChildren() == 100
elseif game.PlaceId == 16498369169 then
    repeat
        task.wait(1)
    until #game:GetService("Workspace").Map2:GetChildren() == 51
end


repeat
    task.wait(1)
until game:GetService("Workspace").__THINGS and game:GetService("Workspace").__DEBRIS

task.wait(2)

print("[CLIENT] Loaded Game")

local WAITING = false

local function serverhop(player)
    local timeToWait = Random.new():NextInteger(30, 60)
    print("[ANTI-STAFF] BIG Games staff (" .. player.Name ..  ") is in server! Waiting for " .. tostring(timeToWait) .. " seconds before server hopping...")
    task.wait(timeToWait)

    local success, _ = pcall(function()
        serverhopshit()
    end)

    if not success then
        game.Players.LocalPlayer:Kick("[ANTI-STAFF] A BIG Games staff member joined and script was unable to server hop")
    end
end

for _, player in pairs(game.Players:GetPlayers()) do
    local success, _ = pcall(function()
        if player:IsInGroup(5060810) then
            WAITING = true
            serverhop(player)
        end
    end)
    if not success then
        print("[ANTI-STAFF] Error while checking player: " .. player.Name)
    end
end

print("[ANTI-STAFF] No staff member detected")

game.Players.PlayerAdded:Connect(function(player)
    if player:IsInGroup(5060810) and not WAITING then
        print("[ANTI-STAFF] Staff member joined, stopping all scripts")
        getgenv().autoBalloon = false
        getgenv().autoChest = false
        getgenv().autoFishing = false

        getgenv().STAFF_DETECTED = true
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false

        local world
        local mapPath
        if game.PlaceId == 8737899170 then
            mapPath = game:GetService("Workspace").Map
            world = "World 1"
        elseif game.PlaceId == 16498369169 then
            mapPath = game:GetService("Workspace").Map2
            world = "World 2"
        end


        local _, zoneData

        if world == "World 1" then
            _, zoneData = require(game:GetService("ReplicatedStorage").Library.Util.ZonesUtil).GetZoneFromNumber(Random.new():NextInteger(40, 90))
        else
            _, zoneData = require(game:GetService("ReplicatedStorage").Library.Util.ZonesUtil).GetZoneFromNumber(Random.new():NextInteger(5, 20))
        end

        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mapPath[tostring(zoneData["_script"])].PERSISTENT.Teleport.CFrame

        serverhop(player)
    end
end)

task.wait(getgenv().autoBalloonConfig.START_DELAY)


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Things    = Workspace:WaitForChild("__THINGS")
Player = game.Players.LocalPlayer
local Cooldowns = {
	Fishing = tick(),
	OpenEggs    = tick(),
	OrbCollect  = tick(),
	PlaceFlag   = tick(),
	Vending = tick(),
	Daily = tick(),
	Dig = tick(),
	Fruits  = tick(),
	TNT   = tick(),
	Farm    = tick(),
	Rewards = tick(),
	Ranks = tick(),
	Daycare = tick(),
	Merchants   = tick(),
	Stairs  = tick(),
	Enchants	= tick(),
}
local CollectBags = getsenv(Player.PlayerScripts.Scripts.Game:WaitForChild("Lootbags Frontend")).Claim
local Network = ReplicatedStorage:WaitForChild("Network")


local function CollectDrops()
	Cooldowns.OrbCollect = tick()

	local OrbChildren   = Things.Orbs:GetChildren()
	local BagChildren   = Things.Lootbags:GetChildren()

	local MyOrbDrops = {}

	for i,v in OrbChildren do
		MyOrbDrops[i]  = tonumber(v.Name)

		v:Destroy()
	end

	if #BagChildren > 0 and CollectBags then
		for _,v in BagChildren do
			CollectBags(v.Name)
		end
	elseif not CollectBags then
		CollectBags = getsenv(Player.PlayerScripts.Scripts.Game:WaitForChild("Lootbags Frontend")).Claim
	end

	if #OrbChildren > 0 then
		Network["Orbs: Collect"]:FireServer(MyOrbDrops)
	end
end

print("almost done")

local running = true
task.spawn(function()
    while running do
        pcall(CollectDrops)
        task.wait(0, 1)
    end
end)

print("done done done")
OldHooks = {}
local ClientCmds = require(game.ReplicatedStorage.Library:WaitForChild("Client"))
OldHooks.CalculateSpeedMultiplier = ClientCmds.PlayerPet.CalculateSpeedMultiplier
ClientCmds.PlayerPet.CalculateSpeedMultiplier  = function(...)
	return 9999
end

while getgenv().autoBalloon do
    local balloonIds = {}

    local getActiveBalloons = ReplicatedStorage.Network.BalloonGifts_GetActiveBalloons:InvokeServer()

    local allPopped = true
    for i, v in pairs(getActiveBalloons) do
        if not v.Popped then
            allPopped = false
            print("Unpopped balloon found")
            balloonIds[i] = v
        end
    end

    if allPopped then
        print("No balloons detected, waiting " .. getgenv().autoBalloonConfig.GET_BALLOON_DELAY .. " seconds")
        if getgenv().autoBalloonConfig.SERVER_HOP then
            serverhopshit()
        end
        task.wait(getgenv().autoBalloonConfig.GET_BALLOON_DELAY)
        continue
    end

    if not getgenv().autoBalloon then
        break
    end

    local originalPosition = LocalPlayer.Character.HumanoidRootPart.CFrame

    LocalPlayer.Character.HumanoidRootPart.Anchored = true
    for balloonId, balloonData in pairs(balloonIds) do
        if getgenv().autoOpenGiftBag then
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("GiftBag_Open"):InvokeServer("Gift Bag")
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("GiftBag_Open"):InvokeServer("Large Gift Bag")
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("GiftBag_Open"):InvokeServer("Mini Chest")
        end

        print("Popping balloon")

        local balloonPosition = balloonData.Position

        ReplicatedStorage.Network.Slingshot_Toggle:InvokeServer()

        task.wait()

        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(balloonPosition.X, balloonPosition.Y + 30, balloonPosition.Z)

        task.wait()

        local args = {
            [1] = Vector3.new(balloonPosition.X, balloonPosition.Y + 25, balloonPosition.Z),
            [2] = 0.5794160315249014,
            [3] = -0.8331117721691044,
            [4] = 200
        }

        ReplicatedStorage.Network.Slingshot_FireProjectile:InvokeServer(unpack(args))

        task.wait(0.1)

        local args = {
            [1] = balloonId
        }

        ReplicatedStorage.Network.BalloonGifts_BalloonHit:FireServer(unpack(args))

        task.wait()

        ReplicatedStorage.Network.Slingshot_Unequip:InvokeServer()

        LocalPlayer.Character.HumanoidRootPart.Anchored = false
        local startTime = os.time()
        repeat
            local currentTime = os.time()
            local balloonInfo = ReplicatedStorage.Network.BalloonGifts_GetActiveBalloons:InvokeServer()[balloonId]
            if balloonInfo == nil or currentTime - startTime >= 3 then
                break
            else
                wait()
            end
        until false

        print("Popped balloon, waiting " .. tostring(getgenv().autoBalloonConfig.BALLOON_DELAY) .. " seconds")
        task.wait(getgenv().autoBalloonConfig.BALLOON_DELAY)
    end

    if getgenv().autoBalloonConfig.SERVER_HOP then
        serverhopshit()
    end

    LocalPlayer.Character.HumanoidRootPart.Anchored = false
    LocalPlayer.Character.HumanoidRootPart.CFrame = originalPosition
end
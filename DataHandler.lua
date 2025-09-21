local ProfileService = require(game.ServerScriptService.Modules:WaitForChild("ProfileService"))

local ProfileTemplate = {
	Cash = 0;
	Faction = "picking";
	Items = {};
	LoginDay = 0;
}

local ProfileStore = ProfileService.GetProfileStore("PlayerData", ProfileTemplate)

local Profiles = {}

local function playerAdded(player)
	local profile = ProfileStore:LoadProfileAsync("Player_"..player.UserId)

	if profile then
		profile:AddUserId(player.UserId)
		profile:Reconcile()

		profile:ListenToRelease(function()
			Profiles[player] = nil
			player:Kick()
		end)

		if player:IsDescendantOf(game.Players) == true then
			Profiles[player] = profile
		else
			profile:Release()
		end
	else
		player:Kick()
	end
end

game.Players.PlayerAdded:Connect(function(player)
	playerAdded(player)
	local profile = Profiles[player]
	if not profile then warn("No profile found") return end
	
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = player
	
	local Cash = Instance.new("IntValue")
	Cash.Name = "Cash"
	Cash.Value = profile.Data.Cash or 0
	Cash.Parent = ls
	
	Cash:GetPropertyChangedSignal("Value"):Connect(function()
		profile.Data.Cash = Cash.Value
	end)
	
	game.ServerScriptService:WaitForChild("PlotHandler"):WaitForChild("CreatePlot"):Fire(player, profile.Data.Items)
end)

game.Players.PlayerRemoving:Connect(function(player)
	local profile = Profiles[player]
	
	if profile then
		profile:Release()
	end
end)

for _, player in game.Players:GetPlayers() do
	task.spawn(playerAdded, player)
end

script:WaitForChild("ItemUnlocked").Event:Connect(function(player, itemId)
	local profile = Profiles[player]
	table.insert(profile.Data.Items, itemId)
end)

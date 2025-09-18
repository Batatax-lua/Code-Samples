local recontain173 = game.ReplicatedStorage.Events.Recontain:WaitForChild("Recontain173")
local voiceline = "rbxassetid://6608163811"

-- find 173's model
local scp173 = workspace:WaitForChild("scp173")
local scpMeshPart = scp173:FindFirstChild("HumanoidRootPart")

-- find the caged model
local cage = game.ReplicatedStorage.SCPs.Contained:WaitForChild("scp173cage")
local cagehrp = cage:WaitForChild("HumanoidRootPart")

recontain173.Event:Connect(function(player)
	local sound = Instance.new("Sound")
	sound.SoundId = voiceline
	sound.Parent = player.Character.HumanoidRootPart
	sound:Play()
	
	local pos = scpMeshPart.CFrame
	scp173.Parent = game.ReplicatedStorage.SCPs.Uncontained
	cage.Parent = game.Workspace
	cagehrp.CFrame = pos
end)

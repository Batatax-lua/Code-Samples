local startui = game:GetService("StarterGui")

local trigger = script.Parent
local recontainSound = "rbxassetid://9080720033"
local message = "SCP-049 has been successfully recontained."
local messagebox = startui.Noti.TextLabel

trigger.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")

	if humanoid and character:IsA("Model") then
		local npc = character.Name == "scp049"
		if npc then
			
			local sound = Instance.new("Sound")
			sound.SoundId = recontainSound
			sound.Parent = workspace
			sound:Play()

			
			game.ReplicatedStorage.Events.Recontain.Recontain049TriggerBox:FireAllClients(message)

			
			character:MoveTo(trigger.Position) 
			character.HumanoidRootPart.Anchored = true 

			
			local animator = humanoid:FindFirstChildOfClass("Animator")
			if animator then
				-- !! FILL THIS AFTER MAKING THE ANIM !! --
				--local idleAnim = humanoid:LoadAnimation(animator:LoadAnimation(YourIdleAnimation))
				--idleAnim:Play()
			end
		end
	end
end)
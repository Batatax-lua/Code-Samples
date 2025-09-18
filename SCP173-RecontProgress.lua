local progressBarUI = game.ReplicatedStorage:WaitForChild("ProgressBarUI")
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

progressBarUI.OnClientEvent:Connect(function(show)
	if show then
		local progressBar = Instance.new("Frame")
		progressBar.Size = UDim2.new(0.5, 0, 0.05, 0)
		progressBar.Position = UDim2.new(0.25, 0, 0.85, 0)
		progressBar.BackgroundColor3 = Color3.new(0, 1, 0)
		progressBar.Parent = gui

		progressBar:TweenSize(UDim2.new(0.5, 0, 0.05, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 5, true)

		wait(5)
		progressBar:Destroy()
	else
		for _, v in pairs(gui:GetChildren()) do
			if v:IsA("Frame") then
				v:Destroy()
			end
		end
	end
end)

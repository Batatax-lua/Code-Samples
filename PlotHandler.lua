local plots = game.Workspace.Plots
local TemplatePlot = game.Workspace.TemplatePlot

game.Players.PlayerAdded:Connect(function(plr)
	for _, plot in plots:GetChildren() do
		if plot:GetAttribute("Taken") then continue end
		
		plot:SetAttribute("Taken", true)
		plot:SetAttribute("Owner", plr.UserId)
		
		local itemFolder = Instance.new("Folder")
		itemFolder.Name = "Items"
		itemFolder.Parent = plot
		
		local TmpButtons = TemplatePlot.Buttons:Clone()
		local TmpItems = TemplatePlot.Items
		
		for _, Button in TmpButtons:GetChildren() do
			local RelCFrame = TemplatePlot.CFrame:ToObjectSpace(Button.CFrame)
			Button.CFrame = plot.CFrame:ToWorldSpace(RelCFrame)
			Button.Touched:Connect(function(hit)
				local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
				
				if not plr then return end
				if plot:GetAttribute("Owner") ~= plr.UserId  then return end
				
				local unlock = Button:GetAttribute("IdUnlock")
				if not unlock then warn("Missing IdUnlock") return end
				
				local price = Button:GetAttribute("Price")
				
				if price then
					if plr.leaderstats.Cash.Value < price then
						warn("Too poor")
						return
					end
					plr.leaderstats.Cash.Value -= price
				end
				
				for _, item in TmpItems:GetChildren() do
					if item:GetAttribute("Id") ~= unlock then continue end
					local itemClone = item:Clone()
					local itemCFrame
					
					if itemClone:IsA("Model") then
						itemCFrame = itemClone:GetPivot()
					elseif item:IsA("BasePart") then
						itemCFrame = itemClone.CFrame
					end
					
					local RelItemCFrame = TemplatePlot.CFrame:ToObjectSpace(itemCFrame)
					local worldCFrame = plot.CFrame:ToWorldSpace(RelItemCFrame)
					
					if itemClone:IsA("Model") then
						itemClone:PivotTo(worldCFrame)
					elseif itemClone:IsA("BasePart") then
						itemClone.CFrame = worldCFrame
					end
					
					itemClone.Parent = itemFolder
				end
				Button:Destroy()
			end)
		end
		
		TmpButtons.Parent = plot
		break
	end
end)

game.Players.PlayerRemoving:Connect(function(plr)
	for _, plot in plots:GetChildren() do
		if not plot:GetAttribute("Owner") then continue end
		
		if plot:GetAttribute("Owner") ~= plr.UserId then continue end
		
		plot:SetAttribute("Taken", nil)
		plot:SetAttribute("Owner", nil)
		break
	end
end)

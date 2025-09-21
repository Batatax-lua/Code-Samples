local plots = game.Workspace.Plots
local TemplatePlot = game.ReplicatedStorage:WaitForChild("TemplatePlots").TemplatePlot

local function getPlot(player)
	for _, plot in plots:GetChildren() do
		local owner = plot:GetAttribute("Owner")
		if not owner then continue end
		if owner ~= player.UserId then continue end
		return plot
	end
end

local function getItemFromTmpPlot(itemId)
	for _, item in TemplatePlot.Items:GetChildren() do
		if item:GetAttribute("Id") == itemId then
			return item	
		end
	end
end

local function getButtonByIdUnlock(player, itemId)
	local plot = getPlot(player)
	if not plot then return end
	
	for _, Button in plot.Buttons:GetChildren() do
		local UnlockId = Button:GetAttribute("IdUnlock")
		if not UnlockId then continue end
		
		if itemId == UnlockId then 
			return Button 
		end
	end
end

local function loadItems(player, itemIdsTable)
	local plot = getPlot(player)
	for _, itemId in itemIdsTable do
		local item = getItemFromTmpPlot(itemId)
		if not item then continue end
		
		local itemClone = item:Clone()
		local itemCFrame
		
		if itemClone:IsA("Model") then
			itemCFrame = itemClone:GetPivot()
		elseif itemClone:IsA("BasePart") then
			itemCFrame = itemClone.CFrame
		end
		
		local RelItemCFrame = TemplatePlot.CFrame:ToObjectSpace(itemCFrame)
		local worldCFrame = plot.CFrame:ToWorldSpace(RelItemCFrame)

		if itemClone:IsA("Model") then
			itemClone:PivotTo(worldCFrame)
		elseif itemClone:IsA("BasePart") then
			itemClone.CFrame = worldCFrame
		end
		
		itemClone.Parent = plot.Items
	end
end

script:WaitForChild("CreatePlot").Event:Connect(function(player, itemIdsTable)
	for _, plot in plots:GetChildren() do
		if plot:GetAttribute("Taken") then continue end
		
		plot:SetAttribute("Taken", true)
		plot:SetAttribute("Owner", player.UserId)
		
		local itemFolder = Instance.new("Folder")
		itemFolder.Name = "Items"
		itemFolder.Parent = plot
		
		local TmpButtons = TemplatePlot.Buttons:Clone()
		local TmpItems = TemplatePlot.Items
		
		loadItems(player, itemIdsTable)
		
		for _, Button in TmpButtons:GetChildren() do
			if table.find(itemIdsTable, Button:GetAttribute("IdUnlock")) then continue end
			
			if Button:GetAttribute("Hidden") then
				Button.Transparency = 1
				Button.BillboardGui.Enabled = false
				Button.CanCollide = false
			end
			
			local RelCFrame = TemplatePlot.CFrame:ToObjectSpace(Button.CFrame)
			Button.CFrame = plot.CFrame:ToWorldSpace(RelCFrame)
			Button.Touched:Connect(function(hit)
				if Button:GetAttribute("Hidden") then return end
				
				local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
				
				if not plr then return end
				if plot:GetAttribute("Owner") ~= plr.UserId  then return end
				
				if Button:GetAttribute("Debounce") then return end
				Button:SetAttribute("Debounce", true)
				
				task.delay(2, function()
					if Button then
						Button:SetAttribute("Debounce", false)
					end
				end)
				
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
				
				local itemsToShow = Button:GetAttribute("Show")
				if itemsToShow then
					local itemIds = string.split(itemsToShow, ',')
					
					for _, itemId in itemIds do
						itemId = tonumber(itemId)
						local Button = getButtonByIdUnlock(player, itemId)
						if not Button then continue end
						
						Button.Transparency = 0
						Button.BillboardGui.Enabled = true
						Button.CanCollide = true
						Button:SetAttribute("Hidden", nil)
					end
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
				game.ServerScriptService.DataHandler.ItemUnlocked:Fire(plr, unlock)
			end)
		end
		
		TmpButtons.Parent = plot
		
		for _, Button in TmpButtons:GetChildren() do
			if table.find(itemIdsTable, Button:GetAttribute("IdUnlock")) then
				local itemsToShow = Button:GetAttribute("Show")
				if itemsToShow then
					local itemIds = string.split(itemsToShow, ',')

					for _, itemId in itemIds do
						itemId = tonumber(itemId)
						local Button = getButtonByIdUnlock(player, itemId)
						if not Button then continue end

						Button.Transparency = 0
						Button.BillboardGui.Enabled = true
						Button.CanCollide = true
						Button:SetAttribute("Hidden", nil)
					end
				end
			end
		end
		
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

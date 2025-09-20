script.Parent.Touched:Connect(function(hit)
	if hit:HasTag("Ore") then
		local plot = script.Parent.Parent.Parent
		if not plot then warn("No plot found") return end
		
		local plotUsrId = plot:GetAttribute("Owner")
		if not plotUsrId then warn("No UserID found") return end
		
		local plrObject = game.Players:GetPlayerByUserId(plotUsrId)
		if not plrObject then warn("No player object found") return end
		
		plrObject.leaderstats.Cash.Value += hit:GetAttribute("Value")
		
		hit:Destroy()
	end
end)

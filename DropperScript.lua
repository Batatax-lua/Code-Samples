local handler = require(game:WaitForChild("ServerScriptService").Modules.DropperHandler)

local active = script.Parent.Dropper:GetAttribute("Enabled")
local DRP_CD = script.Parent.Dropper:GetAttribute("Cooldown")
local DRP_TYP = script.Parent.Dropper:GetAttribute("Type")

if active == true then
	while task.wait(DRP_CD) do
		local oreFound = handler.GetType(script.Parent.Dropper)
		if oreFound ~= nil then
			local ore = oreFound:Clone()
			ore.Parent = script.Parent.DropperOres
			ore.CFrame = script.Parent.Dropper.CFrame
			ore.Rotation = Vector3.new(0, 90, 0)
		else
			warn("Dropper could not find ore type!")
		end
	end
end

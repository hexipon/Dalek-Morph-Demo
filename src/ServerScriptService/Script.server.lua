local DalekRemoteEvent = game:GetService("ReplicatedStorage"):waitForChild("DalekRemoteEvent")
local dalek = require(game:GetService("ServerScriptService").Dalek)
dalek.Initiate()

DalekRemoteEvent.OnServerEvent:Connect(function(Player,val, functionToCall)
	if functionToCall == dalek.Function.MoveEye then
		dalek.MoveEye(Player, val)
	end
	if functionToCall == dalek.Function.MoveDome then
		dalek.MoveDome(Player, val)
	end
	if functionToCall == dalek.Function.ZeroEye then
		dalek.ZeroEye(Player, nil)
	end
	if functionToCall == dalek.Function.DeMorph then
		dalek.RemoveMorph(Player)
	end
	
	if functionToCall == nil then
		dalek.NewMorph(Player,val)
	end
	
end)
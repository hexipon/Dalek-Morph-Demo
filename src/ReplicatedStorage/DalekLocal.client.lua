--for local use
local DalekFunction = {
	NewMorph = 0,
	RemoveMorph = 1,
	MoveEye = 2,
	MoveDome = 3,
	ZeroEye = 4
}
local keyDown = false
local currentKeyPressed=nil
local DalekRemoteEvent = game:GetService("ReplicatedStorage"):waitForChild("DalekRemoteEvent")
local oldpos=nil
local player = game.Players.LocalPlayer
local character = nil
	repeat
		character = player.Character
		wait()
until character

workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function()
	local x, y, z = workspace.Camera.CFrame:ToOrientation ( )
	x = x + 1.4
	--move the eye acording to the rotation of the players camera
		local newpos = x
		if not(oldpos==nil)then
			DalekRemoteEvent:FireServer((newpos-oldpos)*40, DalekFunction.MoveEye)
		end
		oldpos = x
end)
game:GetService("UserInputService").InputBegan:connect(function(input, gameProcessedEvent)
	if (input.UserInputType ==Enum.UserInputType.Keyboard) then
		keyDown=true
		--move the dome
		if (input.KeyCode == Enum.KeyCode.E ) then
			while(keyDown) do
				DalekRemoteEvent:FireServer(-10, DalekFunction.MoveDome)
				--without this wait it locks up
				wait(0.1)
			end
		end
		if (input.KeyCode == Enum.KeyCode.Q ) then
			while(keyDown) do
				DalekRemoteEvent:FireServer(10, DalekFunction.MoveDome)
				wait(0.1)
			end
		end
	end
end)

game:GetService("UserInputService").InputEnded:connect(function(input)
	--stop moving the dome
	if (input.UserInputType ==Enum.UserInputType.Keyboard) and ((input.KeyCode == Enum.KeyCode.E) or (input.KeyCode == Enum.KeyCode.Q)) then
		keyDown = false
	end
end)
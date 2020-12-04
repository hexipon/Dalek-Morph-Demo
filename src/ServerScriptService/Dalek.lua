local Dalek = {}

--[[(basically) an enum that helps choose which
which function should be called
this is used outside of this script]]
Dalek.Function = {
	NewMorph = 0,
	RemoveMorph = 1,
	MoveEye = 2,
	MoveDome = 3,
	ZeroEye = 4,
	DeMorph = 5
}

Dalek.Initiate = function()
	--list of all the dalek morphs controlled by players
	Dalek.MorphList = {}
	--[[list of all the Dalek models players can choose to
	morph into]]
	Dalek.ModelList = game:GetService("ReplicatedStorage"):waitForChild("Daleks"):getChildren()
	
end

Dalek.Weld = function(a,b)
	local W = Instance.new("Weld")
	W.Part0 = a
	W.Part1 = b
	local CJ = CFrame.new(a.Position)
	local C0 = a.CFrame:inverse()*CJ
	local C1 = b.CFrame:inverse()*CJ
	W.C0 = C0
	W.C1 = C1
	W.Parent = a
end

Dalek.NewMorph = function(Player, DalekName)
	
	
	assert(not(Dalek.ModelList == nil), 'Model list is nil')
	local newDalek ={}
	--find the Dalek model
	for _,a in next, Dalek.ModelList do
		if a.Name == DalekName then
			newDalek = a:Clone()
		end
	end
	--check if the dalek model exists 
	assert(not(newDalek == nil),DalekName .. ' model does not exist')
	local char
	repeat
		char = Player.Character
		wait()
	until char
	
	if(char:findFirstChild("Dalek"))then
		Dalek.RemoveMorph(Player)
	end
	--Dalek model does exist, so weld it etc..
	newDalek.Name = 'Dalek'
	
	--set the player up
	Dalek.SetupPlayer(newDalek,char)
	
	--Add the dalek morph to the active morph list
	Dalek.MorphList[Player.Name] = newDalek
	--move dalek morph to character 
	Dalek.MorphList[Player.Name].Parent = char
	--Weld individual sections
	Dalek.CreateHinges(Dalek.MorphList[Player.Name])
	Dalek.WeldEye(Dalek.MorphList[Player.Name])
	Dalek.WeldDome(Dalek.MorphList[Player.Name])
	Dalek.WeldArm(Dalek.MorphList[Player.Name])
	Dalek.WeldFender(Dalek.MorphList[Player.Name])
	Dalek.WeldGun(Dalek.MorphList[Player.Name])
	Dalek.WeldNeck(Dalek.MorphList[Player.Name])
	Dalek.WeldShoulder(Dalek.MorphList[Player.Name])
	Dalek.WeldSkirt(Dalek.MorphList[Player.Name])	
	--Weld the sections together
	Dalek.Weld(Dalek.MorphList[Player.Name].EyeStalk.EyeJoint_2, Dalek.MorphList[Player.Name].Dome.DomeJoint)
	Dalek.Weld(Dalek.MorphList[Player.Name].Fender.Fender, Dalek.MorphList[Player.Name].Shoulder.ShoulderB)
	Dalek.Weld(Dalek.MorphList[Player.Name].Gun.GunJoint_2, Dalek.MorphList[Player.Name].Shoulder.ShoulderB)
	Dalek.Weld(Dalek.MorphList[Player.Name].ManipulatorArm.MaipulatorArmJoint_2, Dalek.MorphList[Player.Name].Shoulder.ShoulderB)
	Dalek.Weld(Dalek.MorphList[Player.Name].Neck.NeckJoint, Dalek.MorphList[Player.Name].Shoulder.ShoulderB)
	Dalek.Weld(Dalek.MorphList[Player.Name].Shoulder.ShoulderB, Dalek.MorphList[Player.Name].Dome.DomeJoint_2)
	Dalek.Weld(Dalek.MorphList[Player.Name].Skirt.SkirtJoint, Dalek.MorphList[Player.Name].Shoulder.ShoulderB)
	--Unanchor everything 
	for _,a in next, Dalek.MorphList[Player.Name]:GetDescendants() do
		if a:IsA("BasePart") then 
			a.Anchored=false
			if not(a.Name == 'Fender') then
				a.CanCollide=false
			end
		end
	end
	Dalek.WeldPlayer(Dalek.MorphList[Player.Name], char)
end

Dalek.SetupPlayer = function(_Dalek, char)
	--remove jump
	local Humanoid = char:WaitForChild("Humanoid")
	Humanoid.JumpPower=0
	--turn player invisible
	for _,a in next, char:GetDescendants() do
		if a:IsA("BasePart") or (a.ClassName == 'Decal')then 
				a.Transparency=1
		end
	end
	char.Animate.Disabled = true
end

Dalek.WeldPlayer = function(_Dalek, char)
	
	local PrimaryPart = char.PrimaryPart
	local playerPos = PrimaryPart.Position
	--set position to player position
	PrimaryPart.CFrame = _Dalek.Shoulder.ShoulderB.CFrame
	--weld to player
	Dalek.Weld(_Dalek.Shoulder.ShoulderB,PrimaryPart)
	char:MoveTo(playerPos)
end



Dalek.CreateHinges = function(_Dalek)
	
	--create the hinge and angle limitations
	local JointHinge = Instance.new("Attachment")
	JointHinge.Axis = Vector3.new(1,0,0)
	local JointHinge2 = JointHinge:Clone()
	JointHinge2.Orientation = Vector3.new(0,0,0)
	JointHinge.Parent = _Dalek.EyeStalk.EyeJoint
	JointHinge2.Parent = _Dalek.EyeStalk.EyeJoint_2
	local hinge = Instance.new("HingeConstraint")
	hinge.ActuatorType = Enum.ActuatorType.Servo
	hinge.ServoMaxTorque = 'inf'
	hinge.AngularSpeed = 'inf'
	--set the angle limits
	hinge.LimitsEnabled = true
	hinge.LowerAngle = -15
	hinge.UpperAngle = 25
	hinge.Restitution = 0
	--set attachments
	hinge.Attachment0 = JointHinge2
	hinge.Attachment1 = JointHinge
	hinge.Name = 'EyeHinge'
	hinge.Parent = _Dalek
	
	--create the hinge and angle limitations
	local JointHinge = Instance.new("Attachment")
	JointHinge.Axis = Vector3.new(0,1,0)
	JointHinge.SecondaryAxis = Vector3.new(-1,0,0)
	local JointHinge2 = JointHinge:Clone()
	JointHinge.Parent = _Dalek.Dome.DomeJoint
	JointHinge2.Parent = _Dalek.Dome.DomeJoint_2
	local hinge = Instance.new("HingeConstraint")
	hinge.ActuatorType = Enum.ActuatorType.Servo
	hinge.ServoMaxTorque = 'inf'
	hinge.AngularSpeed = 'inf'
	--set attachments
	hinge.Attachment0 = JointHinge2
	hinge.Attachment1 = JointHinge
	hinge.Name = 'DomeHinge'
	hinge.Parent = _Dalek
end

Dalek.WeldEye = function(_Dalek)
	for i,p in next,_Dalek.EyeStalk:GetDescendants() do
		if (p:IsA("BasePart")) then
			if not(p== _Dalek.EyeStalk.EyeJoint) and not(p==_Dalek.EyeStalk.EyeJoint_2) then
				Dalek.Weld(_Dalek.EyeStalk.EyeJoint, p)
			end
		end
	end
end

Dalek.WeldDome = function(_Dalek)
	for i,p in next,_Dalek.Dome:GetDescendants() do
		if (p:IsA("BasePart")) then
			if not (p== _Dalek.Dome.DomeJoint)and not(p==_Dalek.Dome.DomeJoint_2)  then
				Dalek.Weld(_Dalek.Dome.DomeJoint, p)
			end
		end
	end
	
end

Dalek.WeldFender = function(_Dalek)
	
	for i,p in next,_Dalek.Fender:GetDescendants() do
		if (p:IsA("BasePart")) then
			if not (p== _Dalek.Fender.Fender)then
				Dalek.Weld(_Dalek.Fender.Fender, p)
			end
		end
	end
	
end

Dalek.WeldGun = function(_Dalek)
	
	for i,p in next,_Dalek.Gun:GetDescendants() do
		if (p:IsA("BasePart")) then
			if not (p== _Dalek.Gun.GunJoint) --[[and not(p== _Dalek.Gun.GunJoint_2)]] then
				Dalek.Weld(_Dalek.Gun.GunJoint, p)
			end
		end
	end
	
end

Dalek.WeldArm = function(_Dalek)
	
	for i,p in next,_Dalek.ManipulatorArm:GetDescendants() do
		if (p:IsA("BasePart")) then
			if not (p== _Dalek.ManipulatorArm.MaipulatorArmJoint)--[[ and not(p== _Dalek.Gun.MaipulatorArmJoint_2)]] then
				Dalek.Weld(_Dalek.ManipulatorArm.MaipulatorArmJoint, p)
			end
		end
	end
	
end

Dalek.WeldNeck = function(_Dalek)
	
	for i,p in next,_Dalek.Neck:GetDescendants() do
		if (p:IsA("BasePart")) then
			if not (p== _Dalek.Neck.NeckJoint) then
				Dalek.Weld(_Dalek.Neck.NeckJoint, p)
			end
		end
	end
	
end

Dalek.WeldShoulder = function(_Dalek)
	
	for i,p in next,_Dalek.Shoulder:GetDescendants() do
		if (p:IsA("BasePart")) then
			if not (p== _Dalek.Shoulder.ShoulderJoint) then
				Dalek.Weld(_Dalek.Shoulder.ShoulderJoint, p)
			end
		end
	end
end

Dalek.WeldSkirt = function(_Dalek)
	
	for i,p in next,_Dalek.Skirt:GetDescendants() do
		if (p:IsA("BasePart")) then
			if not (p== _Dalek.Skirt.SkirtJoint) then
				Dalek.Weld(_Dalek.Skirt.SkirtJoint, p)
			end
		end
	end
	
end

Dalek.RemoveMorph = function(Player)
	Dalek.MorphList[Player.Name]:Destroy()
	table.remove(Dalek.MorphList,Dalek.MorphList[Player])
	--turn player visible
	local char
	repeat
		char = Player.Character
		wait()
	until char
	for _,a in next, char:GetDescendants() do
		if (a:IsA("BasePart") or (a.ClassName == 'Decal')) and not(a.Name == 'HumanoidRootPart') then 
				a.Transparency=0
		end
	end
	char.Animate.Disabled = false
	char.Humanoid.JumpPower = 50
end

Dalek.MoveEye = function(Player, Rotation)
	--move the eye acording to the rotation of the players camera
	Dalek.MorphList[Player.Name].EyeHinge.TargetAngle = Dalek.MorphList[Player.Name].EyeHinge.TargetAngle + Rotation
end

Dalek.ZeroEye = function(Player)
	--move the eye acording to the rotation of the players camera
	Dalek.MorphList[Player.Name].EyeHinge.TargetAngle = 0
end

Dalek.MoveDome = function(Player, Rotation)
	--rotate the dome acording to key press
	Dalek.MorphList[Player.Name].DomeHinge.TargetAngle = Dalek.MorphList[Player.Name].DomeHinge.TargetAngle + Rotation 
end

return Dalek

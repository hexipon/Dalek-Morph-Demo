local DalekRemoteEvent = game:GetService("ReplicatedStorage"):waitForChild("DalekRemoteEvent")
local Player = game.Players.LocalPlayer or game.Players:GetPropertyChangedSignal("LocalPlayer"):wait()

---
local DalekList = {}
local DeMorph = 5
local Page = 1

local Gui = script.Parent

local _PrevVis = false

getLocations = (function()
	local DalekFolder = game:GetService("ReplicatedStorage"):WaitForChild("Daleks")
	local DalekNameList = {}
	for _,a in next, DalekFolder:getChildren() do
		table.insert(DalekNameList,a.Name)
	end
	table.sort(DalekNameList, function(a,b) return a:lower() < b:lower() end)
	return DalekNameList
end)

Activate = (function(DalekName)
	if(game:GetService("Players").LocalPlayer.PlayerScripts:findFirstChild("DalekLocal")) then
		game:GetService("Players").LocalPlayer.PlayerScripts.DalekLocal:Remove()
	end
	DalekRemoteEvent:FireServer(DalekName, nil)
	local DalekLocalController = game:GetService("ReplicatedStorage").DalekLocal:Clone()
	DalekLocalController.Parent = game:GetService("Players").LocalPlayer.PlayerScripts
	DalekLocalController.Disabled=false
	for _,a in next, Player.Character:GetDescendants() do
		if a.ClassName == 'Sound' then
			a.EmitterSize=0
		end
	end
end)


ButtonsVisible = (function (Visible)
	if Visible == _PrevVis then return end
	_PrevVis = Visible
	if not Visible then
		for i=1,4 do
			Gui.Main["Loc"..i].Visible = false
		end
		Gui.Main.Next.Visible = false
		Gui.Main.Back.Visible = false
	end
	Gui.Main.Size = UDim2.new(0, 450, 0, Visible and 134)
end)

ShowPage = (function (Start,End,List)
	local ii = 1
	for i=Start,End do
		if List[i] then
			Gui.Main["Loc"..ii].LocationName.Text = List[i]
			Gui.Main["Loc"..ii].Visible = true
		else
			Gui.Main["Loc"..ii].Visible = false
		end
		ii = ii + 1
		if ii > 4 then return end
	end
end)

UpdateGuiPage = (function ()
	local Locations = getLocations()
	ShowPage( (Page-1)*4 + 1, Page*4 + 4, Locations )

	if #Locations < 5 then
		Gui.Main.Next.Visible = false
		Gui.Main.Back.Visible = false
	else
		if Locations[Page*4+1] then
			Gui.Main.Next.Visible = true
		else
			Gui.Main.Next.Visible = false
		end
		if Page > 1 then
			Gui.Main.Back.Visible = true
		else
			Gui.Main.Back.Visible = false
		end
	end
end)

for i=1,4 do
	Gui.Main["Loc"..i].MouseButton1Click:connect(function ()
		local ChosenDalek
		for _,v in next, getLocations() do
			if v == Gui.Main["Loc"..i].LocationName.Text then
				ChosenDalek = v
				break
			end
		end
		if not ChosenDalek then return end
		Activate(ChosenDalek)
	end)
end

Gui.Main.Demorph.MouseButton1Click:Connect(function()
	if(game:GetService("Players").LocalPlayer.Character:findFirstChild("Dalek"))then
		game:GetService("Players").LocalPlayer.PlayerScripts:findFirstChild('DalekLocal'):Destroy()
		DalekRemoteEvent:FireServer(nil, DeMorph)
		for _,a in next, Player.Character:GetDescendants() do
			if a.ClassName == 'Sound' then
				a.EmitterSize=5
			end
		end
	end
	
end)

Gui.Main.Back.MouseButton1Click:connect(function ()
	Page = Page - 1
	UpdateGuiPage()
end)
Gui.Main.Next.MouseButton1Click:connect(function ()
	Page = Page + 1
	UpdateGuiPage()
end)
UpdateGuiPage()
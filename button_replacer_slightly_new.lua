-- for newer-ish buttons (stuff like v5.4 with the "supportX" boolvalues or whatever)

local Selection = game:GetService("Selection")

local function transformButton(buttonModel)
	if not buttonModel:IsA("Model") then return end

	local config = buttonModel:FindFirstChild("Configurations") or Instance.new("Folder")
	config.Name = "Configurations"
	config.Parent = buttonModel

	local toMove = {"Timer", "Pressed", "SupportBalloons", "SupportPlayers", "SupportPushboxes", "SupportTurrets", "ColorSpecific", "HideGUI"}
	for _, name in ipairs(toMove) do
		local val = buttonModel:FindFirstChild(name)
		if val then val.Parent = config end
	end

	local clientObject = buttonModel:FindFirstChild("ClientObject")
	if clientObject then clientObject:Destroy() end

	local function addConfigValue(className, name, defaultVal)
		local existing = config:FindFirstChild(name)
		if not existing then
			local obj = Instance.new(className)
			obj.Name = name
			obj.Value = defaultVal
			obj.Parent = config
			return obj
		end
		return existing
	end

	local isPushBox = (buttonModel.Name == "PushBoxButton")

	addConfigValue("BoolValue", "ColorSpecific", false)
	addConfigValue("BoolValue", "HideGUI", false)
	addConfigValue("BoolValue", "SupportBalloons", true)
	
	local supportPlayers = addConfigValue("BoolValue", "SupportPlayers", not isPushBox)
	if isPushBox then supportPlayers.Value = false end

	addConfigValue("BoolValue", "SupportPushboxes", isPushBox)
	addConfigValue("BoolValue", "SupportTurrets", true)

	local buttonPart = nil
	for _, child in ipairs(buttonModel:GetChildren()) do
		if child:IsA("BasePart") then
			if child:FindFirstChild("Press") then
				child.Name = "ButtonPart"
				buttonPart = child

				local cos = child:FindFirstChild("ClientObjectScript")
				if cos then cos:Destroy() end
			end
		end
	end

	local existingInvert = buttonModel:FindFirstChild("Invert")
	if existingInvert and existingInvert:IsA("BoolValue") then
		if existingInvert.Value == true then
			if buttonPart then
				local newInvert = Instance.new("BoolValue")
				newInvert.Name = "Invert"
				newInvert.Value = true
				newInvert.Parent = buttonPart
			end
		end
		existingInvert:Destroy() 
	end

	local label = buttonModel:FindFirstChild("TimerLabel") 
	if not label then
		label = Instance.new("TextLabel")
		label.Name = "TimerLabel"
		label.Parent = buttonModel
	end

	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.Text = "Label"
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.Font = Enum.Font.SourceSansBold

	if not label:FindFirstChild("DefaultColor") then
		local dc = Instance.new("BoolValue")
		dc.Name = "DefaultColor"
		dc.Value = true
		dc.Parent = label
	end

	print("Successfully transformed: " .. buttonModel.Name)
end

for _, obj in ipairs(Selection:Get()) do
	transformButton(obj)
end

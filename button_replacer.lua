local Selection = game:GetService("Selection")

local function transformButton(buttonModel)
	if not buttonModel:IsA("Model") then return end

	local config = buttonModel:FindFirstChild("Configurations") or Instance.new("Folder")
	config.Name = "Configurations"
	config.Parent = buttonModel

	local timer = buttonModel:FindFirstChild("Timer")
	if timer then timer.Parent = config end

	local pressed = buttonModel:FindFirstChild("Pressed")
	if pressed then pressed.Parent = config end

	local function addConfigValue(className, name, val)
		local existing = config:FindFirstChild(name)
		if not existing then
			local obj = Instance.new(className)
			obj.Name = name
			obj.Value = val
			obj.Parent = config
			return obj
		end
		return existing
	end

	addConfigValue("BoolValue", "ColorSpecific", false)
	addConfigValue("BoolValue", "HideGUI", false)
	addConfigValue("BoolValue", "SupportBalloons", true)
	addConfigValue("BoolValue", "SupportPlayers", true)
	
	local isPushBox = (buttonModel.Name == "PushBoxButton")
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
		if buttonPart then
			local newInvert = Instance.new("BoolValue")
			newInvert.Name = "Invert"
			newInvert.Value = true
			newInvert.Parent = buttonPart
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

	print("successfully transformed: " .. buttonModel.Name)
end

for _, obj in ipairs(Selection:Get()) do
	transformButton(obj)
end

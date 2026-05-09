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

	local function addBool(parent, name, val)
		if not parent:FindFirstChild(name) then
			local b = Instance.new("BoolValue")
			b.Name = name
			b.Value = val
			b.Parent = parent
		end
	end

	addBool(config, "ColorSpecific", false)
	addBool(config, "HideGUI", false)
	addBool(config, "SupportBalloons", true)
	addBool(config, "SupportPlayers", true)
	addBool(config, "SupportPushboxes", true)
	addBool(config, "SupportTurrets", true)

	for _, descendant in ipairs(buttonModel:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant:FindFirstChildOfClass("Decal") then
			descendant.Name = "ButtonPart"
			descendant.Parent = buttonModel 
			
			local oldScript = descendant:FindFirstChild("ClientObjectScript")
			if oldScript then oldScript:Destroy() end
			
			local doNotColor = descendant:FindFirstChild("DoNotColor")
			if doNotColor then doNotColor:Destroy() end
		end
	end

	-- TimerLabel Creation/Update Logic
	local label = buttonModel:FindFirstChild("TimerLabel") or Instance.new("TextLabel")
	label.Name = "TimerLabel"
	label.Parent = buttonModel
	
	-- Apply Property Settings from Images
	label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 1
	label.BorderColor3 = Color3.fromRGB(27, 42, 53)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.Text = "Label"
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.TextWrapped = true
	label.Font = Enum.Font.SourceSansBold
	label.Visible = true
	
	addBool(label, "DefaultColor", true)
    
	local invert = buttonModel:FindFirstChild("Invert")
	if invert then invert:Destroy() end
    
	for _, child in ipairs(buttonModel:GetChildren()) do
		if child:IsA("BasePart") and child.Name == "Part" and #child:GetChildren() == 0 then
			child:Destroy()
		end
	end

	print("Successfully updated with TimerLabel: " .. buttonModel.Name)
end

for _, obj in ipairs(Selection:Get()) do
	transformButton(obj)
end

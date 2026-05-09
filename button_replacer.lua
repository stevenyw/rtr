-- PUT THIS IN THE COMMAND BAR AND HIGHLIGHT THE SPECIFIC BUTTON YOU WANT

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

	local function addBool(name, val)
		if not config:FindFirstChild(name) then
			local b = Instance.new("BoolValue")
			b.Name = name
			b.Value = val
			b.Parent = config
		end
	end

	addBool("ColorSpecific", false)
	addBool("HideGUI", false)
	addBool("SupportBalloons", true)
	addBool("SupportPlayers", true)
	addBool("SupportPushboxes", true)
	addBool("SupportTurrets", true)

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
    
	local invert = buttonModel:FindFirstChild("Invert")
	if invert then invert:Destroy() end
    
	for _, child in ipairs(buttonModel:GetChildren()) do
		if child:IsA("BasePart") and child.Name == "Part" and #child:GetChildren() == 0 then
			child:Destroy()
		end
	end

	local label = buttonModel:FindFirstChild("TimerLabel", true)
	if label then label.Parent = buttonModel end

	print("Successfully updated: " .. buttonModel.Name)
end

for _, obj in ipairs(Selection:Get()) do
	transformButton(obj)
end

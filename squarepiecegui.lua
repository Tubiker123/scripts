-- made by gS
loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/z4gs/scripts/master/test.lua"))()
local target,btn,quest,bv
local style = "Fighting Style" -- default
local player = game:GetService("Players").LocalPlayer
local chest = false
local farm = false
local deb = false
local val
local infdash = false
local heartbeat = game:GetService("RunService").Heartbeat
local remote,number
local gui = library:AddWindow("Square Piece", {
    main_color = Color3.fromRGB(0,206,209),
    min_size = Vector2.new(395, 315),
    can_resize = true
})

local tab1 = gui:AddTab("Auto-Farm")
local tab3 = gui:AddTab("Misc")

tab1:AddLabel("Auto Quest")
local drop = tab1:AddDropdown("Select", function(opt)
    quest = opt
end)

tab1:AddLabel("Combat style")
local drop2=tab1:AddDropdown("[ Combat ]", function(opt)
    if opt == "Combat" then
        style = "Fighting Style"
    else
        style = "Sword Style"
    end
end)
drop2:Add("Combat");drop2:Add("Sword")

local slider = tab1:AddSlider("Distance from NPC", function(x)
    val = x
end, { ["min"] = 0, ["max"] = 8 })
slider:Set(90)

btn = tab1:AddButton("Start", function()
    if not farm and number ~= nil and remote ~= nil then
        farm = true
        btn.Text = "Stop"
    else
        if number == nil or remote == nil then
            player:Kick("failed to find the remote")
        end
        btn.Text = "Start"
        farm = false
        wait()
        bv:Destroy()
    end
end)

tab3:AddLabel("Teleports")
local drop3 = tab3:AddDropdown("Select", function(opt)
    player.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.Interactables[opt].HumanoidRootPart.CFrame + workspace.Interactables[opt].HumanoidRootPart.CFrame.lookVector * 5
end)

tab3:AddSwitch("Chest TP", function()
    if not chest then chest = true else chest = false end
end)

tab3:AddSwitch("Inf dash and jump", function()
    if not infdash then infdash = true else infdash = false end
end)

tab3:AddButton("Hide character and name", function()
    player.Character.HumanoidRootPart:FindFirstChild("OverheadUI"):Destroy()
    for i,v in pairs(player.Character:children()) do
        if v.ClassName == "Shirt" or v.ClassName == "Pants" or v.ClassName == "Accessory" then
            v:Destroy()
        end
    end
end)
library:FormatWindows()
tab1:Show()

-- Script starts here --
player.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local mt = getrawmetatable(game)
local old = mt.__namecall
local args
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    args = {...}
    if getnamecallmethod() == "FireServer" and remote == nil and typeof(args[1]) == "string" and typeof(args[2]) == "string" and typeof(args[3]) == "CFrame" and typeof(args[4]) == "number" and #args <= 4 then
        remote = self
        number = args[4]
        return old(self, ...)
    elseif getnamecallmethod() == "InvokeServer" and tostring(self) == "requestDash" and infdash then
        return ""
    end
    return old(self, ...)
end)

player.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

for i,v in pairs(workspace.Interactables:children()) do
    if tostring(v):match("Quest") then
        drop:Add(tostring(v))
    end
end

for i,v in pairs(workspace.Interactables:children()) do
    if not tostring(v):match("Quest") then
        drop3:Add(tostring(v))
    end
end

spawn(function()
    while true do
        if chest then
            for i,v in pairs(workspace.Map.Islands:GetDescendants()) do
                if v.ClassName == "ClickDetector" and tostring(v.Parent) == "ClickDetectorPart" then
                    player.Character:FindFirstChild("HumanoidRootPart").CFrame = v.Parent.CFrame
                    fireclickdetector(v)
                    wait()
                end
            end
        end
        wait(2)
    end
end)

spawn(function()
    for i,v in pairs(player.Backpack:children()) do
        if v.ClassName == "Tool" and #v:children() == 0 then
            player.Character.Humanoid:EquipTool(v)
            player.Character:WaitForChild(v.Name, 30) wait(.5)
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 500, 0, true, game, 1)
        end
    end
end)

local function attack()
    if not deb then
        deb = true
        spawn(function()
            remote:FireServer(style, "MouseButton1", workspace.Camera.CFrame, number)
            wait(.2)
            deb = false
        end)
    end
end

while true do
    if farm then
        pcall(function()
            for i,v in pairs(workspace.Entities:children()) do
                if player.Stats.Armament.Value and not player.Character:FindFirstChild("LeftArmHaki") then
                    remote:FireServer("Fighting Style", "G", workspace.Camera.CFrame, number)
                elseif not player.Character:FindFirstChild("HumanoidRootPart"):FindFirstChildOfClass("BodyVelocity") then
                    bv = Instance.new("BodyVelocity", player.Character.HumanoidRootPart)
                    bv.Velocity = Vector3.new(0,0,0)
                    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
                elseif not player.Quests2:FindFirstChildOfClass("Folder") then
                    player.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.Interactables[quest].HumanoidRootPart.CFrame + workspace.Interactables[quest].HumanoidRootPart.CFrame.lookVector * -3
                    wait(.5)
                        for x = 0, player.Stats.Quests.Value do
                            game:GetService("ReplicatedStorage").Remotes.quest:FireServer(
                                "Accept",
                                    {
                                        ["Index"] = 1, -- you can change this to 2 or 3 if you're doing the quest dummy 1
                                        ["Model"] = workspace.Interactables[quest][quest]
                                    }
                                )
                            wait()
                        end
                    repeat heartbeat:wait() until player.Quests2:FindFirstChildOfClass("Folder")
                    target = player.Quests2:FindFirstChildOfClass("Folder"):WaitForChild("Target").Value
                else
                    target = player.Quests2:FindFirstChildOfClass("Folder"):WaitForChild("Target").Value
                end          
                if v:FindFirstChild("Humanoid").Health > 0 and v.Name ~= player.Name and tostring(v) == target then
                    while v:FindFirstChild("Humanoid").Health > 0 and player.Character:FindFirstChild("Humanoid").Health > 0 and farm do
                        player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame + v.HumanoidRootPart.CFrame.lookVector * (val * -1)
                        attack()
                        heartbeat:wait()
                    end
                end
            end
        end)
    end
    wait()
end

--[[
    Made by gS
]]

loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/z4gs/scripts/master/library.lua"))()

local target,btn,quest,bv,questn,val,remote,chest,farm,deb,infdash
local style = "Fighting Style"
local player = game:GetService("Players").LocalPlayer
local heartbeat = game:GetService("RunService").Heartbeat
local playerstats = game:GetService("ReplicatedStorage").PlayerData[tostring(player)]

local gui = library:AddWindow("Square Piece", {
    main_color = Color3.fromRGB(0,206,209),
    min_size = Vector2.new(395, 315),
    can_resize = true
})

local tab1 = gui:AddTab("Auto-Farm")
local tab3 = gui:AddTab("Misc")

tab1:AddLabel("Quest")
local drop = tab1:AddDropdown("Select", function(opt)
    quest = opt
end)

tab1:AddLabel("Quest number")
local drop4 = tab1:AddDropdown("Select", function(opt)
    questn = tonumber(opt)
end)
for i = 1, 3 do drop4:Add(i) end

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
    if not farm and remote then
        farm = true
        btn.Text = "Stop"
    else
        if not remote then
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
    player.Character.Head:FindFirstChild("face"):Destroy()
    for i,v in pairs(player.Character:children()) do
        if v.ClassName == "Shirt" or v.ClassName == "Pants" or v.ClassName == "Accessory" or v.ClassName == "ShirtGraphic" then
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
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    if getnamecallmethod() == "InvokeServer" and tostring(self) == "requestDash" and infdash then
        return ""
    end
    return old(self, ...)
end)

for i,v in pairs(getgc()) do
    if type(v) == "function" and getfenv(v).script == player.PlayerScripts.Client["Tool Handler"] and getinfo(v).name == "fireRemote" then
        remote = v
    end
end

player.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

for i,v in pairs(workspace.Interactables:children()) do
    if tostring(v):match("Quest") then
        drop:Add(v)
    else
        drop3:Add(v)
    end
end

spawn(function()
    while true do
        if chest then
            for i,v in pairs(workspace.Map.Islands:GetDescendants()) do
                if v.ClassName == "ClickDetector" and tostring(v) == "ClickDetectorPart" then
                    player.Character:FindFirstChild("HumanoidRootPart").CFrame = v.Parent.CFrame
                    fireclickdetector(v)
                    wait()
                end
            end
        end
        wait(2)
    end
end)

local function attack()
    if not deb then
        deb = true
        spawn(function()
            remote(style, "MouseButton1", workspace.Camera.CFrame, workspace.Map.Islands["Mystifine's Village"].Model.Part)
            wait(.1)
            deb = false
        end)
    end
end

while true do
    if farm then
        pcall(function()
            for i,v in pairs(workspace.Entities:children()) do
                if playerstats.Stats.Armament.Value and not player.Character:FindFirstChild("HakiPiece") then
                    remote("Fighting Style", "G", workspace.Camera.CFrame, workspace.Map.Islands["Mystifine's Village"].Model.Part)
                elseif not player.Character:FindFirstChild("HumanoidRootPart"):FindFirstChildOfClass("BodyVelocity") then
                    bv = Instance.new("BodyVelocity", player.Character.HumanoidRootPart)
                    bv.Velocity = Vector3.new(0,0,0)
                    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
                elseif not playerstats.Quests2:FindFirstChildOfClass("Folder") then
                    player.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.Interactables[quest].HumanoidRootPart.CFrame + workspace.Interactables[quest].HumanoidRootPart.CFrame.lookVector * -3
                    wait(.5)
                        for x = 1, playerstats.Stats.Quests.Value do
                            game:GetService("ReplicatedStorage").Remotes.quest:FireServer(
                                "Accept",
                                {
                                    ["Index"] = questn,
                                    ["Model"] = workspace.Interactables[quest][quest]
                                }
                            )
                        end
                    repeat heartbeat:wait() until game:GetService("ReplicatedStorage").PlayerData[player.Name].Quests2:FindFirstChildOfClass("Folder")
                    target = playerstats.Quests2:FindFirstChildOfClass("Folder"):WaitForChild("Target").Value
                else
                    target = playerstats.Quests2:FindFirstChildOfClass("Folder"):WaitForChild("Target").Value
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

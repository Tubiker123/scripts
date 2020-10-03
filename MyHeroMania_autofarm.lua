loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/z4gs/scripts/master/library.lua"))()
    
local gui = library:AddWindow("My Hero Mania Auto Farm", {
    main_color = Color3.fromRGB(0,255,0),
    min_size = Vector2.new(393, 338),
    can_resize = false
})

local punch, skill = game:GetService("ReplicatedStorage").Package.Events.Combat, game:GetService("ReplicatedStorage").Package.Events.Skill
local heartbeat = game:GetService("RunService").Heartbeat
local questgiver,mob,farm,btn,run,bv,autoquest
local player = game:GetService("Players").LocalPlayer
local quests = {}
local tab1 = gui:AddTab("Farm")

tab1:AddLabel("Quest")
local drop = tab1:AddDropdown("Select", function(opt)
    questgiver, mob = rawget(quests, opt), opt
end)
local s = tab1:AddSwitch("Auto Quest", function(bool) autoquest = bool end) s:Set(true)

for i,v in pairs(game:GetService("ReplicatedStorage").Package.Quests:children()) do
    table.insert(quests, v.Target.Value)
    rawset(quests, v.Target.Value, v.Giver.Value)
    drop:Add(v.Target.Value)
end

btn = tab1:AddButton("Start", function()
    if not farm then 
        btn.Text,farm = "Stop", true
        run = game:GetService("RunService").Stepped:connect(function() pcall(function() player.Character.Humanoid:ChangeState(11) end) end) 
    else 
        run:Disconnect()
        btn.Text,farm = "Start", false
    end
end)

library:FormatWindows()
tab1:Show()

spawn(function()
    while true do
        pcall(function()
            if player.Character.HumanoidRootPart:FindFirstChild("Title") and farm then
                player.Character.HumanoidRootPart.Title:Destroy()
                for i,v in pairs(player.Character:children()) do
                    if v.ClassName == "Accessory" or v.ClassName == "Shirt" or v.ClassName == "Pants" or v.ClassName == "ShirtGraphic" then
                        v:Destroy()
                    end
                end
            end
        end)
        wait()
    end
end)

while true do
    if farm then
        pcall(function()
            for i,v in pairs(workspace.Living:children()) do
                if not player.PlayerGui.HUD.Frames.Quest.Visible and autoquest then
                    game:GetService("ReplicatedStorage").Package.Events.GetQuest:InvokeServer(mob.."s")
                    player.PlayerGui.HUD.Frames.Quest.Visible = true
                else
                    if v.Humanoid.Health > 0 and tostring(v) == mob then
                        while v.Humanoid.Health > 0 and player.Character.Humanoid.Health > 0 and farm do
                            player.Character.HumanoidRootPart.CFrame = (v.HumanoidRootPart.CFrame * CFrame.new(0,-11,0)) * CFrame.Angles(-80,0,0)
                            punch:FireServer(math.random(3,4), CFrame.new())
                            heartbeat:wait()
                        end
                    end
                end
            end
        end)
    end
    wait()
end

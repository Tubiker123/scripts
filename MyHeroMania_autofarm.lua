local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local ui = library.Load({
	Title = "My Hero Mania",
	Style = 1,
	SizeX = 300,
	SizeY = 300,
	Theme = "Dark",
})

local heartbeat = game:GetService("RunService").Heartbeat
local questgiver,mob,farm,func
local player = game:GetService("Players").LocalPlayer
local quests = {}
local tab1 = ui.New({Title = "Main"})

for i,v in pairs(game:GetService("ReplicatedStorage").Package.Quests:children()) do
    table.insert(quests, v.Name)
end

for i,v in pairs(getgc()) do
    if type(v) == "function" and getinfo(v).name == "Combat" then
        func = v
    end
end

tab1.Dropdown({
	Text = "Target",
    Callback = function(opt)
        questgiver, mob = opt, game:GetService("ReplicatedStorage").Package.Quests[opt].Target.Value
	end,
	Options = quests
})

tab1.Toggle({
	Text = "Autofarm",
    Callback = function(bool)
        farm = bool   
 	end,
    Enabled = false
})

player.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

coroutine.wrap(function()
    while heartbeat:wait() do
        pcall(function()
            if farm and not player.PlayerGui.HUD.Frames.Quest.Visible then
                game:GetService("ReplicatedStorage").Package.Events.GetQuest:InvokeServer(questgiver)
                player.PlayerGui.HUD.Frames.Quest.Visible = true
            end
            if player.Character.HumanoidRootPart:FindFirstChild("Title") and farm then
                player.Character.HumanoidRootPart.Title:Destroy()
		player.Character.Head.face:Destroy()
		player.Character.Stats.Speed:Destroy()
                for i,v in pairs(player.Character:children()) do
                    if v.ClassName == "Accessory" or v.ClassName == "Shirt" or v.ClassName == "Pants" or v.ClassName == "ShirtGraphic" then
                        v:Destroy()
                    end
                end
            end
        end)
    end
end)()

while heartbeat:wait() do
    if farm then
        pcall(function()
            for i,v in pairs(workspace.Living:children()) do
                if v.Humanoid.Health > 0 and v.Name == mob then
                    while v.Humanoid.Health > 0 and player.Character.Humanoid.Health > 0 and farm do
                        player.Character.HumanoidRootPart.CFrame = (v.HumanoidRootPart.CFrame * CFrame.new(0,4,0)) * CFrame.Angles(80,0,0)
                        spawn(func)
                        heartbeat:wait()
                    end
                end
            end
        end)
    end
end

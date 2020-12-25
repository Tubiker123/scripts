local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local ui = library.Load({
	Title = "My Hero Mania",
	Style = 1,
	SizeX = 300,
	SizeY = 300,
	Theme = "Dark",
})

local heartbeat = game:GetService("RunService").Heartbeat
local questgiver,mob,farm,func,old,infdash
local player = game:GetService("Players").LocalPlayer
local quests = {}

for i,v in pairs(game:GetService("ReplicatedStorage").Package.Quests:children()) do
    table.insert(quests, v.Name)
end

for i,v in pairs(getgc()) do
    if type(v) == "function" and getinfo(v).name == "Combat" then
        func = v
    end
end

local tab1 = ui.New({Title = "Main"})
local tab2 = ui.New({Title = "Misc"})

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
        while farm and wait() do
            pcall(function()
                if not player.PlayerGui.HUD.Frames.Quest.Visible then
                    game:GetService("ReplicatedStorage").Package.Events.GetQuest:InvokeServer(questgiver)
                    player.PlayerGui.HUD.Frames.Quest.Visible = true
                end
                if player.Character.HumanoidRootPart.Title and farm then
                    player.Character.HumanoidRootPart.Title:Destroy()
                    player.Character.Head.face:Destroy()
                    player.Character.Stats.Speed:Destroy()
                    for i,v in pairs(player.Character:children()) do
                        if v:isA("Accessory") or v:isA("Shirt") or v:isA("Pants") or v:isA("ShirtGraphic") then
                            v:Destroy()
                        end
                    end
                end
            end)
        end
    end,
    Enabled = false
})

tab2.Toggle({
    Text = "Inf dash",
    Callback = function(bool)
        infdash = bool
    end,
    Enabled = false
})

old = hookfunction(wait, function(...)
    if debug.traceback():find("Input:453") and infdash then
        return 0
    end
    return old(...)
end)

player.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

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

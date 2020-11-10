--[[
  Made by gS,
  
  [+] autoquest
  [+] instakill
]]

loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/z4gs/scripts/master/library.lua"))()
    
local gui = library:AddWindow("One Piece Millenium 3", {
    main_color = Color3.fromRGB(0,255,127),
    min_size = Vector2.new(360, 315),
    can_resize = false
})

local tab1 = gui:AddTab("Main")
local player = game:GetService("Players").LocalPlayer
local heartbeat = game:GetService("RunService").Heartbeat
local quests, remotes = require(game:GetService("ReplicatedStorage").Modules.Quests), game:GetService("ReplicatedStorage").Remotes
local mob, quest, farm, stpd

tab1:AddLabel("Quest")
local drop = tab1:AddDropdown("Select", function(opt)
    mob, quest = rawget(rawget(quests, opt), "QuestContributors"), opt
end)

for i,v in next, workspace.QuestNPCs:children() do drop:Add(v) end

btn = tab1:AddButton("Start", function()
    if not farm then 
        btn.Text,farm = "Stop", true
        stpd = game:GetService("RunService").Stepped:connect(function()
            player.Character:FindFirstChild("Humanoid"):ChangeState(11)
            setsimulationradius(500)
            player.MaximumSimulationRadius = 500
        end) 
    else 
        stpd:Disconnect()
        btn.Text,farm = "Start", false
    end
end)

library:FormatWindows()
tab1:Show()

player.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

coroutine.wrap(function()
    while wait() do
        if farm then
            if not player.PlayerValues.Quests:FindFirstChild(quest) then
                remotes.ClientE:FireServer({
                    Type = "Quest",
                    Description = player.PlayerGui.Interface.DialogueFrame.dialogueBox.TextArea.Text,
                    ID = quest,
                    NPCName = quest,
                    Job = "AcceptDialogue"
                })
            elseif player.Backpack:FindFirstChild("Combat") and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:EquipTool(player.Backpack.Combat)
            end
        end
    end
end)()

while heartbeat:wait() do
    if farm then
        pcall(function()
            for i,v in next, workspace.Enemies:children() do
                if v.Name == mob then
                    repeat
                        if v.Humanoid.MaxHealth - v.Humanoid.Health > 5 then
                            v.Humanoid.Health = 0
                        end
                        player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * (CFrame.fromAxisAngle(Vector3.new(1,0,0), math.rad(90))) * CFrame.new(0,0,5)
                        player.Character.Combat:Activate()
                        heartbeat:wait()
                    until v.Humanoid.Health <= 0 or player.Character.Humanoid.Health <= 0 or not farm
                end
            end
        end)
    end
end

loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/z4gs/scripts/master/library.lua"))()

local player = game:GetService("Players").LocalPlayer
local heartbeat = game:GetService("RunService").Heartbeat
local remotes = game:GetService("ReplicatedStorage").Remotes
local btn, run, newindex

local gui = library:AddWindow("Flame Zero Auto Farm", {
    main_color = Color3.fromRGB(255, 69, 0),
    min_size = Vector2.new(370, 310),
    can_resize = false
})

local array = {
    ["Bandit"] = "Allen",
    ["Sadistic Pyromancer"] = "Bertrum",
    ["Thug"] = "Hadja",
    ["Thief"] = "Hauno",
    ["Infernal"] = "Shin",
    ["Rogue Pyromancer"] = "Leah",
    ["Horned Infernal"] = "Louis",
    ["Butcher"] = "Jose",
    ["Holy Sol Assassin"] = "Aria",
    ["Holy Sol Special Unit Assassin"] = "Lida",
    ["Evil Pyromancer"] = "Maya",
    ["Artificial Infernal"] = "Mahmoud",
    ["Advanced Artificial Infernal"] = "Chase",
    ["Advance Butchers"] = "Lyon",
    ["Elite Butchers"] = "Jake"
}

local tab = gui:AddTab("Main")

tab:AddLabel("NPC")
local drop = tab:AddDropdown("Select", function(opt) array.target, array.quest = opt, npcs[opt] end)

for i,v in next, array do drop:Add(i) end

tab:AddLabel("Weapon")
local drop2 = tab:AddDropdown("Select", function(opt) array.weap = opt end)

for i,v in next, player.Backpack:children() do 
    if v.ClassName == "Tool" and not v.Name:match("Gen") then 
        drop2:Add(v) 
    end 
end

btn = tab:AddButton("Start", function()
    if not array.farm then
        run = game:GetService("RunService").Stepped:connect(function()
            pcall(function() player.Character.Humanoid:ChangeState(11) end)
        end)
        array.farm = true btn.Text = "Stop"
    else
        array.farm = false btn.Text = "Start"
        run:Disconnect()
    end
end)

library:FormatWindows()
tab:Show()

player.PlayerGui.DeathScreen.Enabled = false

player.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

newindex = hookfunction(getrawmetatable(game).__newindex, newcclosure(function(a, b, c)
    if b == "Health" and not checkcaller() then
        return
    end
    return newindex(a, b, c)
end))

spawn(function()
    while wait() do
        if array.farm and player.PlayerFolder.QuestMax.Value == 0 then
            pcall(function()
                player.Character.HumanoidRootPart.CFrame = workspace.NPCS[quest].HumanoidRootPart.CFrame
                remotes.Player.NPCChat:FireServer("Re-Do", quest)
            end)
        end
    end
end)

while wait() do
    if array.farm then
        pcall(function()
            for i,v in next, workspace.FightableNPCS:children() do
                if v.Name == array.target then
                    while v.Humanoid.Health > 0 and farm and player.Character.Humanoid.Health > 0 do
                        player.Character.HumanoidRootPart.CFrame = (v.HumanoidRootPart.CFrame * CFrame.new(0,5,0)) * CFrame.Angles(80,0,0)
                        if array.weap == "Combat" then
                            remotes.Melee.Combat:FireServer("Punch", 1)
                        else
                            remotes.Melee.Sword:FireServer(weap, "Slash", 1)
                        end
                        heartbeat:wait()
                    end
                end
            end
        end)
    end
end

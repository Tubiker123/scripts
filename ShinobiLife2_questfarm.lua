getgenv().options = {
    autofarm = true,
    autorank = false -- not done too lazy to get lvl 1000 to discover the rank remote
}

local player = game:GetService("Players").LocalPlayer
local heartbeat = game:GetService("RunService").Heartbeat
local mobmission

if workspace:FindFirstChild("CCoff") then
    workspace.CCoff:Destroy()
end

local function getQuest()
    for i,v in next, workspace.missiongivers:children() do
        if v.Name == "" and v.Head.givemission.Enabled and v.Head.givemission.color.Image == "http://www.roblox.com/asset/?id=5459241648" then -- get defeat npc missions
            return v
        elseif v.Name == "" and v.Head.givemission.Enabled and v.Head.givemission.color.Image == "http://www.roblox.com/asset/?id=5459241799" and player.statz.lvl.lvl.Value >= 700 then -- get defeat boss missions if your level >= 700
            return v
        end
    end
end

player.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

while getgenv().options.autofarm do
    if not player.currentmission.Value then
        mobmission = getQuest()
        if mobmission then
            repeat
                player.Character.HumanoidRootPart.CFrame = mobmission.HumanoidRootPart.CFrame
                mobmission.CLIENTTALK:FireServer()
                mobmission.CLIENTTALK:FireServer("accept")
                heartbeat:wait() 
            until player.currentmission.Value
            mobmission = nil
        end
    end
    pcall(function()
        for i,v in next, workspace.npc:children() do
            if v.Name ~= "logtraining" and v.HumanoidRootPart:FindFirstChild("BLOCKBAR") then
                while v.Humanoid.Health > 0 do
                    for i = 0, 20 do
                        v.Humanoid.Health = 0
                    end
                    player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
                    wait()
                end
            end
        end
    end)
    heartbeat:wait()
end

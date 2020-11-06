--[[
    Made by gS

    Features {
        [+] Auto quest,
        [+] Auto rank up
        [+] Anti tp bypass,
        [+] Anti afk,
        [+] Instakill
    }
]]

getgenv().options = {
    autofarm = true,
    autorankup = true
}

local player = game:GetService("Players").LocalPlayer
local heartbeat = game:GetService("RunService").Heartbeat
local mobmission

hookfunction(getrenv().print, newcclosure(function() end)

local function getQuest()
    for i,v in next, workspace.missiongivers:children() do
        if v.Name == "" and v.Head.givemission.Enabled and v.Head.givemission.color.Image == "http://www.roblox.com/asset/?id=5459241648" then
            return v
        elseif v.Name == "" and v.Head.givemission.Enabled and v.Head.givemission.color.Image == "http://www.roblox.com/asset/?id=5459241799" and player.statz.lvl.lvl.Value >= 700 then
            return v
        end
    end
end

player.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

while options.autofarm do
    if options.autorankup and player.statz.lvl.lvl.Value == 1000 then
        player.startevent:FireServer("rankup")
    end
    pcall(function()
        if not player.currentmission.Value then
            mobmission = getQuest()
            if mobmission then
                repeat
                    player.Character.HumanoidRootPart.CFrame = mobmission.HumanoidRootPart.CFrame
                    mobmission:WaitForChild("CLIENTTALK"):FireServer()
                    mobmission:WaitForChild("CLIENTTALK"):FireServer("accept")
                    heartbeat:wait() 
                until player.currentmission.Value
                mobmission = nil
            end
        else
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
        end
    end)
    heartbeat:wait()
end

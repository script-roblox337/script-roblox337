-- ServerScript trong ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local BanDataStore = DataStoreService:GetDataStore("TempBanStore")
local banEvent = ReplicatedStorage:WaitForChild("BanEvent")

local BAN_DURATION = 10 * 60 -- 10 phút tính bằng giây

-- Khi người chơi vào game
Players.PlayerAdded:Connect(function(player)
	local userId = player.UserId
	local banData, err = BanDataStore:GetAsync(tostring(userId))

	if banData then
		local currentTime = os.time()
		if currentTime < banData then
			local remaining = math.floor((banData - currentTime) / 60)
			player:Kick("Bạn bị ban. Còn lại: " .. remaining .. " phút.")
		else
			-- Hết hạn ban
			BanDataStore:RemoveAsync(tostring(userId))
		end
	end
end)

-- Nhận lệnh ban từ admin
banEvent.OnServerEvent:Connect(function(sender, targetName)
	if sender.Name ~= "jtiydoyxll" then return end  -- thay bằng tên admin

	for _, targetPlayer in pairs(Players:GetPlayers()) do
		if targetPlayer.Name:lower() == targetName:lower() then
			local banUntil = os.time() + BAN_DURATION
			BanDataStore:SetAsync(tostring(targetPlayer.UserId), banUntil)
			targetPlayer:Kick("Bạn đã bị ban trong 10 phút.")
			break
		end
	end
end)

-- put this in serverscriptservice, and replace the default ID with the player in the message

local DataStoreService = game:GetService("DataStoreService")

local targetIds = {
    "28361612"
}

local stores = {
    "HDAdminPlayerDataV1.0",
    "HDAdminSystemDataV1.0"
}

print("---Badge wipe initiated...---")

for _, userId in ipairs(targetIds) do
    print("Cleaning data for UserID: " .. userId)

    for _, storeName in ipairs(stores) do
        local success, ds = pcall(function()
            return DataStoreService:GetDataStore(storeName)
        end)

        if success then
            local keysToTry = {userId, "Player_" .. userId, "User_" .. userId}

            for _, key in ipairs(keysToTry) do
                local removeSuccess, err = pcall(function()
                    return ds:RemoveAsync(key)
                end)

                if not removeSuccess then
                    warn("Error on key " .. key .. ": " .. tostring(err))
                end
            end
        else
            warn("Could not access DataStore: " .. storeName)
        end
    end
    print("Done with UserID: " .. userId)
    print("---------------------------")
end

print("--- ALL REQUESTS PROCESSED ---")

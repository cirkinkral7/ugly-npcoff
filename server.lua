local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    
    -- Konsol çıktısı
    print('^2[gladius-npc-handler]^7: Tum NPC ve Trafik akisi basariyla devre disi birakildi.')
end)
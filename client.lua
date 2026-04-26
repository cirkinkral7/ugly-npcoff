Citizen.CreateThread(function()
    while true do
        -- NPC ve Araç çarpanlarını sıfırla
        SetVehicleDensityMultiplierThisFrame(0.0)      -- Trafikteki araçlar
        SetPedDensityMultiplierThisFrame(3.0)          -- Yürüyen yayalar
        SetRandomVehicleDensityMultiplierThisFrame(0.0)-- Rastgele araçlar
        SetParkedVehicleDensityMultiplierThisFrame(0.0)-- Park halindeki araçlar
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0) -- Senaryo gereği duran NPC'ler
        
        -- Acil durum araçlarını ve rastgele olayları kapat
        SetGarbageTrucks(false) 
        SetRandomBoats(false)
        SetCreateRandomCops(false) 
        SetCreateRandomCopsNotOnScenarios(false)
        SetCreateRandomCopsOnScenarios(false)

        -- Dispatch (Polis, Ambulans vb.) birimlerini tamamen durdur
        for i = 1, 15 do
            EnableDispatchService(i, false)
        end

        Citizen.Wait(0) -- Bu değerlerin her frame'de yenilenmesi gerekir
    end
end)
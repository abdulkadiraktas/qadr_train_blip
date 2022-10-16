function trainChecker(train)
    if IsThisModelATrain(GetEntityModel(train)) then
        local trainTrailerNumber = Citizen.InvokeNative(0x60B7D1DCC312697D,train) -- GetTrainCarriageTrailerNumber
        local isTrainIsReal = GetTrainCarriage(train,trainTrailerNumber-1)
        if isTrainIsReal ~= 0 then
            if not Citizen.InvokeNative(0x9FA00E2FC134A9D0,train) then -- DoesEntityHaveBlip
                local createdBlip = addBlipToTrain(-399496385,train,"Train")
                print("Train blip created.",createdBlip)
            end
        end
    end
end

function addBlipToTrain(blipType,train,blipText)
    local blip = Citizen.InvokeNative(0x23f74c2fda6e7c61, blipType, train) -- BlipAddForEntity
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, blipText)    -- SetBlipNameFromPlayerString
    return blip
end

function getTrains()
    local handle, firstVehicle = FindFirstVehicle()
    trainChecker(firstVehicle)
    local isExist, nextVeh = FindNextVehicle(handle)
    while isExist do
        trainChecker(nextVeh)
        isExist, nextVeh = FindNextVehicle(handle)
    end
    EndFindVehicle(handle)
end

Citizen.CreateThread(function()
    while true do
        getTrains()
        Wait(10000)
    end
end)
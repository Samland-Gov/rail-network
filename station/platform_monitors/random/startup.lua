local monitors = require "monitors"

local destinations = {
    "Iron Valley",
    "Coal Town", 
    "Steel Junction",
    "Copper Town",
    "Gold City",
    "Diamond Peak",
    "Redstone Rapids"
}

local trains = {
    {
        destination = "Iron Valley",
        time = "14:30",
        callingAt = "Steel Junction, Copper Town, Gold City"
    },
    {
        destination = "Coal Town",
        time = "14:45"
    }
}

local function generateTime()
    local hour = math.random(0, 23)
    local minute = math.random(0, 59)
    return string.format("%02d:%02d", hour, minute)
end

local function updateTrains()
    while true do
        -- Randomly remove trains
        for i = #trains, 1, -1 do
            if math.random() < 0.3 then -- 30% chance to remove each train
                table.remove(trains, i)
            end
        end

        -- Randomly add new trains
        if #trains < 5 and math.random() < 0.7 then -- 70% chance to add if less than 5 trains
            local newTrain = {
                destination = destinations[math.random(#destinations)],
                time = generateTime()
            }

            -- 50% chance to add calling points
            if math.random() < 0.5 then
                local calls = {}
                local numCalls = math.random(1, 3)
                for i = 1, numCalls do
                    table.insert(calls, destinations[math.random(#destinations)])
                end
                newTrain.callingAt = table.concat(calls, ", ")
            end

            table.insert(trains, newTrain)
        end

        sleep(5)
    end
end

monitors.setupMonitors()

parallel.waitForAll(updateTrains, function()
    monitors.displayTrainInfo(trains)
end)
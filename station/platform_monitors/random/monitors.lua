local monitors = {}

-- Detect and wrap all connected monitors
for _, side in ipairs(peripheral.getNames()) do
    if peripheral.getType(side) == "monitor" then
        table.insert(monitors, peripheral.wrap(side))
    end
end

-- Function to set up monitors
local function setupMonitors()
    for _, monitor in ipairs(monitors) do
        monitor.setTextScale(1) -- Adjust text size
        monitor.clear()
    end
end

-- Function to right-align text
local function rightAlign(monitor, text, row)
    local width, _ = monitor.getSize()
    local x = width - #text + 1
    monitor.setCursorPos(x, row)
    monitor.write(text)
end

-- Function to centre-align text
local function centerAlign(monitor, text, row)
    local width, _ = monitor.getSize()
    local x = math.floor((width - #text) / 2) + 1
    monitor.setCursorPos(x, row)
    monitor.write(text)
end

-- Function to render scrolling text
local function scrollText(monitor, text, row, offset)
    local width, _ = monitor.getSize()
    local len = #text
    if len <= width then
        monitor.setCursorPos(1, row)
        monitor.write(text)
    else
        local displayText = text:sub(offset, offset + width - 1)
        monitor.setCursorPos(1, row)
        monitor.write(displayText)
    end
end

-- Main display function
local function displayTrainInfo(trains)
    local scrollOffset = 1
    local scrollSpeed = 0.2 -- Adjust scrolling speed

    while true do
        local width, _ = monitors[1]:getSize()

        local train1 = trains[1]
        local train2 = trains[2]

        for _, monitor in ipairs(monitors) do
            monitor.clear()

            -- First Train
            if train1 then
                monitor.setCursorPos(1, 1)
                monitor.write(train1.destination)
                rightAlign(monitor, train1.time, 1)

                -- First Train Calling At (Scrolling)
                if train1.callingAt then
                    scrollText(monitor, "Calling at: " .. train1.callingAt, 2, scrollOffset)
                end
            end

            -- Second Train (without Calling At)
            if train2 then
                monitor.setCursorPos(1, 3)
                monitor.write("2nd " .. train2.destination)
                rightAlign(monitor, train2.time, 3)
            end

            -- Empty line
            monitor.setCursorPos(1, 4)
            monitor.write("")

            -- Current time (centre-aligned)
            local time = textutils.formatTime(os.time(), true)
            centerAlign(monitor, "Current Time: " .. time, 5)
        end

        -- Update scrolling offset
        if train1 and train1.callingAt and #train1.callingAt > width then
            scrollOffset = scrollOffset + 1
            -- Reset only after the entire text has scrolled past
            if scrollOffset > #train1.callingAt + width / 2 then
                scrollOffset = 1
            end
        end

        sleep(scrollSpeed) -- Loop delay to control updates
    end
end

lib = {
    setupMonitors = setupMonitors,
    displayTrainInfo = displayTrainInfo
}

return lib
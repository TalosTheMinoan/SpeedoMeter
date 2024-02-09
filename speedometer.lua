local speedUnit = "km/h" -- Set the speed unit to kilometers per hour ("km/h") or miles per hour ("mph")
local speedMultiplier = (speedUnit == "km/h") and 3.6 or 2.237 -- Conversion factor for speed units

local themes = {
    "modern",
    "retro",
    "futuristic",
    "minimalist"
}

local currentTheme = "modern" -- Default theme

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local speed = GetEntitySpeed(vehicle) * speedMultiplier
            
            -- Display speed on the screen
            DrawSpeedometer(speed)
        end
    end
end)

function DrawSpeedometer(speed)
    SetTextFont(4)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()

    -- Draw the speedometer
    local text = string.format("%s: %.1f %s", "Speed", speed, speedUnit)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.9, 0.8)

    -- Draw speed trend indicator
    DrawSpeedTrendIndicator(speed)
end

function DrawSpeedTrendIndicator(speed)
    local trendArrow = "→" -- Default arrow indicating constant speed
    local prevSpeed = prevSpeed or speed

    if speed > prevSpeed then
        trendArrow = "↑" -- Arrow indicating increasing speed
    elseif speed < prevSpeed then
        trendArrow = "↓" -- Arrow indicating decreasing speed
    end

    SetTextFont(4)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()

    -- Draw the trend indicator
    local text = string.format("Trend: %s", trendArrow)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.9, 0.75)

    prevSpeed = speed
end

-- Function to change speedometer theme
function ChangeSpeedometerTheme(theme)
    if themes[theme] then
        currentTheme = themes[theme]
        -- Implement theme change logic here
    else
        print("Invalid theme specified.")
    end
end

-- Command to change speedometer theme
RegisterCommand("changetheme", function(source, args)
    local theme = tonumber(args[1])
    ChangeSpeedometerTheme(theme)
end, false)

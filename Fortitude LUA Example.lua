---------------------------------------------
-- U2SE's Fortitude LUA Example Script --
---------------------------------------------
system.setScriptName("~t4~Fortitude ~u~Example Script") -- Here we set the script name/title


-- Submenus
local ped_spawner = menu.addSubmenu("", "~t3~Ped Spawner", "Ped spawn/delete examples.") -- Submenu for ped spawner
local object_spawner = menu.addSubmenu("", "~t5~Object Spawner", "Object spawn/delete examples.") -- Submenu for object spawner
local vehicle_spawner = menu.addSubmenu("", "~t2~Vehicle Spawner", "Vehicle spawn/delete examples.") -- Submenu for vehicle spawner


-----------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------
-- Basic color codes for text --
---------------------------------

-- ~e~ = Red Text
-- ~u~ = Pink Text
-- ~t1~ = Purple Text
-- ~t2~ = Orange Text
-- ~t3~ = Light Blue Text
-- ~t4~ = Yellow Text
-- ~t5~ = Light Pink Text
-- ~t6~ = Green Text
-- ~v~ = Black Text
-- ~q~ = White Text
-- ~m~ = Gray Text
-- ~t~ = Light Gray Text
-- ~s~ = Reset Color Text

-- Keep in mind that coloring text may interfere with peoples Fortitude Themes!


-----------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------
-- Basic color codes for logger text --
-----------------------------------------

-- <red> = Red Text
-- <green> = Green Text
-- <blue> = Blue Text
-- <darkred> = Dark Red Text
-- <darkgreen> = Dark Green Text
-- <darkblue> = Dark Blue Text
-- <white> = White Text
-- <cyan> = Cyan Text
-- <magenta> = Magenta Text
-- <gray> = Gray Text
-- <darkgray> = Dark Gray Text

-- You can also use custom colors via hex code, just make sure to enter the hex like this: <#ffffff>

-----------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------
-- Font codes for text --
--------------------------

-- ~italic~ = Italic
-- ~bold~ = Bold
-- ~h~ = Highlight


--------------------------
-- Font codes for text --
--------------------------

-- ~italic~ = Italic
-- ~bold~ = Bold
-- ~h~ = Highlight


-----------------------------------------------------------------------------------------------------------------------------------------------------


----------------------------------
-- Font codes for logger text --
----------------------------------

-- ~italic~ = Italic
-- <b> = Bold
-- </b> = Remove Bold
-- <u> = Underline


-----------------------------------------------------------------------------------------------------------------------------------------------------



-- Global variable to control notifications display
local displayNotifications = true

menu.addDivider("", "Notification Settings") -- Adds divider in script to give a more organized appearance

menu.addToggleButton("", "Enable Notifications", "Enable/disable all notifications.", true, function (toggle)
    displayNotifications = toggle
    if displayNotifications then
        logger.logInfo("<green>Notifications Enabled")
        notifications.alertInfo("Notifications:", "~t6~Enabled")
    else
        logger.logInfo("<red>Notifications Disabled")
        notifications.alertInfo("Notifications:", "~e~Disabled")
    end
end)


-- Global variables for spawned entities
local spawnedPed = nil
local spawnedObject = nil
local spawnedVehicle = nil
local currentPedVariant = 0 -- Default ped variant 
local currentVehicleTint = 0 -- Default vehicle tint
local currentVehicleLivery = 0 -- Default vehicle livery



-- Define lists of ped, object, and vehicle models (hashes and names)
local pedModels = {
    { name = "~u~MP_Male", hash = 0xF5C1611E },
    { name = "~u~MP_Female", hash = 0xA7AF20C0 },
    { name = "~u~Player_Zero", hash = 0x0D7114C9 },
    { name = "~u~Player_Three", hash = 0x00B69710 }
}

local objectModels = {
    { name = "~u~Streetlight", hash = 0xAC2F3FD0 },
    { name = "~u~Knife", hash = 0x7571214C },
    { name = "~u~Shoe", hash = 0xD416F7E8 },
    { name = "~u~Gun", hash = 0xCF80443D }
}

local vehicleModels = {
    { name = "~u~Oil Wagon", hash = 0xC3E6C004},
    { name = "~u~Police Wagon", hash = 0xB203C6B3 },
    { name = "~u~Supply Wagon", hash = 0xEC2A1018 },
    { name = "~u~Circus Wagon", hash = 0xC2D200FE }
}

-- Current selected model hashes (initialized to the first item's hash)
local currentPedHash = pedModels[1].hash
local currentObjectHash = objectModels[1].hash
local currentVehicleHash = vehicleModels[1].hash

-- Ped Spawner
menu.addDivider(ped_spawner, "Ped Spawner")

menu.addIntSpinner(ped_spawner, "IntSpinner : : Select Ped Model", "Choose the ped model to spawn.", 0, #pedModels, 1, 1, function(currentValue)
    currentPedHash = pedModels[currentValue].hash
    if displayNotifications then
        logger.logInfo("Selected Ped: " .. pedModels[currentValue].name .. " (Hash: " .. string.format("0x%X", currentPedHash) .. ")")
        notifications.alertInfo("Ped Spawner:", "Selected: ~u~" .. pedModels[currentValue].name)
    end
end)


menu.addIntSpinner(ped_spawner, "IntSpinner : : Set Ped Variant", "Choose the variant for the selected ped model.", 1, 300, 1, currentPedVariant, function(value)
    currentPedVariant = value
    if displayNotifications then
        logger.logInfo("Selected Ped Variant: " .. currentPedVariant)
        notifications.alertInfo("Ped Spawner:", "Selected Variant: ~u~" .. currentPedVariant)
    end
end)


menu.addButton(ped_spawner, "Button : :  Spawn Ped", "Click to spawn the selected ped.", function ()
    local local_x, local_y, local_z = player.getLocalPedCoords()
        spawnedPed = spawner.spawnPed(currentPedHash, local_x, local_y, local_z, true)
        natives.ped_equipPedOutfitPreset(spawnedPed, currentPedVariant, false)
        if displayNotifications then
            logger.logInfo("<green>Spawned ped at local coords: " .. string.format("0x%X", currentPedHash))
            notifications.alertInfo("Ped Spawner:", "~t6~Spawned ped")
    end
end)


menu.addButton(ped_spawner, "Button : :  Delete Ped", "Click to delete the spawned ped.", function ()
        spawner.deletePed(spawnedPed)
        if displayNotifications then
            logger.logInfo("<red>Deleted ped at local coords: " .. string.format("0x%X", currentPedHash))
            notifications.alertInfo("Ped Spawner:", "~e~Deleted ped")
    end
end)


menu.addToggleButton(ped_spawner, "ToggleButton : : Spawn/Delete Ped", "Toggle to spawn or delete the selected ped.", false, function (toggle)
    local local_x, local_y, local_z = player.getLocalPedCoords()
    if toggle then
        if spawnedPed then
            spawner.deletePed(spawnedPed) -- Delete previous ped if exists
            spawnedPed = nil
        end
        spawnedPed = spawner.spawnPed(currentPedHash, local_x, local_y, local_z, true)
        natives.ped_equipPedOutfitPreset(spawnedPed, currentPedVariant, false)
        if displayNotifications then
            logger.logInfo("<green>Spawned ped at local coords: " .. string.format("0x%X", currentPedHash))
            notifications.alertInfo("Ped Spawner:", "~t6~Spawned ped")
        end
    else
        if spawnedPed then
            spawner.deletePed(spawnedPed)
            spawnedPed = nil
            if displayNotifications then
                logger.logInfo("<red>Deleted ped at local coords: " .. string.format("0x%X", currentPedHash))
                notifications.alertInfo("Ped Spawner:", "~e~Deleted ped")
            end
        else
            if displayNotifications then
                logger.logInfo("<red>No ped to delete")
                notifications.alertInfo("Ped Spawner:", "~e~No ped spawned")
            end
        end
    end
end)


-- Object Spawner
menu.addDivider(object_spawner, "Object Spawner")

menu.addIntSpinner(object_spawner, "IntSpinner : : Select Object Model", "Choose the object model to spawn.", 1, #objectModels, 1, 1, function(currentValue)
    currentObjectHash = objectModels[currentValue].hash
    if displayNotifications then
        logger.logInfo("Selected Object: " .. objectModels[currentValue].name .. " (Hash: " .. string.format("0x%X", currentObjectHash) .. ")")
        notifications.alertInfo("Object Spawner:", "Selected: ~u~" .. objectModels[currentValue].name)
    end
end)


menu.addButton(object_spawner, "Button : :  Spawn Object", "Click to spawn the selected object.", function ()
    local local_x, local_y, local_z = player.getLocalPedCoords()
        spawnedObject = spawner.spawnObject(currentObjectHash, local_x, local_y, local_z, true)
        if displayNotifications then
            logger.logInfo("<green>Spawned object at local coords: " .. string.format("0x%X", currentObjectHash))
            notifications.alertInfo("Object Spawner:", "~t6~Spawned object")
    end
end)


menu.addButton(object_spawner, "Button : :  Delete Object", "Click to delete the spawned object.", function ()
        spawner.deleteObject(spawnedObject)
        if displayNotifications then
            logger.logInfo("<red>Deleted object at local coords: " .. string.format("0x%X", currentObjectHash))
            notifications.alertInfo("Object Spawner:", "~e~Deleted object")
    end
end)


menu.addToggleButton(object_spawner, "ToggleButton : : Spawn/Delete Object", "Toggle to spawn or delete the selected object.", false, function (toggle)
    local local_x, local_y, local_z = player.getLocalPedCoords()
    if toggle then
        if spawnedObject then
            spawner.deleteObject(spawnedObject) -- Delete previous object if exists
            spawnedObject = nil
        end
        spawnedObject = spawner.spawnObject(currentObjectHash, local_x, local_y, local_z, true)
        if displayNotifications then
            logger.logInfo("<green>Spawned object at local coords: " .. string.format("0x%X", currentObjectHash))
            notifications.alertInfo("Object Spawner:", "~t6~Spawned object")
        end
    else
        if spawnedObject then
            spawner.deleteObject(spawnedObject)
            spawnedObject = nil
            if displayNotifications then
                logger.logInfo("<red>Deleted object at local coords: " .. string.format("0x%X", currentObjectHash))
                notifications.alertInfo("Object Spawner:", "~e~Deleted object")
            end
        else
            if displayNotifications then
                logger.logInfo("<red>No object to delete")
                notifications.alertInfo("Object Spawner:", "~e~No object spawned")
            end
        end
    end
end)

-- Vehicle Spawner
menu.addDivider(vehicle_spawner, "Vehicle Spawner")

menu.addIntSpinner(vehicle_spawner, "IntSpinner : : Select Vehicle Model", "Choose the vehicle model to spawn.", 1, #vehicleModels, 1, 1, function(currentValue)
    currentVehicleHash = vehicleModels[currentValue].hash
    if displayNotifications then
        logger.logInfo("Selected Vehicle: " .. vehicleModels[currentValue].name .. " (Hash: " .. string.format("0x%X", currentVehicleHash) .. ")")
        notifications.alertInfo("Vehicle Spawner:", "Selected: ~u~" .. vehicleModels[currentValue].name)
    end
end)


menu.addIntSpinner(vehicle_spawner, "IntSpinner : : Set Vehicle Tint", "Choose the tint for the selected vehicle model.", 1, 300, 1, currentVehicleTint, function(value)
    currentVehicleTint = value
    if displayNotifications then
        logger.logInfo("Selected Vehicle Tint: " .. currentVehicleTint)
        notifications.alertInfo("Vehicle Spawner:", "Selected Tint: ~u~" .. currentVehicleTint)
    end
end)


menu.addIntSpinner(vehicle_spawner, "IntSpinner : : Set Vehicle Livery", "Choose the livery for the selected vehicle model.", 1, 300, 1, currentVehicleLivery, function(value) -- Note that not all vehicles support livery changes, you may have to change the hashes and find a wagon that does
    currentVehicleLivery = value
    if displayNotifications then
        logger.logInfo("Selected Vehicle Livery: " .. currentVehicleLivery)
        notifications.alertInfo("Vehicle Spawner:", "Selected Livery: ~u~" .. currentVehicleLivery)
    end
end)


menu.addButton(vehicle_spawner, "Button : :  Spawn Vehicle", "Click to spawn the selected vehicle.", function ()
    local local_x, local_y, local_z = player.getLocalPedCoords()
        spawnedVehicle = spawner.spawnVehicle(currentVehicleHash, local_x, local_y, local_z, false, true)
        natives.vehicle_setVehicleTint(spawnedVehicle, value)
	natives.vehicle_setVehicleLivery(spawnedVehicle, value)
        if displayNotifications then
            logger.logInfo("<green>Spawned vehicle at local coords: " .. string.format("0x%X", currentVehicleHash))
            notifications.alertInfo("Vehicle Spawner:", "~t6~Spawned vehicle")
    end
end)


menu.addButton(vehicle_spawner, "Button : :  Delete Vehicle", "Click to delete the spawned vehicle.", function ()
        spawner.deleteVehicle(spawnedVehicle)
        if displayNotifications then
            logger.logInfo("<red>Deleted vehicle at local coords: " .. string.format("0x%X", currentVehicleHash))
            notifications.alertInfo("Vehicle Spawner:", "~e~Deleted vehicle")
    end
end)


menu.addToggleButton(vehicle_spawner, "ToggleButton : : Spawn/Delete Vehicle", "Toggle to spawn or delete the selected vehicle.", false, function (toggle)
    local local_x, local_y, local_z = player.getLocalPedCoords()
    if toggle then
        if spawnedVehicle then
            spawner.deleteVehicle(spawnedVehicle) -- Delete previous vehicle if exists
            spawnedVehicle = nil
        end
        spawnedVehicle = spawner.spawnVehicle(currentVehicleHash, local_x, local_y, local_z, false, true)
        natives.vehicle_setVehicleTint(spawnedVehicle, value)
	natives.vehicle_setVehicleLivery(spawnedVehicle, value)
        if displayNotifications then
            logger.logInfo("<green>Spawned vehicle at local coords: " .. string.format("0x%X", currentVehicleHash))
            notifications.alertInfo("Vehicle Spawner:", "~t6~Spawned vehicle")
        end
    else
        if spawnedVehicle then
            spawner.deleteVehicle(spawnedVehicle)
            spawnedVehicle = nil
            if displayNotifications then
                logger.logInfo("<red>Deleted vehicle at local coords: " .. string.format("0x%X", currentVehicleHash))
                notifications.alertInfo("Spawner:", "~e~Deleted vehicle")
            end
        else
            if displayNotifications then
                logger.logInfo("<red>No vehicle to delete")
                notifications.alertInfo("Spawner:", "~e~No vehicle spawned")
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------------------


-------------------
-- Script Credit --
-------------------

menu.addDivider("", "~u~: : ~s~Built For LUA Learners ~u~: :")
menu.addDivider("", "~t4~: : ~s~Developed By ~u~U2SE ~t4~: :")
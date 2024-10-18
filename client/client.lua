local currentLocale = "en"  --locals "en","cz","sk"

local function canOpenTarget(ped)
    return IsPedFatallyInjured(ped)
        or IsPedDeadOrDying(ped)
        or IsEntityPlayingAnim(ped, 'dead', 'dead_a', 3)
        or IsPedCuffed(ped)
        or IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3)
        or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 3)
        or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_enter', 3)
        or IsEntityPlayingAnim(ped, 'random@mugging3', 'handsup_standing_base', 3)
end


local locales = {}
local localeFile = 'locales/' .. currentLocale .. '.lua' 

local success, err = loadfile(localeFile)

if success then
    locales = success()
else
    print("Error loading locale file:", err)
end

local options = {
    {
        name = 'dx_steal:main',
        distance = 2,
        icon = 'fa-solid fa-magnifying-glass',
        label = locales['search'], 
        onSelect = function (data)
            if canOpenTarget(data.entity) then
                if dx.Progress then
                    if lib.progressBar({
                        duration = dx.ProgressLength,
                        label = locales['searching'], 
                        position = 'bottom',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                            move = true,
                            combat = true,
                        },
                        anim = {
                            dict = 'anim@gangops@facility@servers@bodysearch@',
                            clip = 'player_search'
                        },
                    }) then
                        exports.ox_inventory:openNearbyInventory()
                    else
                        lib.notify({
                            title = locales['searching_title'], -- 
                            description = locales['searching_cancelled'], 
                            type = 'error',
                            position = 'top'
                        })
                    end
                end
            else
                lib.notify({
                    title = locales['searching_title'], 
                    description = locales['invalid_target'], 
                    type = 'error',
                    position = 'top'
                })
            end
        end
    },
}

exports.ox_target:addGlobalPlayer(options)

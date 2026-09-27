while not import do
    sleep()
end

import('@entry_points/adv_map_entry_point')

local t1 = CREATURES_ITERATOR.FilterMap(
---@param item Creature
function (item)
    if item:HasAbility(ABILITY_TAXPAYER) then
        return item.id
    end

    return nil
end).Collect()

print("T1: ", t1)

local t2 = CREATURES_ITERATOR.FilterMap(
---@param item Creature
function (item)
    if item:HasAbility(ABILITY_TAXPAYER) then
        return item.id
    end

    return nil
end).Collect()

print("T2: ", t2)
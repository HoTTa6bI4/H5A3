while not import do
    sleep()
end

import('@entry_points/adv_map_entry_point')
import('/Fights/Test1/c1m1_fight1')

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

---@type ArmySlot[]
local stacks = c1m1_fight1:GenerateArmySlots()
-- StartCombat(GetPlayerHeroes(1)[0], nil, stacks, 1)

local heroes = HEROES_ITERATOR.FilterMap(
---@param item Hero
function (item)
    if item.town == TOWN_DUNGEON then
        return item.id
    end
    return nil
end).Collect()

print("Dungeon heroes: ", heroes)
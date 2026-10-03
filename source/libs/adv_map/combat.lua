---@class _ArmySlot
---@field creature Creature
---@field amount number
---@field IsEmpty function(): 1|nil

---@alias ArmySlot _ArmySlot|DefaultClassBody

---@param id CreatureID
---@param amount number
---@return ArmySlot
function ArmySlot(id, amount)
    ---@type ArmySlot
    local _army_slot = Class {
        typename = "ArmySlot",
    }

    _army_slot.creature = CREATURES_DATA(id)
    _army_slot.amount = amount

    function _army_slot:IsEmpty()
        local result = self.amount == 0
        return result
    end

    return _army_slot
end

do
    local oldGetObjectArmySlotCreature = GetObjectArmySlotCreature

    function GetObjectArmySlotCreature(object, slot)
        local creature, count = %oldGetObjectArmySlotCreature(object, slot)
        local army_slot = ArmySlot(creature, count)
        return army_slot
    end
end

do 
    local oldStartCombat = StartCombat

    ---@param hero string Скриптовое имя героя
    ---@param enemy string|nil Скриптовое имя вражеское героя/nil - нейтралы
    ---@param army_slots ArmySlot[] Данные о существах и их количестве в бою
    ---@param is_quick_combat? 1|nil Допустим ли быстрый бой
    ---@param arena? string|nil Путь к кастомной арене в файлах игры
    ---@return 1|nil|boolean is_alive Победил ли в бою герой, запустивший его
    function StartCombat(hero, enemy, army_slots, arena, is_quick_combat)
        local p = {}
        ---@param slot ArmySlot
        for _, slot in army_slots do
            table.push(p, slot.creature.id)
            table.push(p, slot.amount)
        end
        table.push(p, nil)
        table.push(p, nil)
        table.push(p, arena)
        table.push(p, is_quick_combat)
        local fight_id = GetLastSavedCombatIndex()
        %oldStartCombat(hero, enemy, length(army_slots), table.unpack(p))
        while GetLastSavedCombatIndex() == fight_id do
            sleep()
        end
        
        return IsHeroAlive(hero)
    end
end

__end_import()
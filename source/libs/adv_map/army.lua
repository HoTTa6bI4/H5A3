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

    _army_slot.creature = Creature(id)
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

__end_import()
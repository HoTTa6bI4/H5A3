SPELLS_COUNT = 390

---@class _Spell
---@field id SpellType
---@field name string
---@field desc string
---@field icon string
---@field school SpellSchoolType
---@field level number
---@field is_aimed 1|nil
---@field is_area 1|nil
---@field cost number

---@alias Spell _Spell | DefaultClassBody

SPELLS_DATA = {}

---@param id SpellType
function Spell(id)
    local data =  SPELLS_GENERATED_TABLE[id]

    ---@type Spell
    local _spell = Class {
        typename = "Spell"
    }

    _spell.id = id
    _spell.name = data.name
    _spell.desc = data.desc
    _spell.school = data.school
    _spell.icon = data.icon
    _spell.level = data.level
    _spell.is_aimed = data.is_aimed
    _spell.is_area = data.is_area
    _spell.cost = data.cost

    SPELLS_DATA[id] = _spell
    return _spell
end

SPELLS_ITERATOR = Iterator(range_generator.FromTop(1, SPELLS_COUNT - 1))
    .Map(function (item)
        local result = Spell(item)
        return result
    end)

__end_import()
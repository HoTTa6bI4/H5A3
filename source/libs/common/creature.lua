CREATURES_COUNT = 3000

---@class _Creature
---@field id CreatureID
---@field is_generatable nil|1
---@field is_upgrade nil|1
---@field attack number
---@field defence number
---@field min_damage number
---@field max_damage number
---@field speed number
---@field initiative number
---@field health number
---@field mana number
---@field size number
---@field exp number
---@field power number
---@field town TownType
---@field town_extended TownTypeExtended
---@field first_element CreatureMagicElementType
---@field second_element CreatureMagicElementType
---@field grow number
---@field tier number
---@field cost number
---@field range number
---@field name string
---@field desc string
---@field icon string
---@field is_flying nil|1
---@field abilities CreatureAbilityType[]
---@field known_spells table<SpellType, MasteryLevel>
---@field HasAbility function(ability: CreatureAbilityType): 1|nil
---@field HasSpell function(spell: SpellType): 1|nil
---@field IsShooter function(): 1|nil
---@field IsCaster function(): 1|nil

---@alias Creature _Creature|DefaultClassBody

---@param id CreatureID
---@return Creature
---@nodiscard
function Creature(id)
    local data = CREATURES_GENERATED_TABLE[id]

    ---@type Creature
    local _creature = Class { typename = "Creature" }

    _creature.id = id
    _creature.is_generatable = data.is_generatable
    _creature.is_upgrade = data.is_upgrade
    _creature.attack = data.attack
    _creature.defence = data.defence
    _creature.min_damage = data.dmg_min
    _creature.max_damage = data.dmg_max
    _creature.speed = data.speed
    _creature.initiative = data.ini
    _creature.health = data.health
    _creature.mana = data.sp
    _creature.size = data.size
    _creature.exp = data.exp
    _creature.power = data.power
    _creature.town = data.town
    _creature.town_extended = data.town_extended
    _creature.first_element = data.first_element
    _creature.second_element = data.second_element
    _creature.grow = data.grow
    _creature.tier = data.tier
    _creature.cost = data.cost
    _creature.range = data.range
    _creature.name = data.name
    _creature.desc = data.desc
    _creature.icon = data.icon
    _creature.abilities = data.abilities
    _creature.known_spells = data.known_spells

    --- Проверяет наличие заклинания у существа
    ---@param spell SpellType
    ---@return 1|nil has
    ---@nodiscard
    function _creature:HasSpell(spell)
        ---@type 1|nil
        local result = self.known_spells[spell]
        return result
    end

    --- Проверяет наличие умения у существа
    ---@param ability CreatureAbilityType
    ---@return 1|nil has
    ---@nodiscard
    function _creature:HasAbility(ability)
        local result = contains(self.abilities, ability)
        return result
    end

    --- Определяет, является ли существо кастером
    ---@return 1|nil|boolean
    function _creature:IsCaster()
        local result = self.mana ~= 0
        return result
    end

    --- Определяет, является ли существо стрелком
    ---@return 1|nil|boolean
    function _creature:IsShooter()
        local result = self.range ~= 0
        return result
    end

    return _creature
end

CREATURES_ITERATOR = Iterator(range_generator.FromTop(1, CREATURES_COUNT - 1))
    .Map(function (item)
        local result = Creature(item)
        return result
    end)

__end_import()
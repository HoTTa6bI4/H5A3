---@class _Hero
---@field id string
---@field class HeroClassType
---@field spec HeroSpecType
---@field spec_name string
---@field spec_desc string
---@field spec_icon string
---@field icon string
---@field town TownType
---@field name string
---@field bio string

---@alias Hero _Hero | DefaultClassBody

HEROES_DATA = {}

---@param id string
---@return Hero
function Hero(id)
    local data = HEROES_GENERATED_TABLE[id]

    ---@type Hero
    local _hero = Class {
        typename = "Hero"
    }

    _hero.id = id
    _hero.bio = data.bio
    _hero.class = data.hero_class
    _hero.spec = data.spec
    _hero.spec_name = data.spec_name
    _hero.spec_desc = data.spec_desc
    _hero.spec_icon = data.spec_icon
    _hero.town = data.town
    _hero.name = data.name
    _hero.icon = data.icon

    HEROES_DATA[id] = _hero
    return _hero
end

HEROES_ITERATOR = Iterator(keys(HEROES_GENERATED_TABLE)).Map(function (item)
    local result = Hero(item)
    return result
end)

__end_import()
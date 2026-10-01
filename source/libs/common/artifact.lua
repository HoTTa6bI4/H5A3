ARTIFACT_COUNT = 500

---@class _Artifact
---@field id ArtifactID
---@field is_sellable 1|nil
---@field name string
---@field icon string
---@field desc string
---@field cost number
---@field slot ArtifactSlot
---@field class ArtifactClass

---@alias Artifact _Artifact | DefaultClassBody

ARTIFACTS_DATA = {}

---@param id ArtifactID
---@return Artifact
function Artifact(id)
    local data = ARTIFACTS_GENERATED_TABLE[id]
    ---@type Artifact
    local _artifact = Class {
        typename = "Artifact"
    }

    _artifact.id = id
    _artifact.cost = data.cost
    _artifact.desc = data.desc
    _artifact.is_sellable = data.is_sellable
    _artifact.name = data.name
    _artifact.slot = data.slot
    _artifact.class = data.type
    _artifact.icon = data.icon

    ARTIFACTS_DATA[id] = _artifact
    return _artifact
end

ARTIFACTS_ITERATOR = Iterator(range_generator.FromTop(1, ARTIFACT_COUNT - 1))
    .Map(function (item)
        local result = Artifact(item)
        return result
    end)

__end_import()
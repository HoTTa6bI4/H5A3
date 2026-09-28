---@alias UnitCountGenerationMode
---| `UNIT_COUNT_GENERATION_MODE_POWER_BASED`
---| `UNIT_COUNT_GENERATION_MODE_RAW`
UNIT_COUNT_GENERATION_MODE_POWER_BASED = 0
UNIT_COUNT_GENERATION_MODE_RAW = 1

---@alias ArmyGetter fun(): Creature

---@class CombatGenerationModel
---@field stack_count_generation_logic UnitCountGenerationMode []
---@field army_base_count_data table<DifficultyLevel, number> []
---@field army_counts_grow table<DifficultyLevel, number> []?
---@field army_getters ArmyGetter[]
---@field required_artifacts Artifact[]?
---@field optional_artifacts table<ArtifactSlot, Artifact[]>?
---@field artifacts_base_costs table<DifficultyLevel, number>?
---@field artifacts_costs_grow table<DifficultyLevel, number>?

---@class FightHeroSetupModel
---@field army_slots ArmySlot[]
---@field artifacts ArtifactID[]?

---@class _GeneratedCombat
---@field generation_model CombatGenerationModel
---@field GenerateArmySlots function(): ArmySlot[]
---@field GenerateHeroSetup function(): FightHeroSetupModel

---@alias GeneratedCombat _GeneratedCombat | DefaultClassBody

---@param generation_model CombatGenerationModel
---@return GeneratedCombat
function GeneratedCombat(generation_model) 
    ---@type GeneratedCombat
    local _fight = Class {
        typename = "GeneratedCombat"
    }

    _fight.generation_model = generation_model

    ---@return ArmySlot[]
    ---@nodiscard
    function _fight:GenerateArmySlots()
        local week = GetDate(WEEK)

        ---@type ArmySlot[]
        local result = {}
        for i, stack_type in self.generation_model.stack_count_generation_logic do
            local creature = self.generation_model.army_getters[i]()
            if stack_type == UNIT_COUNT_GENERATION_MODE_POWER_BASED then
                local stack_power = self.generation_model.army_base_count_data[i][__difficulty]
                if self.generation_model.army_counts_grow and length(self.generation_model.army_counts_grow) > 0 then
                    stack_power = stack_power + self.generation_model.army_counts_grow[i][__difficulty] * week
                end
                result[i] = ArmySlot(creature.id, ceil(stack_power / creature.power))
            else
                local count = self.generation_model.army_base_count_data[i][__difficulty]
                if self.generation_model.army_counts_grow and length(self.generation_model.army_counts_grow) > 0 then
                    count = count + self.generation_model.army_counts_grow[i][__difficulty] * week
                end
                result[i] = ArmySlot(creature.id, count)
            end
        end

        return result
    end

    ---@return FightHeroSetupModel
    ---@nodiscard
    function _fight:GenerateHeroSetup()
        local week = GetDate(WEEK)
        ---@type FightHeroSetupModel
        local result
        result.army_slots = self.GenerateArmySlots(self.generation_model)
        if not self.generation_model.artifacts_base_costs then
            return result
        end

        result.artifacts = {}
        if self.generation_model.required_artifacts and length(self.generation_model.required_artifacts) > 0 then
            ---@param art Artifact
            for _, art in self.generation_model.required_artifacts do
                count = count + 1
                result.artifacts[count] = art.id
            end
        end
        ---@diagnostic disable-next-line
        local used_slots = {}
        local weight = self.generation_model.artifacts_base_costs[__difficulty]
        if self.generation_model.artifacts_costs_grow and self.generation_model.artifacts_costs_grow[__difficulty] then
            weight = weight + self.generation_model.artifacts_costs_grow[__difficulty] * week
        end
        ---@type Artifact[]
        local possible_arts = {}
        local n = 1
        for _, arts in self.generation_model.optional_artifacts do
            for _, art in arts do
                possible_arts[n] = art
                n = n + 1
            end
        end
        while 1 do
            local selected = Iterator(possible_arts).Filter(
                ---@param art Artifact
                function (art)
                    local used_slots = %used_slots
                    local weight = %weight
                    local result = %result
                    if used_slots[art.slot] then
                        return nil
                    end
                    if art.cost <= weight and (not contains(result.artifacts, art)) then
                        return 1
                    end
                end
            ).Collect()
            if length(selected) == 0 then
                break
            end
            ---@type Artifact
            local art = Random.FromTable(selected)
            table.push(result.artifacts, art.id)
            ---@diagnostic disable-next-line
            used_slots[art.slot] = 1
            possible_arts = Iterator(selected).Filter(
            ---@param item Artifact
            function (item)
                local art = %art
                if item.id == art.id then
                    return nil
                end
                return 1
            end).Collect()
            weight = weight - art.cost
            sleep()
        end

        return result
    end

    return _fight
end

__end_import()
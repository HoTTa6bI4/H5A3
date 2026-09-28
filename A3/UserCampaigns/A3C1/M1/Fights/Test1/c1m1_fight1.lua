
while not (UNIT_COUNT_GENERATION_MODE_POWER_BASED and UNIT_COUNT_GENERATION_MODE_RAW and Iterator and GeneratedCombat) do
    sleep()
end

---@type GeneratedCombat
c1m1_fight1 = GeneratedCombat({
	stack_count_generation_logic = {
		[1] = UNIT_COUNT_GENERATION_MODE_POWER_BASED,
		[2] = UNIT_COUNT_GENERATION_MODE_POWER_BASED,
		[3] = UNIT_COUNT_GENERATION_MODE_RAW,
	},

	army_base_count_data = {
		[1] = {
			[DIFFICULTY_HEROIC] = 25000,
			[DIFFICULTY_EASY] = 10000,
			[DIFFICULTY_HARD] = 20000,
			[DIFFICULTY_NORMAL] = 15000,
		},
		[2] = {
			[DIFFICULTY_NORMAL] = 25000,
			[DIFFICULTY_HARD] = 30000,
			[DIFFICULTY_HEROIC] = 35000,
			[DIFFICULTY_EASY] = 20000,
		},
		[3] = {
			[DIFFICULTY_EASY] = 15,
			[DIFFICULTY_HARD] = 25,
			[DIFFICULTY_HEROIC] = 30,
			[DIFFICULTY_NORMAL] = 20,
		},
	},

	army_counts_grow = {
	},

	army_getters = {
		[1] = function ()
            local id = CREATURES_ITERATOR.Filter(
                   ---@param item Creature
                   function(item)
                      local result = contains({TOWN_ACADEMY, TOWN_DUNGEON}, item.town) and contains({1, 2}, item.tier)
                      return result
                   end)
                   .Filter(
                   ---@param creature Creature
                   function(creature)
                       local result = creature.is_generatable
                       return result
                   end)     
                .TakeRandom(1)
                .Collect()[1]
            return id
		end,
		[2] = function ()
            local id = CREATURES_ITERATOR.Filter(
                   ---@param item Creature
                   function(item)
                      local result = contains({TOWN_DUNGEON}, item.town) and contains({4}, item.tier)
                      return result
                   end)
                   .Filter(
                   ---@param creature Creature
                   function(creature)
                       local result = 1
                       return result
                   end)     
                .TakeRandom(1)
                .Collect()[1]
            return id
		end,
		[3] = function ()
            local id = Random.FromTable({108})
            local result = Creature(id)
            return result
        end,
	},

	required_artifacts = Iterator({1}).Map(function(a) local result = Artifact(a) return result end).Collect(),
	optional_artifacts = {
		[NECK] = Iterator({15}).Map(function(a) local result = Artifact(a) return result end).Collect(),
	},

	artifacts_base_costs = {
		[DIFFICULTY_EASY] = 10000,
		[DIFFICULTY_HARD] = 20000,
		[DIFFICULTY_HEROIC] = 25000,
		[DIFFICULTY_NORMAL] = 15000,
	},

})

 __end_import()
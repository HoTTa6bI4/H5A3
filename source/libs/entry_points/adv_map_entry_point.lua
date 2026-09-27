while not (import and __end_import) do
    sleep()
end

import("@consts/ability")
import("@consts/artifact")
import("@consts/common")
import("@consts/creature")
import("@consts/skill")
import("@consts/spell")
import("@consts/town_building")
import("@consts/week")

import("@generated/creatures")
import("@generated/heroes")
import("@generated/artifacts")
import("@generated/spells")

import("@common/core")
import("@common/consts")
import("@common/class")
import("@common/random")
import("@common/iterators")

import("@common/creature")
import("@common/artifact")

import("@adv_map/army")
import("@adv_map/fight_generation")

__end_import()
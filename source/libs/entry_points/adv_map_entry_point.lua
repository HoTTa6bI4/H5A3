while not (import and __end_import) do
    sleep()
end

import("@consts/ability")
import("@consts/artifact")
import("@consts/common")
import("@consts/creature")
import("@consts/hero_spec")
import("@consts/hero_class")
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
import("@common/hero")
import("@common/spell")

import("@adv_map/combat")
import("@adv_map/fight_generation")
import("@adv_map/mini_dialog")

__end_import()
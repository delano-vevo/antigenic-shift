class_name Trait
extends Resource
## Implements a specialized Trait that will be part of a ViralStrain, defining the
## behaviours and stats of all zombies infected with that particular strain

## Trait type
@export var trait_type: Enum.TraitType ## The Type of trait (defined in Enum.TraitType)
@export var trait_stat: Enum.EnemyStats ## The enemy stat to be affected by the trait, if any
@export var trait_amount: float = 1.0 ## The amount by which the enemy stat will be modulated - default to 1.0
@export var behavior: PackedScene ## The Behavior node, if any, this should apply to a zombie

## Applies this trait's modifier to the provided Zombie enemy
## Called once on zombie spawn from ViralStrain.gd
func apply_trait(zombie: Enemy) -> void:
	print("Applying trait " + str(self) + " to zombie " + str(zombie))
	if (trait_type == Enum.TraitType.BEHAVIOR):
		# Apply a provided Behavior node to the zombie for runtime code execution
		var behavior_instance = behavior.instantiate()
		zombie.add_child(behavior_instance)
		zombie.behaviors.append(behavior_instance)
	elif (trait_type == Enum.TraitType.STAT_CHANGE_FLAT):
		# Apply a flat stat change to the provided stat
		zombie.set(Global.STAT_NAMES[trait_stat], zombie.get(Global.STAT_NAMES[trait_stat]) + trait_amount)
	elif (trait_type == Enum.TraitType.STAT_CHANGE_PERCENT):
		# Apply a percentage change to the provided stat
		zombie.set(Global.STAT_NAMES[trait_stat], zombie.get(Global.STAT_NAMES[trait_stat]) * trait_amount)

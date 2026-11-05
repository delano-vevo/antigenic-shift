class_name Behavior
extends Node2D
## A component of the Traits system; some Traits will contain a reference to a Behavior node as a PackedScene,
## which will be linked on spawn to the zombie and execute bespoke code at various points in runtime

## Called ONCE after being added as a child of the Zombie
func on_added() -> void:
	# Debug output
	print("New behavior added to " + str(get_parent()))

## Called when the parent entity dies
func on_death() -> void:
	pass

## Called when the parent entity is attacking the player
func on_attack() -> void:
	pass

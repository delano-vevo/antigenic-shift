class_name Behavior
extends Node2D
## A component of the Traits system; some Traits will contain a reference to a Behavior node as a PackedScene,
## which will be linked on spawn to the zombie and execute bespoke code at various points in runtime

## Called when the parent entity dies
func on_death() -> void:
	pass

class_name ViralStrain
extends Node2D
## This class implements a strain of the zombie virus, built as an aggregate
## of Traits and Behaviors. A ViralStrain will be assigned to a Zombie on spawn,
## and will dictate its stats and programming based on the contained components.
##
## Additionally, these ViralStrains can be combined in order to perform Antigenic
## Shift, which will create a new ViralStrain containing randomized elements of the
## two Strains which were combined

## Editor variables
@export var zombie_base_tscn: PackedScene ## The base Zombie type this strain will generate

## Internal variables
@export var traits: Array[Trait] ## The Traits that will be applied to every zombie spawning with this viral strain

## Spawn a zombie with this strain of the virus
func spawn_zombie() -> Enemy:
	var new_zombie: Enemy = zombie_base_tscn.instantiate()
	for viral_trait in traits:
		viral_trait.apply_trait(new_zombie)
	return new_zombie

## Add a new trait to the strain
func add_trait(new_trait: Trait) -> void:
	traits.append(new_trait)

## Easy access to the number of traits on this strain
func num_traits() -> int:
	return traits.size()

## Custom _to_string override for outputting to the console during testing
func _to_string() -> String:
	var ret_str: String = "["
	for t in traits:
		ret_str += str(t) + "|"
	return ret_str+"]"

extends Node2D
## Implements the logic for spawning zombies during the daytime portion of gameplay

## Signals
signal zombie_spawned(zombie: Enemy)

## Resource loads
@onready var viral_strain_tscn = preload("res://Entities/Enemies/ViralStrains/viral_strain.gd")
@onready var spawn_timer_tscn = preload("res://GameLogic/ZombieSpawnTimer.tscn")

## Editor variables
## The ViralStrain nodes responsible for the various strains that will spawn zombies;
## exposed to the editor so that some number of starting strains can be hard-coded
@export var viral_strains: Array[ViralStrain]
@export var spawn_checker: Area2D ## An Area2D that can be used to check the validity of a given spawn position by checking overlapping bodies

## Spawns a zombie from a provided ViralStrain
## Returns a reference to the spawned zombie
func spawn_zombie(viral_strain: ViralStrain) -> Enemy:
	var new_zombie = viral_strain.spawn_zombie()
	zombie_spawned.emit(new_zombie)
	return new_zombie

## Spawns a zombie from a specific ViralStrain at a provided index
## Default - will just spawn using the first Strain in the array
## Useful for spawning from a randomized strain
## Returns a reference to the spawned zombie
func spawn_zombie_index(strain_idx: int = 0) -> Enemy:
	var new_zombie = viral_strains[strain_idx].spawn_zombie()
	zombie_spawned.emit(new_zombie)
	return new_zombie

## Combines two ViralStrains into a novel strain
@warning_ignore("unused_parameter")
func combine_strains(strain_a: ViralStrain, strain_b: ViralStrain) -> ViralStrain:
	var strain = viral_strain_tscn.new()
	add_child(strain)
	return null

## Adds a new ViralStrain into the manager
func add_new_strain(viral_strain: ViralStrain) -> void:
	viral_strains.append(viral_strain)
	var new_timer: Timer = spawn_timer_tscn.instantiate()
	new_timer.strain = viral_strain
	add_child(new_timer)

## Handles a spawn signal from a ZombieSpawnTimer node
func _on_zombie_spawn_timer_spawn_zombie(viral_strain: ViralStrain, amount: int) -> void:
	for i in range(amount):
		var new_zombie = spawn_zombie(viral_strain)
		zombie_spawned.emit(new_zombie)

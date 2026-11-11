extends Node2D
## Implements the logic for spawning zombies during the daytime portion of gameplay

## Signals
signal zombie_spawned(zombie: Enemy)

## Resource loads
@onready var viral_strain_gd = preload("res://Entities/Enemies/ViralStrains/viral_strain.gd")
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

## Takes two random strains and combines them into a new one; useful for calling
## from Main in the day_end portion of the game control
func combine_random_strains() -> ViralStrain:
	# Get two random, distinct indices into the viral_strains array
	var strain_a_idx = randi_range(0, viral_strains.size()-1)
	var strain_b_idx = strain_a_idx
	while (strain_b_idx == strain_a_idx):
		strain_b_idx = randi_range(0, viral_strains.size()-1)
	# Combine the strains at these indices and return the result
	var new_strain = combine_strains(viral_strains[strain_a_idx], viral_strains[strain_b_idx])
	return new_strain

## Combines two specific ViralStrains into a novel strain
func combine_strains(strain_a: ViralStrain, strain_b: ViralStrain) -> ViralStrain:
	var strain = viral_strain_gd.new()
	# Determine the base zombie type for the new strain
	# Just grab one randomly from one of the two zombie bases
	strain.zombie_base_tscn = strain_a.zombie_base_tscn if randi_range(0,1)==0 else strain_b.zombie_base_tscn
	# Determine the number of traits to propagate to the new strain of the virus
	# Take the virus with more traits and add 1 to get a newer, stronger virus
	var num_new_traits: float = strain_a.num_traits() + 1 if strain_a.num_traits() > strain_b.num_traits() else strain_b.num_traits() + 1
	# Clamp values to ensure both strains can meet their demand
	var traits_from_a: int = clamp(int(floor(num_new_traits/2)), 0, strain_a.num_traits())
	var traits_from_b: int = clamp(int(num_new_traits) - traits_from_a, 0, strain_b.num_traits())
	# Pull random selection of traits from each strain
	# Track already selected traits to prevent duplicates
	var already_added: Array[Trait] = []
	for i in range(traits_from_a):
		var added: bool = false
		while (!added):
			# Pick a random trait to try adding and compare it with the already_added list
			var try_add = strain_a.traits.pick_random()
			if (!already_added.has(try_add)):
				strain.add_trait(try_add.duplicate())
				already_added.append(try_add)
				added = true
	# Reset values and run it back on strain B
	already_added = []
	for i in range(traits_from_b):
		var added: bool = false
		while (!added):
			# Pick a random trait to try adding and compare it with the already_added list
			var try_add = strain_b.traits.pick_random()
			if (!already_added.has(try_add)):
				strain.add_trait(try_add.duplicate())
				already_added.append(try_add)
				added = true
	# Generate a spawn timer for the new strain
	var new_timer = spawn_timer_tscn.instantiate()
	new_timer.strain = strain
	new_timer.spawn_batch_size = randi_range(1,3) # TODO: make this more robust than just a simple random
	new_timer.wait_time = randf_range(5.0, 10.0) # TODO: magic number! naughty!
	add_child(new_timer)
	# Add the new strain to the list and return a reference
	viral_strains.append(strain)
	add_child(strain)
	return strain

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

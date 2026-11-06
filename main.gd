extends Node2D
## The main game controller, responsible for the synthesis and handling of the game systems

## Resource loads
@onready var viral_strain = preload("res://Entities/Enemies/ViralStrains/viral_strain.gd")

## Editor nodes
@export var player_controller: Node2D
@export var gui: Control

## Gameplay variables
@export var viral_strains: Array[ViralStrain]

## Initialize the game
func _ready() -> void:
	update_ammo_counter()

## Game loop
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("debug_1")):
		var nz = spawn_zombie()
		nz.global_position = get_global_mouse_position()

## Determines the nearest player entity (between gunner & scientist) to a specific
## GLOBAL position within world space and returns it (or null if an error is encountered)
func get_nearest_player(global_pos: Vector2) -> Entity:
	var s_dist = global_pos.distance_to(player_controller.scientist.global_position)
	var g_dist = global_pos.distance_to(player_controller.gunner.global_position)
	if (s_dist < g_dist):
		return player_controller.scientist
	else:
		return player_controller.gunner

## Sends updated ammo data from the player to the GUI layer
func update_ammo_counter() -> void:
	gui.ammo_counter.set_ammo_clip(player_controller.gunner.clip_current)
	gui.ammo_counter.set_ammo_total(player_controller.gunner.bullets)

## Spawns a zombie from a specific ViralStrain at a provided index
## Default - will just spawn using the first Strain in the array
func spawn_zombie(strain_idx: int = 0) -> Enemy:
	var new_zombie = viral_strains[strain_idx].spawn_zombie()
	add_child(new_zombie)
	return new_zombie

## Combines two ViralStrains into a novel strain
func combine_strains(strain_a: ViralStrain, strain_b: ViralStrain) -> ViralStrain:
	var strain = viral_strain.new()
	add_child(strain)
	return null

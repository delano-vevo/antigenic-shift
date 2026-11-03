extends Node2D
## The main game controller, responsible for the synthesis and handling of the game systems

## Editor nodes
@export var player_controller: Node2D
@export var gui: Control

## Initialize the game
func _ready() -> void:
	update_ammo_counter()

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

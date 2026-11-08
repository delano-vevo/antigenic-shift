extends Node2D
## The main game controller, responsible for the synthesis and handling of the game systems

## Resource loads
@onready var viral_strain = preload("res://Entities/Enemies/ViralStrains/viral_strain.gd")
@onready var day_end_gui_tscn: PackedScene = preload("res://GUI/DayEnd/DayEndGUI.tscn")

## Editor nodes
@export var player_controller: Node2D ## The controller that handles the two Player characters
@export var gui_layer: CanvasLayer ## The CanvasLayer where the GUI is drawn
@export var gameplay_gui: Control ## The GUI node handling all of the gameplay UI elements
@export var snow_particles: GPUParticles2D ## The particle system for snow FX
@export var game_camera: Camera2D ## The camera controller for the gameplay section, following the players
@export var day_night_controller: Node2D ## The controller for the day/night cycle
@export var environment: Node2D ## The Node that contains all of the environment objects in the main game loop (incl. the players)
@export var bunker: EnvironmentObject ## The Bunker the player returns to at the end of the day

## Gameplay variables
@export var viral_strains: Array[ViralStrain]
@onready var xp: float = 0.0 ## Current XP value
@onready var next_level_xp: float = 10.0 ## XP required to level up
@onready var cure_progress: float = 0.0 ## The progress the player has made (as a percentage) towards discovering a cure

## Initialize the game
func _ready() -> void:
	# Set the world clear color to a nice snowy blue-white
	RenderingServer.set_default_clear_color(Color("b3b9d1"))
	snow_particles.emitting = true
	# Initialize the UI elements
	update_ammo_counter()
	_on_player_hp_get()
	# Start the first day
	day_night_controller.start_day()

## Game loop
func _process(delta: float) -> void:
	# Invoke the camera controller
	camera_control()
	# Update the countdown timer
	gameplay_gui.day_remaining.update_countdown(day_night_controller.day_length_timer.time_left)
	# Parse debug inputs
	# Spawn zombies at the mouse cursor for testing
	if (Input.is_action_just_pressed("debug_1")):
		var nz = spawn_zombie()
		nz.global_position = get_global_mouse_position()
	# Add some default upgrades to the player for testing
	if (Input.is_action_just_pressed("debug_2")):
		var upg_1 = load("res://Entities/Player/Upgrades/hp_upgrade.gd").new()
		var upg_2 = load("res://Entities/Player/Upgrades/shot_damage_upgrade.gd").new()
		player_controller.scientist.get_upgrade(upg_1)
		player_controller.gunner.get_upgrade(upg_2)
	# Toggle the bunker's door for testing
	if (Input.is_action_just_pressed("debug_3")):
		bunker.toggle_open()
	# Trigger an end of day event to test the GUI
	if (Input.is_action_just_pressed("debug_4")):
		end_day()

## Handles the camera control, calculating the best camera position & zoom by aggregating
## onscreen entities (and maybe even level data eventually)
func camera_control() -> void:
	# Find the midpoint between the two player objects
	# For now this lerps to the exact midpoint, but this could be weighted in the future
	# to bias towards whichever Player controller is currently active
	# This is a little bit vomity already with the sled physics :x
	var cam_targ = player_controller.scientist.global_position.lerp(player_controller.gunner.global_position, 0.5)
	# Apply calculated target to actual camera position
	game_camera.global_position = cam_targ

## Determines whether the current day is over by polling DayNightControl
func is_day_over() -> bool:
	return !day_night_controller.day_countdown_timer.is_stopped()

## Ends the current day
func end_day() -> void:
	# Pause the game
	get_tree().paused = true
	# Apply the end of day UI layer
	gameplay_gui.visible = false
	var day_end_gui = day_end_gui_tscn.instantiate()
	# Check for a levelup and pass info along to the GUI node
	day_end_gui.init(xp == next_level_xp)
	# Add GUI to tree
	gui_layer.add_child(day_end_gui)

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
	gameplay_gui.ammo_counter.set_ammo_clip(player_controller.gunner.clip_current)
	gameplay_gui.ammo_counter.set_ammo_total(player_controller.gunner.bullets)

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

## Update the ammo counter GUI on ammo_changed signal from the Gunner player character
func _on_gunner_ammo_changed() -> void:
	update_ammo_counter()

## Pass player references to the GUI to update health UI
func _on_player_hp_get() -> void:
	gameplay_gui.health_bars.update_counters(player_controller.scientist, player_controller.gunner)

## Update the XP counter when player obtains a sample
func _on_player_xp_get(amount: float) -> void:
	# Add the XP amount to the counter
	xp += amount
	# Check if this is enough for a level-up and do (something???)
	if (xp >= next_level_xp):
		xp = next_level_xp # For now just clamp it to max in order to keep it from fucking up the GUI
	# Update the XP bar GUI
	gameplay_gui.xp_bar.set_xp_amount(xp, next_level_xp)

## Handles a game_over signal from any source that may trigger a game over state
func _on_game_over() -> void:
	print("Game freaking over!")

## Start the countdown in the GUI when signaled from the day/night controller
func _on_day_night_controller_countdown_begin() -> void:
	gameplay_gui.start_countdown(day_night_controller.day_countdown_timer)

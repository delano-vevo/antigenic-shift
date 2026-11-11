extends Node2D
## The main game controller, responsible for the synthesis and handling of the game systems

## Resource loads
@onready var day_end_gui_tscn: PackedScene = preload("res://GUI/DayEnd/DayEndGUI.tscn")
@onready var game_over_gui_tscn: PackedScene = preload("res://GUI/GameOver/GameOverGUI.tscn")

## Editor nodes
@export var player_controller: Node2D ## The controller that handles the two Player characters
@export var gui_layer: CanvasLayer ## The CanvasLayer where the GUI is drawn
@export var gameplay_gui: Control ## The GUI node handling all of the gameplay UI elements
@export var snow_particles: GPUParticles2D ## The particle system for snow FX
@export var game_camera: Camera2D ## The camera controller for the gameplay section, following the players
@export var day_night_controller: Node2D ## The controller for the day/night cycle
@export var environment: Node2D ## The Node that contains all of the environment objects in the main game loop (incl. the players)
@export var bunker: EnvironmentObject ## The Bunker the player returns to at the end of the day
@export var zombie_spawner: Node2D ## The Node responsible for handling zombie spawning logic

## Gameplay variables
@export var viral_strains: Array[ViralStrain]
@onready var xp: float = 0.0 ## Current XP value
@onready var next_level_xp: float = 10.0 ## XP required to level up
@onready var cure_progress: float = 0.0 ## The progress the player has made (as a percentage) towards discovering a cure
@export var cure_progress_per_level: float = 10.0 ## The amount of cure progress rewarded for each successful level-up (if selected)
@onready var last_upgrade: PlayerUpgrade ## Tracks the last upgrade applied to the player(s)
@onready var day_end_gui: Control ## The Control node housing the end of day GUI
@onready var current_day: int = 0 ## The current day cycle
@export var max_days: int = 14 ## The number of days the player has to find a cure before game over

## Initialize the game
func _ready() -> void:
	# Set the world clear color to a nice snowy blue-white
	RenderingServer.set_default_clear_color(Color("b3b9d1"))
	snow_particles.emitting = true
	# Initialize the UI elements
	update_ammo_counter()
	_on_player_hp_get()
	# Start the first day
	start_next_day()

## Game loop
func _process(_delta: float) -> void:
	# Invoke the camera controller
	camera_control()
	# Update the countdown timer
	gameplay_gui.day_remaining.update_countdown(day_night_controller.day_length_timer.time_left)
	# Parse debug inputs
	# Spawn zombies at the mouse cursor for testing
	if (Input.is_action_just_pressed("debug_1")):
		var nz = zombie_spawner.spawn_zombie()
		environment.add_child(nz)
		nz.global_position = get_global_mouse_position()
	# Add some XP to the player for testing
	if (Input.is_action_just_pressed("debug_2")):
		_on_player_xp_get(5.0)
	# Toggle the bunker's door for testing
	if (Input.is_action_just_pressed("debug_3")):
		bunker.toggle_open()
	# Trigger an antigenic shift in the zombie spawner by combining two random strains
	if (Input.is_action_just_pressed("debug_4")):
		zombie_spawner.combine_random_strains()
		print(zombie_spawner.viral_strains)
		for strain in zombie_spawner.viral_strains:
			print("Strain:")
			print(strain)
			print("--------\n")
		#day_night_controller.day_length_timer.start(1.0)

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
	# If the Gunner is currently active, apply extra look in aim direction
	if (player_controller.current_player == player_controller.gunner):
		var mouse_pos = get_global_mouse_position()
		var offset_h: float = (mouse_pos.x - player_controller.gunner.global_position.x) / (Global.GAME_WIDTH/2)
		var offset_v: float = (mouse_pos.y - player_controller.gunner.global_position.y) / (Global.GAME_HEIGHT/2)
		game_camera.offset = Vector2(offset_h, offset_v) * Global.AIM_LOOK
	else:
		game_camera.offset = Vector2.ZERO

## Determines whether the current day is over by polling DayNightControl
func is_day_over() -> bool:
	return !day_night_controller.day_countdown_timer.is_stopped()

## Ends the current day
func end_day() -> void:
	# Pause the game
	get_tree().paused = true
	# Apply the end of day UI layer
	gameplay_gui.stop_countdown()
	gameplay_gui.visible = false
	day_end_gui = day_end_gui_tscn.instantiate()
	# Add GUI to tree
	gui_layer.add_child(day_end_gui)
	# Check for a levelup and pass info along to the GUI node
	# TODO: if cure_progress ever stops being a percentage this will need additional math
	day_end_gui.init(cure_progress, xp == next_level_xp)
	# Check for a level-up and reset the XP counter if needed
	if (xp == next_level_xp):
		do_level_up()
	# Connect signals from the day_end_gui to relevant endpoints
	# Endpoints in Main for game control
	day_end_gui.continue_game.connect(start_next_day)
	day_end_gui.upgrade_player.connect(player_upgrade)
	day_end_gui.progress_cure.connect(progress_cure)

## Starts a new day - signalled from day_end_gui
func start_next_day() -> void:
	print("Starting a new day!")
	# Add a new viral strain to the spawner
	zombie_spawner.combine_random_strains()
	print(zombie_spawner.viral_strains)
	# Increment the day counter
	current_day += 1
	# Update relevant UI values
	gameplay_gui.start_day(current_day)
	# Check if this causes a game over
	if (current_day >= max_days):
		print("You're out of time! Game over :(")
	# Unpause the game and return to the regular gameplay GUI
	if (day_end_gui != null):
		day_end_gui.queue_free()
	get_tree().paused = false
	gameplay_gui.visible = true
	# Restart the day-night controller
	day_night_controller.start_day()

## Called on end-of-day level-up - zeroes out XP and calculates the new next_level value
func do_level_up() -> void:
	print("Level up")
	# TODO: this is laughably simplistic right now as a proof of concept, this will definitely need tweaked
	xp = 0
	next_level_xp *= 1.1
	_on_player_xp_get(0) # Call an empty signal to update UI elements
	print("New xp target: " + str(next_level_xp))

## For now this method is kind of a nothing because cure_progress is just implemented as a flat
## value indicating a percentage out of 100; this method is here as a black box in case that ends
## up needing to change to avoid a gigantic pain in the ass
func get_cure_progress_percent() -> float:
	return cure_progress

## Upgrades the player with a randomly selected PlayerUpgrade
## By default, will generate a new random upgrade when upgrade argument is null
func player_upgrade(upgrade: PlayerUpgrade = null) -> void:
	print("Giving the player a new upgrade!")
	if (upgrade == null):
		# Generate a random upgrade to apply
		upgrade = Global.PLAYER_UPGRADES[randi_range(0,Enum.PlayerUpgradeTypes.SIZE-1)].new()
		upgrade.upgrade_amount = 1.0 # TODO: actually randomize this instead of a default amount
	# Parse the upgrade through the player controller to apply to specific Player instances
	player_controller.route_upgrade(upgrade)
	# Keep track of the most recently applied player upgrade
	# Mostly used by UI nodes fetching it from get_tree().get_current_scene(), which
	# seems like it just has to be a bad idea but here we are
	last_upgrade = upgrade
	print(upgrade)

## Apply progress towards finding the cure
## If no amount is specified, value will default to the onboard variable
func progress_cure(amount: float = cure_progress_per_level) -> void:
	print("Progressing the cure...")
	cure_progress += amount
	# Check for victory
	if (cure_progress >= 100):
		print("Virus cured! You win! yay!")

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
	get_tree().paused = true
	gameplay_gui.visible = false
	var game_over_gui = game_over_gui_tscn.instantiate()
	gui_layer.add_child(game_over_gui)

## Start the countdown in the GUI when signaled from the day/night controller
func _on_day_night_controller_countdown_begin() -> void:
	gameplay_gui.start_countdown(day_night_controller.day_countdown_timer)

## Grab a new zombie from a zombie_spawner signal and add it to the game
## Zombies will be spawned just outside the bounds of the game camera to keep the player surrounded
func _on_zombie_spawner_zombie_spawned(zombie: Enemy) -> void:
	print("Spawning a zombie!")
	var viewport_rect = get_viewport().get_visible_rect().size
	var valid_spawn: bool = false
	var spawn_pos: Vector2
	var num_attempts: int = 0
	# Nest this in a while loop to retry randomizing position if an invalid spawn
	# (e.g. trying to spawn a zombie inside of a wall) is detected
	while (!valid_spawn):
		var which_dir: int = randi_range(0, 3)
		match which_dir:
			# TODO: account for camera offset here!!!
			0: # Right
				var spawn_x = game_camera.global_position.x + (viewport_rect.x/2)
				var spawn_y = game_camera.global_position.y + randf_range(-viewport_rect.y/2, viewport_rect.y/2)
				spawn_pos = Vector2(spawn_x, spawn_y)
			1: # Left
				var spawn_x = game_camera.global_position.x - (viewport_rect.x/2)
				var spawn_y = game_camera.global_position.y + randf_range(-viewport_rect.y/2, viewport_rect.y/2)
				spawn_pos = Vector2(spawn_x, spawn_y)
			2: # Up
				var spawn_x = game_camera.global_position.x + randf_range(-viewport_rect.x/2, viewport_rect.x/2)
				var spawn_y = game_camera.global_position.y - (viewport_rect.y/2)
				spawn_pos = Vector2(spawn_x, spawn_y)
			3: # Down
				var spawn_x = game_camera.global_position.x + randf_range(-viewport_rect.x/2, viewport_rect.x/2)
				var spawn_y = game_camera.global_position.y + (viewport_rect.y/2)
				spawn_pos = Vector2(spawn_x, spawn_y)
		# Check the validity of the position by trying collisions with the zombie_spawner spawn_checker area2D
		zombie_spawner.spawn_checker.global_position = spawn_pos
		if (zombie_spawner.spawn_checker.get_overlapping_bodies().size() == 0):
			valid_spawn = true
		else:
			num_attempts += 1
		# Increment the attempts counter and throw a warning if threshold has been crossed
		if (num_attempts > 100):
			print("Couldn't spawn a zombie! Something's wrong with the loop!")
			valid_spawn = true
	# Pass the zombie into the environment to join the fray
	zombie.global_position = spawn_pos
	environment.add_child(zombie)

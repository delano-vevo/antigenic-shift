extends Node2D
## The player is comprised of two different entities; the Scientist, who runs around
## the level to collect ammunition and viral samples, while pulling around a sled
## containing the Gunner, in charge of defending them both with his rifle.
##
## Each of these two characters are implemented as distinct entities, with distinct
## StateMachines; they're composited here under a player controller that handles their
## states and upper-level inputs, like shifting control between the two

## Editor nodes
@export var scientist: Entity ## The Scientist half of the player duo
@export var gunner: Entity ## The Gunner half of the player duo
@export var wagon_handle: Line2D ## The Line representing the wagon's "handle"
@export var sled: CharacterBody2D ## The sled upon which the gunner rests

## Editor variables
@export var rope_length_max: float = 80.0 ## The maximum length of "slack" that the rope can provide
@export var friction_coefficient: float = 5.0

## Internal variables
@onready var current_player: Entity = scientist ## The currently active player Entity in the scene

## Input handler
func _input(event: InputEvent) -> void:
	if (event is InputEventKey and Input.is_action_just_pressed("shift_player")):
		# Shift between the playable characters
		if (current_player == scientist):
			current_player = gunner
			scientist.state_machine.set_state(scientist.state_machine.idle_state)
			gunner.state_machine.set_state(gunner.state_machine.active_state)
		else:
			current_player = scientist
			scientist.state_machine.set_state(scientist.state_machine.running_state)
			gunner.state_machine.set_state(gunner.state_machine.idle_state)
 
## Game loop
func _process(delta: float) -> void:
	# Set the points on the wagon handle graphic
	wagon_handle.clear_points()
	wagon_handle.add_point(scientist.global_position)
	wagon_handle.add_point(sled.global_position)

func _physics_process(delta: float) -> void:
	# Apply the pulling physics to the gunner's cart
	var player_dist = scientist.global_position.distance_to(sled.global_position)
	if (player_dist >= rope_length_max):
		# Pull towards the player
		var cart_target_dir = sled.position.direction_to(scientist.position)
		# Accelerate the sled in the direction specified
		# TODO: this is causing weird snappy rotation when going from 0 - need more robust physics
		sled.velocity += cart_target_dir * delta * 800.0 # TODO: magic number naughty naughty!
		# Clamp movement speed at the scientist's run speed for consistency in controls and feeling
		sled.velocity = sled.velocity.limit_length(scientist.move_speed)
	else:
		# Apply friction to slow the sled when the player is still
		sled.velocity.x = move_toward(sled.velocity.x, 0, friction_coefficient * delta * abs(sled.velocity.normalized().x))
		sled.velocity.y = move_toward(sled.velocity.y, 0, friction_coefficient * delta * abs(sled.velocity.normalized().y))
	# Rotate the sled to face along its current velocity vector
	if (sled.velocity != Vector2.ZERO):
		sled.look_at(sled.position + sled.velocity)
	#print(sled.velocity)
	# Apply physics movement to the sled
	sled.move_and_slide()
	# Override the gunner's rotation every frame to keep him centered on the sled
	# for a cool effect and more consistent aiming/shooting controls
	gunner.global_rotation = 0

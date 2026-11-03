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
@export var rope_handle: Line2D ## The Line representing the wagon's "handle"
@export var sled: CharacterBody2D ## The sled upon which the gunner rests

## Editor variables
@export var rope_length_max: float = 80.0 ## The maximum length of "slack" that the rope can provide
@export var friction_coefficient: float = 5.0 ## The "friction" amount for deceleration on the sled
@export var sled_accel: float = 500.0 ## The acceleration factor applied to the sled

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
	rope_handle.clear_points()
	rope_handle.add_point(scientist.global_position)
	rope_handle.add_point(sled.global_position)

func _physics_process(delta: float) -> void:
	# Apply the pulling physics to the gunner's cart
	var player_dist = scientist.global_position.distance_to(sled.global_position)
	if (player_dist >= rope_length_max):
		# Pull towards the player
		var cart_target_dir = sled.global_position.direction_to(scientist.global_position)
		sled.velocity = sled.velocity.move_toward(cart_target_dir * scientist.move_speed, sled_accel * delta)
	else:
		sled.velocity = sled.velocity.move_toward(Vector2.ZERO, friction_coefficient * delta)
	# Rotate the sled to face the scientist
	if (sled.velocity != Vector2.ZERO):
		# I really prefer this move_toward solution but I have no clue how to account for the overflow lol :(
		var targ_angle = sled.velocity.angle()
		# Check for the fastest path to the target angle by comparing the current delta
		# with the delta when you add or subtract 360 degrees from the target angle
		# NOTE: yes, this would probably be cleaner and more performant to just do directly
		# with radians, but looking at the unit circle makes me cry
		var t_a = rad_to_deg(targ_angle)
		var s_r = rad_to_deg(sled.rotation)
		if (abs(t_a - s_r) > abs(t_a-360 - s_r)):
			targ_angle -= deg_to_rad(360)
		elif (abs(t_a - s_r) > abs(t_a+360 - s_r)):
			targ_angle += deg_to_rad(360)
		# Apply rotational movement to approach the previously determined optimum angle
		sled.rotation = move_toward(sled.rotation, targ_angle, 5.0 * delta)
	# Apply physics movement to the sled
	sled.move_and_slide()
	# Override the gunner's rotation every frame to keep him centered on the sled
	# for a cool effect and more consistent aiming/shooting controls
	gunner.global_rotation = 0

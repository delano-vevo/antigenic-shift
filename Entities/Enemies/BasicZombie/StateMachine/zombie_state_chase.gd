extends State

## State links
@export var idle_state: State
@export var charge_state: State

func state_entered(parent: Entity) -> void:
	print("I chase-a the player!")
	parent.move_anim_playback.travel("Move")

func physics_process(delta: float, parent: Entity) -> State:
	# Get the nearest player entity from Main
	var nearest_player = get_tree().get_current_scene().get_nearest_player(parent.global_position)
	# Make sure the player exists
	if (nearest_player == null):
		return idle_state
	# Make sure the player is still in range
	if (parent.global_position.distance_to(nearest_player.global_position) > parent.detect_range + parent.lose_range):
		return idle_state
	elif (parent.global_position.distance_to(nearest_player.global_position) <= parent.attack_range):
		# See if the player is within attack range, and if so, apply the attack state
		parent.do_attack()
		# Abort the rest of the state execution without actually changing states (deferred to attack Behavior)
		return charge_state
	# Apply movement in the player's direction
	parent.velocity = parent.global_position.direction_to(nearest_player.global_position).normalized() * parent.move_speed
	parent.move_and_slide()
	# Set blend positions in the animation tree
	var look_dir = 1
	if (nearest_player.global_position.x < parent.global_position.x):
		look_dir = -1
	parent.set_blend_spaces(look_dir)
	# No exit conditions encountered - continue in this state
	return null

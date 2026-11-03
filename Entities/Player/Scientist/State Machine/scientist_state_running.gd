extends State

func physics_process(delta: float, parent: Entity) -> State:
	# Obtain movement input
	var move_h = Input.get_axis("move_left", "move_right")
	var move_v = Input.get_axis("move_up", "move_down")
	var move_dir = Vector2(move_h, move_v).normalized()
	# Apply input to blend positions in the parent AnimationTree
	if (move_h != 0):
		parent.animation_tree.set("parameters/MoveStateMachine/Run/blend_position", round(move_h))
		parent.animation_tree.set("parameters/MoveStateMachine/Idle/blend_position", round(move_h))
		parent.move_anim_playback.travel("Run") # Play the running animation if input detected
	elif (move_v == 0):
		# No H or V input - play the idle animation
		parent.move_anim_playback.travel("Idle")
	# Apply input to CharacterBody2D movement
	parent.velocity = move_dir * parent.move_speed
	parent.move_and_slide()
	# No state change encountered - proceed with this state
	return null

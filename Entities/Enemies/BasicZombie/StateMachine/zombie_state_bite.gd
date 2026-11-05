extends State

@export var chase_state: State
@export var timeout: Timer

func state_entered(parent: Entity) -> void:
	# Start the timeout
	timeout.start()
	# Play bite animation and apply VFX
	parent.animation_tree.set("parameters/Bite_OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	var bite = parent.bite_fx.instantiate()
	bite.global_position = parent.bite_player.global_position
	get_tree().get_current_scene().add_child(bite)
	# Debug output
	print("I bite-a the player!")

func process(delta: float, parent: Entity) -> State:
	# Poll the state timeout timer to detect state change
	if (timeout.is_stopped()):
		return chase_state
	else:
		return null

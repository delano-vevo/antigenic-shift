extends State

func state_entered(parent: Entity) -> void:
	# Disable collisions
	parent.collision_shape.disabled = true
	# Fire the death animation
	parent.animation_tree.set("parameters/Death_OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

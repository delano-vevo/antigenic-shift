extends State

func process(delta: float, parent: Entity) -> State:
	# Aim the gun with the mouse pointer
	parent.gun_sprite.look_at(parent.get_global_mouse_position())
	# Set the parent's look direction based on mouse position
	if (parent.get_global_mouse_position().x < parent.body_sprite.global_position.x):
		parent.body_sprite.scale.x = -1
	else:
		parent.body_sprite.scale.x = 1
	# Set vertical flip on the gun sprite so it doesn't go upside down
	parent.gun_sprite.scale.y = parent.body_sprite.scale.x
	# No exit conditions encountered - proceed w/ this state
	return null

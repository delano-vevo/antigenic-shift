extends State

## State links
@export var reload_state: State

func state_entered(parent: Entity) -> void:
	pass#parent.laser_line.visible = true

func physics_process(delta: float, parent: Entity) -> State:
	# Aim the gun with the mouse pointer
	parent.gun_sprite.look_at(parent.get_global_mouse_position())
	# Set the parent's look direction based on mouse position
	if (parent.get_global_mouse_position().x < parent.body_sprite.global_position.x):
		parent.body_sprite.scale.x = -1
	else:
		parent.body_sprite.scale.x = 1
	# Set vertical flip on the gun sprite so it doesn't go upside down
	parent.gun_sprite.scale.y = parent.body_sprite.scale.x
	# Do the graphics for LaserSight using the ShootRay
	parent.laser_line.clear_points()
	parent.laser_line.add_point(Vector2.ZERO)#parent.gun_sprite.global_position - parent.gun_sprite.global_position)
	var shoot_col = parent.shoot_ray.get_collider()
	if (shoot_col == null):
		parent.laser_line.add_point(parent.ray_end.global_position - parent.gun_sprite.global_position)
	else:
		# TODO: add another Sprite graphic at the laser sight interaction point for extra visual feedback
		parent.laser_line.add_point(parent.shoot_ray.get_collision_point() - parent.gun_sprite.global_position)
	# Check for shooting input and process
	if (Input.is_action_pressed("shoot")):
		parent.try_shoot_gun()
	# Check for reload input and process
	if (Input.is_action_just_pressed("reload")):
		return reload_state
	# No exit conditions encountered - proceed w/ this state
	return null

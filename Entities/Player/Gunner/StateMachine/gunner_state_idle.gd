extends State

func state_entered(parent: Entity) -> void:
	# Turn off the laser sight
	parent.laser_line.visible = false
	# Rotate the gun sprite down to an idle position
	if (parent.body_sprite.scale.x == -1):
		parent.gun_sprite.rotation_degrees = 160
	else:
		parent.gun_sprite.rotation_degrees = 20

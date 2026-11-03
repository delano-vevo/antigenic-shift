extends State

func state_entered(parent: Entity) -> void:
	# Reset to an idling animation
	parent.move_anim_playback.travel("Idle")

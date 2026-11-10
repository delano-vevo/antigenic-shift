extends GPUParticles2D

func _ready() -> void:
	emitting = true

func _on_finished() -> void:
	# TODO: draw this to the persistent blood viewport before deleting!
	pass#queue_free()

## This is an insanely hacky and stupid way to do this lmao, plase god if you're reading this
## in the final build I can only beg your forgiveness
func _on_timer_timeout() -> void:
	speed_scale = 0
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)

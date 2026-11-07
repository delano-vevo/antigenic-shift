extends GPUParticles2D

func _ready() -> void:
	emitting = true

func _on_finished() -> void:
	# TODO: draw this to the persistent blood viewport before deleting!
	queue_free()

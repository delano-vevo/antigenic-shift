class_name HitParticles
extends GPUParticles2D

@export var timeout_timer: Timer

# Emit the particles and start the timeout countdown
func start_particles() -> void:
	emitting = true
	timeout_timer.start()

func _on_timer_timeout() -> void:
	# Garbage collect this particle node
	queue_free()

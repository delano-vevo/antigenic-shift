class_name EnvironmentObject
extends StaticBody2D
## Defines the basic logic for an object in the environment, e.g. a tree or a car

## Editor nodes
@export var hit_particles: GPUParticles2D ## Used to do VFX when this object is shot with a bullet

## Called when the object is hit by a Gunshot; base behavior is to just emit a few
## particles if a hit_particle system is defined
func get_shot(gunshot: Gunshot, collision_point: Vector2) -> void:
	if (hit_particles != null):
		## Duplicate the existing one-shot particles node to allow for multiple simultaneous FX
		var new_part: GPUParticles2D = hit_particles.duplicate()
		add_child(new_part)
		## Emit particles from this GPUParticles node at the collision point
		# TODO: this DESPERATELY needs some kind of garbage collection!
		new_part.global_position = collision_point
		new_part.emitting = true

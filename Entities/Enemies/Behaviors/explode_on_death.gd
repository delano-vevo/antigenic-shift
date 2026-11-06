extends Behavior
## Implements a damaging AoE explosion on a delay after the enemy is killed

@export var exploded_sprite: Sprite2D
@export var explode_particles: GPUParticles2D
@export var damage_area: Area2D
@export var damage_amount: float = 5.0

func on_death() -> void:
	print("Boom! I asploded!")
	# Set the zombie graphics to the exploded zombie texture
	get_parent().sprite.visible = false
	exploded_sprite.visible = true
	# Check the damage area to see if a player was hit
	for body in damage_area.get_overlapping_bodies():
		if (body is Player):
			body.take_damage(damage_amount)
	# Emit corpse explosion particles
	explode_particles.emitting = true

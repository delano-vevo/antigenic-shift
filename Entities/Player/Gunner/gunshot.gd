class_name Gunshot
extends Node2D
## Encapsulates all of the logic (raycast, hit signals, particles, etc.) for a gunshot

## Editor nodes
@export var shot_fx_line: Line2D ## A Line used to render a simple line effect to show gunshots
@export var animation_player: AnimationPlayer ## Used to animate the fading effect on the VFX

## Gameplay variables
@onready var damage_amt: float = 1.0 ## The amount of damage this gunshot will do to whatever it hits

## Called to process the gunshot; return indicates whether the bullet hit
## Takes a RayCast2D corresponding to the trajectory of the bullet as an argument
## Takes a floating point value for shot_spread to generate a random offset in angle
## for the bullet to simulate the bullet spread of rapid-fire shooting; defaults to none
func shoot(shoot_ray: RayCast2D, shot_spread: float = 0.0) -> bool:
	add_child(shoot_ray)
	shoot_ray.enabled = true
	if (shot_spread != 0):
		shoot_ray.rotation_degrees += randf_range(-(shot_spread/2), shot_spread/2)
	# Update the raycast to check for a hit
	shoot_ray.force_raycast_update()
	var hit = shoot_ray.get_collider()
	# Use the node's Line to provide basic VFX
	shot_fx_line.clear_points()
	#print("shoot ray rotation " + str(shoot_ray.rotation_degrees))
	#print("Gunshot rotation : " + str(rotation_degrees))
	shot_fx_line.rotation = shoot_ray.rotation
	#print("Rotation degrees: " + str(shot_fx_line.rotation_degrees))
	shot_fx_line.add_point(Vector2.ZERO)
	# Add the second line point either at the raycast end (on a miss) or the hit point (on a hit)
	if (hit == null):
		shot_fx_line.add_point(shoot_ray.target_position)
	else:
		# Set the second point as a simple Vector2(x, 0) where x = distance from node's position
		# to the point of impact; the inherited rotation on this node will apply the Y naturally
		shot_fx_line.add_point(Vector2(self.global_position.distance_to(shoot_ray.get_collision_point()), 0))
	# Play the fadeout animation (also responsible for calling queue_free() on animation end)
	animation_player.play("fade_out")
	# If an object was hit, apply hit logic
	if (hit != null):
		# Apply effects to the hit node
		# The hit object MUST have implemented the method get_shot() in order for this to have an effect
		if (hit.has_method("get_shot")):
			hit.get_shot(self, shoot_ray.get_collision_point())
		# TODO: maybe add an 'else' here with some kind of default particles/behavior?
		# Delete this node and indicate success
		return true
	# No hits detected - delete this node and return false
	return false

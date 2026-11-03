extends Entity

## Editor nodes
@export var gun_sprite: Sprite2D
@export var body_sprite: Sprite2D
@export var shoot_ray: RayCast2D
@export var laser_line: Line2D
@export var ray_end: Node2D
@export var shoot_cooldown_timer: Timer

## Gameplay variables
@export var shot_spread: float = 10.0 ## The angle, in degrees, of possible shot spread when firing
@export var shoot_cooldown: float = 0.5 ## The minimum time in seconds between consecutive gunshots

## Initialize
func _ready() -> void:
	ray_end.position = shoot_ray.target_position

## Called to fire a shot from the gun using RayCast2D
## Return indicates success or failure of attempted gunshot
func try_shoot_gun() -> bool:
	# Check if the cooldown is active
	if (shoot_cooldown_timer.is_stopped()):
		print("Shooting gun!")
		# Generate a new raycast for checking the shot
		var this_shot_ray = shoot_ray.duplicate()
		gun_sprite.add_child(this_shot_ray)
		this_shot_ray.enabled = true
		this_shot_ray.rotation_degrees += randf_range(-(shot_spread/2), shot_spread/2)
		this_shot_ray.force_raycast_update()
		# Do a gunshot at the endpoint of the ray
		var hit = this_shot_ray.get_collider()
		if (hit != null):
			print(hit) # TODO: add actual hit effects here
		# Remove the duplicate ray
		this_shot_ray.queue_free()
		# Set the cooldown timer
		shoot_cooldown_timer.start(shoot_cooldown)
	# If no success case has been encountered, indicate failure
	return false

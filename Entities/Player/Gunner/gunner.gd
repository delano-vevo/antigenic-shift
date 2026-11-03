extends Entity

## Linked scenes
@export var gunshot: PackedScene

## Editor nodes
@export var gun_sprite: Sprite2D
@export var body_sprite: Sprite2D
@export var shoot_ray: RayCast2D
@export var laser_line: Line2D
@export var ray_end: Node2D
@export var shoot_cooldown_timer: Timer
@export var reload_timer: Timer

## Gameplay variables
@export var shot_spread: float = 10.0 ## The angle, in degrees, of possible shot spread when firing
@export var shoot_cooldown: float = 0.2 ## The minimum time in seconds between consecutive gunshots
@export var clip_size: int = 20 ## The amount of bullets in a full clip
@onready var clip_current: int = clip_size ## The amount of bullets currently loaded into the clip
@export var bullets: int = 100.0 ## The total amount of bullets currently in posession
@export var reload_time: float = 2.0 ## The time, in seconds, a reload takes

## Initialize
func _ready() -> void:
	ray_end.position = shoot_ray.target_position

## Called to fire a shot from the gun using RayCast2D
## Return indicates success or failure of attempted gunshot
func try_shoot_gun() -> bool:
	# Check if the cooldown is active & the gun is loaded
	if (shoot_cooldown_timer.is_stopped() and clip_current > 0):
		# Generate a new gunshot for checking the shot
		var this_shot = gunshot.instantiate()
		gun_sprite.add_child(this_shot)
		this_shot.shoot(shoot_ray.duplicate(), shot_spread)
		# Reset the gun's cooldown
		shoot_cooldown_timer.start(shoot_cooldown)
		# Expend a bullet
		clip_current -= 1
		# Update the GUI in the main scene
		get_tree().get_current_scene().update_ammo_counter()
	# If no success case has been encountered, indicate failure
	return false

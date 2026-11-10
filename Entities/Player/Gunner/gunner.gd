extends Player

## Signals
signal ammo_changed

## Linked scenes
@export var gunshot_tscn: PackedScene
@export var bullet_shell_tscn: PackedScene

## Editor nodes
@export var gun_sprite: Sprite2D
@export var body_sprite: Sprite2D
@export var shoot_ray: RayCast2D
@export var laser_line: Line2D
@export var ray_end: Node2D
@export var shoot_cooldown_timer: Timer
@export var reload_timer: Timer
@export var muzzle_flash: Sprite2D
@export var flash_timer: Timer

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
		var this_shot = gunshot_tscn.instantiate()
		gun_sprite.add_child(this_shot)
		# Apply upgrades to the bullet and fire it
		for upgrade in upgrades:
			upgrade.upgrade_gunshot(this_shot)
		this_shot.shoot(shoot_ray.duplicate(), shot_spread)
		# Do the VFX
		# Muzzle flash
		muzzle_flash.frame = randi_range(0,muzzle_flash.hframes*muzzle_flash.vframes)
		muzzle_flash.visible = true
		flash_timer.start()
		# Bullet shell
		var bullet_shell = bullet_shell_tscn.instantiate()
		bullet_shell.global_position = gun_sprite.global_position
		bullet_shell.direction_degrees = gun_sprite.rotation_degrees-(90*sign(body_sprite.scale.x))
		get_tree().get_current_scene().add_child(bullet_shell)
		# Reset the gun's cooldown
		shoot_cooldown_timer.start(shoot_cooldown)
		# Expend a bullet
		clip_current -= 1
		# Signal to Main to update ammo counter
		ammo_changed.emit()
	# If no success case has been encountered, indicate failure
	return false

## Called when the gunner obtains more ammunition
func get_ammo(amount: int) -> void:
	bullets += amount
	ammo_changed.emit()

## Hide the muzzle flash after a brief timer
func _on_timer_timeout() -> void:
	muzzle_flash.visible = false

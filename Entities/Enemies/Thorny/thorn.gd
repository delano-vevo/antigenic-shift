extends CharacterBody2D
## A Thorn projectile, as fired by a Thorny-type zombie

## Internal variables
@onready var player: Player ## The targeted Player instance; grabbed on intialize
@onready var acceleration: Vector2 = Vector2.ZERO ## Acceleration used to modify velocity in homing code

## Gameplay variables
@export var move_speed: float = 180.0 ## The speed at which the thorn flies
@export var rot_spd: float = 60.0 ## The rotation speed of the thorn as it tries to track down the player
@onready var damage_amt: float ## The damage this applies to the player on hit - MUST be initialized in instantiating Entity!

## Initialize
func _ready() -> void:
	player = get_tree().get_current_scene().get_nearest_player(global_position)

## Game loop
func _physics_process(delta: float) -> void:
	# Apply homing movement towards the player
	var targ_angle = (player.global_position - global_position).normalized() * move_speed
	var seek = (targ_angle - velocity).normalized() * rot_spd
	acceleration += seek
	velocity += acceleration * delta
	velocity = velocity.limit_length(move_speed)
	rotation = velocity.angle()-deg_to_rad(90) # I know this is inefficient and I could easily solve this with a Google search but I like my degrees
	# Apply movement and handle collisions
	var col = move_and_collide(velocity * delta)
	if (col != null):
		# Check for player damage
		if (col.get_collider() is Player):
			col.get_collider().take_damage(damage_amt)
		# Destroy the thorn
		queue_free()

## Implement a timeout for the thorn so it doesn't chase the player into eternity
func _on_timeout_timer_timeout() -> void:
	queue_free()

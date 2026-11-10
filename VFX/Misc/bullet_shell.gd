extends Sprite2D
## Implements a simple bullet shell VFX sprite that can be garbage-collected and
## rendered to a viewport texture as needed after processing movement

## Gameplay variables
@onready var direction_degrees: float ## The angle of movement, in degrees
@export var direction_random: float = 10.0 ## The amount of randomization applied to direction, in degrees
@export var decel: float = 2800.0 ## The amount of deceleration to apply to the bullet shell
@export var initial_speed: float = 500.0 ## The initial speed at which the shell will be ejected from the gun
@export var speed_random: float = 300.0 ## The randomness applied to the bullet shell's starting speed
@onready var done_moving: bool = false ## Boolean flag for the garbage collection I'll definitely get around to doing
@onready var speed: float ## The actual movement speed
@export var rotation_speed: float = 20.0 ## The speed at which the graphic will rotate for extra flair
@export var rotation_speed_random: float = 5.0 ## The extra randomness applied to the rotation speed

## Added to tree - the direction of the bullet shell should be set BEFORE
## adding it as a child to the Main scene, so this will just add some randomness
func _ready() -> void:
	# Apply randomness to speed and direction
	direction_degrees += direction_random
	initial_speed += randf_range(0, speed_random)
	rotation_speed += randf_range(-1*rotation_speed_random, rotation_speed_random)
	speed = initial_speed

## Game loop - move the shell and apply deceleration until it's finished
func _physics_process(delta: float) -> void:
	if (!done_moving):
		# Apply deceleration
		speed -= decel * delta
		# Check for movement finished
		if (speed <= 0):
			speed = 0
			done_moving = true
		else:
			# Apply movement
			var move_dir = Vector2.RIGHT.rotated(deg_to_rad(direction_degrees))
			position += move_dir * (speed * delta)
			# Apply rotation speed as a factor of movement speed (such that rotation will slow with deceleration)
			rotation_degrees += rotation_speed * (speed / initial_speed)

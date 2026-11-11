extends CharacterBody2D
## Defines a damaging projectile fired by a Spitter-type zombie

## Nodes
@export var sprite: Sprite2D

## Gameplay variables
@export var move_speed: float = 200.0
var move_direction ## Direction of movement as an angle in RADIANS - should ALWAYS be defined by the zombie BEFORE adding this to the tree!
var damage_amount ## Damage this deals to the player - must ALWAYS be defined by the zombie spitting the projectile!

## Initialize
func _ready() -> void:
	# Randomize graphic
	sprite.rotation_degrees = randf_range(0,360)

## Game loop
func _physics_process(delta: float) -> void:
	var move_vector = Vector2.RIGHT.rotated(move_direction)
	move_vector *= move_speed
	move_vector *= delta
	var hit = move_and_collide(move_vector)
	# Collision detected - process
	if (hit != null):
		# Check if it hit a player and apply damage
		if (hit.get_collider() is Player):
			hit.get_collider().take_damage(damage_amount)
		on_hit()

## Generic behavior on hitting any target (particle effects, etc.)
func on_hit() -> void:
	queue_free() # TODO: update this with VFX and the like

## When lifetime expires, kill the projectile
func _on_lifetime_timeout() -> void:
	pass # Replace with function body.

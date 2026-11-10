class_name Pickup
extends Area2D
## Implements a generic Pickup type for the player to grab

## Gameplay variables
@onready var move_dir: float ## The direction of the pickup's initial movement
@export var initial_move_spd: float = 180.0 ## The starting speed of the pickup
@export var move_spd_random: float = 60.0 ## Randomness applied to the starting speed
@onready var move_spd: float ## The movement speed of the pickup
@export var decel: float = 800.0 ## The amount of deceleration applied to the pickup

## Initialize
func _ready() -> void:
	# Connect signals
	self.body_entered.connect(_on_body_entered)
	# Randomize base movement
	move_spd = initial_move_spd + randf_range(0, move_spd_random)
	move_dir = randf_range(0, 360) ## In degrees

## Game loop
func _physics_process(delta: float) -> void:
	if (move_spd > decel * delta):
		move_spd -= decel * delta
		var move_dir: Vector2 = Vector2.RIGHT.rotated(deg_to_rad(move_dir))
		position += move_dir * move_spd * delta
	else:
		move_spd = 0

## Check for a player body entering the pickup area
func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		get_pickup(body)
		# TODO: do cooler pickup effects here eventually
		queue_free()

## Passes the pickup's item to the Player node that collided it in the body_entered
## signal above; override in child nodes to define pickup functionality
func get_pickup(player: Player) -> void:
	pass

class_name Enemy
extends Entity
## This class implements core behaviors and properties for the game's zombies

## Editor nodes
@export var sprite: Sprite2D

## Gameplay variables
@export var move_speed: float = 1.0
@export var detect_range: float = 1.0 ## The range at which a zombie will detect a player # TODO: make this line of sight
@export var lose_range: float = 1.0 ## The range at which a zombie will lose interest and quit chasing a player
@export var damage_resist: float = 0.0 ## The enemy's resistance to incoming damage (as a percentage out of 100)
@export var attack_damage: float = 1.0 ## The amount of damage the enemy does when attacking a player
@export var attack_range: float = 20.0 ## The range at which the enemy will attempt to attack a player
@onready var behaviors: Array[Behavior] ## An array of Behavior type resources that will execute and effect the enemy behavior at runtime

## Called from gunshot.gd when this is struck by a bullet; all enemies should have
## at least this basic functionality for reacting to gunshots
func get_shot(gunshot: Gunshot) -> void:
	# The simplest possible "take-damage-then-die" effect
	hp -= gunshot.damage_amt
	if (hp <= 0):
		die()

## Called when the zombie is killed to handle death logic
func die() -> void:
	# Trigger all on_death Behaviors
	for behavior in behaviors:
		behavior.on_death()
	# Remove from the scene tree
	queue_free()

## Called when the enemy attempts to attack the player
func do_attack() -> void:
	# Apply attack logic from Behaviors
	for behavior in behaviors:
		behavior.on_attack()

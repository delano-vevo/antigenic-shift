class_name Enemy
extends Entity
## This class implements core behaviors and properties for the game's zombies

## Editor nodes
@export var sprite: Sprite2D

## Gameplay variables
@export var move_speed: float = 1.0
@export var detect_range: float = 1.0 ## The range at which a zombie will detect a player # TODO: make this line of sight
@export var lose_range: float = 1.0 ## The range at which a zombie will lose interest and quit chasing a player
@export var damage_resistance: float = 0.0 ## The enemy's resistance to incoming damage (as a percentage out of 100)
@export var attack_damage: float = 1.0 ## The amount of damage the enemy does when attacking a player

## Called from gunshot.gd when this is struck by a bullet; all enemies should have
## at least this basic functionality for reacting to gunshots
func get_shot(gunshot: Gunshot) -> void:
	# The simplest possible "take-damage-then-die" effect
	hp -= gunshot.damage_amt
	if (hp <= 0):
		queue_free()

extends Node2D

## Editor nodes
@export var animation_player: AnimationPlayer
@export var damage_area: Area2D

## Gameplay variables
@onready var damage: float = 1.0 ## The amount of damage this will do to the player on hit; default to 1

# TODO: add some cool ass blood particles?
func _ready() -> void:
	animation_player.play("bite")

## Called from the AnimationPlayer function track; on the impact frame,
## this uses damage_area to check for and apply damage to a player if necessary
func do_damage() -> void:
	for body in damage_area.get_overlapping_bodies():
		if (body is Player):
			body.take_damage(damage)

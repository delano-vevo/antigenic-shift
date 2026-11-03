class_name Entity
extends CharacterBody2D

## Editor nodes
@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree
@export var state_machine: StateMachine

## Gameplay variables
@export var max_hp: float = 1.0
@onready var hp: float = max_hp

## Initialize
func _ready() -> void:
	pass

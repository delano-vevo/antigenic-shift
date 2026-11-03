class_name Enemy
extends Entity
## This class implements core behaviors and properties for the game's zombies

## Editor nodes
@export var sprite: Sprite2D

## Gameplay variables
@export var move_speed: float = 1.0
@export var detect_range: float = 1.0 ## The range at which a zombie will detect a player # TODO: make this line of sight
@export var lose_range: float = 1.0 ## The range at which a zombie will lose interest and quit chasing a player

class_name Trait
extends Resource
## Implements a specialized Trait that will be part of a ViralStrain, defining the
## behaviours and stats of all zombies infected with that particular strain

## Stats
@export var hp_flat: float ## alters the enemy's HP by a flat amount
@export var hp_percent: float ## Alters the enemy's HP by a percentage
@export var move_speed_flat: float ## Alters the enemy's movement speed by a flat amount
@export var move_speed_percent: float ## Alters the enemy's movement speed by a percentage
@export var attack_damage_flat: float ## Alters the enemy's attack damage by a flat amount
@export var attack_damage_percent: float ## Alters the enemy's attack damage by a percentage

## Behaviors

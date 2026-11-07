class_name Enemy
extends Entity
## This class implements core behaviors and properties for the game's zombies

## Preloads
@onready var blood_particles_tscn: PackedScene = preload("res://VFX/BloodParticles.tscn")

## Editor nodes
@export var sprite: Sprite2D

## Gameplay variables
@export var move_speed: float = 1.0
@export var detect_range: float = 1.0 ## The range at which a zombie will detect a player # TODO: make this line of sight
@export var lose_range: float = 1.0 ## The EXTRA range (on top of detect_range) that the enemy will pursue from once the player is spotted
@export var damage_resist: float = 0.0 ## The enemy's resistance to incoming damage (as a percentage out of 100)
@export var attack_damage: float = 1.0 ## The amount of damage the enemy does when attacking a player
@export var attack_range: float = 20.0 ## The range at which the enemy will attempt to attack a player
@onready var behaviors: Array[Behavior] ## An array of Behavior type resources that will execute and effect the enemy behavior at runtime

## Called from gunshot.gd when this is struck by a bullet; all enemies should have
## at least this basic functionality for reacting to gunshots
func get_shot(gunshot: Gunshot, collision_point: Vector2) -> void:
	# Do blood VFX based on collision point and whatnot
	var blood_part = blood_particles_tscn.instantiate()
	blood_part.global_position = global_position
	blood_part.rotation = gunshot.global_position.direction_to(global_position).angle()
	get_tree().get_current_scene().add_child(blood_part)
	# The simplest possible "take-damage-then-die" effect
	# Apply damage damping from damage_resist trait
	take_damage(gunshot.damage_amt)

## Take in some amount of damage from an outside source and apply logic
func take_damage(amount: float) -> void:
	var damage_taken: float = amount * (1-clamp(damage_resist,0,Global.MAX_DAMAGE_RESIST))
	hp -= damage_taken
	if (hp <= 0):
		die()

## Called when the zombie is killed to handle death logic
func die() -> void:
	# Don't die more than once, of course
	if (!state_machine.dead_state.is_current_state()):
		# Trigger all on_death Behaviors
		for behavior in behaviors:
			behavior.on_death()
		# Set to dead state, which should be implemented in ALL enemies
		state_machine.set_state(state_machine.dead_state)

## Called when the enemy attempts to attack the player
func do_attack() -> void:
	# Apply attack logic from Behaviors
	for behavior in behaviors:
		behavior.on_attack()

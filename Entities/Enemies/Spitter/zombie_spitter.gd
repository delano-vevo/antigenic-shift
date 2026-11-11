extends Enemy

## Load scenes
@onready var projectile_tscn: PackedScene = preload("res://Entities/Enemies/Spitter/SpitterProjectile.tscn")

## Internal variables
## The Playback node responsible for the Movement state machine in the animation BlendTree
@onready var move_anim_playback: AnimationNodeStateMachinePlayback

## Initialize
func _ready() -> void:
	# Activate the animation tree
	set_blend_spaces(1) # Make sure all blend spaces have a default value to avoid animation weirdness
	animation_tree.active = true
	# Grab the animation playback node
	move_anim_playback = animation_tree.get("parameters/MoveStateMachine/playback")
	# Call generic entity init
	super()

## Spits out a damaging projectile; invoked from the StateMachine
func spit_projectile() -> void:
	var new_projectile = projectile_tscn.instantiate()
	new_projectile.damage_amount = attack_damage
	new_projectile.global_position = global_position
	new_projectile.move_direction = global_position.direction_to(get_tree().get_current_scene().get_nearest_player(global_position).global_position).angle()
	get_tree().get_current_scene().environment.add_child(new_projectile)

## Update all BlendSpaces in the AnimationTree
func set_blend_spaces(amount: int) -> void:
	# Bind values to acceptable options
	if (amount == 1 or amount == -1):
		animation_tree.set("parameters/MoveStateMachine/Move/blend_position", amount)
		animation_tree.set("parameters/MoveStateMachine/Idle/blend_position", amount)
		animation_tree.set("parameters/Spit_BlendSpace/blend_position", amount)
		animation_tree.set("parameters/Death_BlendSpace/blend_position", amount)

## Deactivate the AnimationTree (called from death animation end)
func stop_anim() -> void:
	print("Stopping spitter animation")
	animation_tree.active = false

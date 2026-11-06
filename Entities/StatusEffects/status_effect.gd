class_name StatusEffect
extends Node2D
## Implements a basic status effect that gets added as a child of an Entity
## in order to apply some sort of effect over time

@export var effect_timeout: Timer ## A Timer that controls when this effect should timeout and disappear
@export var effect_tick: Timer ## A Timer that controls how often a "tick" of the status effect should occur

func _ready() -> void:
	effect_timeout.timeout.connect(_on_effect_timeout_timeout)
	effect_tick.timeout.connect(_on_effect_tick_timeout)

## Delete the effect on timeout
func _on_effect_timeout_timeout() -> void:
	queue_free()

## Apply a tick of the status effect
func _on_effect_tick_timeout() -> void:
	do_tick()

## Implemented in child classes, this is the function that determines
## what exactly a "tick" of the status effect entails
func do_tick() -> void:
	pass

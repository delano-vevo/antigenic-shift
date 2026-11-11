extends Area2D

@export var poison_status_tscn: PackedScene
@export var anim_player: AnimationPlayer
@onready var fadeout: bool = false

# Remove the cloud once it's timed out
func _on_timeout_timeout() -> void:
	anim_player.play("fade_out")

# Check for an overlap with the player and apply poison if detected
func _on_body_entered(body: Node2D) -> void:
	if (body is Player and !body.has_node("PoisonStatus")):
		body.add_child(poison_status_tscn.instantiate())

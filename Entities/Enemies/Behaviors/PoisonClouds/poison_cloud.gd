extends Area2D

@export var poison_status_tscn: PackedScene

# Remove the cloud once it's timed out
func _on_timeout_timeout() -> void:
	queue_free()

# Check for an overlap with the player and apply poison if detected
func _on_body_entered(body: Node2D) -> void:
	if (body is Player and !body.has_node("PoisonStatus")):
		print("Poisoned the player! Tehehehe")
		body.add_child(poison_status_tscn.instantiate())

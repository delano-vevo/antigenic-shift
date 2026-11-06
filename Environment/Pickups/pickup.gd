class_name Pickup
extends Area2D

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		get_pickup(body)
		# TODO: do cooler pickup effects here eventually
		queue_free()

## Passes the pickup's item to the Player node that collided it in the body_entered
## signal above; override in child nodes to define pickup functionality
func get_pickup(player: Player) -> void:
	pass

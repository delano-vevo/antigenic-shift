extends Pickup

@export var ammo_amount: int = 1.0 ## The amount of ammo this pickup will grant the player

func get_pickup(player: Player) -> void:
	# This hard-coded path will almost certainly break something catastrophically at some point
	# but fuck it we ball
	get_tree().get_current_scene().player_controller.gunner.get_ammo(ammo_amount)

extends Pickup

@export var amount: float = 1.0 ## The amount of progress this sample represents to the next breakthrough

func get_pickup(player: Player) -> void:
	player.get_xp(amount)

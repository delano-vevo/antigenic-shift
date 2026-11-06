extends StatusEffect

@export var poison_damage: float = 0.1

func do_tick() -> void:
	get_parent().take_damage(poison_damage)

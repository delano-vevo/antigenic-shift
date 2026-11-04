extends Node

## Maps enum values from EnemyStats to the actual string name of the property
## in the Enemy nodes for access with enemy.set() and enemy.get()
const STAT_NAMES: Dictionary = {
	Enum.EnemyStats.HP: "max_hp",
	Enum.EnemyStats.MOVE_SPEED: "move_speed",
	Enum.EnemyStats.ATTACK_DAMAGE: "attack_damage",
	Enum.EnemyStats.DAMAGE_RESIST: "damage_resist",
}

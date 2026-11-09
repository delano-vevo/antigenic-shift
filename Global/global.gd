extends Node

const MAX_DAMAGE_RESIST: float = 0.9

## Maps enum values from EnemyStats to the actual string name of the property
## in the Enemy nodes for access with enemy.set() and enemy.get()
const STAT_NAMES: Dictionary = {
	Enum.EnemyStats.HP: "max_hp",
	Enum.EnemyStats.MOVE_SPEED: "move_speed",
	Enum.EnemyStats.ATTACK_DAMAGE: "attack_damage",
	Enum.EnemyStats.DAMAGE_RESIST: "damage_resist",
	Enum.EnemyStats.DETECT_RANGE: "detect_range",
}

## Maps enum values from PlayerUpgradeTypes to actual preloaded resources
const PLAYER_UPGRADES: Dictionary = {
	Enum.PlayerUpgradeTypes.HP: preload("res://Entities/Player/Upgrades/hp_upgrade.gd"),
	Enum.PlayerUpgradeTypes.SHOT_DAMAGE: preload("res://Entities/Player/Upgrades/shot_damage_upgrade.gd"),
}

extends Node

const MAX_DAMAGE_RESIST: float = 0.9
const GAME_WIDTH: float = 512
const GAME_HEIGHT: float = 384
const AIM_LOOK: float = 15.0

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

## Maps enum values from Pickups to actual preloaded resources
const PICKUPS: Dictionary = {
	Enum.Pickups.HP: preload("res://Environment/Pickups/HPPickup.tscn"),
	Enum.Pickups.AMMO: preload("res://Environment/Pickups/AmmoPickup.tscn"),
	Enum.Pickups.VIRAL_SAMPLE: preload("res://Environment/Pickups/ViralSample.tscn"),
}

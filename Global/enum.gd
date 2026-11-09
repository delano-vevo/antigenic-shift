extends Node

## Types of Trait effects
enum TraitType {
	BEHAVIOR,
	STAT_CHANGE_FLAT,
	STAT_CHANGE_PERCENT,
}

## All the stats on Enemies that can be modified by Traits
enum EnemyStats {
	HP,
	MOVE_SPEED,
	ATTACK_DAMAGE,
	DAMAGE_RESIST,
	DETECT_RANGE,
}

## All types of player upgrades
enum PlayerUpgradeTypes {
	HP,
	SHOT_DAMAGE,
	SIZE ## Special ending value to allow easy access via PlayerUpgradeTypes.SIZE to the number of upgrade types available
}

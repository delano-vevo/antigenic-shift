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
	DAMAGE_RESIST
}

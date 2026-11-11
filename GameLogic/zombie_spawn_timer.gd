extends Timer
## Extend a basic Timer node to contain a pointer to a ViralStrain
## and append this information to a custom signal to be used in ZombieSpawner
## I hope you like spaghetti!

## Signals
signal spawn_zombie(viral_strain: ViralStrain, amount: int)

## Gameplay variables
@export var strain: ViralStrain ## The Strain this timer is linked to; exposed to the editor for testing
@export var spawn_batch_size: int ## The amount of zombies to spawn at once when the timer fires

## Propagate timeout signal into a custom spawn_zombie signal
func _on_timeout() -> void:
	spawn_zombie.emit(strain, spawn_batch_size)

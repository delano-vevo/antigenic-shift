extends Control
## Handles the UI elements on the end-of-day screen, including level-up choices,
## text elements, the cure progress bar, notifications for the titular Shift, etc.

## Signals
## Used to pass decisions from Buttons in UI children up to Main for processing
signal continue_game
signal upgrade_player
signal progress_cure

## Editor nodes
@export var subviewport: SubViewport ## The subviewport rendering the miniature scene for the day end UI
@export var cure_progress_label: Label ## The label indicator for the cure_progress bar
@export var cure_progress_bar: TextureProgressBar ## The progress bar for displaying cure % from Main.gd
@export var upgrade_display: NinePatchRect ## The background for the upgrade display label below
@export var upgrade_display_label: Label ## The Label used to display the applied upgrade when the player chooses that option on levelup
@export var continue_button: Button ## The Button used to continue with the game after the player is done in the UI

## Scene preloads
@onready var no_level_up_tscn: PackedScene = preload("res://GUI/DayEnd/DayEndNoLevelUp.tscn")
@onready var level_up_tscn: PackedScene = preload("res://GUI/DayEnd/DayEndLevelUp.tscn")

## Internal variables
@onready var sub_scene: Control ## The child scene (either levelup or no levelup) controlling the day end UI interactions

## On tree entered
func _ready() -> void:
	# TODO: update the cursor for interfacing with the levelup UI
	pass

## Custom initializer - takes input from Main.tscn to set up the UI correctly on day end
func init(cure_progress_percent: float, level_up: bool) -> void:
	## Set the cure progress
	cure_progress_bar.value = cure_progress_percent
	## Apply the level-up UI
	if (level_up):
		print("Leveling up! Woo, alright!")
		sub_scene = level_up_tscn.instantiate()
		sub_scene.progress_cure_button.pressed.connect(do_progress_cure)
		sub_scene.upgrade_player_button.pressed.connect(do_upgrade_player)
		add_child(sub_scene)
	else:
		print("Bummer! no level up tonight :(")
		sub_scene = no_level_up_tscn.instantiate()
		sub_scene.continue_button.pressed.connect(start_next_day)
		add_child(sub_scene)

## Called when the player wants to level up with the day's XP
func do_upgrade_player() -> void:
	# Signal the player's upgrade to Main
	upgrade_player.emit()
	# Get rid of the intermediary sub-scene UI
	sub_scene.queue_free()
	# Show the UI for the player upgrade
	# TODO: add some tweens here in the polishing phase to make this extra sleek
	upgrade_display_label.set_text(get_tree().get_current_scene().last_upgrade.get_upgrade_string())
	upgrade_display.visible = true
	continue_button.visible = true
	continue_button.disabled = false

## Called when the player wants to progress the cure with the day's XP
func do_progress_cure() -> void:
	# Signal the cure progress to main
	progress_cure.emit()
	# Get rid of the intermediary sub-scene UI
	sub_scene.queue_free() # NOTE: this should never cause an error because this code should never be running when sub_scene is null
	# Show the UI for cure progress
	# TODO: add some tweens here in the polishing phase to make this extra sleek
	cure_progress_bar.value = get_tree().get_current_scene().get_cure_progress_percent()
	cure_progress_bar.visible = true
	cure_progress_label.visible = true
	continue_button.visible = true
	continue_button.disabled = false

## Called when the player is done interacting with the day end UI and wants to begin the next day
func start_next_day() -> void:
	continue_game.emit()

## Called when the player presses the activated ContinueButton
## If anyone is reading this, no the redundant continue button isn't vibe-coded
## AI garbage, I'm just authentically this dumb
func _on_continue_button_pressed() -> void:
	start_next_day()

extends Control

@export var player_stats: Stats

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var level_number: Label = $LevelContainer/LevelNumber

func _ready() -> void:
	player_stats.xp_changed.connect(update_xp_bar)
	player_stats.level_up.connect(update_level_display)
	
	# Inicializa os valores
	update_xp_bar(player_stats.experience, player_stats.experience_required)
	update_level_display(player_stats.level)

func update_xp_bar(current_xp: int, required_xp: int) -> void:
	progress_bar.max_value = required_xp
	progress_bar.value = current_xp

func update_level_display(new_level: int) -> void:
	level_number.text = str(new_level)

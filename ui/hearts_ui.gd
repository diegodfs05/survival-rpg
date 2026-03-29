extends Control

@export var player_stats: Stats

@onready var empty_hearts: TextureRect = $EmptyHearts
@onready var full_hearts: TextureRect = $FullHearts

const TOTAL_WIDTH = 60

func _ready() -> void:
	player_stats.health_changed.connect(animate_heart_change)
	empty_hearts.size.x = TOTAL_WIDTH
	update_heart_width(player_stats.health)

func animate_heart_change(current_health: int) -> void:

	var target_width = (float(current_health) / player_stats.max_health) * TOTAL_WIDTH
	var tween = create_tween()
	tween.tween_property(full_hearts, "size:x", target_width, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

func update_heart_width(current_health: int) -> void:
	var target_width = (float(current_health) / player_stats.max_health) * TOTAL_WIDTH
	full_hearts.size.x = target_width

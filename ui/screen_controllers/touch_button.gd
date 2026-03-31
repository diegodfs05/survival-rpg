extends TouchScreenButton

@export var action_name: String = "attack"

func _ready() -> void:
	# Conecta os sinais nativos do TouchScreenButton
	pressed.connect(_on_pressed)
	released.connect(_on_released)

func _on_pressed() -> void:
	Input.action_press(action_name)

func _on_released() -> void:
	Input.action_release(action_name)

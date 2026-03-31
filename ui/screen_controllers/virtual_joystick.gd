extends Control

@export var max_radius: float = 32.0
@export var dead_zone: float = 5.0

@onready var base: TextureRect = $Base
@onready var stick: TextureRect = $Base/Stick

var joystick_vector: Vector2 = Vector2.ZERO
var is_pressing: bool = false
var touch_index: int = -1

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and touch_index == -1:
			var dist = event.position.distance_to(base.global_position + base.size / 2)
			if dist < max_radius * 2:
				touch_index = event.index
				is_pressing = true
		elif not event.pressed and event.index == touch_index:
			_reset_joystick()

	if event is InputEventScreenDrag and event.index == touch_index:
		var center = base.global_position + base.size / 2
		var offset = event.position - center
		joystick_vector = offset.limit_length(max_radius)
		stick.global_position = center + joystick_vector - (stick.size / 2)
		_update_input_map()

func _update_input_map() -> void:
	if joystick_vector.length() < dead_zone:
		_reset_input_actions()
		return

	# Normaliza o vetor para cálculo de força:
	# $$direction = \frac{joystick\_vector}{max\_radius}$$
	var norm_vec = joystick_vector / max_radius
	
	# Simula as ações de Input existentes no seu projeto
	_handle_action("move_right", norm_vec.x > 0.3, abs(norm_vec.x))
	_handle_action("move_left", norm_vec.x < -0.3, abs(norm_vec.x))
	_handle_action("move_down", norm_vec.y > 0.3, abs(norm_vec.y))
	_handle_action("move_up", norm_vec.y < -0.3, abs(norm_vec.y))

func _handle_action(action: String, active: bool, strength: float) -> void:
	if active:
		Input.action_press(action, strength)
	else:
		Input.action_release(action)

func _reset_joystick() -> void:
	touch_index = -1
	is_pressing = false
	joystick_vector = Vector2.ZERO
	stick.position = (base.size / 2) - (stick.size / 2)
	_reset_input_actions()

func _reset_input_actions() -> void:
	Input.action_release("move_left")
	Input.action_release("move_right")
	Input.action_release("move_up")
	Input.action_release("move_down")

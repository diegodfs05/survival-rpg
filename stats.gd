class_name Stats extends Resource

@export var health: = 4 :
	set(value):
		var previous_health = health
		health = clamp(value, 0, max_health)
		if health != previous_health: health_changed.emit(health)
		if health <= 0: no_health.emit()

# Valor base de XP para qualquer inimigo
const BASE_ENEMY_XP = 215
@export var max_health: = 4
@export var level: int = 1
@export var experience: int = 0
@export var experience_required: int = 750

signal health_changed(new_health)
signal no_health()
signal level_up(new_level)
signal xp_changed(current_xp, required_xp)

func add_experience(amount: int):
	experience += amount
	while experience >= experience_required:
		level_up_process()
	xp_changed.emit(experience, experience_required)

func level_up_process():
	experience -= experience_required
	max_health += 1
	level += 1
	health += (level / 2)
	# Curva de nível: aumenta 10% a cada nível
	experience_required = int(experience_required * 1.1)
	level_up.emit(level)

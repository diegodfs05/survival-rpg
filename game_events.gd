extends Node

signal grass_cut(xp_amount: int)
signal enemy_defeated(enemy_level: int, base_xp: int)

# Pré-carrega a cena para ganhar performance
const DAMAGE_NUMBER_SCENE = preload("res://ui/damage_number.tscn")

func spawn_damage_number(value: int, pos: Vector2) -> void:
	var number = DAMAGE_NUMBER_SCENE.instantiate()
	# Adiciona o número à cena principal para ele não ser deletado com o monstro
	get_tree().current_scene.add_child(number)
	
	# Posiciona o número e inicia a animação
	number.global_position = pos
	number.set_value_and_animate(value)

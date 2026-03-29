extends Node2D

@export_group("Configurações de Spawn")
@export var enemy_scene: PackedScene      # Qual inimigo spawnar (Arraste o .tscn do Morcego aqui)
@export var max_enemies: int = 5          # Limite de monstros ativos para este spawner
@export var spawn_cooldown: float = 5.0   # Tempo em segundos entre cada nascimento
@export var spawn_radius: float = 60.0    # Raio de dispersão (para não nascerem um em cima do outro)

@export_group("Configurações da Área")
@export var area_level: int = 1           # Nível que os monstros desta área terão

@onready var timer: Timer = $Timer

var current_enemy_count: int = 0

func _ready() -> void:
	# Configura o cronômetro com o tempo definido
	timer.wait_time = spawn_cooldown
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout() -> void:
	if current_enemy_count < max_enemies:
		spawn_enemy()

func spawn_enemy() -> void:
	if not enemy_scene: return
	
	var enemy = enemy_scene.instantiate() as Enemy
	if enemy:
		# Define o nível do monstro baseado na configuração do Spawner
		enemy.enemy_level = area_level
		
		# Calcula uma posição aleatória dentro do raio para dispersão
		var random_offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * randf_range(0, spawn_radius)
		enemy.global_position = global_position + random_offset
		
		# Conecta o sinal de saída da árvore para saber quando o monstro morreu/sumiu
		enemy.tree_exited.connect(_on_enemy_removed)
		
		# Adiciona o inimigo à cena principal (não ao spawner, para ele se mover livremente)
		get_parent().add_child.call_deferred(enemy)
		current_enemy_count += 1

func _on_enemy_removed() -> void:
	current_enemy_count -= 1

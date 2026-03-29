class_name Enemy extends CharacterBody2D

# Efeitos comuns
const HIT_EFFECT = preload("uid://bkexmlihmpv74")
const DEATH_EFFECT = preload("uid://ra0kqr8k26y5")

# Configurações de Nível e Ratios
@export_group("Level System")
@export var enemy_level: int = 1
@export var hp_ratio: float = 1.0          # Multiplica o HP base do nível
@export var experience_ratio: float = 1.0  # Multiplica a XP base
@export var vision_ratio: float = 1.0      # Multiplica o alcance da visão

@export_group("Combat")
@export var stats: Stats

# Referências comuns que todo inimigo tem
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hitbox: Hitbox = $Hitbox
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var center: Marker2D = $Center

# Novas referências para a UI flutuante
@onready var health_bar: ProgressBar = $HealthBarAnchor/ProgressBar
@onready var level_label: Label = $HealthBarAnchor/LevelLabel

func _ready() -> void:
	# Importante: Duplicar o resource para que um morcego não compartilhe HP com outro
	if stats:
		stats = stats.duplicate()
		setup_stats()
		# Conecta a mudança de vida à barra de progresso
		stats.health_changed.connect(_on_health_changed)
		stats.no_health.connect(die)
	
	if hurtbox:
		hurtbox.hurt.connect(take_hit.call_deferred)
		
	setup_combat()
	setup_overhead_ui()
	_child_ready()

# Função virtual para ser usada nas subclasses (como o _ready)
func _child_ready() -> void:
	pass

func setup_stats() -> void:
	# Matemática de Escalonamento Base
	# Exemplo: HP base começa em 5 e ganha 1 por nível
	var base_hp_for_level = 4 + enemy_level
	stats.max_health = int(base_hp_for_level * hp_ratio)
	stats.health = stats.max_health
	
func setup_combat() -> void:
	# Define o dano do inimigo igual ao seu nível
	if hitbox:
		hitbox.damage = enemy_level

func setup_overhead_ui() -> void:
	if health_bar:
		health_bar.max_value = stats.max_health
		health_bar.value = stats.health
	if level_label:
		level_label.text = str(enemy_level)

func _on_health_changed(new_health: int) -> void:
	if health_bar:
		# Atualiza a barra com um Tween opcional para suavidade
		var tween = create_tween()
		tween.tween_property(health_bar, "value", new_health, 0.2)

func get_player() -> Player:
	return get_tree().get_first_node_in_group("player") as Player

func is_player_in_range(custom_range: float) -> bool:
	var player = get_player()
	if player:
		# Aplica o vision_ratio ao alcance solicitado
		var adjusted_range = custom_range * vision_ratio
		return global_position.distance_to(player.global_position) <= adjusted_range
	return false

func can_see_player(max_view_distance: float) -> bool:
	if not is_player_in_range(max_view_distance): return false
	
	var player = get_player()
	ray_cast_2d.target_position = player.global_position - global_position
	ray_cast_2d.force_raycast_update()
	return not ray_cast_2d.is_colliding()

func take_hit(other_hitbox: Hitbox) -> void:
	var effect = HIT_EFFECT.instantiate()
	get_tree().current_scene.add_child(effect)
	effect.global_position = center.global_position
	
	stats.health -= other_hitbox.damage
	
	# CHAMA O NÚMERO FLUTUANTE AQUI
	GameEvents.spawn_damage_number(other_hitbox.damage, global_position + Vector2(0, -10))
	# O knockback ainda é responsabilidade da subclasse processar na física, 
	# mas a força nós recebemos aqui.
	_on_hit_taken(other_hitbox)

# Para a subclasse decidir se entra em estado de Hit ou toca som
func _on_hit_taken(_hb: Hitbox) -> void:
	pass

func die() -> void:
	# A XP agora considera o ratio do monstro específico
	var final_xp_to_emit = int(stats.BASE_ENEMY_XP * experience_ratio)
	GameEvents.enemy_defeated.emit(enemy_level, final_xp_to_emit)
	
	var death_effect = DEATH_EFFECT.instantiate()
	get_tree().current_scene.add_child(death_effect)
	death_effect.global_position = global_position
	queue_free()

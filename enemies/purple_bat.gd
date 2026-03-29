extends Enemy # Agora ele estende a nossa nova classe!

const SPEED = 30
const FRICTION = 500

@export var min_range: = 4
@export var max_range: = 128

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
@onready var marker_2d: Marker2D = $Marker2D
@onready var navigation_agent_2d: NavigationAgent2D = $Marker2D/NavigationAgent2D

# Substituímos o _ready pelo _child_ready da superclasse
func _child_ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var state = playback.get_current_node()
	match state:
		"IdleState":
			if can_see_player(max_range):
				playback.travel("ChaseState")
		
		"ChaseState":
			var player = get_player()
			if player:
				navigation_agent_2d.target_position = player.global_position
				var next_point = navigation_agent_2d.get_next_path_position()
				velocity = global_position.direction_to(next_point - marker_2d.position) * SPEED
				sprite_2d.scale.x = sign(velocity.x) if velocity.x != 0 else sprite_2d.scale.x
			
			if not is_player_in_range(max_range * 1.5): # Margem para parar de perseguir
				playback.travel("IdleState")
				
			move_and_slide()
			
		"HitState":
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			move_and_slide()

# Implementamos o que acontece especificamente com o morcego ao levar hit
func _on_hit_taken(other_hitbox: Hitbox) -> void:
	velocity = other_hitbox.knockback_direction * other_hitbox.knockback_amount
	playback.start("HitState")

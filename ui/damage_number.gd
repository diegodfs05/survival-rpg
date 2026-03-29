extends Label

func set_value_and_animate(value: int) -> void:
	text = str(value)
	
	# Faz o número ser independente do movimento do pai (inimigo/player)
	top_level = true
	
	var tween = create_tween().set_parallel(true)
	
	# Animação 1: Sobe 20 pixels verticalmente
	tween.tween_property(self, "position:y", position.y - 20, 0.5)\
		.set_trans(Tween.TRANS_QUART)\
		.set_ease(Tween.EASE_OUT)
	
	# Animação 2: Desaparece (Alpha vai para 0)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)\
		.set_delay(0.2)
	
	# Animação 3: Pequeno efeito de escala (Bounce)
	scale = Vector2.ZERO
	tween.tween_property(self, "scale", Vector2.ONE, 0.2)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	
	# Auto-destruição ao finalizar as animações
	tween.chain().tween_callback(queue_free)

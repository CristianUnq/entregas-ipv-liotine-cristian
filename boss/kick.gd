extends State

func enter() -> void:
	# Frenamos al personaje para pegar la patada
	player.velocity.x = 0
	player.animation_player.play("kick")

func physics_update(delta: float) -> void:
	# Aplicamos gravedad por si patea en el aire o cayendo
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta
		
	player.move_and_slide()

	# Le preguntamos al AnimationPlayer si ya terminó de reproducir.
	if not player.animation_player.is_playing() or player.animation_player.current_animation != "kick":
		transitioned.emit(self, "idle")

func exit() -> void:
	# nos aseguramos de apagar la hitbox de la patada
	var hitbox_shape = player.get_node("Pivot/HitboxKick/CollisionShape2D")
	if hitbox_shape:
		hitbox_shape.disabled = true


func _on_hitbox_kick_body_entered(body: Node2D) -> void:
	var direccion_impacto = sign(body.global_position.x - player.global_position.x)
	print(direccion_impacto)
	body.recibe_impact(direccion_impacto, "normal")

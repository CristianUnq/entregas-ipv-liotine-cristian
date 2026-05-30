extends State

func enter() -> void:
	# Frenamos al personaje para pegar la pina
	player.velocity.x = 0
	player.animation_player.play("punch")

func physics_update(delta: float) -> void:
	# Aplicamos gravedad por si tiró la piña justo cuando estaba cayendo del aire
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta
		
	player.move_and_slide()

	# Le preguntamos al AnimationPlayer si ya terminó de reproducir.
	if not player.animation_player.is_playing() or player.animation_player.current_animation != "punch":
		transitioned.emit(self, "idle")

func exit() -> void:
	var hitbox_shape = player.get_node("Pivot/HitboxPunch/CollisionShape2D")
	if hitbox_shape:
		hitbox_shape.disabled = true


func _on_hitbox_punch_body_entered(body: Node2D) -> void:
	# averiguar de que lado esta el oponente para calcular para que lado es el impacto
	#var posicion = body.global_position.x - player.global_position.x
	var direccion_impacto = sign(body.global_position.x - player.global_position.x)
	print(direccion_impacto)
	body.recibe_impact(direccion_impacto, "normal")

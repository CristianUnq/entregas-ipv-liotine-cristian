extends State

func enter() -> void:
	# Frenamos al personaje para pegar la pina
	player.velocity.x = 0
	player.animation_player.play("uppercut")
	player.uppercut_missed.play()

func physics_update(delta: float) -> void:
	# Aplicamos gravedad por si tiró la piña justo cuando estaba cayendo del aire
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta
		
	player.move_and_slide()
	player.actualizar_mirada()
	
	if not player.animation_player.is_playing():
		# ¿El jugador sigue manteniendo apretado "Abajo"?
		if Input.is_action_pressed(player.input_prefix + "crouch"):
			# Si sigue apretando, vuelve directo a agacharse
			transitioned.emit(self, "crouch")
		else:
			# Si soltó la tecla, vuelve a estar parado (Idle)
			transitioned.emit(self, "idle")
			
func exit() -> void:
	var hitbox_shape = player.get_node("Pivot/HitboxUppercut/CollisionShape2D")
	if hitbox_shape:
		hitbox_shape.disabled = true

func _on_hitbox_uppercut_body_entered(body: Node2D) -> void:
	var direccion_impacto = sign(body.global_position.x - player.global_position.x)
	print("Entro a hitboxUppercut")
	body.recibe_impact(direccion_impacto, "uppercut")

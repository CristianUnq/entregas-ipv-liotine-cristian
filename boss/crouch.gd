extends State

func enter() -> void:
	player.standing_collision.set_deferred("disabled", true)
	player.crouching_collision.set_deferred("disabled", false)
	player.animation_player.play("crouch")

func physics_update(delta: float) -> void:
	# gravedad
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta
		
	player.move_and_slide()
	
	if not Input.is_action_pressed(player.input_prefix + "crouch"):
		transitioned.emit(self, "idle")

func handle_input(event: InputEvent) -> void:
	# Si apretamos el botón de ataque
	if event.is_action_pressed(player.input_prefix + "attackPunch"):
		transitioned.emit(self, "punch")
		
	elif event.is_action_pressed(player.input_prefix + "attackKick"):
		print("toco tecla attackKick")
		transitioned.emit(self, "kick")
		
	elif event.is_action_pressed(player.input_prefix + "punchUp"):
		print("toco tecla punchUp")
		transitioned.emit(self, "uppercut")

func exit() -> void:
	player.standing_collision.set_deferred("disabled", false)
	player.crouching_collision.set_deferred("disabled", true)

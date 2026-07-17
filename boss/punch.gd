extends State

var combo_requested: bool = false
#var action_punch: String = "punch" 

func enter() -> void:
	player.velocity.x = 0
	combo_requested = false
	
	_disable_hitbox()
	
	# Arrancamos con el primer golpe
	player.animation_player.play("punch_combo_1")
	player.punch_missed.play()

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta
		player.move_and_slide()

	# 1. ESCUCHAMOS EL COMBO: 
	if Input.is_action_just_pressed(player.input_prefix + "attackPunch"):
		var anim_actual = player.animation_player.current_animation
		
		# Solo escuchamos si está en el golpe 1 o el golpe 2.
		# (Si ya está en el 3, no hay más combo que encadenar).
		if anim_actual == "punch_combo_1" or anim_actual == "punch_combo_2":
			if player.animation_player.current_animation_position > 0.1:
				combo_requested = true

# 2. SEÑAL DE FINALIZACIÓN
func _on_animation_finished(anim_name: StringName) -> void:
	
	match anim_name:
		"punch_combo_1":
			# Preguntamos si pidió combo Y SI ADEMÁS existe la animación 2
			if combo_requested and player.animation_player.has_animation("punch_combo_2"):
				player.animation_player.play("punch_combo_2")
				player.punch_missed.play()
				combo_requested = false 
			else:
				transitioned.emit(self, "idle")
				
		"punch_combo_2":
			# Preguntamos si pidió combo Y SI ADEMÁS existe la animación 3
			if combo_requested and player.animation_player.has_animation("punch_combo_3"):
				player.animation_player.play("punch_combo_3")
				player.punch_missed.play()
				combo_requested = false 
			else:
				# Si es Liu Kang, como no tiene "punch_combo_3", va a caer acá y volver a idle
				transitioned.emit(self, "idle")
				
		"punch_combo_3":
			# Termina el tercer golpe (Scorpion), volvemos a guardia
			transitioned.emit(self, "idle")

func exit() -> void:
	_disable_hitbox()

func _disable_hitbox() -> void:
	var hitbox_shape = player.get_node("Pivot/HitboxPunch/CollisionShape2D")
	if hitbox_shape:
		hitbox_shape.set_deferred("disabled", true)

func _on_hitbox_punch_body_entered(body: Node2D) -> void:
	var direccion_impacto = sign(body.global_position.x - player.global_position.x)
	body.recibe_impact(direccion_impacto, "normal")

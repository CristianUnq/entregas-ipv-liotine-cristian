extends CharacterBody2D

class_name Fighter

@export var input_prefix: String = "f1_"
@export var start_facing_left: bool = false
@export var barra_vida: ProgressBar

const SPEED = 60.0
const JUMP_VELOCITY = -260.0
const FORCE_HIT = 50.0

var direction_after_hit = 0
var tipo_golpe_recibido: String = "normal"
var oponente : Fighter
var vida_actual: float = 100.0

# Traemos la gravedad desde la configuración del proyecto
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var pivot = $Pivot
@onready var animation_player = $AnimationPlayer
# @onready var sprite = $Sprite2D
@onready var standing_collision: CollisionShape2D = $StandingCollision
@onready var crouching_collision: CollisionShape2D = $CrouchingCollision
@onready var laying_collision: CollisionShape2D = $LayingCollision
@onready var jumping_collision: CollisionShape2D = $JumpingCollision
@onready var state_machine = $StateMachine
@onready var saltoLiuKang: AudioStreamPlayer2D = $SaltoLiuKang
@onready var punch: AudioStreamPlayer2D = $Punch
@onready var kick: AudioStreamPlayer2D = $Kick
@onready var uppercut: AudioStreamPlayer2D = $Uppercut
@onready var punch_missed: AudioStreamPlayer2D = $PunchMissed
@onready var kick_missed: AudioStreamPlayer2D = $KickMissed
@onready var uppercut_missed: AudioStreamPlayer2D = $UppercutMissed
@onready var shout_kick: AudioStreamPlayer2D = $ShoutKick

func _ready() -> void:
	# El jugador nace
	if start_facing_left:
		pivot.scale.x = -1

func recibe_impact(direction, tipoGolpe) -> void:
	var estado_actual = state_machine.current_state.name.to_lower()
	
	# ESCUDO ACTUALIZADO: 
	# Solo ignoramos el golpe si ya está tirado en el piso o si ya está muerto.
	# Si está en "hit", SÍ permitimos que reciba daño para que funcionen los combos.
	if estado_actual == "laying" or estado_actual == "dead":
		return 
		
	direction_after_hit = direction
	tipo_golpe_recibido = tipoGolpe
	
	# 1. Le avisamos al grupo "camara" que se sacuda
	if tipoGolpe == "uppercut":
		# Temblor violento para el gancho
		get_tree().call_group("camara", "sacudir", 25.0)
		uppercut.play()
		vida_actual -= 10.0
	else:
		# Temblor cortito y seco para la piña normal
		get_tree().call_group("camara", "sacudir", 1.0)
		punch.play()
		vida_actual -= 5.0
	
	if barra_vida != null:
		barra_vida.value = vida_actual
		
	if barra_vida.value <= 0:
		print("ENTRANDO EN DEAD")
		player_dead()
		return
		
	Engine.time_scale = 0.05
	
	# Pasamos al estado de recibir el golpe. 
	# Al llamarlo de nuevo aunque ya esté en "hit", la máquina de estados 
	# debería reiniciar el estado (volviendo a ejecutar el enter() del hit)
	state_machine.on_child_transition(state_machine.current_state, "hit")
	
	# Esperamos 0.05 segundos EN TIEMPO REAL (ignorando la congelación)
	await get_tree().create_timer(0.05, true, false, true).timeout
	
	# Devolvemos el tiempo a su velocidad normal
	Engine.time_scale = 1.0

func player_dead() -> void:
	state_machine.on_child_transition(state_machine.current_state, "dead")
	
func actualizar_mirada() -> void:
	if oponente == null:
		return
	
	var direccion_mirada = 1
		
	if global_position.x < oponente.global_position.x:
		pivot.scale.x = 1
		direccion_mirada = -1
	elif global_position.x > oponente.global_position.x:
		pivot.scale.x = -1
		direccion_mirada = 1
		
	laying_collision.position.x = abs(laying_collision.position.x) * direccion_mirada

func evitar_equilibrio_sobre_rival() -> void:
	if is_on_floor():
		
		for i in get_slide_collision_count():
			var colision = get_slide_collision(i)
			
			if colision == null:
				continue
			
			var objeto_tocado = colision.get_collider()
			
			
			if objeto_tocado is Fighter and objeto_tocado != self:
				var direccion_empuje = sign(global_position.x - objeto_tocado.global_position.x)
				
				if direccion_empuje == 0:
					direccion_empuje = 1 
					
				var velocidad_guardada = velocity.x
				
				velocity.x = 100 * direccion_empuje
				move_and_slide()
				
				velocity.x = velocidad_guardada
				break

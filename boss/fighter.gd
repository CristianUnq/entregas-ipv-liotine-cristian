extends CharacterBody2D

class_name Fighter

@export var input_prefix: String = "f1_"
@export var start_facing_left: bool = false
const SPEED = 300.0
const JUMP_VELOCITY = -580.0
const FORCE_HIT = 400.0

var direction_after_hit = 0
var tipo_golpe_recibido: String = "normal"
var oponente : Fighter

# Traemos la gravedad desde la configuración del proyecto
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var pivot = $Pivot
@onready var animation_player = $AnimationPlayer
# @onready var sprite = $Sprite2D
@onready var standing_collision: CollisionShape2D = $StandingCollision
@onready var crouching_collision: CollisionShape2D = $CrouchingCollision

func _ready() -> void:
	# El jugador nace
	if start_facing_left:
		pivot.scale.x = -1
	# La StateMachine (que es un nodo hijo) se despierta sola en su propio _ready() 
	# y pone al jugador en el estado inicial (ej: Idle).

func recibe_impact(direction, tipoGolpe) -> void:
	direction_after_hit = direction
	tipo_golpe_recibido = tipoGolpe
	var state_machine = $StateMachine
	state_machine.on_child_transition(state_machine.current_state, "hit")
	
func actualizar_mirada() -> void:
	if oponente == null:
		return
		
	if global_position.x < oponente.global_position.x:
		pivot.scale.x = 1
	elif global_position.x > oponente.global_position.x:
		pivot.scale.x = -1

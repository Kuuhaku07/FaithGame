extends CharacterBody2D

@export var Max_Speed = 300
@export var Aceleracion = Vector2(1500, 1500)
@export var Friccion = 1000
@onready var axis = Vector2.ZERO
@export var Jump_Speed = 500
@export var Is_Grounded = true
@export var Is_Crouched = false






func _physics_process(delta):
	move(delta)
	var motion = Vector2(axis.x * Max_Speed, axis.y * Jump_Speed)
	Is_Grounded = motion
	if Is_Crouched:
		set_scale(Vector2(1, 0.5))
	else:
		set_scale(Vector2(1, 1))


func get_input_axis():
	axis.x = int(Input.is_action_pressed("Moverse_Derecha")) - int(Input.is_action_pressed("Moverse_Izquierda"))
	
	
	if Input.is_action_just_pressed("Saltar") and is_on_floor():
		axis.y = -1
	elif Input.is_action_pressed("Saltar") :
		axis.y = -1
	elif Input.is_action_just_released("Saltar") and axis.y < 0:
		axis.y = 0
	else:
		axis.y=0.5
		
	if Input.is_action_just_pressed("Agacharse") and Is_Grounded:
		Is_Crouched = true
	elif Input.is_action_just_released("Agacharse") and Is_Crouched:
		Is_Crouched = false
	return axis.normalized()

func move(delta):
	
	axis=get_input_axis()
	
	if axis== Vector2.ZERO:
		apply_friction(Friccion * delta)
	else:
		apply_movement(axis * Aceleracion* delta)
	move_and_slide()
		
func apply_friction(amount):
	if velocity.length()>amount:
		velocity -=velocity.normalized() * amount
	else: 
		velocity= Vector2.ZERO
		
func apply_movement(accel):
	velocity += accel
	velocity = velocity.limit_length(Max_Speed)

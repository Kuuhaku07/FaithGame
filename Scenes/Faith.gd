extends CharacterBody2D

@export var Max_Speed = 400
@export var Aceleracion = Vector2(1500, 4000)
@export var Friccion = 10
@onready var axis = Vector2.ZERO

@export var Is_Grounded = true
@export var Is_Crouched = false

@export var Jump_Max=30000

@export var max_gravity = 1500
@export var gravity = 1500

func _physics_process(delta):
	move(delta)
	var motion = Vector2(axis.x * Max_Speed,0)
	if is_on_floor():
		Is_Grounded = true
	else:
		Is_Grounded=false
	if Is_Crouched:
		set_scale(Vector2(1, 0.5))
	else:
		set_scale(Vector2(1, 1))

func get_input_axis():
	axis.x = int(Input.is_action_pressed("Moverse_Derecha")) - int(Input.is_action_pressed("Moverse_Izquierda"))
	
	if Input.is_action_just_pressed("Agacharse") and Is_Grounded:
		Is_Crouched = true
	elif Input.is_action_just_released("Agacharse") and Is_Crouched:
		Is_Crouched = false
	return axis.normalized()

func move(delta):
	
	axis=get_input_axis()

	if axis== Vector2.ZERO:
		apply_friction(Friccion,delta,Is_Grounded)
	

	apply_gravity(gravity*delta)
	apply_movement(axis * Aceleracion* delta)
	jump(Is_Grounded,delta,Jump_Max)
	move_and_slide()
		
func apply_friction(amount,delta,Is_Grounded):
	if abs(velocity.x)>amount:
		velocity.x -=velocity.x * amount*delta
		print(velocity.x)
	else: 
		velocity.x= 0
		
func apply_movement(accel):
	velocity += accel
	velocity = velocity.limit_length(Max_Speed)
	
func apply_gravity(accel):
	if velocity.y<max_gravity:
		velocity.y += accel
		
func jump(grounded,delta,Jump_max):
	if grounded== true:

		if velocity.y<Jump_max and Input.is_action_just_pressed("Saltar") :
			velocity.y = Jump_max*-1*delta

			
	
		
	


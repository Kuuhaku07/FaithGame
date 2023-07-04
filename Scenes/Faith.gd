extends CharacterBody2D

@export var Max_Speed:float = 300
@export var Aceleracion:int = 1500
@export var Friccion:float = 15
@onready var axis:Vector2 = Vector2.ZERO

@export var Is_Grounded:bool = true
@export var Is_Crouched:bool = false

@export var Jump_Max:int=25000
@export var DoubleJump:bool=true

@export var max_gravity:int = 1500
@export var gravity:int= 1500

func _physics_process(delta):
	move(delta)
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
		apply_friction(Friccion,delta)
	
	if Is_Grounded==false:
		apply_gravity(gravity*delta)
	if Is_Crouched==false:
		if Input.is_action_just_pressed("Rodar") and Is_Grounded:
			roll(axis.x)
		else:
			apply_movement(axis.x * Aceleracion* delta)
	else:
		apply_movement(axis.x * Aceleracion* delta/1.5)
		apply_friction(Friccion,delta)	
	jump(Is_Grounded,delta,Jump_Max)
	move_and_slide()
		
func apply_friction(amount,delta):
	if abs(velocity.x)>amount:
		velocity.x -=velocity.x * amount*delta
		print(velocity.x)
	else: 
		velocity.x= 0
		
func apply_movement(accel):
	if abs(velocity.x)<Max_Speed:
		velocity.x += accel
func roll(axisx):
	if velocity.x <= Max_Speed+50:
		velocity.x = (Max_Speed+100)*axisx
		print("uy")
func apply_gravity(accel):
	if velocity.y<max_gravity:
		velocity.y += accel
		
func jump(grounded,delta,Jump_max):
	
		if grounded:
			DoubleJump=true
		if  Input.is_action_just_pressed("Saltar") :
			if grounded:
				velocity.y = Jump_max*-1*delta
			else:
				if DoubleJump==true:
					velocity.y=Jump_max*-0.75*delta
					DoubleJump=false

			
	
		
	


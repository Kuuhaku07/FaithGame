extends RigidBody2D


@export var dir:Vector2 = Vector2.ZERO
@export var Velocity:Vector2 = Vector2.ZERO

@export var Gravity:float = 300
@export var Speed:float = 300


func _ready()->void:
	Velocity=dir*Speed
func _process(delta:float)->void:
	Velocity.y+=Gravity*delta
	
	var collision =move_and_collide(Velocity*delta)
	if not collision:return
	
	Velocity=Velocity.bounce(collision.get_normal())*0.6
	
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

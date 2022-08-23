extends KinematicBody


var _max_speed = 10.0
var _acceleration = 10.0
var _decelaration = 10.0
var velocity := Vector3.ZERO
var gravity := 9.81


func _physics_process(delta):
	var move_vector = Vector2.ZERO
	if Input.is_action_pressed("move_forward"):
		move_vector.x += 1.0
	if Input.is_action_pressed("move_backward"):
		move_vector.x -= 1.0
	if Input.is_action_pressed("move_right"):
		move_vector.y += 1.0
	if Input.is_action_pressed("move_left"):
		move_vector.y -= 1.0

	var tmp = Vector2(velocity.x, velocity.z)

	if move_vector.length_squared() > 0.2:
		tmp = lerp(tmp, move_vector.normalized() * _max_speed, delta * _acceleration)
	else:
		tmp = lerp(tmp, Vector2.ZERO, delta * _decelaration)
	

	velocity.x = tmp.x
	velocity.z = tmp.y
	velocity.y += -gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)

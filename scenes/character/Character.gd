extends KinematicBody

onready var _camera_anchor = $CameraAnchor

var _max_speed = 10.0
var _acceleration = 5.0
var _deceleration = 10.0
var _velocity := Vector3.ZERO
var _gravity := -9.81


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

	var tmp = Vector2(_velocity.x, _velocity.z)

	if move_vector.length_squared() > 0.2:
		tmp = lerp(tmp, move_vector.normalized() * _max_speed, delta * _acceleration)
	else:
		tmp = lerp(tmp, Vector2.ZERO, delta * _deceleration)

	_velocity.x = tmp.x
	_velocity.z = tmp.y
	_velocity.y += _gravity * delta
	_velocity = move_and_slide(_velocity, Vector3.UP)

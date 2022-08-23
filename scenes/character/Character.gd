extends KinematicBody

onready var _camera_anchor = $CameraAnchor
onready var _model = $Model

var _max_speed = 10.0
var _acceleration = 5.0
var _deceleration = 10.0
var _jump_force = 5.0
var _mouse_sensitivity = 0.005
var _velocity := Vector3.ZERO
var _gravity := -9.81


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion:
		event = event as InputEventMouseMotion
		_camera_anchor.rotate(Vector3.UP, -event.get_relative().x * _mouse_sensitivity)


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

	if Input.is_action_just_pressed("jump"):
		jump()

	var tmp = Vector2(_velocity.x, _velocity.z)

	if move_vector.length_squared() > 0.2:
		var rot = -_camera_anchor.get_rotation().y
		move_vector = move_vector.normalized().rotated(rot)
		tmp = lerp(tmp, move_vector * _max_speed, delta * _acceleration)

	else:
		tmp = lerp(tmp, Vector2.ZERO, delta * _deceleration)

	_velocity.x = tmp.x
	_velocity.z = tmp.y
	_velocity.y += _gravity * delta
	_velocity = move_and_slide(_velocity, Vector3.UP)

	# When the new velocity is close to zero, the model starts to jiggle when the camera is rotated.
	# Checking that the velocity is non-zero removes that.
	if _velocity.length_squared() > 0.5:
		_model.rotation.y = tmp.angle_to(Vector2.RIGHT)

func jump():
	if is_on_floor():
		_velocity.y = _jump_force

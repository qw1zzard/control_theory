extends Sprite


var g: float = 9.81
var mass: float = 10.0
var radius: float = 27.0
var alpha: float
var new_alpha: float
var speed: float = 0.0
var angle_speed: float
var a: float

var current: float = 0.0
var target: float = 200.0
var x_start: float
var y_start: float

var previous_error: float = 0.0
var error_P: float
var integral_I: float = 0.0
var devariate_D: float

var KP: float = 0.09
var KI: float = 0.0001
var KD: float = 0.0001
var dt: float = 0.00001


func controller_PID(input: float, set_point: float):
	error_P = set_point - input
	integral_I += error_P * dt
	devariate_D = (error_P - previous_error) / dt
	previous_error = error_P
#	print('Current: ', input, ', error: ', error_P)
	return KP*error_P + KI*integral_I + KD*devariate_D


func _ready():
	self.position.x = get_viewport().size.x / 2.0
	self.position.y = get_viewport().size.y / 2.0 - self.texture.get_height()
	x_start = self.position.x
	y_start = self.position.y
	self.rotation = alpha


func _process(delta: float):
	if Input.is_action_just_pressed('ui_accept'): target *= -1

	new_alpha = controller_PID(current, target)

	if -180.0 < new_alpha and new_alpha < 180.0:
		alpha = new_alpha

	if (current < 380 and alpha >= 0) or (current > -380 and alpha <= 0):
		a = g * sin(alpha * PI/180.0) / 1.5
		speed += a * delta
		current += speed

		angle_speed = speed / radius
		self.rotation += angle_speed

		self.position.x = x_start + current * cos(alpha * PI/180.0)
		self.position.y = y_start + current * sin(alpha * PI/180.0)
	else:
		speed = 0.0

extends Line2D


var k: float = 2.0 # spring rate
var c: float = 1.0 # movement resistance
var mass: float = 2.0
var time: float = 0.0
var beta: float = c / (2*mass) # attenuation coefficient
var omega: float = 0.0 # cyclic frequency of damped oscillations
var phi: float = -PI
var state: int = 0

var target: float
var start_y: float = 0.0
var start_x: float
var y_offset: float
var new_length: float
var start_length: float

var KP = 0.1
var KI = 0.2
var KD = -0.001
var previous_error: float = 0.0
var error_P: float
var integral_I: float = 0.0
var devariate_D: float


func initialize():
	time = 0.0
	self.set_point_position(0,  Vector2(start_x, start_y))
	self.set_point_position(1,  Vector2(start_x, start_length))
	$Ball.position = self.get_point_position(1) + Vector2.DOWN * y_offset
	$Target.position = Vector2(start_x, target)


func controller_PID(input: float, dt: float):
	error_P = target - y_offset - input
	integral_I += error_P * dt
	devariate_D = (error_P - previous_error) / dt
	previous_error = error_P
#	print('Current:  ', input, ', error: ', error_P)
	return KP*error_P + KI*integral_I + KD*devariate_D


func simulate(delta: float, state: int):
	time += delta
	new_length = start_length*(2 + exp(-beta*time) * cos(omega*time + phi))
	if state == 2:
		new_length += controller_PID(self.get_point_position(1).y, delta)
	$Ball.position.y = new_length + y_offset
	self.set_point_position(1, Vector2(start_x, new_length))


func _ready():
	if k*mass > beta*beta: omega = sqrt(k*mass - beta*beta)
	start_x = get_viewport().size.x / 2.0
	y_offset = $Ball.texture.get_height() / 2.0
	start_length = self.texture.get_height() * 1.5
	target = 0.45 * get_viewport().size.y
	initialize()


func _process(delta):
	if Input.is_action_just_pressed('ui_down'): state = 1
	elif Input.is_action_just_pressed('ui_up'): state = 2
	elif Input.is_action_just_pressed('ui_accept'):
		initialize()
		state = 0

	if state > 0: simulate(delta, state)

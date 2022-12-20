extends Node2D


func _ready():
	$Track.position.x = get_viewport().size.x / 2.0
	$Track.position.y = get_viewport().size.y / 2.0
	$Target.position = $Track.position + Vector2.RIGHT * $Ball.target \
					   + Vector2.UP * $Ball.texture.get_height()
	$Track.rotation = $Ball.alpha * PI/180.0


func _process(_delta):
	if Input.is_action_just_pressed('ui_accept'):
		$Target.position = $Track.position - Vector2.RIGHT * $Ball.target \
						   + Vector2.UP * $Ball.texture.get_height()
	$Track.rotation = $Ball.alpha * PI/180.0

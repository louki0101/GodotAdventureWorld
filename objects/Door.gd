extends Area2D

export(NodePath) var teleport_target = null

var player_in_door = false


func _ready():
	$PopupIndicator.hide()



func _process(delta):	
	if Input.is_action_just_pressed("enter_door") and player_in_door == true:
		get_tree().call_group("player", "teleport_to", get_node(teleport_target).position)



func _on_Door_body_entered(body):
	if body.is_in_group("player"):
		$PopupIndicator.show()
		player_in_door = true


func _on_Door_body_exited(body):
	if body.is_in_group("player"):
		$PopupIndicator.hide()
		player_in_door = false




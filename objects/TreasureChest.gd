extends Area2D

var player_in_front = false
var is_full = true


func _ready():
	$PopupIndicator.hide()



func _process(delta):	
	if Input.is_action_just_pressed("enter_door") and player_in_front == true and is_full == true:
		get_tree().call_group('player','add_item','coin')
		is_full = false
		$EmptySprite.show()
		$FullSprite.hide()
		$PopupIndicator.hide()
		
		




func _on_TreasureChest_body_entered(body):
	if body.is_in_group("player") and is_full == true:
		$PopupIndicator.show()
		player_in_front = true


func _on_TreasureChest_body_exited(body):
	if body.is_in_group("player"):
		$PopupIndicator.hide()
		player_in_front = false

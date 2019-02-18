extends Area2D

export(NodePath) var player_path = null

var player_at_counter = false
var torch_available = true


func _ready():
	$PopupIndicator.hide()


func player_has_coin():
	var player = get_node(player_path)
	if player.inventory.find('coin') >= 0:
		return true
	else:
		return false



func _process(delta):	
	if Input.is_action_just_pressed("enter_door") and player_at_counter == true and torch_available == true:
		var player = get_node(player_path)
		
		if player_has_coin():
			player.remove_item('coin')
			$Merchant.play('sell')
			yield(get_tree().create_timer(1.5), "timeout")
			$Merchant.play('default')
			player.add_item('torch')
			torch_available = false
			$Torch.hide()
			$PopupIndicator.hide()
			
			
		




func _on_Merchant_body_entered(body):
	if body.is_in_group("player") and torch_available == true:		
		$PopupIndicator.show()
		player_at_counter = true
		
		if player_has_coin():
			$PopupIndicator/NotSprite.hide()
		else:
			$PopupIndicator/NotSprite.show()


func _on_Merchant_body_exited(body):
	if body.is_in_group("player"):
		$PopupIndicator.hide()
		player_at_counter = false

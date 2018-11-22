extends Area2D



func _on_Goal_body_entered(body):
	if body.is_in_group("player"):
		print('Player Wins!')

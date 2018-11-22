extends Area2D



func _on_Bush_body_entered(body):
	if body.is_in_group("moves_bushes"):
		get_node("AnimationPlayer").play("move_bush")

func end_bush_move():
	print('animation ended!')
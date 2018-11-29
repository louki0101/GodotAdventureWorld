extends Area2D



func _on_WaterArea2D_body_entered(body):
	if body.has_method("entered_water"):
		body.entered_water()


func _on_WaterArea2D_body_exited(body):
	if body.has_method("exited_water"):
		body.exited_water()

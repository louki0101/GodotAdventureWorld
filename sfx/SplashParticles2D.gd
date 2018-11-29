extends Particles2D



func _on_CleanupTimer_timeout():
	queue_free()

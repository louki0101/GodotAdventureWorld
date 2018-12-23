extends "res://actors/Actor.gd"





func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func _on_DamageArea2D_body_entered(body):
	if body.has_method("hurt") and body.is_in_group("player"):
		body.hurt()




func actor_behavior(delta):
	#gravity	
	vel.y = min(vel.y + GRAV, GRAV_MAX)
	
	
	
	if is_on_wall():
		vel.x = 0
	
	
	if sprite.flip_h == true:
		#right
		vel.x = min(vel.x + ACCELERATION, MAX_SPEED)
	else:
		#left
		vel.x = max(vel.x - ACCELERATION, -MAX_SPEED)
	
	


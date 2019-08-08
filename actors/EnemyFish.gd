extends "res://actors/Actor.gd"



onready var front_ray = get_node("RayPivot/FrontRayCast2D")
onready var ray_pivot = get_node("RayPivot")


func _ready():
	MAX_SPEED = 200
	ACCELERATION = 20




func _on_DamageArea2D_body_entered(body):
	if body.has_method("hurt") and body.is_in_group("player"):
		body.hurt()




func actor_behavior(delta):
	
	
	if is_on_wall():
		vel.x = 0
	
	
	if front_ray.is_colliding():
		vel.x = 0
		sprite.flip_h = not sprite.flip_h
		ray_pivot.scale.x = ray_pivot.scale.x * -1
	
		
	
	if sprite.flip_h == true:
		#right
		vel.x = min(vel.x + ACCELERATION, MAX_SPEED)
	else:
		#left
		vel.x = max(vel.x - ACCELERATION, -MAX_SPEED)
	
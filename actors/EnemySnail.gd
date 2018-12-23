extends KinematicBody2D


#movement
var vel = Vector2()
var GRAV = 1000
var GRAV_MAX = 20000
var MAX_SPEED = 20000
var ACCELERATION = 500

var UP_VECTOR = Vector2(0,-1)
var JUMP_HEIGHT = -39000


onready var sprite = get_node("AnimatedSprite")


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func _on_DamageArea2D_body_entered(body):
	if body.has_method("hurt") and body.is_in_group("player"):
		body.hurt()




func _physics_process(delta):
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
	
	move_and_slide(vel * delta, UP_VECTOR)


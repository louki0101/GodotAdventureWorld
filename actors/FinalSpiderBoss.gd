extends KinematicBody2D


var state = 'pre_drop_in'



var vel = Vector2()
var GRAV = 300
var GRAV_MAX = 1000
var MAX_SPEED = 300
var ACCELERATION = 25

var UP_VECTOR = Vector2(0,-1)




func _ready():
	pass

func _process(delta):
	
	if state == 'drop_in':
		
		if self.is_on_floor():
			state = 'first_attack'	
		
		vel.y += (delta * GRAV)
		move_and_slide(vel, UP_VECTOR)	
		
	elif state == 'first_attack':
		vel.x -= (delta * GRAV)
		vel.y = 0
		move_and_slide(vel, UP_VECTOR)	
	elif state == 'second_attack':
		pass
	elif state == 'fainting':
		pass




func trigger_drop_in():
	print('droppin in')
	state = 'drop_in'
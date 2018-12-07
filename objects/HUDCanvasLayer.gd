extends CanvasLayer

var heart_full_tex = preload("res://art/hud/hud_heartFull.png")
var heart_empty_tex = preload("res://art/hud/hud_heartEmpty.png")

func _ready():
	get_node("HBoxContainer").show()


func update(hearts):	
	for i in range(0, get_node("HBoxContainer").get_children().size()):
		var heart = get_node("HBoxContainer/Heart_" + str(i))
		if (i+1) > hearts: heart.texture = heart_empty_tex
		else: heart.texture = heart_full_tex
class_name AmmoDisplay
extends Node

var ammo := 30
var bullets: Array[Node]

func _ready() -> void:
	for i in range(30):
		bullets.push_back(get_node("Ammo" + str(i + 1)))
		
func has() -> bool:
	return ammo > 0
	
func is_full() -> bool:
	return ammo == 30
	
func use():
	ammo -= 1
	_update()
	
func reload():
	ammo = 30
	_update()

func _update():
	for i in range(len(bullets)):
		bullets[i].visible = i < ammo
		i += 1
		

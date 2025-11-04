class_name AmmoDisplay
extends Node

var ammo := 30 if GameState.has_magazine else 0
var bullets: Array[Node]

func _ready() -> void:
	for i in range(30):
		bullets.push_back(get_node("Ammo" + str(i + 1)))
	_update()	
		
func has() -> bool:
	return ammo > 0
	
func get_amount() -> int:
	return ammo
	
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
		

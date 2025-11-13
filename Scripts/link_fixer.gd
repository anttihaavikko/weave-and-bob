extends Node

@export var links: Array[PlayerPart]
@export var center: Node2D

var origins: Array[PartOrigin] = []

func _ready() -> void:
	for l in links:
		origins.push_back(PartOrigin.new(l.position, l.rotation))
		
func _process(_delta: float) -> void:
	var mid := Vector2.ZERO
	for l in links:
		mid += l.position
	var distance := (center.position - mid / len(links)).length()
	if distance > 50:
		print("needs fixing? ", distance)
		GameState.fix_player.emit()

class PartOrigin:
	var position: Vector2
	var rotation: float
	
	func _init(pos: Vector2, rot: float) -> void:
		position = pos
		rotation = rot

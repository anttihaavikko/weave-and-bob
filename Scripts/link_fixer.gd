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
	if distance > 35:
		print("reset")
		for l in links:
			var origin := origins[links.find(l)] 
			l.move_to(center.position + origin.position, origin.rotation)

class PartOrigin:
	var position: Vector2
	var rotation: float
	
	func _init(pos: Vector2, rot: float) -> void:
		position = pos
		rotation = rot
	

extends Node2D

@export var area: Area2D
@export var hider: Node

func _ready():
	area.body_entered.connect(enter)
	area.body_exited.connect(exit)
	
func enter(_node: Node2D):
	hider.hide()

func exit(_node: Node2D):
	hider.show()

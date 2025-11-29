extends Node2D

@export var area: Area2D
@export var hider: Node

var playing := false

func _ready():
	area.body_entered.connect(enter)
	area.body_exited.connect(exit)
	
func enter(_node: Node2D):
	hider.hide()
	if not playing:
		playing = true
		Musics.dim_for(2.5)
		SoundEffects.singleton.add(22, global_position)
		await get_tree().create_timer(2).timeout
		playing = false

func exit(_node: Node2D):
	hider.show()

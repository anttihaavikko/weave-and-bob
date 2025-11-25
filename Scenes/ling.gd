extends Node

@export var area: Area2D
@export var appearer: Appearer
@export var message: Message
@export var face: Node2D

var face_pos: Vector2
var intro := "What are you doing here Weave!?\nThis is my place...\nGo bother dad or something!"
var messages := [
	"Lorem ipsum dolor"
]

func _ready():
	face_pos = face.position
	area.body_entered.connect(enter)
	area.body_exited.connect(exit)
	
func _process(_delta):
	var pp := GameState.player.live_gun.global_position
	face.position = face_pos + face.to_local(pp).normalized() * 20

func enter(_node: Node2D):
	appearer.appear()
	var content := intro if not GameState.has("ling") else messages.pick_random() as String
	message.show_text(content)

func exit(_node: Node2D):
	appearer.disappear()
	if message.done:
		GameState.mark("ling")
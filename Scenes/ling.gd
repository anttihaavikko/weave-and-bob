extends Node

@export var area: Area2D
@export var appearer: Appearer
@export var message: Message
@export var face: Node2D
@export var talk: AudioStreamPlayer2D

var face_pos: Vector2
var intro := "What are you doing here Weave!?\nThis is my place...\nGo bother dad or something!"
var messages := [
	"Have you been to the east side yet?\nThat's Mother\'s domain.\nThe entrance is locked though and\nyou'll need to find another route.",
	"Where's Bob?\nHe never wants to play with me!"
]

func _ready():
	face_pos = face.position
	area.body_entered.connect(enter)
	area.body_exited.connect(exit)
	message.line_change.connect(do_talk)
	
func _process(_delta):
	var pp := GameState.player.live_gun.global_position
	face.position = face_pos + face.to_local(pp).normalized() * 20

func enter(_node: Node2D):
	appearer.appear()
	var content := intro if not GameState.has("ling") else messages.pick_random() as String
	message.show_text(content)
	do_talk()

func do_talk():
	talk.play()
	await get_tree().create_timer(randf_range(0.5, 1)).timeout
	talk.play()

func exit(_node: Node2D):
	appearer.disappear()
	if message.done:
		GameState.mark("ling")
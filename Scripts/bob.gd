extends Node2D

@export_multiline var main_message: String;
@export var spots: Array[Node2D]
@export var anim: AnimationPlayer
@export var face: Node2D
@export var area: Area2D
@export var text: Appearer
@export var message: Message

var cur: Vector2
var points: Array[Vector2]
var face_pos: Vector2
var moving := false
var talking := false
var done := false
var tween: Tween

func _ready():
	if GameState.has(name):
		queue_free()
		return
	
	face_pos = face.position

	area.body_entered.connect(enter)
	area.body_exited.connect(exit)

	if len(spots) > 0:
		points.push_back(self.global_position)
		for spot in spots:
			points.push_back(spot.global_position)
		cur = self.global_position
		move()

func _process(_delta):
	var pp := GameState.player.live_gun.global_position
	face.position = face_pos + face.to_local(pp).normalized() * 5

func enter(_node: Node2D):
	if not visible:
		return
	if moving and tween:
		moving = false
		tween.kill()
		anim.play("idle", 0.2)
	talking = true
	message.show_text(get_text())
	text.appear()
	
func get_text() -> String:
	if done:
		return [
			"I've got nothing else\nfor you right now.",
			"What do you think\nof this invasion?",
			"These are some really\nnice mushrooms!",
			"We've already found X of Y\npossible mushroom spots!"
		].pick_random()
	return main_message
	
func exit(_node: Node2D):
	text.disappear()
	talking = false
	if message.done:
		done = true
		GameState.mark(name)
	
func move():
	if len(spots) > 0:
		if not talking:
			cur = points.filter(func(s): return s != cur).pick_random()
			var duration := global_position.distance_to(cur) * 0.004
			anim.play("walk", 0.3)
			moving = true
			tween = get_tree().create_tween()
			tween.tween_property(self, "global_position", cur, duration).set_trans(Tween.TRANS_QUAD)
			await get_tree().create_timer(duration).timeout
			anim.play("idle", 0.2)
			moving = false
		await get_tree().create_timer(randf_range(3, 6)).timeout
		move()

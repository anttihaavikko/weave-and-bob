extends Node2D

@export_multiline var main_message: String;
@export var spots: Array[Node2D]
@export var anim: AnimationPlayer
@export var face: Node2D
@export var area: Area2D
@export var text: Appearer
@export var message: Message
@export var speech: AudioStreamPlayer2D
@export var final: bool
@export var end_bob: Node
@export var start_note: AreaTextDisplay

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
	
	if final and GameState.met_bobs >= 5:
		show()
		start_note.enabled = false
	
	face_pos = face.position

	area.body_entered.connect(enter)
	area.body_exited.connect(exit)

	if len(spots) > 0:
		points.push_back(self.global_position)
		for spot in spots:
			points.push_back(spot.global_position)
		cur = self.global_position
		move()

	message.line_change.connect(speak)

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
	speak()

func speak():
	speech.play()

func get_text() -> String:
	if done:
		if final:
			return [
				"Ending bits",
				"You're %s done with everything!" % GameState.get_percentage()
			].pick_random()
		return [
			"This is a really nice spot\nfor gathering mushrooms!",
			"I've got nothing else\nfor you right now.",
			"What do you think\nof this invasion?",
			"These are some really\nnice mushrooms!",
			"I've coined the term mathvasion\nfor this new invasive species!",
			"We've already found %d of 5\npossible mushroom spots!" % [GameState.met_bobs]
		].pick_random()
	return [
		"What's up with these flying goons?\nI'm calling it a mathvasion!",
		"I'd suggest you to shy away from\ndisturbing Big Papa or Worm Mom!",
		"This is a really sweet spot for mushrooms.\nDestroying angel is my favourite species!\nI do love fly agarics too...",
		"Just one more spot of mushrooms\nand we're set for the coming winter.",
		"And all done with mushrooms!\nI'm going to go back home now.",
		"Hey don't bother with the mathvasion!\nJust go to sleep instead."
	][GameState.met_bobs]
	
func exit(_node: Node2D):
	if not visible:
		return
	text.disappear()
	talking = false
	if message.done:
		if not done and not final:
			GameState.met_bobs += 1
		if not final:
			GameState.mark(name)
		done = true
		if GameState.met_bobs == 5:
			end_bob.show()
			start_note.enabled = false
	
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

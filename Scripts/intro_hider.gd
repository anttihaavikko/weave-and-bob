extends Area2D

@export var appearers: Array[Appearer]
@export var options: OptionsMenu

func _ready() -> void:
	if GameState.spawn_set or GameState.has_gun:
		options.toggle_button.hide()
		for a in appearers:
			a.queue_free()
		queue_free()
	body_entered.connect(entered)

func entered(_node: Node2D):
	GameState.spawn_set = true
	queue_free()
	options.toggle_button.hide()
	if options.open:
		options.toggle()
	for a in appearers:
		a.disappear()

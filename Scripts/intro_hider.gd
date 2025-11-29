extends Area2D

@export var appearers: Array[Appearer]
@export var options: OptionsMenu
@export var completion: Appearer
@export var thanks: Appearer

func _ready() -> void:
	if GameState.spawn_set or OS.is_debug_build():
		options.toggle_button.hide()
		for a in appearers:
			a.queue_free()
		queue_free()
		return
	
	body_entered.connect(entered)

	if GameState.met_bobs >= 5:
		await get_tree().create_timer(0.2).timeout
		completion.show_with_text("Completion %s" % GameState.get_percentage())
		thanks.appear()

func entered(_node: Node2D):
	GameState.spawn_set = true
	queue_free()
	options.toggle_button.hide()
	if options.open:
		options.toggle()
	for a in appearers:
		a.disappear()

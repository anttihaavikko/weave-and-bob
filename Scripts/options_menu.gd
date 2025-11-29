class_name OptionsMenu
extends SlidingPanel

@export var toggle_button: Button
@export var music: Slider
@export var sounds: Slider
@export var extra_panel: SlidingPanel

var saver = Saver.new("settings.json")

func _ready():
	super._ready()
	toggle_button.pressed.connect(close)
	music.value_changed.connect(volumes_changed)
	sounds.value_changed.connect(volumes_changed)
	GameState.options = self
	var data = saver.load()
	if data and data.has("music"):
		music.value = data.music
	if data and data.has("sounds"):
		sounds.value = data.sounds
	volumes_changed(0)

func volumes_changed(_val):
	AudioServer.set_bus_volume_linear(1, music.value * 2)
	AudioServer.set_bus_volume_linear(2, sounds.value * 2)
	
func close():
	toggle()
	if extra_panel.open:
		extra_panel.toggle()
	saver.save({"music": music.value, "sounds": sounds.value})

func _input(_event):
	if Input.is_action_just_pressed("escape"):
		close()

func restart():
	close()
	GameState.restart()

func toggle_fullscreen():
	var full := DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if full else DisplayServer.WINDOW_MODE_FULLSCREEN)

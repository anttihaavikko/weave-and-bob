class_name Encounter
extends Node2D

@export var doors: Array[Door]
@export var reward: PackedScene
@export var reward_type: Pickup.Type

var id: String
var waves: Array[Wave]
var wave_count: int

func start(enemy: Enemy):
	id = enemy.id
	# print("starting encounter")
	for door in doors: door.close()
	
	GameState.main_text.show_with_text("Enemies incoming!")
	SoundEffects.singleton.add(12, global_position) # warn.wav
	
	await get_tree().create_timer(0.5).timeout
	
	for child in get_children():
		if child is Wave:
			waves.push_back(child)
	
	wave_count = len(waves)
	next_wave()
	
func open_doors():
	for door in doors: door.open()

func next_wave() -> void:
	if waves.is_empty():
		# print("encounter complete")
		await get_tree().create_timer(0.25).timeout
		open_doors()
		await get_tree().create_timer(0.5).timeout
		Musics.intensify(false)
		var pickup := reward.instantiate()
		if pickup is Pickup:
			pickup.id = id
			pickup.type = reward_type
			SoundEffects.singleton.add(6, global_position) # pickup1.wav
		add_child(pickup)
		return
	var wave = waves.pop_front()
	wave.start(self, "%d/%d" % [wave_count - len(waves), wave_count])

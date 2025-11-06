class_name Encounter
extends Node2D

@export var doors: Array[Door]
@export var reward: PackedScene
@export var reward_type: Pickup.PickupType

var id: String
var waves: Array[Wave]

func start(enemy: Enemy):
	id = enemy.id
	print("starting encounter")
	for door in doors: door.close()
	
	for child in get_children():
		if child is Wave:
			waves.push_back(child)
			
	next_wave()		

func next_wave() -> void:
	if waves.is_empty():
		print("encounter complete")
		for door in doors: door.open()
		await get_tree().create_timer(0.5).timeout
		var pickup := reward.instantiate()
		if pickup is Pickup:
			pickup.id = id
			pickup.type = reward_type
		add_child(pickup)
		return
	var wave = waves.pop_front()
	wave.start(self)

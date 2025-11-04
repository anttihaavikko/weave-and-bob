extends Node

var has_magazine := true
var ids: Array[String]

enum PickupType { None, Magazine }

func mark(id: String):
	ids.push_back(id)

func collect(type: PickupType):
	if type == PickupType.Magazine: has_magazine = true
	
func has(id: String) -> bool:
	return ids.has(id)
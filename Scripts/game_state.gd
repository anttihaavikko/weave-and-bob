extends Node

var has_magazine := true
var ids: Array[String]

enum PickupType { None, Magazine }

func collect(id: String, type: PickupType):
	ids.push_back(id)
	if type == PickupType.Magazine: has_magazine = true
	
func has(id: String) -> bool:
	return ids.has(id)
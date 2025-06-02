extends Node


func saveConfig(data: Dictionary, SaveLocation: String) -> int:
	var file: FileAccess = FileAccess.open(SaveLocation, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open file: %s" % SaveLocation)
		return 1

	for sectionName: String in data.keys():
		var _result:bool = file.store_line("[" + sectionName + "]")
		var sectionData: Dictionary = data[sectionName]

		for key: String in sectionData.keys():
			var value:Variant = sectionData[key]
			var valueString: String = ""

			if value is Vector3:
				var v: Vector3 = value
				valueString = "(%s, %s, %s)" % [v.x, v.y, v.z]
				
			elif typeof(value) == TYPE_FLOAT:
				var f:int = value + 0
				valueString = str(f)
			else:
				valueString = str(value)

			_result = file.store_line("%s=%s" % [key, valueString])

		_result = file.store_line("")

	file.close()
	return 0

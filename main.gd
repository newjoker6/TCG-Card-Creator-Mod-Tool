extends Control

var _Skills: Array = ["None",
	'Charging',
	'FireClaw',
	'BlazingClaw',
	'InfernoClaw',
	'HellfireClaw',
	'FlamePillar',
	'BlazingPillar',
	'InfernoPillar',
	'SunPillar',
	'SpitFire',
	'Fireball',
	'MegaFlare',
	'CometStrike',
	'PiercingHit',
	'PiercingStrike',
	'PiercingCrash',
	'OmegaPierce',
	'BlitzAttack',
	"BlitzStrike",
	'BlitzSmash',
	"BlitzCrash",
	'FireWall',
	'InfernoWall',
	'BlazingWall',
	'HellfireWall',
	'PsychUp',
	'CriticalWound',
	'DesperadoHit',
	'SolarFlare',
	'Counter',
	'FrenzyHit',
	'Charge',
	'SuperCharge',
	'MegaCharge',
	'GigaCharge',
	'StoneWall',
	'RockWall',
	'GiantWall',
	'GigaWall',
	'Grow',
	'SuperGrow',
	'MegaGrow',
	'GigaGrow',
	'PebbleBlast',
	'StoneBlast',
	'RockSmash',
	'BoulderCrush',
	'Cover',
	'Protection',
	'Safeguard',
	'PerfectGuard',
	'HardenShell',
	'FortifyShell',
	'PowerUp',
	'Sharpen',
	'FuryStrike',
	'SwipeAttack',
	'Earthquake',
	'AncientProtection',
	'HealingMist',
	'HealingShower',
	'HealingRain',
	'HealingWaterfall',
	'EnergyPool',
	'EnergyFountain',
	'EnergyRain',
	'EnergyFlood',
	'DrainHit',
	'DrainStrike',
	'DrainSmash',
	'DrainCrush',
	'ColdShot',
	'IceBurst',
	'IcicleBlast',
	'SubzeroBeam',
	'RegenPool',
	'RegenFountain',
	'RegenRain',
	'RegenFlood',
	'Osmosis',
	'CleansingMist',
	'IcicleField',
	'MassAbsorb',
	'Consume',
	'Rejuvenate',
	'PoisonFang',
	'VenomFang',
	'ToxicFang',
	'AcidFang',
	'PoisonBlast',
	'VenomBlast',
	'ToxicBlast',
	'AcidBlast',
	'SandShot',
	'SandBlast',
	'SandStorm',
	'SandHurricane',
	'PowerDrip',
	'PowerLeak',
	'Discharge',
	'Meltdown',
	'AirShot',
	'AirCutter',
	'SonicBoom',
	'WindBlade',
	'Berserk',
	'FocusFire',
	"PoisonMist",
	"PoisonStorm",
	'BlindingSmog',
	'StickyGoo',
	'SpeedUp',
	"SpeedDown",
	"SleepShot",
	"SleepBlast",
	"SleepMist",
	"SleepStorm",
	"Tornado",
	"MassBerserk",
	"Tailwind",
	"BattleCry"]
var _gamePath:String
var _savePath: String = "user://gamepath.dat"
#var _pW: String = "Susie is the hottest member of legion"
var _successText:String = "[font_size=40] [outline_color=4b4539][outline_size=5] [color=Green]Card files created successfully[/color]"
var _failedText:String = "[font_size=40] [outline_color=4b4539][outline_size=5] [color=Red]Failed to create cards[/color]"
@export_group("Scene Nodes")
@export_subgroup("Card Details")
@export var _CardNameTextLine: LineEdit
@export var _GenerateButton: Button
@export var _PackOptionButton: OptionButton
@export var _CardIDSpinBox: SpinBox
@export var _ElementIndexOptionButton: OptionButton
@export var _RarityOptionButton: OptionButton
@export var _RolesOptionButton: OptionButton
@export var _SkillsOptionButton: OptionButton
@export var _ArtistNameTextLine: LineEdit
@export var _CardDescriptionTextLine: LineEdit
@export var _NewCardButton: Button
@export var _UseImageButton: Button
@export var _NewCardCreator: VBoxContainer
@export var _PackAdditionOptionButton: OptionButton
@export var _AdditionPackSpinBox: SpinBox
@export var _CountUpDownOptionButton: OptionButton
@export var _GenerateCardsFromImageButton: Button
@export var _ExistingCardCreator: VBoxContainer
@export var _PreviousEvolutionLine: LineEdit
@export var _NextEvolutionLine: LineEdit
@warning_ignore("unused_private_class_variable")
@export var _CardImageSelectLine: LineEdit
@warning_ignore("unused_private_class_variable")
@export var _CardImageSelectButton: Button



@export_subgroup("Stats")
@export var _HPSpinBox: SpinBox
@export var _HPLevelAddSpinBox: SpinBox
@export var _MagicSpinBox: SpinBox
@export var _MagicLevelAddSpinBox: SpinBox
@export var _SpeedSpinBox: SpinBox
@export var _SpeedLevelUpSpinBox: SpinBox
@export var _SpritSpinBox: SpinBox
@export var _SpritLevelUpSpinBox: SpinBox
@export var _StrengthSpinBox: SpinBox
@export var _StrengthLevelUpSpinBox: SpinBox
@export var _VitalitySpinBox: SpinBox
@export var _VitalityLevelUpSpinBox: SpinBox

@export_subgroup("Non-Card Nodes")
@export var _PopWindow: Window
@export var _FilePicker: FileDialog
@export var _BrowseButton: Button
@export var _PromptWindow: Window
@export var _PathDialog: FileDialog
@export var _AnotherImageButton: Button
@export var _FeedbackLabel: RichTextLabel
@export var _BackButton:Button
@export var _BackButton2:Button
@warning_ignore("unused_private_class_variable")
@export var _ImageDialog: FileDialog

var _filePaths: PackedStringArray
var _countUp:bool = true


func _ready() -> void:
	OS.low_processor_usage_mode = true
	get_window().borderless = false
	connectSignals()
	SetupBaseOptions()
	_gamePath = loadEncryptedGamePath()
	
	if _gamePath.is_empty():
		promptForPath()
	else:
		_PopWindow.popup_centered()
		await get_tree().process_frame
		_PopWindow.grab_focus()


func promptForPath() -> void:
	_PromptWindow.popup_centered()
	_PromptWindow.move_to_foreground()


func connectSignals() -> void:
	var _ConnectStatus:int
	_ConnectStatus = _GenerateButton.pressed.connect(GenerateData)
	_ConnectStatus = _CardNameTextLine.text_changed.connect(CheckField)
	_ConnectStatus = _PackOptionButton.item_selected.connect(PackSelected)
	_ConnectStatus = _NewCardButton.pressed.connect(NewCardPressed)
	_ConnectStatus = _UseImageButton.pressed.connect(UseImagePressed)
	_ConnectStatus = _FilePicker.files_selected.connect(ImagesSelected)
	_ConnectStatus = _PackAdditionOptionButton.item_selected.connect(PackAdditionSelected)
	_ConnectStatus = _CountUpDownOptionButton.item_selected.connect(CountingSelected)
	_ConnectStatus = _GenerateCardsFromImageButton.pressed.connect(GenerateDataFromImages)
	_ConnectStatus = _BrowseButton.pressed.connect(BrowseFiles)
	_ConnectStatus = _PathDialog.dir_selected.connect(GamePathSelected)
	_ConnectStatus = _AnotherImageButton.pressed.connect(UseImagePressed)
	_ConnectStatus = _BackButton.pressed.connect(GoBack)
	_ConnectStatus = _BackButton2.pressed.connect(GoBack)
	_ConnectStatus = _CardImageSelectButton.pressed.connect(ShowImageSelector)
	_ConnectStatus = _ImageDialog.file_selected.connect(SelectImage)

func ShowImageSelector() -> void:
	_ImageDialog.show()


func SelectImage(path:String) -> void:
	_filePaths.clear()
	var _b:bool = _filePaths.append(path)
	_CardImageSelectLine.text = path


func GoBack() -> void:
	var _err:Error = get_tree().reload_current_scene()


func GamePathSelected(dir: String) -> void:
	_gamePath = dir
	saveEncryptedGamePath(dir)
	_PromptWindow.hide()
	_PopWindow.popup_centered()
	await get_tree().process_frame
	_PopWindow.move_to_foreground()


func BrowseFiles() -> void:
	_PathDialog.show()


func GenerateDataFromImages() -> void:
	var _ID: int = _AdditionPackSpinBox.value as int
	var destDir:String = _gamePath.path_join("BepInEx\\patchers\\TCGShopNewCardsModPreloader\\MonsterImages\\")
	var newName:String
	var destPath:String

	var dir:DirAccess = DirAccess.open("user://")
	var _err: Error = dir.make_dir_recursive(destDir)
	for p:String in _filePaths:
		var cleanedName:String = remove_leading_numbers(p.get_file())
		var elementCount:int = _ElementIndexOptionButton.item_count
		var rareCount:int = _RarityOptionButton.item_count
		var skillCount:int = _SkillsOptionButton.item_count
		var roleCount:int = _RolesOptionButton.item_count
		var rng: RandomNumberGenerator = RandomNumberGenerator.new()
		var randomelement:String = _ElementIndexOptionButton.get_item_text(rng.randi_range(0, elementCount - 1))
		var randomrarity:String = _RarityOptionButton.get_item_text(rng.randi_range(0, rareCount - 1))
		var randomskill:String = _SkillsOptionButton.get_item_text(rng.randi_range(0, skillCount - 1))
		var randomrole:String = _RolesOptionButton.get_item_text(rng.randi_range(0, roleCount - 1))
		newName = "%s%s" %[_ID, cleanedName]
		destPath = destDir + newName
		_err = dir.copy(p, destPath)
		
		CreateData(
			newName.get_basename(),
			_ID,
			["None", "None"],
			randomelement,
			randomrarity,
			randomskill,
			randomrole,
			true)
			
		if _countUp:
			_ID += 1
			continue
		_ID -= 1


func CountingSelected(idx: int) -> void:
	match idx:
		0:
			_countUp = true
		1:
			_countUp = false


func PackAdditionSelected(idx: int) -> void:
	var option: String = _PackOptionButton.get_item_text(idx)
	match option:
		"Tetramon":
			_AdditionPackSpinBox.min_value = 122
			_AdditionPackSpinBox.max_value = 998
		"Megabot":
			_AdditionPackSpinBox.min_value = 1113
			_AdditionPackSpinBox.max_value = 1998
		"FantasyRPG":
			_AdditionPackSpinBox.min_value = 2001
			_AdditionPackSpinBox.max_value = 2998
		"CatJob":
			_AdditionPackSpinBox.min_value = 3040
			_AdditionPackSpinBox.max_value = 3998


func ImagesSelected(paths: PackedStringArray) -> void:
	_filePaths = paths
	_ExistingCardCreator.show()
	


func NewCardPressed() -> void:
	_PopWindow.hide()
	_NewCardCreator.visible = true


func UseImagePressed() -> void:
	_PopWindow.hide()
	_FilePicker.popup_centered()


func SetupBaseOptions() -> void:
	_PackOptionButton.select(0)
	_ElementIndexOptionButton.select(0)
	_RarityOptionButton.select(0)
	_RolesOptionButton.select(0)
	_Skills.sort()
	for skill:String in _Skills:
		_SkillsOptionButton.add_item(skill)
	_SkillsOptionButton.select(0)
	PackSelected(0)
	PackAdditionSelected(0)
	CountingSelected(0)


func PackSelected(idx:int) -> void:
	var option: String = _PackOptionButton.get_item_text(idx)
	match option:
		"Tetramon":
			_CardIDSpinBox.min_value = 122
			_CardIDSpinBox.max_value = 998
		"Megabot":
			_CardIDSpinBox.min_value = 1113
			_CardIDSpinBox.max_value = 1998
		"FantasyRPG":
			_CardIDSpinBox.min_value = 2001
			_CardIDSpinBox.max_value = 2998
		"CatJob":
			_CardIDSpinBox.min_value = 3040
			_CardIDSpinBox.max_value = 3998


func CheckField(text: String) -> void:
	_GenerateButton.disabled = true if text.is_empty() else false


func GenerateData() -> void:
	print("Generating...")
	if !_CardNameTextLine.text.is_empty():
		var cardName:String = _CardNameTextLine.text
		var _ID:int = _CardIDSpinBox.value as int
		var evolutions: PackedStringArray = [_PreviousEvolutionLine.text, _NextEvolutionLine.text]
		var element:String = _ElementIndexOptionButton.get_item_text(_ElementIndexOptionButton.get_selected_id())
		var rare:String = _RarityOptionButton.get_item_text(_RarityOptionButton.get_selected_id())
		var skill:String = _SkillsOptionButton.get_item_text(_SkillsOptionButton.get_selected_id())
		var role:String = _RolesOptionButton.get_item_text(_RolesOptionButton.get_selected_id())
		CreateData(
			str(_ID) + cardName,
			_ID,
			evolutions,
			element,
			rare,
			skill,
			role,
			false)
	
	var destDir:String = _gamePath.path_join("BepInEx\\patchers\\TCGShopNewCardsModPreloader\\MonsterImages\\")
	var newName:String
	var destPath:String
	var dir:DirAccess = DirAccess.open("user://")
	var _err: Error = dir.make_dir_recursive(destDir)
	newName = "%s%s.png" %[int(_CardIDSpinBox.value), _CardNameTextLine.text]
	destPath = destDir + newName
	_err = dir.copy(_CardImageSelectLine.text, destPath)
	print("Done")


func CreateData(MonsterName:String,
id:int,
evos: PackedStringArray = ["None", "None"],
element:String = "Fire",
rarity:String = "Common",
skill:String ="AcidBlast",
role:String ="None",
randvalues:bool = false) -> void:
	_FeedbackLabel.show()
	_FeedbackLabel.text = "[font_size=40][color=White][outline_color=black][outline_size=5]Creating..."
	_FeedbackLabel.self_modulate = "ffffffff"
	await get_tree().create_timer(1).timeout
	
	var dir:DirAccess = DirAccess.open("user://")
	var configdir:String = _gamePath.path_join("BepInEx\\patchers\\TCGShopNewCardsModPreloader\\MonsterConfigs\\")
	var _err: Error = dir.make_dir_recursive(configdir)

	var temp: TemplateDataClass = TemplateDataClass.new()
	var Data:Dictionary
	Data[MonsterName] = temp.TemplateData
	Data[MonsterName]["Name"] = GetNameWithoutId(MonsterName.get_basename())

	Data[MonsterName]["Monster Type"] = MonsterName
	Data[MonsterName]["Monster Type ID"] = id
	
	Data[MonsterName]["Artist Name"] = (
		"" if _ArtistNameTextLine.text.is_empty()
		else _ArtistNameTextLine.text)
	
	Data[MonsterName]["Description"] = (
		"" if _CardDescriptionTextLine.text.is_empty()
		else _CardDescriptionTextLine.text)
	
	Data[MonsterName]["Element Index"] = element
	Data[MonsterName]["Rarity"] = rarity
	Data[MonsterName]["Roles"] = role
	Data[MonsterName]["Skills"] = skill

	Data[MonsterName]["Previous Evolution"] = evos[0]
	Data[MonsterName]["Next Evolution"] = evos[1]
	Data[MonsterName]["HP"] = _HPSpinBox.value if !randvalues else randf_range(0, 30)
	Data[MonsterName]["HP Level Add"] = _HPLevelAddSpinBox.value
	Data[MonsterName]["Magic"] = _MagicSpinBox.value if !randvalues else randf_range(0, 30)
	Data[MonsterName]["Magic Level Add"] = _MagicLevelAddSpinBox.value
	Data[MonsterName]["Speed"] = _SpeedSpinBox.value if !randvalues else randf_range(0, 30)
	Data[MonsterName]["Speed Level Add"] = _SpeedLevelUpSpinBox.value
	Data[MonsterName]["Sprit"] = _SpritSpinBox.value if !randvalues else randf_range(0, 30)
	Data[MonsterName]["Sprit Level Add"] = _SpritLevelUpSpinBox.value
	Data[MonsterName]["Strength"] = _StrengthSpinBox.value if !randvalues else randf_range(0, 30)
	Data[MonsterName]["Strength Level Add"] = _StrengthLevelUpSpinBox.value
	Data[MonsterName]["Vitality"] = _VitalitySpinBox.value if !randvalues else randf_range(0, 30)
	Data[MonsterName]["Vitality Level Add"] = _VitalityLevelUpSpinBox.value
	
	var eCode:int = ToolHelper.saveConfig(Data, configdir + "%s.ini" %[MonsterName])
	if eCode == 0:
		_FeedbackLabel.show()
		_FeedbackLabel.text = _successText
		_FeedbackLabel.self_modulate = "ffffffff"
		await get_tree().create_timer(3).timeout
		var t:Tween = get_tree().create_tween()
		var _pt: PropertyTweener = t.tween_property(_FeedbackLabel, "self_modulate", Color("ffffff00"), 1.0)
		await t.finished
		_FeedbackLabel.hide()
	else:
		_FeedbackLabel.show()
		_FeedbackLabel.text = _failedText
		_FeedbackLabel.self_modulate = "ffffffff"
		await get_tree().create_timer(3).timeout
		var t:Tween = get_tree().create_tween()
		var _pt: PropertyTweener = t.tween_property(_FeedbackLabel, "self_modulate", Color("ffffff00"), 1.0)
		await t.finished
		_FeedbackLabel.hide()

func GetNameWithoutId(input: String) -> String:
	for i:int in input.length():
		var character:String = input[i]
		if character < "0" or character > "9":
			return input.substr(i)
	return input


func remove_leading_numbers(text: String) -> String:
	var i:int = 0
	while (i < text.length() and
	(text[i].is_valid_int() or
	text[i] == ' ' or
	text[i] == '_' or
	text[i] == '-')):
		i += 1
	return text.substr(i)


func saveEncryptedGamePath(gamedir: String) -> void:
	var key: PackedByteArray = generateKey().sha256_buffer()
	var file: FileAccess = FileAccess.open_encrypted(_savePath, FileAccess.WRITE, key)
	if file:
		var _success: bool = file.store_string(gamedir)
		file.close()
	else:
		print("Failed to open encrypted file for writing: ", FileAccess.get_open_error())


func loadEncryptedGamePath() -> String:
	var key: PackedByteArray = generateKey().sha256_buffer()
	var result: String = ""
	
	if FileAccess.file_exists(_savePath):
		var file: FileAccess = FileAccess.open_encrypted(_savePath, FileAccess.READ, key)
		if file:
			result = file.get_as_text()
			file.close()
		else:
			print("Failed to open encrypted file for reading: ", FileAccess.get_open_error())
	else:
		print("Save file does not exist: ", _savePath)
		
	return result


func generateKey() -> String:
	var encoded_data:PackedInt32Array = [
		0x53A1, 0x75B2, 0x73C3, 0x69D4, 0x65E5,
		0x20F6,
		0x69A7, 0x73B8,
		0x20C9,
		0x74D0, 0x68E1, 0x65A2,
		0x20B3,
		0x68C4, 0x6FD5, 0x74E6, 0x74A7, 0x65B8, 0x73C9, 0x74D0,
		0x20E1,
		0x6DA2, 0x65B3, 0x6DC4, 0x62E5, 0x65A6, 0x72B7,
		0x20C8,
		0x6FD9, 0x66E0,
		0x20A1,
		0x6CB2, 0x65C3, 0x67D4, 0x69E5, 0x6FA6, 0x6EB7
	]
	
	var result:String = ""
	for value:int in encoded_data:
		result += char(value & 0xFF)
	
	return result

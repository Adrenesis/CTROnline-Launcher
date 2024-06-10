extends Control

var runButton = null
var saveButton = null
var saveAndRunButton = null
var usernameLineEdit = null
var fps30Button = null
var fps30CheckBox = null
var skipBiosButton = null
var skipDuckStationButton = null
var skipGameSettingsButton = null
var skipXDeltaButton = null
var skipBiosCheckBox = null
var skipDuckStationCheckBox = null
var skipGameSettingsCheckBox = null
var skipXDeltaCheckBox = null
var forceBiosButton = null
var forceBiosCheckBox = null
var forceDuckStationButton = null
var forceDuckStationCheckBox = null
var forceGameSettingsButton = null
var forceGameSettingsCheckBox = null
var forceXDeltaButton = null
var forceXDeltaCheckBox = null
var forceUpdateButton = null
var forceUpdateCheckBox = null

var biosLineEdit = null
var duckStationLineEdit = null
var gameSettingsLineEdit = null
var xDeltaLineEdit = null
var inputLineEdit = null
var outputLineEdit = null

var biosBrowse = null
var duckStationBrowse = null
var gameSettingsBrowse = null
var xDeltaBrowse = null
var inputBrowse = null
var outputBrowse = null

var biosRollback = null
var duckStationRollback = null
var gameSettingsRollback = null
var xDeltaRollback = null
var inputRollback = null
var outputRollback = null

var biosDefault = null
var duckStationDefault = null
var gameSettingsDefault = null
var xDeltaDefault = null
var inputDefault = null
var outputDefault = null

var fileDialog = null

var browsingBios = false
var browsingDuckStation = false
var browsingGameSettings = false
var browsingXDelta = false
var browsingInput = false
var browsingOutput = false

func _ready():
	runButton = get_node("%RunButton")
	saveButton = get_node("%SaveButton")
	saveAndRunButton = get_node("%SaveAndRunButton")
	usernameLineEdit = get_node("%UsernameLineEdit")
	fps30Button = get_node("%FPS30")
	fps30CheckBox = fps30Button.get_node("CheckBox")
	skipBiosButton = get_node("%SkipBios")
	skipBiosCheckBox = skipBiosButton.get_node("CheckBox")
	skipDuckStationButton = get_node("%SkipDuckStation")
	skipDuckStationCheckBox = skipDuckStationButton.get_node("CheckBox")
	skipGameSettingsButton = get_node("%SkipGameSettings")
	skipGameSettingsCheckBox = skipGameSettingsButton.get_node("CheckBox")
	skipXDeltaButton = get_node("%SkipXDelta")
	skipXDeltaCheckBox = skipXDeltaButton.get_node("CheckBox")
	forceBiosButton = get_node("%ForceBios")
	forceBiosCheckBox = forceBiosButton.get_node("CheckBox")
	forceDuckStationButton = get_node("%ForceDuckStation")
	forceDuckStationCheckBox = forceDuckStationButton.get_node("CheckBox")
	forceGameSettingsButton = get_node("%ForceGameSettings")
	forceGameSettingsCheckBox = forceGameSettingsButton.get_node("CheckBox")
	forceXDeltaButton = get_node("%ForceXDelta")
	forceXDeltaCheckBox = forceXDeltaButton.get_node("CheckBox")
	forceUpdateButton = get_node("%ForceUpdate")
	forceUpdateCheckBox = forceUpdateButton.get_node("CheckBox")
	
	forceBiosButton.connect("toggled", self, "force_bios_pressed")
	forceDuckStationButton.connect("toggled", self, "force_duckstation_pressed")
	forceGameSettingsButton.connect("toggled", self, "force_gamesettings_pressed")
	forceXDeltaButton.connect("toggled", self, "force_xdelta_pressed")
	runButton.connect("pressed", self, "run_button_pressed")
	saveButton.connect("pressed", self, "save_button_pressed")
	saveAndRunButton.connect("pressed", self, "save_and_run_pressed")
	
	biosLineEdit = get_node("%BiosLineEdit")
	duckStationLineEdit = get_node("%DuckStationLineEdit")
	gameSettingsLineEdit = get_node("%GameSettingsLineEdit")
	xDeltaLineEdit = get_node("%XDeltaLineEdit")
	inputLineEdit = get_node("%InputLineEdit")
	outputLineEdit = get_node("%OutputLineEdit")
	
	biosBrowse = get_node("%BiosBrowse")
	duckStationBrowse = get_node("%DuckStationBrowse")
	gameSettingsBrowse = get_node("%GameSettingsBrowse")
	xDeltaBrowse = get_node("%XDeltaBrowse")
	inputBrowse = get_node("%InputBrowse")
	outputBrowse = get_node("%OutputBrowse")
	
	biosRollback = get_node("%BiosRollback")
	duckStationRollback = get_node("%DuckStationRollback")
	gameSettingsRollback = get_node("%GameSettingsRollback")
	xDeltaRollback = get_node("%XDeltaRollback")
	inputRollback = get_node("%InputRollback")
	outputRollback = get_node("%OutputRollback")
	
	biosBrowse.connect("pressed", self, "browse_bios")
	duckStationBrowse.connect("pressed", self, "browse_duckstation")
	gameSettingsBrowse.connect("pressed", self, "browse_gamesettings")
	xDeltaBrowse.connect("pressed", self, "browse_xdelta")
	inputBrowse.connect("pressed", self, "browse_input")
	outputBrowse.connect("pressed", self, "browse_output")
	
	biosRollback.connect("pressed", self, "rollback_bios")
	duckStationRollback.connect("pressed", self, "rollback_duckstation")
	gameSettingsRollback.connect("pressed", self, "rollback_gamesettings")
	xDeltaRollback.connect("pressed", self, "rollback_xdelta")
	inputRollback.connect("pressed", self, "rollback_input")
	outputRollback.connect("pressed", self, "rollback_output")
	
	biosDefault = biosLineEdit.text
	duckStationDefault = duckStationLineEdit.text
	gameSettingsDefault = gameSettingsLineEdit.text
	xDeltaDefault = xDeltaLineEdit.text
	inputDefault = inputLineEdit.text
	outputDefault = outputLineEdit.text
	
	fileDialog = get_node("%FileDialog")
	fileDialog.access = FileDialog.ACCESS_FILESYSTEM
	fileDialog.connect("file_selected", self, "file_dialog_confirmed")
	fileDialog.connect("dir_selected", self, "file_dialog_confirmed")
	fileDialog.get_cancel().connect("pressed", self, "file_dialog_canceled")
	fileDialog.get_close_button().connect("pressed", self, "file_dialog_canceled")
	
	load_config()

func file_dialog_canceled():
	browsingBios = false
	browsingDuckStation = false
	browsingGameSettings = false
	browsingXDelta = false
	browsingInput = false
	browsingOutput = false

func file_dialog_confirmed(path):
	print(path)
	if browsingBios:
		biosLineEdit.text = path
		browsingBios = false
	if browsingDuckStation:
		duckStationLineEdit.text = path
		browsingDuckStation = false
	if browsingGameSettings:
		gameSettingsLineEdit.text = path
		browsingGameSettings = false
	if browsingXDelta:
		xDeltaLineEdit.text = path
		browsingXDelta = false
	if browsingInput:
		inputLineEdit.text = path
		browsingInput = false
	if browsingOutput:
		inputLineEdit.text = path
		browsingOutput = false


func browse_bios():
	fileDialog.mode = FileDialog.MODE_OPEN_FILE
	fileDialog.filters = ["*.bin"]
	var path = biosLineEdit.text.rsplit("/", true, 1)[0]
	if biosLineEdit.text.begins_with("."):
		path = (
			OS.get_executable_path().rsplit("/", true, 1)[0] + 
			biosLineEdit.text.substr(1).rsplit("/", true, 1)[0] + 
			"/"
		)
	fileDialog.current_dir = path
	browsingBios = true
	fileDialog.popup()

func rollback_bios():
	biosLineEdit.text = biosDefault


func browse_duckstation():
	fileDialog.mode = FileDialog.MODE_OPEN_DIR
	var path = duckStationLineEdit.text
	if duckStationLineEdit.text.begins_with("."):
		path = (
			OS.get_executable_path().rsplit("/", true, 1)[0] + 
			duckStationLineEdit.text.substr(1)
		)
		print(path)
	fileDialog.current_dir = path
	browsingDuckStation = true
	fileDialog.popup()

func rollback_duckstation():
	duckStationLineEdit.text = duckStationDefault


func browse_gamesettings():
	fileDialog.mode = FileDialog.MODE_OPEN_DIR
	var path = gameSettingsLineEdit.text
	if gameSettingsLineEdit.text.begins_with("."):
		path = (
			OS.get_executable_path().rsplit("/", true, 1)[0] + 
			gameSettingsLineEdit.text.substr(1)
		)
	fileDialog.current_dir = path
	browsingGameSettings = true
	fileDialog.popup()

func rollback_gamesettings():
	gameSettingsLineEdit.text = gameSettingsDefault


func browse_xdelta():
	fileDialog.mode = FileDialog.MODE_OPEN_DIR
	var path = xDeltaLineEdit.text
	if xDeltaLineEdit.text.begins_with("."):
		path = (
			OS.get_executable_path().rsplit("/", true, 1)[0] + 
			xDeltaLineEdit.text.substr(1)
		)
	fileDialog.current_dir = path
	browsingXDelta = true
	fileDialog.popup()

func rollback_xdelta():
	xDeltaLineEdit.text = xDeltaDefault


func browse_input():
	fileDialog.mode = FileDialog.MODE_OPEN_FILE
	fileDialog.filters = ["*.bin"]
	var path = inputLineEdit.text.rsplit("/", true, 1)[0]
	if inputLineEdit.text.begins_with("."):
		path = (
			OS.get_executable_path().rsplit("/", true, 1)[0] + 
			biosLineEdit.text.substr(1).rsplit("/", true, 1)[0] + 
			"/"
		)
	fileDialog.current_dir = path
	browsingInput = true
	fileDialog.popup()

func rollback_input():
	inputLineEdit.text = inputDefault


func browse_output():
	fileDialog.mode = FileDialog.MODE_OPEN_FILE
	fileDialog.filters = ["*.bin"]
	var path = outputLineEdit.text.rsplit("/", true, 1)[0]
	if outputLineEdit.text.begins_with("."):
		path = (
			OS.get_executable_path().rsplit("/", true, 1)[0] + 
			outputLineEdit.text.substr(1).rsplit("/", true, 1)[0] + 
			"/"
		)
	fileDialog.current_dir = path
	browsingOutput = true
	fileDialog.popup()

func rollback_output():
	outputLineEdit.text = outputDefault


func force_bios_pressed(pressed):
	skipBiosButton.disabled = pressed
	skipBiosCheckBox.disabled = pressed
	if pressed:
		skipBiosCheckBox.pressed = false

func force_duckstation_pressed(pressed):
	skipDuckStationButton.disabled = pressed
	skipDuckStationCheckBox.disabled = pressed
	if pressed:
		skipDuckStationCheckBox.pressed = false

func force_gamesettings_pressed(pressed):
	skipGameSettingsButton.disabled = pressed
	skipGameSettingsCheckBox.disabled = pressed
	if pressed:
		skipGameSettingsCheckBox.pressed = false

func force_xdelta_pressed(pressed):
	skipXDeltaButton.disabled = pressed
	skipXDeltaCheckBox.disabled = pressed
	if pressed:
		skipXDeltaCheckBox.pressed = false

func save_and_run_pressed():
	save_button_pressed()
	run_button_pressed()

func save_button_pressed():
	save_config()

func run_button_pressed():
	print(get_run_string())
	var output = []
	var args = get_run_string().split(" ")
	args.insert(0, "/c")
	OS.execute("cmd.exe", ["/c", ("echo " + usernameLineEdit.text + "> ./username.ini") ], false, output, true, true)
	OS.execute("cmd.exe", args, false, output, true, true)

func get_run_string():
	#TODO support Linux
	return get_win_run_string()

func get_win_run_string():
	var string = ".\\autoupdater.bat"
	string += " -f" if fps30Button.pressed else ""
	string += " -sb" if skipBiosButton.pressed else ""
	string += " -sd" if skipDuckStationButton.pressed else ""
	string += " -ss" if skipGameSettingsButton.pressed else ""
	string += " -sx" if skipXDeltaButton.pressed else ""
	string += " -fb" if forceBiosButton.pressed else ""
	string += " -fd" if forceDuckStationButton.pressed else ""
	string += " -fs" if forceGameSettingsButton.pressed else ""
	string += " -fx" if forceXDeltaButton.pressed else ""
	string += " -fu" if forceUpdateButton.pressed else ""
	string += " -i " + inputLineEdit.text.replace("/", "\\").replace(" ", "^ ")
	string += " -o " + outputLineEdit.text.replace("/", "\\").replace(" ", "^ ")
	string += " -b " + biosLineEdit.text.replace("/", "\\").replace(" ", "^ ")
	string += " -d " + duckStationLineEdit.text.replace("/", "\\").replace(" ", "^ ")
	string += " -s " + gameSettingsLineEdit.text.replace("/", "\\").replace(" ", "^ ")
	string += " -x " + xDeltaLineEdit.text.replace("/", "\\").replace(" ", "^ ")
	
	return string


func save_config():
	if not OS.has_feature("standalone") :
		print("can't save config in the editor")
		return
	var config = ConfigFile.new()

	# Enregistrer quelques valeurs.
	config.set_value("settings", "fps_30", String(fps30Button.pressed))
	config.set_value("settings", "skip_bios", String(skipBiosButton.pressed))
	config.set_value("settings", "skip_duckstation", String(skipDuckStationButton.pressed))
	config.set_value("settings", "skip_gamesettings", String(skipGameSettingsButton.pressed))
	config.set_value("settings", "skip_xdelta", String(skipXDeltaButton.pressed))
	config.set_value("settings", "force_bios", String(forceBiosButton.pressed))
	config.set_value("settings", "force_duckstation", String(forceDuckStationButton.pressed))
	config.set_value("settings", "force_gamesettings", String(forceGameSettingsButton.pressed))
	config.set_value("settings", "force_xdelta", String(forceXDeltaButton.pressed))
	config.set_value("settings", "force_update", String(forceUpdateButton.pressed))
	
	config.set_value("path", "bios_path", String(biosLineEdit.text))
	config.set_value("path", "duckstation_path", String(duckStationLineEdit.text))
	config.set_value("path", "gameettings_path", String(gameSettingsLineEdit.text))
	config.set_value("path", "xdelta_path", String(xDeltaLineEdit.text))
	config.set_value("path", "input_path", String(inputLineEdit.text))
	config.set_value("path", "output_path", String(outputLineEdit.text))
	
	config.set_value("settings", "username", String(usernameLineEdit.text))
	

	# L'enregistrer sur dans un fichier (en écrasant le fichier déjà existant s'il y en a un).
	print(OS.get_executable_path().rsplit("/", true, 1)[0] + "/" + "config.cfg")
	config.save(OS.get_executable_path().rsplit("/", true, 1)[0] + "/" + "config.cfg")

func get_config_bool(value : String):
	print(value)
	if value == "True":
		return true
	else:
		return false

func load_config():
	if not OS.has_feature("standalone") :
		print("can't load config in editor based execution")
		return
	var config = ConfigFile.new()

	# Charger depuis le fichier.
	var err = config.load(OS.get_executable_path().rsplit("/", true, 1)[0] + "/" + "config.cfg")
	
	if err == OK:

		fps30CheckBox.pressed = get_config_bool(config.get_value("settings", "fps_30", String(fps30CheckBox.pressed)))
		skipBiosCheckBox.pressed = get_config_bool(config.get_value("settings", "skip_bios", String(skipBiosCheckBox.pressed)))
		skipDuckStationCheckBox.pressed = get_config_bool(config.get_value("settings", "skip_duckstation", String(skipDuckStationCheckBox.pressed)))
		skipGameSettingsCheckBox.pressed = get_config_bool(config.get_value("settings", "skip_gamesettings", String(skipGameSettingsCheckBox.pressed)))
		skipXDeltaCheckBox.pressed = get_config_bool(config.get_value("settings", "skip_xdelta", String(skipXDeltaCheckBox.pressed)))
		forceBiosCheckBox.pressed = get_config_bool(config.get_value("settings", "force_bios", String(forceBiosCheckBox.pressed)))
		forceDuckStationCheckBox.pressed = get_config_bool(config.get_value("settings", "force_duckstation", String(forceDuckStationCheckBox.pressed)))
		forceGameSettingsCheckBox.pressed = get_config_bool(config.get_value("settings", "force_gamesettings", String(forceGameSettingsCheckBox.pressed)))
		forceXDeltaCheckBox.pressed = get_config_bool(config.get_value("settings", "force_xdelta", String(forceXDeltaCheckBox.pressed)))
		forceUpdateCheckBox.pressed = get_config_bool(config.get_value("settings", "force_update", String(forceUpdateCheckBox.pressed)))
		
		biosLineEdit.text = config.get_value("path", "bios_path", String(biosLineEdit.text))
		duckStationLineEdit.text = config.get_value("path", "duckstation_path", String(duckStationLineEdit.text))
		gameSettingsLineEdit.text = config.get_value("path", "gameettings_path", String(gameSettingsLineEdit.text))
		xDeltaLineEdit.text = config.get_value("path", "xdelta_path", String(xDeltaLineEdit.text))
		inputLineEdit.text = config.get_value("path", "input_path", String(inputLineEdit.text))
		outputLineEdit.text = config.get_value("path", "output_path", String(outputLineEdit.text))
		
		usernameLineEdit.text = config.get_value("settings", "username", String(usernameLineEdit.text))
	else:
		print("no config to load")

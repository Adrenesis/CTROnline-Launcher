extends Control

const RunWithGodot = preload("res://RunWithGodot.gd")


var default_min_size_default_font 
var default_min_size_run_font 
var min_size_default_font 
var min_size_run_font
var run_button_parent

var is_running = false
var is_canceled = false

var console = null

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

var keepRunningButton = null
var keepRunningCheckBox = null

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

var xDeltaURLLineEdit = null
var duckStationURLLineEdit = null
var gameSettingsURLLineEdit = null
var clientURLLineEdit = null
var patchURLLineEdit = null

var xDeltaURLRollback = null
var duckStationURLRollback = null
var gameSettingsURLRollback = null
var clientURLRollback = null
var patchURLRollback = null
	

var fileDialog = null
var deleteConfirmationDialog = null

var browsingBios = false
var browsingDuckStation = false
var browsingGameSettings = false
var browsingXDelta = false
var browsingInput = false
var browsingOutput = false


var xDeltaHTTPRequest = null
var duckStationHTTPRequest = null
var gameSettingsHTTPRequest = null
var clientHTTPRequest = null
var patchHTTPRequest = null

func _ready():
	console = get_node("%Console")
	
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
	
	keepRunningButton = get_node("%KeepRunning")
	keepRunningCheckBox = keepRunningButton.get_node("CheckBox")
	
	xDeltaHTTPRequest = get_node("%HTTPRequestXDelta")
	duckStationHTTPRequest = get_node("%HTTPRequestDuckStation")
	gameSettingsHTTPRequest = get_node("%HTTPRequestGameSettings")
	clientHTTPRequest = get_node("%HTTPRequestClient")
	patchHTTPRequest = get_node("%HTTPRequestPatch")
	
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
	
	xDeltaURLRollback = get_node("%XDeltaURLRollback")
	duckStationURLRollback = get_node("%DuckStationURLRollback")
	gameSettingsURLRollback = get_node("%GameSettingsURLRollback")
	clientURLRollback = get_node("%ClientURLRollback")
	patchURLRollback = get_node("%PatchURLRollback")
	
	xDeltaURLLineEdit = get_node("%XDeltaURLLineEdit")
	duckStationURLLineEdit = get_node("%DuckStationURLLineEdit")
	gameSettingsURLLineEdit = get_node("%GameSettingsURLLineEdit")
	clientURLLineEdit = get_node("%ClientURLLineEdit")
	patchURLLineEdit = get_node("%PatchURLLineEdit")
		
	usernameLineEdit.connect("text_changed", self, "username_changed")
	
	fps30CheckBox.connect("pressed", self, "fps_30_pressed")
	
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
	
	fileDialog = get_node("%FileDialog")
	fileDialog.popup_exclusive = true
	fileDialog.access = FileDialog.ACCESS_FILESYSTEM
	fileDialog.connect("file_selected", self, "file_dialog_confirmed")
	fileDialog.connect("dir_selected", self, "file_dialog_confirmed")
	fileDialog.get_cancel().connect("pressed", self, "file_dialog_canceled")
	fileDialog.get_close_button().connect("pressed", self, "file_dialog_canceled")
	
	deleteConfirmationDialog = get_node("%DeleteConfirmationDialog")
	deleteConfirmationDialog.popup_exclusive = true
	
	run_button_parent = runButton.get_parent()
	
	min_size_default_font = theme.default_font.size
	min_size_run_font = run_button_parent.theme.default_font.size
	
	default_min_size_default_font = theme.default_font.size
	default_min_size_run_font = run_button_parent.theme.default_font.size
	
	get_tree().root.connect("size_changed", self, "on_window_resize")
	
	load_config()

func on_window_resize():
	min_size_default_font = default_min_size_default_font
	min_size_run_font = default_min_size_run_font
	if OS.get_window_size().x < 550:
		min_size_default_font = min(default_min_size_default_font * pow((OS.get_window_size().x / 550) * 1.0, 2.0), min_size_default_font)
	if OS.get_window_size().y < 525:
		min_size_default_font = min(default_min_size_default_font * pow((OS.get_window_size().y / 525) * 1.0, 4.0), min_size_default_font)
	
	if OS.get_window_size().x < 550:
		min_size_run_font = min(default_min_size_run_font * pow((OS.get_window_size().x / 550) * 1.0, 1.5), min_size_run_font)
	if OS.get_window_size().y < 525:
		min_size_run_font = min(default_min_size_run_font * pow((OS.get_window_size().y / 525) * 1.0, 5.0), min_size_run_font)
	theme.default_font.size = min_size_default_font
	run_button_parent.theme.default_font.size = min_size_run_font
	run_button_parent.theme.default_font.extra_spacing_bottom = -16.0 * (min_size_run_font/default_min_size_run_font)
	saveAndRunButton.get_node("Label").margin_top = -10.0 * (min_size_run_font/default_min_size_run_font)
	saveButton.get_node("Label").margin_top = -10.0 * (min_size_run_font/default_min_size_run_font)
	runButton.get_node("Label").margin_top = -10.0 * (min_size_run_font/default_min_size_run_font)
	theme.set("CheckBox/constants/check_vadjust", (9.0 * (min_size_run_font/default_min_size_run_font) - 9.0))


func username_changed(username : String):
#	print([username.length()])
	if username.length() == 0:
		saveAndRunButton.set_disabled(true)
		runButton.set_disabled(true)
	else:
		if not is_running:
			saveAndRunButton.set_disabled(false)
			runButton.set_disabled(false)

func fps_30_pressed():
	if fps30CheckBox.pressed:
		outputLineEdit.text = outputLineEdit.text.replace("60", "30")
		patchURLLineEdit.text = patchURLLineEdit.text.replace("60", "30")
	else:
		outputLineEdit.text = outputLineEdit.text.replace("30", "60")
		patchURLLineEdit.text = patchURLLineEdit.text.replace("30", "60")

func file_dialog_canceled():
	browsingBios = false
	browsingDuckStation = false
	browsingGameSettings = false
	browsingXDelta = false
	browsingInput = false
	browsingOutput = false

func file_dialog_confirmed(path):
#	print(path)
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
		outputLineEdit.text = path
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


func browse_duckstation():
	fileDialog.mode = FileDialog.MODE_OPEN_DIR
	var path = duckStationLineEdit.text
	if duckStationLineEdit.text.begins_with("."):
		path = (
			OS.get_executable_path().rsplit("/", true, 1)[0] + 
			duckStationLineEdit.text.substr(1)
		)
#		print(path)
	fileDialog.current_dir = path
	browsingDuckStation = true
	fileDialog.popup()


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


func force_bios_pressed(pressed):
	skipBiosButton.set_disabled(pressed)
	skipBiosCheckBox.set_disabled(pressed)
	if pressed:
		skipBiosCheckBox.pressed = false

func force_duckstation_pressed(pressed):
	skipDuckStationButton.set_disabled(pressed)
	skipDuckStationCheckBox.set_disabled(pressed)
	if pressed:
		skipDuckStationCheckBox.pressed = false

func force_gamesettings_pressed(pressed):
	skipGameSettingsButton.set_disabled(pressed)
	skipGameSettingsCheckBox.set_disabled(pressed)
	if pressed:
		skipGameSettingsCheckBox.pressed = false

func force_xdelta_pressed(pressed):
	skipXDeltaButton.set_disabled(pressed)
	skipXDeltaCheckBox.set_disabled(pressed)
	if pressed:
		skipXDeltaCheckBox.pressed = false

func save_and_run_pressed():
	save_button_pressed()
	run_button_pressed()

func save_button_pressed():
	save_config()

func run_button_pressed():
	is_running = true
	saveAndRunButton.set_disabled(true)
	runButton.set_disabled(true)
#	print(get_run_string())
	var output = []
	var args = get_run_string().split(" ")
	args.insert(0, "-Command")
	var rwg := RunWithGodot.new()
	add_child(rwg)
	yield(rwg.custom_init(self), "completed")
	rwg.queue_free()
#	OS.execute("cmd.exe", ["/c", ("echo " + usernameLineEdit.text + "> ./username.ini") ], false, output, true, true)
#	OS.execute("powershell", args, false, output, true, true)
	saveAndRunButton.set_disabled(false)
	runButton.set_disabled(false)
	if not keepRunningButton.pressed and not is_canceled:
		get_tree().quit()
	is_running = false
	is_canceled = false

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
	string += " -i '" + inputLineEdit.text.replace("/", "\\") + "'"
	string += " -o '" + outputLineEdit.text.replace("/", "\\") + "'"
	string += " -b '" + biosLineEdit.text.replace("/", "\\") + "'"
	string += " -d '" + duckStationLineEdit.text.replace("/", "\\") + "'"
	string += " -s '" + gameSettingsLineEdit.text.replace("/", "\\") + "'"
	string += " -x '" + xDeltaLineEdit.text.replace("/", "\\") + "'"
	
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
	config.set_value("path", "gamesettings_path", String(gameSettingsLineEdit.text))
	config.set_value("path", "xdelta_path", String(xDeltaLineEdit.text))
	config.set_value("path", "input_path", String(inputLineEdit.text))
	config.set_value("path", "output_path", String(outputLineEdit.text))
	
	config.set_value("url", "xdelta_url", String(xDeltaURLLineEdit.text))
	config.set_value("url", "duckstation_url", String(duckStationURLLineEdit.text))
	config.set_value("url", "gamesettings_url", String(gameSettingsURLLineEdit.text))
	config.set_value("url", "client_url", String(clientURLLineEdit.text))
	config.set_value("url", "patch_url", String(patchURLLineEdit.text))
	
	config.set_value("settings", "username", String(usernameLineEdit.text))
	

	# L'enregistrer sur dans un fichier (en écrasant le fichier déjà existant s'il y en a un).
	print(OS.get_executable_path().rsplit("/", true, 1)[0] + "/" + "config.cfg")
	config.save(OS.get_executable_path().rsplit("/", true, 1)[0] + "/" + "config.cfg")

func get_config_bool(value : String):
#	print(value)
	if value == "True":
		return true
	else:
		return false

func load_config():
	if not OS.has_feature("standalone") :
#		print(biosLineEdit.text)
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
		gameSettingsLineEdit.text = config.get_value("path", "gamesettings_path", String(gameSettingsLineEdit.text))
		xDeltaLineEdit.text = config.get_value("path", "xdelta_path", String(xDeltaLineEdit.text))
		inputLineEdit.text = config.get_value("path", "input_path", String(inputLineEdit.text))
		outputLineEdit.text = config.get_value("path", "output_path", String(outputLineEdit.text))
		
#		print(xDeltaURLLineEdit.text)
		xDeltaURLLineEdit.text = config.get_value("url", "xdelta_url", String(xDeltaURLLineEdit.text))
		duckStationURLLineEdit.text = config.get_value("url", "duckstation_url", String(duckStationURLLineEdit.text))
		gameSettingsURLLineEdit.text = config.get_value("url", "gamesettings_url", String(gameSettingsURLLineEdit.text))
		clientURLLineEdit.text = config.get_value("url", "client_url", String(clientURLLineEdit.text))
		patchURLLineEdit.text = config.get_value("url", "patch_url", String(patchURLLineEdit.text))
		
		
		usernameLineEdit.text = config.get_value("settings", "username", String(usernameLineEdit.text))
		username_changed(usernameLineEdit.text)
	else:
		print("no config to load")
		if OS.get_name() == "Windows":
			biosLineEdit.text = biosRollback.windowsDefault
			duckStationLineEdit.text = duckStationRollback.windowsDefault
			gameSettingsLineEdit.text = gameSettingsRollback.windowsDefault
			xDeltaLineEdit.text = xDeltaRollback.windowsDefault
			inputLineEdit.text = inputRollback.windowsDefault
			outputLineEdit.text = outputRollback.windowsDefault
			
			xDeltaURLLineEdit.text = xDeltaURLRollback.windowsDefault
			duckStationURLLineEdit.text = duckStationURLRollback.windowsDefault
			gameSettingsURLLineEdit.text = gameSettingsURLRollback.windowsDefault
			clientURLLineEdit.text = clientURLRollback.windowsDefault
			patchURLLineEdit.text = patchURLRollback.windowsDefault
		elif OS.get_name() == "X11":
			biosLineEdit.text = biosRollback.linuxDefault
			duckStationLineEdit.text = duckStationRollback.linuxDefault
			gameSettingsLineEdit.text = gameSettingsRollback.linuxDefault
			xDeltaLineEdit.text = xDeltaRollback.linuxDefault
			inputLineEdit.text = inputRollback.linuxDefault
			outputLineEdit.text = outputRollback.linuxDefault
			
			xDeltaURLLineEdit.text = xDeltaURLRollback.linuxDefault
			duckStationURLLineEdit.text = duckStationURLRollback.linuxDefault
			gameSettingsURLLineEdit.text = gameSettingsURLRollback.linuxDefault
			clientURLLineEdit.text = clientURLRollback.linuxDefault
			patchURLLineEdit.text = patchURLRollback.linuxDefault
			
		else:
			OS.alert("Sorry this OS is not implemented yet =(")


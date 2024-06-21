tool
extends EditorPlugin

var button

func _enter_tree():
	button  = Button.new()
	button.text = "Run Exported"
	var input_event := InputEventKey.new()
	input_event.scancode = KEY_F5
	input_event.pressed = true
	input_event.control = true
	var shortcut := ShortCut.new()
	shortcut.shortcut = input_event
	button.shortcut = shortcut
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, button)
	button.connect("pressed", self, "run")
	pass


func _exit_tree():
	button.disconnect("pressed", self, "run")
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, button)
	button.queue_free()
	
	pass


func write_file(content : String, path : String):
	var file := File.new()
	var err = file.open(path, File.WRITE) # Ouvert en écriture seulement
	if err != OK:
		print("ERROR: writing failed")
	else:
		file.store_string(content)
		file.close()

func run():
	var exe_path = OS.get_executable_path().replace("/", "\\")
	var project_path = ProjectSettings.globalize_path("res://export_preset.cfg").replace("/", "\\")
	var output = ProjectSettings.globalize_path("res://bin/CTROnline-Launcher.exe").replace("/", "\\")
	var o = []
	OS.execute("cmd", [ "/c", '"' + exe_path + '" --no-window --path ".\\project.godot" --export "Windows Desktop" "' + output + '"'], true, o)
	write_file("cd .\\bin & .\\CTROnline-Launcher.exe --remote-debug 127.0.0.1:6007", "./bin/execute.bat")
	OS.execute("powershell", [ "-Command", "invoke-expression 'cmd /c start cmd /c .\\bin\\execute.bat'"], false)


tool
extends Node



enum ERROR {
	OK,
	FAILED,
	ERR_UNAVAILABLE,
	ERR_UNCONFIGURED,
	ERR_UNAUTHORIZED,
	ERR_PARAMETER_RANGE_ERROR,
	ERR_OUT_OF_MEMORY,
	ERR_FILE_NOT_FOUND,
	ERR_FILE_BAD_DRIVE,
	ERR_FILE_BAD_PATH,
	ERR_FILE_NO_PERMISSION,
	ERR_FILE_ALREADY_IN_USE,
	ERR_FILE_CANT_OPEN,
	ERR_FILE_CANT_WRITE,
	ERR_FILE_CANT_READ
	ERR_FILE_UNRECOGNIZED,
	ERR_FILE_CORRUPT,
	ERR_FILE_MISSING_DEPENDENCIES,
	ERR_FILE_EOF,
	ERR_CANT_OPEN,
	ERR_CANT_CREATE,
	ERR_QUERY_FAILED,
	ERR_ALREADY_IN_USE,
	ERR_LOCKED,
	ERR_TIMEOUT,
	ERR_CANT_CONNECT,
	ERR_CANT_RESOLVE,
	ERR_CONNECTION_ERROR,
	ERR_CANT_ACQUIRE_RESOURCE,
	ERR_CANT_FORK,
	ERR_INVALID_DATA,
	ERR_INVALID_PARAMETER,
	ERR_ALREADY_EXISTS,
	ERR_DOES_NOT_EXIST,
	ERR_DATABASE_CANT_READ,
	ERR_DATABASE_CANT_WRITE,
	ERR_COMPILATION_FAILED,
	ERR_METHOD_NOT_FOUND,
	ERR_LINK_FAILED,
	ERR_SCRIPT_FAILED,
	ERR_CYCLIC_LINK,
	ERR_INVALID_DECLARATION,
	ERR_DUPLICATE_SYMBOL,
	ERR_PARSE_ERROR,
	ERR_BUSY,
	ERR_SKIP,
	ERR_HELP,
	ERR_BUG,
	ERR_PRINTER_ON_FIRE
}

signal delete_confirm_answered

var path_about_to_be_deleted
var controller

func get_absolute_path(path : String, trailing_slash_check = false) -> String:
	var result = path
	if path.begins_with("./"):
		result = path.replace("./", "/")
		result = OS.get_executable_path().rsplit("/", false, 1)[0] + result
		result = result.replace('\\', '/').replace("\n", "").replace("\r", "")
	if (path.find("%") != -1) and (OS.get_name() == "Windows"):
		var output := []
		OS.execute("cmd", ["/c", "echo " + path], true, output)
		result = output[0].replace("\\", "/").replace("\n", "").replace("\r", "")
	if trailing_slash_check:
		if not result.ends_with("/"):
			result += "/"
	return result

func file_exists(path : String) -> bool:
	var output = []
	OS.execute("powershell", [ "-Command", "cmd /c if exist '" + get_absolute_path(path) + "' echo true"], true, output)
	return output[0]


func read_file(path):
	return os_read_file(path)

func write_file(content : String, path : String):
	var file := File.new()
#	print(path)
	var err = file.open(get_absolute_path(path), File.WRITE)
	if err != OK:
		print("ERROR: writing failed with error " + ERROR.keys()[err])
	else:
		file.store_string(content)
		file.close()


func delete_file(path : String) -> bool:
	var directory := Directory.new()
	return (OK == directory.remove(get_absolute_path(path)))

func copy_file(source : String, destination : String) -> bool:
	var directory := Directory.new()
#	print([get_absolute_path(source)])
#	print([get_absolute_path(destination)])
	return (OK == directory.copy(get_absolute_path(source), get_absolute_path(destination)))



func are_files_different(p_path0, p_path1) -> bool:
	var file = File.new()
	var path0 = get_absolute_path(p_path0)
	var path1 = get_absolute_path(p_path1)
#	print([path0])
#	print(file.get_sha256(path0))
#	print(file.get_sha256("F:/Godot Project 3.5/CTROnline-Launcher/bin/Client.exe"))
#	print([path1])
#	print(file.get_sha256(path1))
#	print(file.get_sha256(path0).casecmp_to(file.get_sha256(path1)) != 0 )
	return (file.get_sha256(path0).casecmp_to(file.get_sha256(path1)) != 0)

func directory_exists(path : String) -> bool:
	var output = []
	OS.execute("powershell", [ "-Command", "cmd /c if exist '" + get_absolute_path(path) + "' echo true"], true, output)
	return output[0]

func make_directory(path : String) -> bool:
	var directory = Directory.new()
	return (OK == directory.make_dir(get_absolute_path(path)))

func delete_directory(p_path : String):
	var path = get_absolute_path(p_path)
	var path_check = path.to_lower()
	if (
		(path_check.find("xdelta") != -1) or
		(path_check.find("duckstation") != -1) or
		(path_check.find("temp") != -1)
	):
		os_delete_directory(path)
		yield(get_tree(), "idle_frame")
	else:
		path_about_to_be_deleted = path 
		controller.deleteConfirmationDialog.get_node("Label2").text = (
			"/!\\ YOU ARE ABOUT TO DELETE THE DIRECTORY /!\\\n\"" +
			path +
			"\"\nDO YOU WISH TO CONTINUE?")
		controller.deleteConfirmationDialog.popup()
		yield(self, "delete_confirm_answered")
			

func delete_confirmed():
	os_delete_directory(path_about_to_be_deleted)
#	print(path_about_to_be_deleted + " deleted")
	emit_signal("delete_confirm_answered")

func delete_canceled():
	controller.is_canceled = true
	emit_signal("delete_confirm_answered")

func os_install_update_and_relaunch():
	if OS.get_name() == "Windows":
		Utils.write_file('@echo off > NUL\n' +
			'start "" "cmd /c echo Launching new version & cd .\\temp > NUL & ping 127.0.0.1 -n 3 > nul & echo F|xcopy .\\CTROnline-Launcher.exe ..\\CTROnline-Launcher.exe /Y > nul & cd .. & start .\\' + os_get_original_exe_filename() + ' -t"', ".\\temp\\rebooter.bat")
		OS.execute("powershell", ["-Command", ".\\temp\\rebooter.bat"],false)
	elif OS.get_name() == "X11":
		return "CTROnline-Launcher-x11-latest.zip"
	else:
		OS.alert(OS.get_name() + " OS is not supported, sorry =(")
	

func os_get_original_exe_filename():
	if OS.get_name() == "Windows":
		return OS.get_executable_path().rsplit("/", true, 1)[1]
	elif OS.get_name() == "X11":
		return "CTROnline-Launcher"
	else:
		OS.alert(OS.get_name() + " OS is not supported, sorry =(")

func os_get_update_exe_filename():
	if OS.get_name() == "Windows":
		return "CTROnline-Launcher.exe"
	elif OS.get_name() == "X11":
		return "CTROnline-Launcher"
	else:
		OS.alert(OS.get_name() + " OS is not supported, sorry =(")

func os_get_update_zip_filename():
	if OS.get_name() == "Windows":
		return "CTROnline-Launcher-win64-latest.zip"
	elif OS.get_name() == "X11":
		return "CTROnline-Launcher-x11-latest.zip"
	else:
		OS.alert(OS.get_name() + " OS is not supported, sorry =(")


func os_get_update_link():
	if OS.get_name() == "Windows":
		return "https://github.com/Adrenesis/CTROnline-Launcher/releases/latest/download/CTROnline-Launcher-win64-latest.zip"
	elif OS.get_name() == "X11":
		return "https://github.com/Adrenesis/CTROnline-Launcher/releases/latest/download/CTROnline-Launcher-x11-latest.zip"
	else:
		OS.alert(OS.get_name() + " OS is not supported, sorry =(")

func os_read_file(path:String) -> String:
	if OS.get_name() == "Windows":
		var output = []
		OS.execute("powershell", [ "-Command", 'Get-Content ' + path ], true, output)
		#print(output)
		return output[0]
	elif OS.get_name() == "X11":
		return ""
		pass
	else:
		OS.alert(OS.get_name() + " OS is not supported, sorry =(")
		return ""

func os_extract_archive(input : String, output : String):
	controller.proxy_print("Extracting " + input + " to " + output)
	yield(get_tree(), "idle_frame")
	if OS.get_name() == "Windows":
		OS.execute("powershell", [ "-Command", ("Expand-Archive '" + input + "' -DestinationPath '" + output + "'") ])
	elif OS.get_name() == "X11":
		pass
	else:
		OS.alert(OS.get_name() + " OS is not supported, sorry =(")

func get_os_xdelta_command(fps30 : = false) -> String:
	if OS.get_name() == "Windows":
		var result = '"' + get_absolute_path(controller.xDeltaLineEdit.text) + 'xdelta3-3.0.9-x64.exe"'
		if not fps30:
			result += ' -f -d -s "' + controller.inputLineEdit.text + '" "./ctr-u_Online60.xdelta" "' + controller.outputLineEdit.text + '"'
		else:
			result += ' -f -d -s "' + controller.inputLineEdit.text + '" "./ctr-u_Online30.xdelta" "' + controller.outputLineEdit.text + '"'
		return result.replace("/", "\\")
	elif OS.get_name() == "X11":
		return "" #TODO linux
	else:
		OS.alert(OS.get_name() + " OS is not supported, sorry =(")
		return ""

func os_start_duckstation():
	if OS.get_name() == "Windows":
		OS.execute("powershell", [
			"-Command", 
			"Start-Process '" + 
			get_absolute_path(controller.duckStationLineEdit.text) +
			"duckstation-qt-x64-ReleaseLTCG.exe' -ArgumentList '" +
			get_absolute_path( controller.outputLineEdit.text).replace("/", "\\") + "'"], false)
	elif OS.get_name() == "X11":
		return "" #TODO linux
	else:
		OS.alert(OS.get_name() + " OS is not supported, sorry =(")
		return ""
#	os_shell_execute("'" + controller.duckStationLineEdit.text + "duckstation-qt-x64-ReleaseLTCG.exe' '" + controller.outputLineEdit.text + "'")

func os_start_client():
	if OS.get_name() == "Windows":
	#	cmd /c start powershell -NoExit -Command { echo Adrenesis|./Client.exe }
		var filtered_username 
	#	= controller.usernameLineEdit.text.replace("&", "^^^^^^&")
	#	filtered_username = controller.usernameLineEdit.text.replace("*", "^^^*")
	#	filtered_username = controller.usernameLineEdit.text.replace("[", "^^^[")
	#	filtered_username = controller.usernameLineEdit.text.replace("@", "^^^@")
	#	filtered_username = controller.usernameLineEdit.text.replace("^", "^^^^")
		filtered_username = controller.usernameLineEdit.text.replace(" ", "")
		write_file(filtered_username, "./username.ini")
		OS.execute("powershell", [ "-Command", "invoke-expression 'cmd /c start cmd /c .\\Client.exe ^< .\\username.ini'"], false)
	elif OS.get_name() == "X11":
		return "" #TODO linux
	else:
		OS.alert(OS.get_name() + " OS is not supported, sorry =(")
		return ""


func os_delete_directory(path : String):
	if OS.get_name() == "Windows":
#		print("deleting " + path)
		OS.execute("cmd", [ "/c", "rmdir /Q /S \"" + path.replace("/", "\\") + "\""])
	elif OS.get_name() == "X11":
		return "" #TODO linux
	else:
		OS.alert(OS.get_name() + " OS is not supported, sorry =(")
		return ""

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

func get_absolute_path(path : String) -> String:
	if path.begins_with("./"):
		var result = path.replace("./", "/")
		result = OS.get_executable_path().rsplit("/", false, 1)[0] + result
		return result.replace('\\', '/').replace("\n", "").replace("\r", "")
	if (path.find("%") != -1) and (OS.get_name() == "Windows"):
		var output := []
		OS.execute("cmd", ["/c", "echo " + path], true, output)
		return output[0].replace("\\", "/").replace("\n", "").replace("\r", "")
	return path

func file_exists(path : String) -> bool:
	var output = []
	OS.execute("powershell", [ "-Command", "cmd /c if exist '" + get_absolute_path(path) + "' echo true"], true, output)
	return output[0]

func write_file(content : String, path : String):
	var file := File.new()
	var err = file.open(path, File.WRITE) # Ouvert en écriture seulement
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
	print(path_about_to_be_deleted + " deleted")
	emit_signal("delete_confirm_answered")

func delete_canceled():
	controller.is_canceled = true
	emit_signal("delete_confirm_answered")


func os_extract_archive(input : String, output : String):
	yield(get_tree(), "idle_frame")
	if OS.get_name() == "Windows":
		OS.execute("powershell", [ "-Command", ("Expand-Archive '" + input + "' -DestinationPath '" + output + "'") ])
	elif OS.get_name() == "X11":
		pass
	else:
		OS.alert(OS.get_name() + " OS is not supported, sorry =(")

func get_os_xdelta_command() -> String:
	if OS.get_name() == "Windows":
		return controller.xDeltaLineEdit.text + "xdelta3-3.0.9-x64.exe "
	elif OS.get_name() == "X11":
		return "" #TODO linux
	else:
		OS.alert(OS.get_name() + " OS is not supported, sorry =(")
		return ""

func os_start_duckstation():
	OS.execute("powershell", [
		"-Command", 
		"Start-Process '" + 
		get_absolute_path(controller.duckStationLineEdit.text) +
		"duckstation-qt-x64-ReleaseLTCG.exe' -ArgumentList '" +
		get_absolute_path( controller.outputLineEdit.text).replace("/", "\\") + "'"], false)
#	os_shell_execute("'" + controller.duckStationLineEdit.text + "duckstation-qt-x64-ReleaseLTCG.exe' '" + controller.outputLineEdit.text + "'")

func os_start_client():
	
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
func os_delete_directory(path : String):
	if OS.get_name() == "Windows":
#		print("deleting " + path)
		OS.execute("cmd", [ "/c", "rmdir /Q /S \"" + path.replace("/", "\\") + "\""])
	elif OS.get_name() == "X11":
		return "" #TODO linux
	else:
		OS.alert(OS.get_name() + " OS is not supported, sorry =(")
		return ""

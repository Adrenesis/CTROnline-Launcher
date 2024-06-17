extends Node

signal delete_confirm_answered

const Utils = preload("res://utils.gd")

signal download_done
signal stub_signal

var polling_download = false
var waiting_download_print = false
var download_was_text = false
var download_path = ""
var used_http

var path_about_to_be_deleted

var function_state : GDScriptFunctionState

func proxy_print(string : String):
	var time = ""
	if OS.get_time().hour < 10:
		time += "0"
	time += str(OS.get_time().hour) + ":"
	
	if OS.get_time().minute < 10:
		time += "0"
	time += str(OS.get_time().minute) + ":"
	
	if OS.get_time().second < 10:
		time += "0"
	time += str(OS.get_time().second)
	var text = string
	runNode.console.append_bbcode("\n" + "[" + time + "]: " + text)
	runNode.console.scroll_to_line(runNode.console.get_line_count()-1)

func _process(delta : float):
	if polling_download:
		if not waiting_download_print:
			waiting_download_print = true
			function_state = yield(get_tree().create_timer(0.2), "timeout")
			var bodySize = used_http.get_body_size()
			var downloadedBytes = used_http.get_downloaded_bytes()
			var percent = int(downloadedBytes*100/bodySize)
			proxy_print("Downloading " + str(percent) + "%...")
			waiting_download_print = false


func download(link : String, p_path : String, http : HTTPRequest):
	http.connect("request_completed", self, "_http_request_completed")
	var path = get_absolute_path(p_path)
	if not link.ends_with(".ini"):
		download_was_text = false
		http.set_download_file(path)
		
	else:
		download_was_text = true
	download_path = path
	print("Downloading " + link + " to " + path)
	used_http = http
	var request = http.request(link)
	polling_download = true
	if request != OK:
		proxy_print("Http request error")
	else:
		polling_download = true
#		while polling_download:
#			var bodySize = http.get_body_size()
#			var downloadedBytes = http.get_downloaded_bytes()
#
#			var percent = int(downloadedBytes*100/bodySize)
#			proxy_print(str(percent) + " downloaded")

func _http_request_completed(result, _response_code, _headers, _body):
	polling_download = false
#	print(result)
	if result != OK:
		proxy_print("Download Failed")
	else:
		proxy_print("Downloading 100%.")
		if download_was_text:
			write_file(_body.get_string_from_utf8(), download_path)
	used_http.disconnect("request_completed", self, "_http_request_completed")
	print(_response_code)
	emit_signal("download_done")

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

const CHUNK_SIZE = 1024

func hash_file(path) -> String: 
    var ctx = HashingContext.new()
    var file = File.new()
    # Start a SHA-256 context.
    ctx.start(HashingContext.HASH_MD5)
    # Check that file exists.
    if not file.file_exists(get_absolute_path(path)):
        return "zzzzzzzzzzzzzzzzzzzzzzz"
    # Open the file to hash.
    file.open(path, File.READ)
    # Update the context after reading each chunk.
    while not file.eof_reached():
        ctx.update(file.get_buffer(CHUNK_SIZE))
    # Get the computed hash.
    var res = ctx.finish()
    # Print the result as hex string and array.
    return res.hex_encode()


func file_exists(path : String) -> bool:
	var output = []
	OS.execute("powershell", [ "-Command", "cmd /c if exist '" + get_absolute_path(path) + "' echo true"], true, output)
	return output[0]

func write_file(content : String, path : String):
	var file := File.new()
#	print([path])
	var dir_path = get_absolute_path("%USERPROFILE%/Documents/DuckStation/gamesettings")
#	print([dir_path])
#	print(Directory.new().dir_exists(dir_path))
	var err = file.open(path, File.WRITE) # Ouvert en écriture seulement
	if err != OK:
		print("ERROR: writing failed with error " + Utils.ERROR.keys()[err])
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
	var directory := Directory.new()
	var path = get_absolute_path(p_path)
	var path_check = path.to_lower()
	if (
		(path.find("xdelta") != -1) or
		(path.find("duckstation") != -1) or
		(path.find("temp") != -1)
	):
		os_delete_directory(path)
		yield(get_tree(), "idle_frame")
	else:
		path_about_to_be_deleted = path 
		runNode.deleteConfirmationDialog.get_node("Label2").text = (
			"/!\\ YOU ARE ABOUT TO DELETE THE DIRECTORY /!\\\n\"" +
			path +
			"\"\nDO YOU WISH TO CONTINUE?")
		runNode.deleteConfirmationDialog.popup()
		yield(self, "delete_confirm_answered")

func delete_confirmed():
	os_delete_directory(path_about_to_be_deleted)
	print(path_about_to_be_deleted + " deleted")
	emit_signal("delete_confirm_answered")

func delete_canceled():
	runNode.is_canceled = true
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
		return runNode.xDeltaLineEdit.text + "xdelta3-3.0.9-x64.exe "
	elif OS.get_name() == "X11":
		return "" #TODO linux
	else:
		OS.alert(OS.get_name() + " OS is not supported, sorry =(")
		return ""

func os_start_duckstation():
	OS.execute("powershell", [
		"-Command", 
		"Start-Process '" + 
		get_absolute_path(runNode.duckStationLineEdit.text) +
		"duckstation-qt-x64-ReleaseLTCG.exe' -ArgumentList '" +
		get_absolute_path( runNode.outputLineEdit.text).replace("/", "\\") + "'"], false)
#	os_shell_execute("'" + runNode.duckStationLineEdit.text + "duckstation-qt-x64-ReleaseLTCG.exe' '" + runNode.outputLineEdit.text + "'")

func os_start_client():
	
#	cmd /c start powershell -NoExit -Command { echo Adrenesis|./Client.exe }
	var filtered_username 
#	= runNode.usernameLineEdit.text.replace("&", "^^^^^^&")
#	filtered_username = runNode.usernameLineEdit.text.replace("*", "^^^*")
#	filtered_username = runNode.usernameLineEdit.text.replace("[", "^^^[")
#	filtered_username = runNode.usernameLineEdit.text.replace("@", "^^^@")
#	filtered_username = runNode.usernameLineEdit.text.replace("^", "^^^^")
	filtered_username = runNode.usernameLineEdit.text.replace(" ", "")
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
		
func try_install_xdelta(force := false):
	if (force or (not directory_exists(runNode.xDeltaLineEdit.text))): 
		yield(install_xdelta(), "completed")
	else:
		yield(get_tree(), "idle_frame")

func install_xdelta():
	if directory_exists(runNode.xDeltaLineEdit.text):
		yield(delete_directory(runNode.xDeltaLineEdit.text), "completed")
	if not runNode.is_canceled:
		proxy_print("Downloading xdelta from github...")
		download(runNode.xDeltaURLLineEdit.text 
			, "./xdelta.zip"
			, runNode.xDeltaHTTPRequest)
		yield(self, "download_done")
		proxy_print("Download Done.")
		proxy_print("Extracting xdelta...")
		os_extract_archive("./xdelta.zip", runNode.xDeltaLineEdit.text) 
		proxy_print("Done.")

func try_install_duckstation(force := false):
	if (force or (not directory_exists(runNode.duckStationLineEdit.text))):
		yield(install_duckstation(), "completed")
	else:
		yield(get_tree(), "idle_frame")

func install_duckstation():
	proxy_print("Downloading DuckStation from github...")
	download(runNode.duckStationURLLineEdit.text 
		, "./duckstation.zip"
		, runNode.duckStationHTTPRequest)
	yield(self, "download_done")
	proxy_print("Download done.")
	proxy_print("Creating duckstation files...")
	if file_exists(runNode.duckStationLineEdit.text + "duckstation-qt-x64-ReleaseLTCG.exe"):
		 yield(delete_directory(runNode.duckStationLineEdit.text), "completed")
	if not runNode.is_canceled:
		os_extract_archive("./duckstation.zip", runNode.duckStationLineEdit.text) 
		proxy_print("Done.")

func try_install_gamesettings(force := false):
	if(force or (not file_exists(runNode.gameSettingsLineEdit.text + "gamesettings/SCUS-94426.ini"))): 
		yield(install_gamesettings(), "completed")
	else:
		yield(get_tree(), "idle_frame")

func install_gamesettings():
	if not directory_exists(runNode.gameSettingsLineEdit.text):
		make_directory(runNode.gameSettingsLineEdit.text)
	if not directory_exists(runNode.gameSettingsLineEdit.text + "gamesettings"):
		make_directory(runNode.gameSettingsLineEdit.text + "gamesettings")
	if not directory_exists(runNode.gameSettingsLineEdit.text + "gamesettings"):
		proxy_print("ERROR: couldn't create DuckStation GameSettings folder")
		yield(get_tree(), "idle_frame")
	else:
		proxy_print("Downloading GameSettings from CTROnline...")
		download(runNode.gameSettingsURLLineEdit.text
			, runNode.gameSettingsLineEdit.text + "gamesettings/SCUS-94426.ini"
			, runNode.gameSettingsHTTPRequest)
		yield(self, "download_done")
		proxy_print("Download done.")

func try_install_bios(force := true):
	if(force or (not file_exists(runNode.gameSettingsLineEdit.text + "bios/bios.bin"))): 
		yield(install_bios(), "completed")
	else:
		yield(get_tree(), "idle_frame")

func install_bios():
	if not directory_exists(runNode.gameSettingsLineEdit.text + "bios"):
		make_directory(runNode.gameSettingsLineEdit.text)
	if not directory_exists(runNode.gameSettingsLineEdit.text + "bios"):
		proxy_print("ERROR: could not create bios output directory")
		yield(get_tree(), "idle_frame")
	else:
		proxy_print("Copying bios...")
		yield(get_tree(), "idle_frame")
		#echo F|xcopy %BiosFile% %DuckStationSettingsFolder%\bios\bios.bin>nul
		copy_file(runNode.biosLineEdit.text, runNode.gameSettingsLineEdit.text + "bios/bios.bin")
		proxy_print("Done")

func download_last_client():
	proxy_print("echo Downloading last client...")
	if directory_exists("./temp/"):
		yield(delete_directory("./temp/"), "completed")
	make_directory("./temp/")
	if not directory_exists("./temp/"):
		yield(get_tree(), "idle_frame")
	else:
		download(runNode.clientURLLineEdit.text 
			, "./new_client.zip"
			, runNode.clientHTTPRequest)
		yield(self, "download_done")
		proxy_print("Downloading done.")

var has_update_to_be_done = false

func check_update_to_be_done(force := false):

	
	os_extract_archive("./new_client.zip", "./temp/")
	if force:
		yield(get_tree(), "idle_frame")
		has_update_to_be_done = true
	if file_exists("./Client.exe"):
		proxy_print("echo client found, comparing...")
#		print("found")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		if are_files_different("./Client.exe", "./temp/Client.exe"):
			proxy_print("Files are different...")
			has_update_to_be_done = true
		proxy_print("echo check done")
	else:
		proxy_print("CLIENT.EXE not found updating...")
		yield(get_tree(), "idle_frame")
		has_update_to_be_done = true
	if not file_exists(get_absolute_path(runNode.outputLineEdit.text)):
		proxy_print("bin not detected. Generating again.")
		yield(get_tree(), "idle_frame")
		has_update_to_be_done = true

	yield(get_tree(), "idle_frame")



func update_ctronline():
	proxy_print("Game needs an update")
	delete_file("./Client.exe")
	yield(get_tree(), "idle_frame")
	copy_file("./temp/Client.exe", "./Client.exe")
	proxy_print("Downloading last patch...")
	var xdelta_cmd = ""
	if not runNode.fps30CheckBox.pressed:
		download(runNode.patchURLLineEdit.text 
		, "ctr-u_Online60.xdelta"
		, runNode.patchHTTPRequest)
		yield(self, "download_done")
		proxy_print("Downloading done.")
		proxy_print("Updating CTR Online...")
		xdelta_cmd = get_os_xdelta_command()
		xdelta_cmd += "-f -d -s '" + runNode.inputLineEdit.text + "' './ctr-u_Online60.xdelta' '" + runNode.outputLineEdit.text + "'"
		
	else:
		download(runNode.patchURLLineEdit.text
			, "ctr-u_Online30.xdelta"
			, runNode.patchHTTPRequest)
		yield(self, "download_done")
		proxy_print("Downloading done.")
		proxy_print("Updating CTR Online...")
		xdelta_cmd = get_os_xdelta_command()
		xdelta_cmd += "-f -d -s '" + runNode.inputLineEdit.text + "' './ctr-u_Online30.xdelta' '" + runNode.outputLineEdit.text + "'"
#		xdelta_cmd = "%XDeltaFolder%/xdelta3-3.0.9-x64.exe -f -d -s '" + runNode.inputLineEdit.text + "' './ctr-u_Online60.xdelta' '" + runNode.outputLineEdit.text + "'"
	OS.execute("powershell", ["-Command", xdelta_cmd])
#	os_shell_execute(xdelta_cmd)
	proxy_print("Update done.")

func generate_cue():
	var cuePath = runNode.outputLineEdit.text
#	print("." + cuePath.rsplit(".", 1)[1] + ".cue")
	if not file_exists("." + cuePath.rsplit(".", 1)[1] + ".cue"): 
		proxy_print("cue not detected. Generating again")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		write_file(
			"FILE " + runNode.outputLineEdit.text + " BINARY\n" + 
			"  TRACK 01 MODE2/2352\n" +
			"    INDEX 01 00:00:00",
			"." + cuePath.rsplit(".", 1)[1] + ".cue")
	yield(get_tree(), "idle_frame")

func cleanup():
	proxy_print("Cleanup...")
	if directory_exists("./temp/"):
		yield(delete_directory("./temp/"), "completed")
	if file_exists("./new_client.zip"):
		delete_file("./new_client.zip")
	if file_exists("./duckstation.zip"):
		delete_file("./duckstation.zip")
	if file_exists("./xdelta.zip"):
		delete_file("./xdelta.zip")
	proxy_print("Done. Starting Game...")

func start_game():
	os_start_duckstation()
	#TODO wait
	os_start_client()


var runNode = null

func custom_init(p_runNode: Node):
	runNode = p_runNode
	proxy_print(get_absolute_path("%USERPROFILE%/documents/DuckStation/gamesettings"))
	proxy_print(get_absolute_path("./DuckStation"))
	yield(main(), "completed")

func main():
	runNode.deleteConfirmationDialog.get_ok().connect("pressed", self, "delete_confirmed")
	runNode.deleteConfirmationDialog.get_cancel().connect("pressed", self, "delete_canceled")
	runNode.deleteConfirmationDialog.get_close_button().connect("pressed", self, "delete_canceled")
	if not runNode.skipXDeltaButton.pressed:
		yield(try_install_xdelta(runNode.forceXDeltaButton.pressed), "completed")
	if not runNode.is_canceled:
		if not runNode.skipDuckStationButton.pressed:
			yield(try_install_duckstation(runNode.forceDuckStationButton.pressed), "completed")
	print(runNode.is_canceled)
	if not runNode.is_canceled:
		if not runNode.skipGameSettingsButton.pressed:
			yield(try_install_gamesettings(runNode.forceGameSettingsButton.pressed), "completed")
		if not runNode.skipBiosButton.pressed:
			yield(try_install_bios(runNode.forceBiosButton.pressed), "completed")
		yield(download_last_client(), "completed")
		yield(check_update_to_be_done(runNode.forceUpdateButton.pressed), "completed")
		yield(generate_cue(), "completed")
		if has_update_to_be_done:
			yield(update_ctronline(), "completed")
		else:
			proxy_print("Game already updated.")
		start_game()
		runNode.deleteConfirmationDialog.get_ok().disconnect("pressed", self, "delete_confirmed")
		runNode.deleteConfirmationDialog.get_cancel().disconnect("pressed", self, "delete_canceled")
		runNode.deleteConfirmationDialog.get_close_button().disconnect("pressed", self, "delete_canceled")

func queue_free():
	if function_state != null:
		if function_state.is_valid(true):
			function_state.resume()

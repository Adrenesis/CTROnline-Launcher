extends Node

signal download_done

var polling_download = false
var waiting_download_print = false
var download_was_text = false
var download_path = ""
var used_http

var path_about_to_be_deleted

var function_state : GDScriptFunctionState



		
func try_install_xdelta(force := false):
	var path = Utils.get_absolute_path(runNode.xDeltaLineEdit.text, true)
	if (force or (not Utils.directory_exists(path))): 
		yield(install_xdelta(), "completed")
	else:
		yield(get_tree(), "idle_frame")

func install_xdelta():
	yield(get_tree(), "idle_frame")
	var path = Utils.get_absolute_path(runNode.xDeltaLineEdit.text, true)
	if Utils.directory_exists(path):
		yield(Utils.delete_directory(path), "completed")
		yield(get_tree(), "idle_frame")
	if not runNode.is_canceled:
		Utils.controller.proxy_print("Downloading xdelta from github...")
		Downloader.download(runNode.xDeltaURLLineEdit.text 
			, "./xdelta.zip"
			, runNode.xDeltaHTTPRequest)
		yield(Downloader, "download_done")
		Utils.controller.proxy_print("Download Done.")
		Utils.controller.proxy_print("Extracting xdelta...")
		yield(get_tree(), "idle_frame")
		Utils.os_extract_archive("./xdelta.zip", path) 
		yield(get_tree(), "idle_frame")
		Utils.controller.proxy_print("Done.")

func try_install_duckstation(force := false):
	var path = Utils.get_absolute_path(runNode.duckStationLineEdit.text, true)
	if (force or (not Utils.directory_exists(path))):
		yield(install_duckstation(), "completed")
	else:
		yield(get_tree(), "idle_frame")

func install_duckstation():
	yield(get_tree(), "idle_frame")
	Utils.controller.proxy_print("Downloading DuckStation from github...")
	Downloader.download(runNode.duckStationURLLineEdit.text 
		, "./duckstation.zip"
		, runNode.duckStationHTTPRequest)
	yield(Downloader, "download_done")
	Utils.controller.proxy_print("Download done.")
	Utils.controller.proxy_print("Creating duckstation files...")
	var path = Utils.get_absolute_path(runNode.duckStationLineEdit.text, true)
	if Utils.file_exists(path + "duckstation-qt-x64-ReleaseLTCG.exe"):
		yield(Utils.delete_directory(path), "completed")
		yield(get_tree(), "idle_frame")
	if not runNode.is_canceled:
		yield(get_tree(), "idle_frame")
		Utils.os_extract_archive("./duckstation.zip", path) 
		yield(get_tree(), "idle_frame")
		Utils.controller.proxy_print("Done.")

func try_install_gamesettings(force := false):
	var path = Utils.get_absolute_path(runNode.gameSettingsLineEdit.text, true)
	if(force or (not Utils.file_exists(path + "gamesettings/SCUS-94426.ini"))): 
		yield(install_gamesettings(), "completed")
	else:
		yield(get_tree(), "idle_frame")

func install_gamesettings():
	yield(get_tree(), "idle_frame")
	var path = Utils.get_absolute_path(runNode.gameSettingsLineEdit.text, true)
	if not Utils.directory_exists(path):
		Utils.make_directory(path)
		yield(get_tree(), "idle_frame")
	if not Utils.directory_exists(path + "gamesettings"):
		Utils.make_directory(path + "gamesettings")
		yield(get_tree(), "idle_frame")
	if not Utils.directory_exists(path + "gamesettings"):
		Utils.controller.proxy_print("ERROR: couldn't create DuckStation GameSettings folder")
		yield(get_tree(), "idle_frame")
	else:
		Utils.controller.proxy_print("Downloading GameSettings from CTROnline...")
		Downloader.download(runNode.gameSettingsURLLineEdit.text
			, path + "gamesettings/SCUS-94426.ini"
			, runNode.gameSettingsHTTPRequest)
		yield(Downloader, "download_done")
		Utils.controller.proxy_print("Download done.")

func try_install_bios(force := true):
	var path = Utils.get_absolute_path(runNode.gameSettingsLineEdit.text, true)
	if(force or (not Utils.file_exists(path + "bios/bios.bin"))): 
		yield(install_bios(), "completed")
	else:
		yield(get_tree(), "idle_frame")

func install_bios():
	yield(get_tree(), "idle_frame")
	var path = Utils.get_absolute_path(runNode.gameSettingsLineEdit.text, true)
	if not Utils.directory_exists(path + "bios"):
		Utils.make_directory(path)
		yield(get_tree(), "idle_frame")
	if not Utils.directory_exists(path + "bios"):
		Utils.controller.proxy_print("ERROR: could not create bios output directory")
		yield(get_tree(), "idle_frame")
	else:
		Utils.controller.proxy_print("Copying bios...")
		yield(get_tree(), "idle_frame")
		#echo F|xcopy %BiosFile% %DuckStationSettingsFolder%\bios\bios.bin>nul
		Utils.copy_file(runNode.biosLineEdit.text, path + "bios/bios.bin")
		Utils.controller.proxy_print("Done")
		yield(get_tree(), "idle_frame")

func download_last_client():
	yield(get_tree(), "idle_frame")
	Utils.controller.proxy_print("echo Downloading last client...")
	if Utils.directory_exists("./temp/"):
		yield(Utils.delete_directory("./temp/"), "completed")
		yield(get_tree(), "idle_frame")
	Utils.make_directory("./temp/")
	if not Utils.directory_exists("./temp/"):
		yield(get_tree(), "idle_frame")
	else:
		Downloader.download(runNode.clientURLLineEdit.text 
			, "./new_client.zip"
			, runNode.clientHTTPRequest)
		yield(Downloader, "download_done")
		Utils.controller.proxy_print("Downloading done.")

var has_update_to_be_done = false

func check_update_to_be_done(force := false):
	yield(get_tree(), "idle_frame")
	Utils.os_extract_archive("./new_client.zip", "./temp/")
	yield(get_tree(), "idle_frame")
	if force:
		yield(get_tree(), "idle_frame")
		has_update_to_be_done = true
	if Utils.file_exists("./Client.exe"):
		Utils.controller.proxy_print("echo client found, comparing...")
#		print("found")
		yield(get_tree(), "idle_frame")
		if Utils.are_files_different("./Client.exe", "./temp/Client.exe"):
			Utils.controller.proxy_print("Files are different...")
			has_update_to_be_done = true
		Utils.controller.proxy_print("echo check done")
	else:
		Utils.controller.proxy_print("CLIENT.EXE not found updating...")
		yield(get_tree(), "idle_frame")
		has_update_to_be_done = true
	if not Utils.file_exists(Utils.get_absolute_path(runNode.outputLineEdit.text)):
		Utils.controller.proxy_print("bin not detected. Generating again.")
		yield(get_tree(), "idle_frame")
		has_update_to_be_done = true

	yield(get_tree(), "idle_frame")



func update_ctronline():
	Utils.controller.proxy_print("Game needs an update")
	Utils.delete_file("./Client.exe")
	yield(get_tree(), "idle_frame")
	Utils.copy_file("./temp/Client.exe", "./Client.exe")
	Utils.controller.proxy_print("Downloading last patch...")
	var xdelta_cmd = ""
	if not runNode.fps30CheckBox.pressed:
		Downloader.download(runNode.patchURLLineEdit.text 
			, "ctr-u_Online60.xdelta"
			, runNode.patchHTTPRequest)
		yield(Downloader, "download_done")
		
	else:
		Downloader.download(runNode.patchURLLineEdit.text
			, "ctr-u_Online30.xdelta"
			, runNode.patchHTTPRequest)
		yield(Downloader, "download_done")
	
	Utils.controller.proxy_print("Downloading done.")
	Utils.controller.proxy_print("Updating CTR Online...")
	xdelta_cmd = Utils.get_os_xdelta_command(runNode.fps30CheckBox.pressed)
#	print(xdelta_cmd)
	yield(get_tree(), "idle_frame")
	OS.execute("cmd", ["/c", xdelta_cmd])
#	os_shell_execute(xdelta_cmd)
	Utils.controller.proxy_print("Update done.")

func generate_cue():
	var cuePath = runNode.outputLineEdit.text
#	print("." + cuePath.rsplit(".", 1)[1] + ".cue")
	if not Utils.file_exists("." + cuePath.rsplit(".", 1)[1] + ".cue"): 
		Utils.controller.proxy_print("cue not detected. Generating again")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		Utils.write_file(
			"FILE " + runNode.outputLineEdit.text + " BINARY\n" + 
			"  TRACK 01 MODE2/2352\n" +
			"    INDEX 01 00:00:00",
			"." + cuePath.rsplit(".", 1)[1] + ".cue")
	yield(get_tree(), "idle_frame")

func cleanup():
	Utils.controller.proxy_print("Cleanup...")
	if Utils.directory_exists("./temp/"):
		yield(Utils.delete_directory("./temp/"), "completed")
	if Utils.file_exists("./new_client.zip"):
		Utils.delete_file("./new_client.zip")
	if Utils.file_exists("./duckstation.zip"):
		Utils.delete_file("./duckstation.zip")
	if Utils.file_exists("./xdelta.zip"):
		Utils.delete_file("./xdelta.zip")
	Utils.controller.proxy_print("Done. Starting Game...")

func start_game():
	Utils.os_start_duckstation()
	#TODO wait
	Utils.os_start_client()


var runNode = null

func custom_init(p_runNode: Node):
	runNode = p_runNode
	Utils.controller.proxy_print(Utils.get_absolute_path("%USERPROFILE%/documents/DuckStation/gamesettings"))
	Utils.controller.proxy_print(Utils.get_absolute_path("./DuckStation"))
	yield(main(), "completed")

func main():
	runNode.deleteConfirmationDialog.get_ok().connect("pressed", Utils, "delete_confirmed")
	runNode.deleteConfirmationDialog.get_cancel().connect("pressed", Utils, "delete_canceled")
	runNode.deleteConfirmationDialog.get_close_button().connect("pressed", Utils, "delete_canceled")
	if not runNode.skipXDeltaButton.pressed:
		yield(try_install_xdelta(runNode.forceXDeltaButton.pressed), "completed")
	if not runNode.is_canceled:
		if not runNode.skipDuckStationButton.pressed:
			yield(try_install_duckstation(runNode.forceDuckStationButton.pressed), "completed")
#	print(runNode.is_canceled)
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
			Utils.controller.proxy_print("Game already updated.")
		start_game()
		runNode.deleteConfirmationDialog.get_ok().disconnect("pressed", Utils, "delete_confirmed")
		runNode.deleteConfirmationDialog.get_cancel().disconnect("pressed", Utils, "delete_canceled")
		runNode.deleteConfirmationDialog.get_close_button().disconnect("pressed", Utils, "delete_canceled")

func queue_free():
	if function_state != null:
		if function_state.is_valid(true):
			function_state.resume()

#!/usr/bin/env python3

import threading
from threading import Timer
import time
import os
import signal
import subprocess
import i3ipc
import sys

class BarListener:
	def __init__(self):
		self.i3 = i3ipc.Connection()
		self.pipe_path = "/tmp/bar_listener_pipe"
		self.stop_event = threading.Event()
		self.debounce_timers = {
			"workspaces": None,
			"nowplaying": None,
			"usage": None,
			"status": None,
		}
		self.mode = "default"
		self.setup_pipe()
		self.setup_signal_handling()
		self.attach_i3_events()



	def setup_pipe(self):
		# Reset .mode.txt to default for modeListener script
		with open("/home/rneal/.config/i3/scripts/.mode.txt", "w") as f:
			f.write("default")
		
		# If a pipe file already exists, remove it
		if os.path.exists(self.pipe_path):
			os.remove(self.pipe_path)
		
		# Create clean pipe file
		os.mkfifo(self.pipe_path)
		print("Starting bar listener...")



	def setup_signal_handling(self):
		# Stop script gracefully if terminate or interrupt signals are passed
		signal.signal(signal.SIGTERM, self.stop_script)
		signal.signal(signal.SIGINT, self.stop_script)



	def attach_i3_events(self):
		# Define what functions are called by i3-ipc events
		self.i3.on("workspace::init", self.on_ws_event)
		self.i3.on("workspace::empty", self.on_ws_event)
		self.i3.on("workspace::focus", self.on_ws_focus)
		self.i3.on("mode", self.on_mode_change)



	def show_bar(self, bar: str) -> None:
		# Define commands array for each bar
		commands = {
			"workspaces": "polybar-msg -p {} cmd show",
			"nowplaying": "setsid ~/.config/polybar/scripts/hideIt.sh --wait --signal --name '^polybar-nowplaying_eDP1$' --toggle --direction top --peek 0 > /dev/null 2>&1 &",
			"usage": "setsid ~/.config/polybar/scripts/hideIt.sh --wait --signal --name '^polybar-usage_eDP1$' --toggle --direction bottom --peek 0 > /dev/null 2>&1 &",
			"status": "setsid ~/.config/polybar/scripts/hideIt.sh --wait --signal --name '^polybar-status_eDP1$' --toggle --direction bottom --peek 0 > /dev/null 2>&1 &"
		}
		
		# Make sure the bar is defined in the commands array
		if bar in commands:
			try:
				# If the bar argument is "workspaces", get workspaces bar's PID
				if bar == "workspaces":
					pid_command = "ps aux | grep polybar/workspaces.ini | grep -v grep | awk '{print $2}'"
					pid = subprocess.check_output(pid_command, shell=True, text=True).strip()
					
					# If a PID is found, run the corresponding show command for the bar
					if pid:
						subprocess.run(commands[bar].format(pid), shell=True, check=True)
						print(f"{bar.capitalize()} bar shown")
					
					# Error case if workspaces PID isn't found
					else:
						print(f"{bar.capitalize()} bar process not found.")
				
				# If the bar argument isn't "workspaces", run the corresponding show command for the bar
				else:
					subprocess.run(commands[bar], shell=True, check=True)
					print(f"{bar.capitalize()} bar shown")
				
				# Hide the bar after showing for a "peek" effect
				self.hide_bar_timer(bar)
			
			# Error case if subprocess command fails
			except subprocess.CalledProcessError as e:
				print(f"Failed to execute command for {bar}: {e}")
		
		# Error case if bar argument is not recognized
		else:
			print(f"show_bar: Bar '{bar}' not recognized")



	def hide_bar_timer(self, bar: str) -> None:
		# Make sure the bar argument is defined in the debounce_timers array
		if bar in self.debounce_timers:
			
			# If the bar argument's debounce timer is running, reset it
			if self.debounce_timers[bar] is not None:
				self.debounce_timers[bar].cancel()
				print(f"{bar.capitalize()} debounce timer cancelled")
			
			# Restart the bar argument's debounce timer
			self.debounce_timers[bar] = Timer(2, self.hide_bar, args=[bar])
			self.debounce_timers[bar].start()
			print(f"{bar.capitalize()} debounce timer restarted")
		
		# Error case if bar argument is not recognized
		else:
			print(f"hide_bar_timer: Bar '{bar}' not recognized")



	def hide_bar(self, bar: str) -> None:
		# Define commands array for each bar
		commands = {
			"workspaces": "polybar-msg -p {} cmd hide",
			"nowplaying": "setsid ~/.config/polybar/scripts/hideIt.sh --wait --signal --name '^polybar-nowplaying_eDP1$' --region 1498x0+384+10 --direction top --peek 0 > /dev/null 2>&1 &",
			"usage": "setsid ~/.config/polybar/scripts/hideIt.sh --wait --signal --name '^polybar-usage_eDP1$' --region 38x1080+386+-10 --direction bottom --peek 0 > /dev/null 2>&1 &",
			"status": "setsid ~/.config/polybar/scripts/hideIt.sh --wait --signal --name '^polybar-status_eDP1$' --region 1402x1080+480+-10 --direction bottom --peek 0 > /dev/null 2>&1 &"
		}
		
		# Make sure bar argument is defined in commands array
		if bar in commands:
			try:
				
				# If the bar argument is "workspaces", get workspaces bar's PID
				if bar == "workspaces":
					pid_command = "ps aux | grep polybar/workspaces.ini | grep -v grep | awk '{print $2}'"
					pid = subprocess.check_output(pid_command, shell=True, text=True).strip()
					
					# If PID is found, run the corresponding hide command for the bar
					if pid:
						subprocess.run(commands[bar].format(pid), shell=True, check=True)
						print(f"{bar.capitalize()} bar hidden")
					
					# Error case if workspaces PID isn't found
					else:
						print(f"{bar.capitalize()} bar process not found.")
				
				# If the bar argument isn't "workspaces", run the corresponding hide command for the bar
				else:
					subprocess.run(commands[bar], shell=True, check=True)
					print(f"{bar.capitalize()} bar hidden")
			
			# Error case if subprocess command fails
			except subprocess.CalledProcessError as e:
				print(f"Failed to execute command for {bar}: {e}")
		
		# Error case if bar argument is not recognized
		else:
			print(f"hide_bar: Bar '{bar}' not recognized")



	def resize_workspaces_bar(self, i3_mode: str) -> None:
		# Run script to resize the workspaces bar
		try:
			subprocess.run(["/home/rneal/.config/polybar/scripts/workspacesWidth.sh", i3_mode], check=True)
		
		# Error case if subprocess command fails
		except subprocess.CalledProcessError as e:
			print(f"Failed to resize workspaces bar: {e}")



	def on_ws_event(self, i3, event):
		print(f"Workspace changed to: {event.current}")
		self.resize_workspaces_bar(self.mode)
		
		# If not in a binding mode, hide the bar
		if self.mode == "default":
			self.hide_bar_timer("workspaces")



	def on_ws_focus(self, i3, event):
		print(f"Focused on workspace: {event.current}")

		# If not in a binding mode, "peek" show the bar
		if self.mode == "default":
			self.show_bar("workspaces")



	def on_mode_change(self, i3, event):
		self.mode = event.change
		print(f"Mode changed to: {self.mode}")
		
		# Write the event change to .mode.txt for modeListener script
		with open("/home/rneal/.config/i3/scripts/.mode.txt", "w") as f:
			f.write(event.change)
		
		self.resize_workspaces_bar(self.mode)
		
		#If not in a binding mode, hide the bar
		if self.mode == "default":
			self.hide_bar("workspaces")



	def execute_command(self, command: str) -> None:
		# Execute commands read from the pipe
		try:
			# Split the input into the command and the argument
			parts = command.split()
			action = parts[0]
			args = parts[1]

			# Map commands into functions
			func = {
				"show": self.show_bar,
				"hide": self.hide_bar,
			}.get(action)
			
			# If a corresponding function is found, run the function with the argument
			if func:
				func(args)
				
			# Error case if a function isn't found
			else:
				print(f"Unknown action: {action}")
		
		# Error case if the function fails
		except Exception as e:
			print(f"Error processing command: {e}")



	def read_from_pipe(self):
		# Read commands from the pipe and execute them
		with open(self.pipe_path, "r") as pipe:
			while not self.stop_event.is_set():
				command = pipe.readline().strip()
				if command:
					self.execute_command(command)
				else:
					time.sleep(0.1)



	def stop_script(self, signum, frame):
		# Stop the thread gracefully
		print("\nSignal received, stopping script gracefully...")
		self.stop_event.set()
		self.stdin_thread.join()
		print("Script stopped.")
		sys.exit(0)



	def start(self):
		# Start the pipe reading thread
		self.stdin_thread = threading.Thread(target=self.read_from_pipe)
		self.stdin_thread.start()
		
		# Write an initial empty command to the pipe to avoid blocking
		with open(self.pipe_path, "w") as pipe:
			pipe.write("")  # Write an empty string to unblock the pipe

		# Start the i3 event loop
		self.i3.main()



if __name__ == "__main__":
	bar_listener = BarListener()
	bar_listener.start()

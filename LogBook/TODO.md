To-Do
=====
A to-do list for research internship at Rug.

Things to do
------------
- Look for how to run an app in background.
- [DONE] Bluetooth communication.
- Add README about installing noble.

Things to be developed
----------------------
- PC:
	- [DONE] Scala app for HTTP.
	- [DONE] App for Bluetooth.
- Mobile Phone:
	- [DONE] Bluetooth communication
	- [DONE] Tap to hide keyboard -> using delegate pattern?
	- [DONE] History tab.
	
For the Report
--------------
- Intro about context aware building (smart home/office)
	- How this project is positioned.
	- The hardware and software built in this project.
	- Explain about occupancy and cite a paper.
	- Explain how is the architecture of the system and where does this study reside.
		- Using a diagram: current (using wifi to server) and possible architecture if bluetooth is better (using ble to server)
		- Show that the number of sensor may change.
		- how is the implementation going to be if bluetooth is used: using thin client or raspberry pi acting as ble central and accesspoint.

- Research question
	- Is bluetooth more energy efficient than wifi to transfer occupancy data to server?
		- To what extent?
		- Based on number of sensor and location.
	
- Explanation about Bluetooth LE
	- What is the version
	- technical specification
	- what are the characteristics
	- how to communicate (what libraries are used)
	- Explain whici one is more high or low level. Xcode or bluepy
	- what characteristic is used and why
	- explain how Bluetooth LE works: what is central, what is peripheral, etc
	- what is uuid
	
- Explanation about the development of the program
	- What libraries are used
	- What IDE are used and why
	- Why noble is used, explain why and how it works inside.
	- Give screen shots of both pc and phone apps.
	- Explain how many apps which were developed.
	- Give a diagram about the system architecture.
	
- Measuring the energy consumption
	- Explain about Apple Instruments and the capabilities (wireles and wired)
	- also take RSSI into account
	- compare the energy consumption when the phone runs no application as well.
	- using restriction to stop other apps.
	- Figure out the time window and number of maximum beacon, before starting data collection.
	- Can't run overnight because "if the device battery runs dry or the iOS Device is powered off, the log data is lost." This is a CRAZY restriction, and pretty much makes this approach useless for our case 
	- Try to turn off the internet, so that other apps will not disturb
	- Which method is used, tethered or untethered.
	- Explain before all un-needed apps removed and after the un-needed apps removed.
	- The time needed to send a chunk, use more than one comparison.
	- Please turn off the Bluetooth when recording Wifi, and Wifi when recording bluetooth.
	- Why we are choosing those parameters:
		- Number of sensor is impactful esp. for bluetooth.
		- The distance may cause some difference.
		- The LoS and non LoS may have some effect.
	- How did the measurement was conducted.
		- Turn off every communication method (airplane mode).
		- Only enable wifi or bluetooth, depends on what is needed.
		- Using untethered instruments (logging in iOS).
		- Each run is 3 minutes long.
		- And other 5W1H (where is it, how big is the room, etc.)
	
- Problems
	- The scanning that still needs human interaction
	- Energy reporting which is un-exportable.	
		- Solution: Creating applescript to copy and paste from instruments to excel automatically.
	- The bluetooth is not stable:
		- It always stops at 29 packets -> solution: using resubscribing method.
		- It has to be triggered by GNOME (GUI) Bluetooth management tool.
	- Why it is unstable?
		- Is it because of `noble`?
	- This research is only energy consumption for sending data. Without sensing etc.
		- Explain, this may differ in the real implementation, as both bluetooth and wifi may be turned on. The result might be slightly different.
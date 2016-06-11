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
	- The hardware and software built in this project
	
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
	
- Problems
	- The scanning that still needs human interaction
	- Energy reporting which is un-exportable.	
		- Solution: Creating applescript to copy and paste from instruments to excel automatically.
	- The bluetooth is not stable:
		- It always stops at 29 packets -> solution: using resubscribing method.
		- It has to be triggered by GNOME (GUI) Bluetooth management tool.

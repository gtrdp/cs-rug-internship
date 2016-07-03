-- Apple script to automate the copying and pasting process
-- from Apple's Instruments to Microsoft Excel.
-- (c) 2016 - Guntur DP - @gunturdputra

-- read all files
tell application "Finder"
	set fl to files of folder POSIX file "/Users/gtrdp/Documents/Rug/Computing Science/2016/Research Internship/energy benchmark/testing" as alias list
end tell

-- loop for each file
repeat with f in fl
	-- open the file
	tell application "Instruments"
		open f
		activate
		tell application "System Events"
			keystroke tab
			keystroke tab
		end tell
	end tell
	
	-- new file in excel
	tell application "Microsoft Excel"
		activate
		tell application "System Events"
			keystroke "n" using command down
		end tell
		select range ("B:B")
		
		-- change the format to text
		tell application "System Events"
			keystroke "1" using command down
			keystroke (ASCII character 31) -- down
			keystroke (ASCII character 31) -- down
			keystroke (ASCII character 31) -- down
			keystroke (ASCII character 31) -- down
			keystroke (ASCII character 31) -- down
			keystroke (ASCII character 31) -- down
			keystroke (ASCII character 31) -- down
			keystroke (ASCII character 31) -- down
			keystroke (ASCII character 31) -- down
			keystroke (ASCII character 31) -- down
			
			keystroke return
			keystroke (ASCII character 28) -- left
		end tell
	end tell
	
	-- main loop
	set i to 0
	set theBuffer to ""
	set theCurrent to ""
	
	-- copy first line at first
	tell application "Instruments" to activate
	tell application "System Events"
		keystroke "c" using command down
	end tell
	
	set theCurrent to (the clipboard as text)
	
	tell application "Microsoft Excel" to activate
	tell application "System Events"
		keystroke "v" using command down
		keystroke (ASCII character 30) -- up
		keystroke (ASCII character 31) -- down
		keystroke (ASCII character 31) -- down
	end tell
	
	-- continue to copy the rest of the row
	repeat while theBuffer is not equal to theCurrent or (theBuffer is equal to theCurrent and i < 20)
		tell application "Instruments" to activate
		tell application "System Events"
			keystroke (ASCII character 31) -- down
			keystroke "c" using command down
		end tell
		
		set theBuffer to theCurrent
		set theCurrent to (the clipboard as text)
		
		tell application "Microsoft Excel" to activate
		tell application "System Events"
			keystroke "v" using command down
			keystroke (ASCII character 30) -- up
			keystroke (ASCII character 31) -- down
			keystroke space using shift down
			keystroke "-" using control down
			keystroke (ASCII character 31) -- down
			keystroke (ASCII character 31) -- down
		end tell
		
		set i to i + 1
	end repeat
	
	-- close instruments
	tell application "Instruments"
		activate
		tell application "System Events"
			keystroke "w" using command down
		end tell
	end tell
	
	-- save excel and close
	tell application "Microsoft Excel"
		activate
		save active workbook
		tell application "System Events"
			keystroke "w" using command down
		end tell
	end tell
	
	-- done one loop
end repeat

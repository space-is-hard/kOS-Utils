//boot_kos_utils
//Created by space_is_hard, with help from TDW89
//This file is distributed under the terms of the MIT license


//This script is a multifunction utility script. It allows the user to select from
//multiple utilities that will continuously run during flight. It can be set as a boot
//script and is designed for ease-of-use.

CLEARSCREEN.
SET TERMINAL:WIDTH TO 64.
SET TERMINAL:HEIGHT TO 36.

//Open the terminal for the user.
CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").

//Header for our menu
PRINT "------------------------kOS Utility Menu------------------------".
PRINT "----------------------------------------------------------------".   //64 dashes to match terminal width

//Selection menu. Use OVR typing mode for easy editing.
PRINT "Please select the utilities you would like to run  |  I = Up    ".
PRINT "                                                   |  K = Down  ".
PRINT ">[ ]Panel Util - Opens solar panels when not       |  H = Select".
PRINT "                 in atmosphere. Closes panels when |____________".
PRINT "                 entering atmosphere.                           ".
PRINT "                                                                ".
PRINT " [ ]Gear Util - Raises landing gear and landing legs when above ".
PRINT "                100 meters radar altitude. Lowers gear and legs ".
PRINT "                when below 100 meters radar altitude.           ".
PRINT "                                                                ".
PRINT " [ ]Chutes Util - Arms parachutes when descending and when safe ".
PRINT "                  to do so. Will not open chutes if no          ".
PRINT "                  atmosphere is present. Stock chutes only.     ".
PRINT "                                                                ".
PRINT " [ ]RT Antenna Util - Opens RemoteTech extendible antennas when ".
PRINT "                      not in atmosphere and closes them when in ".
PRINT "                      atmosphere. Requires RemoteTech.          ".
PRINT "                                                                ".
PRINT " [ ]Empty Slot - Write your own utility and put it here!        ".
PRINT "                                                                ".
PRINT "                                                                ".
PRINT "                                                                ".
PRINT " [ ]Empty Slot - Write your own utility and put it here!        ".
PRINT "                                                                ".
PRINT "                                                                ".
PRINT "                                                                ".
PRINT " [ ]Empty Slot - Write your own utility and put it here!        ".
PRINT "                                                                ".
PRINT "                                                                ".
PRINT "                                                                ".
PRINT " [ ]RUN SELECTED UTILITIES                                      ".
PRINT "                                                                ".
PRINT "                                                                ".

//Variable to tell whether we're ready to run the main loop
SET selectionMade TO FALSE.

//Variable to tell whether we've just made an input. Will be set to false once an input
//is recognized, disallowing further input until no more input is recognized. This will
//keep the user from pressing down once and scrolling a bunch of times as the loop cycles
//faster than the user can let go of the key
SET inputMade TO FALSE.

//Variable to hold the current selection
SET currentSelection TO 1.

//A list that will hold which utilities we've selected
SET selectionList TO LIST(
    FALSE,  //Panel Util
    FALSE,  //Gear Util
    FALSE,  //Chutes Util
    FALSE,  //Antenna Util
    FALSE,  //Empty
    FALSE,  //Empty
    FALSE,  //Empty
    FALSE   //Run Utilities
).

//We'll call this function when we want to scroll down
FUNCTION scrollDown {
    
    //Clear the selector arrow from its current position
    PRINT " " AT(0, currentSelection * 4).  //Four lines between each selection
    
    //Increment our current selection, maximum selection of 8
    SET currentSelection TO MIN(currentSelection + 1, 8).
    
    //Print a new arrow at the next checkbox down
    PRINT ">" AT(0, currentSelection * 4).  //Four lines between each selection
    
}.

//We'll call this function when we want to scroll up
FUNCTION scrollUp {

    //Clear the selector arrow from its current position
    PRINT " " AT(0, currentSelection * 4).  //Four lines between each selection
    
    //Increment our current selection, maximum selection of 8
    SET currentSelection TO MAX(currentSelection - 1, 1).
    
    //Print a new arrow at the next checkbox up
    PRINT ">" AT(0, currentSelection * 4).  //Four lines between each selection

}.

//We'll call this function when we want to make a selection
FUNCTION makeSelection {
    
    //Check if the current selection is false
    IF selectionList[currentSelection - 1] = FALSE {    //Index starts at 0, hence "- 1"
        
        //Check it
        PRINT "X" AT(2, currentSelection * 4).  //Four lines between each selection
        
        //Change the list to reflect this
        SET selectionList[currentSelection - 1] TO TRUE.    //Index starts at 0, hence "- 1"
        
    //Do the opposite of above
    } ELSE {
        
        //Uncheck it
        PRINT " " AT(2, currentSelection * 4).  //Four lines between each selection
        
        //Change the list to reflect this
        SET selectionList[currentSelection - 1] TO FALSE.    //Index starts at 0, hence "- 1"
    
    }.
    
    //If the 'Run Utilities' option was the one selected, exit the menu loop and continue
    //on with the rest of the script
    IF selectionList[7] = TRUE {    //7 being the last item in our list of 8; 0 was the first
        
        //Exit the menu/selection loop and move on to the utility loop
        SET selectionMade TO TRUE.
        
    }.
    
}.

//This loop will check for menu inputs and perform the neccessary menu operations
UNTIL selectionMade = TRUE {
    
    //If the user has pressed 'up' and we're ready for a new input
    IF inputMade = FALSE AND SHIP:CONTROL:PILOTTOP < 0 {
        
        //Prevent the script from recognizing more inputs
        SET inputMade TO TRUE.
        
        //Call the scroll up function that we made earlier
        scrollUp().
        
    //If the user has pressed 'down' and we're ready for a new input
    } ELSE IF inputMade = FALSE AND SHIP:CONTROL:PILOTTOP > 0 {
        
        //Prevent the script from recognizing more inputs
        SET inputMade TO TRUE.
        
        //Call the scroll down function that we made earlier
        scrollDown().
        
    //If the user has pressed 'select' and we're ready for a new input
    } ELSE IF inputMade = FALSE AND SHIP:CONTROL:PILOTFORE > 0 {
        
        //Prevent the script from recognizing more inputs
        SET inputMade TO TRUE.
    
        //Call the selection function that we made earlier
        makeSelection().
        
    //If no inputs are recognized
    } ELSE {
        
        //No input detected, ready the loop for another input
        SET inputMade TO FALSE.
        
    }.
    
    //Keeps our loop from running too fast but still is able to keep up with the user's
    //potential for rapid keypresses
    WAIT 0.1.
    
}.

//From here, we want to prep the terminal for the utilities themselves
CLEARSCREEN.
SET TERMINAL:WIDTH TO 36.
SET TERMINAL:HEIGHT TO 18.

//And we'll print some info to the terminal to let the user know what's active
IF selectionList[0] = TRUE {
    PRINT "- Panel Utility Active".
}.

IF selectionList[1] = TRUE {
    PRINT "- Gear Utility Active".
}.

IF selectionList[2] = TRUE {
    PRINT "- Chute Utility Active".
}.

IF selectionList[3] = TRUE {

    //Since RemoteTech may not be installed, we'll check for it first
    IF ADDONS:RT:AVAILABLE = TRUE {
    
        PRINT "- RemoteTech Antenna Utility Active".
        
    //If it isn't installed, we'll say so and go ahead and disable that function
    } ELSE {

        PRINT "- RemoteTech not installed;".
        PRINT "  Antenna Utility Disabled".
    
        SET selectionList[3] TO FALSE.
        
    }.
    
}.

//Visual separator
PRINT "------------------------------------".

//The following functions will be used to perform the utilities. We'll initialize each
//function's variables just above the variable's parent function to keep things organized

//=====Panel Utility=====

//Variable to determine if we're in atmosphere or not. Assumes that we start out in atmo,
//but will get immediately corrected if not
SET inAtmo TO TRUE.

FUNCTION panelUtil {

	//Determines whether the vessel is in the atmosphere.
	IF SHIP:ALTITUDE < BODY:ATM:HEIGHT {
		
		//Only attempts to change the value if it's different than the current value
		IF inAtmo = FALSE {
			SET inAtmo TO TRUE.
			
			//Closes the panels
			PANELS OFF.
			
			//Informs the user that we're taking action
			HUDTEXT("Panel Utility: Entering Atmosphere; Closing Panels", 3, 2, 30, YELLOW, FALSE).
            PRINT "Closing Panels".
			
		}.
		
	} ELSE {
	
		//Only attempts to change the value if it's different than the current value
		IF inAtmo = TRUE {
			SET inAtmo TO FALSE.
			
			//Opens the panels
			PANELS ON.
			
			//Informs the user that we're taking action
			HUDTEXT("Panel Utility: Leaving Atmosphere; Opening Panels", 3, 2, 30, YELLOW, FALSE).
            PRINT "Opening Panels".
			
		}.
        
	}.
    
}.

//=====Gear Util=====

//Variable used to determine if we're below 100m. Assumes that we start out on the ground
//but will get immediately corrected if not
SET belowAlt TO TRUE.

FUNCTION gearUtil {

	//Determines whether the vessel is below 100m.
	IF ALT:RADAR < 100 {
		
		//Only attempts to change the value if it's different than the current value
		IF belowAlt = FALSE {
			SET belowAlt TO TRUE.
			
			//Lowers the gear and legs
			GEAR ON.
			LEGS ON.
			
			//Informs the user that we're taking action
			HUDTEXT("Gear Utility: Below 100m; Lowering Gear", 3, 2, 30, YELLOW, FALSE).
            PRINT "Lowering Gear and Legs".
			
		}.
		
	} ELSE {
	
		//Only attempts to change the value if it's different than the current value
		IF belowAlt = TRUE {
			SET belowAlt TO FALSE.
			
			//Lowers the gear and legs
			GEAR OFF.
			LEGS OFF.
			
			//Informs the user that we're taking action
			HUDTEXT("Gear Utility: Above 100m; Raising Gear", 3, 2, 30, YELLOW, FALSE).
            PRINT "Raising Gear and Legs".
			
		}.
        
	}.
    
}.

//=====Chutes Util=====

//List that we'll store all of the parachute parts in
SET chuteList TO LIST().

//Gets all of the parts on the craft
LIST PARTS IN partList.

//Goes over the part list we just made
FOR item IN partList {
    
    //Gets all of the modules of the part we're going over; local variable that gets
    //dumped every time the FOR loop is finished
    LOCAL moduleList TO item:MODULES.
    
    //Goes over moduleList to find the parachute module
    FOR module IN moduleList {
    
        //Checks the name of the module, and stores the part being gone over if the
        //parachute module shows up
        IF module = "ModuleParachute" {
        
            //Stores the part in the chuteList
            chuteList:ADD(item).
            
        }.
        
    }.
    
}.

FUNCTION chutesUtil {
    
    //Determines whether we're in atmosphere
    IF SHIP:ALTITUDE < BODY:ATM:HEIGHT {
        
        //Determines whether we're below 10km
        IF SHIP:ALTITUDE < 10000 {
            
            //Determines whether we're headed down or not, small margin included to
            //prevent the script from triggering while sitting on the launchpad
            IF SHIP:VERTICALSPEED < -1 {
                
                //Goes over the chute list
                FOR chute IN chuteList {
                    
                    //Checks to see if the chute is already deployed
                    IF chute:GETMODULE("ModuleParachute"):HASEVENT("Deploy Chute") {
                        
                        //Checks to see if the chute is safe to deploy
                        IF chute:GETMODULE("ModuleParachute"):GETFIELD("Safe To Deploy?") = "Safe" {
                            
                            //Deploy/arm this chute that has shown up as safe and ready
                            //to deploy
                            chute:GETMODULE("ModuleParachute"):DOACTION("Deploy", TRUE).
                            
                            //Inform the user that we did so
                            HUDTEXT("Chute Utility: Safe to deploy; Arming parachute", 3, 2, 30, YELLOW, FALSE).
                            
                        }.
                        
                    }.
                    
                }.
                
            }.
            
        }.
        
    }.
    
}.

//=====RT Antenna Util=====

//Variable to determine if we're in atmosphere or not. Assumes that we start out in atmo,
//but will get immediately corrected if not. Name altered so as to not conflict with
//the Panel Util's inAtmo variable.
SET RTinAtmo TO TRUE.

//List that we'll store all of the antenna parts in
SET antennaList TO LIST().

//Lists all of the parts on the ship. Name altered so as not to conflict with the chute
//util's part list
LIST PARTS IN RTpartList.

//Goes over the list of parts we just made
FOR item IN RTpartList {
    
    //Gets all of the modules of the part we're going over; local variable that gets
    //dumped every time the FOR loop is finished
    LOCAL moduleList TO item:MODULES.
    
    //Goes over moduleList to find the Remote Tech Antenna module
    FOR module IN moduleList {
    
        //Checks the name of the module, and moves on to check if it's extendible
        IF module = "ModuleRTAntenna" {
            
            //Checks to see if there's also a module for animation; this tells us if the
            //antenna is of the extendible type
            FOR module2 IN moduleList {
                
                IF module2 = "ModuleAnimateGeneric" {
        
                    //Stores the part in the chuteList
                    antennaList:ADD(item).
                    
                }.
            
            }.
            
        }.
        
    }.
    
}.

FUNCTION RTAntennaUtil {

	//Determines whether the vessel is in the atmosphere.
	IF SHIP:ALTITUDE < BODY:ATM:HEIGHT {
		
		//Only attempts to change the value if it's different than the current value
		IF RTinAtmo = FALSE {
			SET RTinAtmo TO TRUE.
			
			//Goes over our previously-built antenna list
			FOR antenna IN antennaList {
                
                //Closes the antenna
                antenna:GETMODULE("ModuleRTAntenna"):DOACTION("Deactivate", TRUE).  //TEST:
                
            }.
			
			//Informs the user that we're taking action
			HUDTEXT("RT Antenna Utility: Entering Atmosphere; Closing Antennas", 3, 2, 30, YELLOW, FALSE).
            PRINT "Closing Antennas".
			
		}.
		
	} ELSE {
	
		//Only attempts to change the value if it's different than the current value
		IF RTinAtmo = TRUE {
			SET RTinAtmo TO FALSE.
			
			//Goes over our previously-built antenna list
			FOR antenna IN antennaList {
                
                //Opens the antenna
                antenna:GETMODULE("ModuleRTAntenna"):DOACTION("Activate", TRUE).  //TEST:
                
            }.
            
			//Informs the user that we're taking action
			HUDTEXT("RT Antenna Utility: Leaving Atmosphere; Opening Antennas", 3, 2, 30, YELLOW, FALSE).
            PRINT "Opening Antennas".
			
		}.
        
	}.
    
}.

//This will be the main operation loop. Each cycle, it will perform the utilities that
//were selected in the menu loop and set using the selection list. The loop will never
//exit unless the user CTRL+C's the program.
UNTIL 1 = 2 {
    
    IF selectionList[0] = TRUE {
        
        panelUtil().
        
    }.
    
    IF selectionList[1] = TRUE {
    
        gearUtil().
        
    }.
    
    IF selectionList[2] = TRUE {
        
        chutesUtil().
        
    }.
    
    IF selectionList[3] = TRUE {
        
        RTAntennaUtil().
        
    }.
    
    IF selectionList[4] = TRUE {
        
        //Empty slot
        
    }.
    
    IF selectionList[5] = TRUE {
        
        //Empty slot
        
    }.
    
    IF selectionList[6] = TRUE {
        
        //Empty Slot
        
    }.
    
    //Index number 7 was our checkbox for running the utilities
    
    //Small wait to keep our script from running multiple times per physics tick
    WAIT 0.01.
    
}.

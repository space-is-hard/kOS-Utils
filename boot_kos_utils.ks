//boot_kos_utils
//Created by space_is_hard
//Additional functions provided by TDW89
//This file is distributed under the terms of the MIT license

//This script is a multifunction utility script. It allows the user to select from
//multiple utilities that will continuously run during flight. It can be set as a boot
//script and is designed for ease-of-use.

SET versionNumber TO "v1.3".

CLEARSCREEN.
SET TERMINAL:WIDTH TO 64.
SET TERMINAL:HEIGHT TO 44.

//Open the terminal for the user.
CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").

//Header for our menu
PRINT "------------------------kOS Utility Menu------------------------".   //Line 0
PRINT "----------------------------------------------------------------".   //64 dashes to match terminal width

//Selection menu. Use OVR typing mode for easy editing.
PRINT "Please select the utilities you would like to run  |  I = Up    ".
PRINT "                                                   |  K = Down  ".
PRINT ">[ ]Panel Util - Opens solar panels when not       |  H = Select".   //Line 4
PRINT "                 in atmosphere. Closes retractable |____________".
PRINT "                 panels when entering atmosphere.               ".
PRINT "                                                                ".
PRINT " [ ]Gear Util  - Raises landing gear and landing legs when above".   //Line 8
PRINT "                 100 meters radar altitude. Lowers gear and legs".
PRINT "                 when below 100 meters radar altitude.          ".
PRINT "                                                                ".
PRINT " [ ]Chutes     - Arms parachutes when descending and when safe  ".   //Line 12
PRINT "      Util       to do so. Will not open chutes if no           ".
PRINT "                 atmosphere is present. Stock chutes only.      ".
PRINT "                                                                ".
PRINT " [ ]RT Antenna - Opens RemoteTech extendible antennas when not  ".   //Line 16
PRINT "          Util   in atmosphere and closes them when in          ".
PRINT "                 atmosphere. Requires RemoteTech.               ".
PRINT "                                                                ".
PRINT " [ ]Fairing    - Jettisons fairings when above 95% atmosphere   ".   //Line 20
PRINT "       Util      height. It is done at 95% to avoid smashing    ".
PRINT "                 solar panels if the Panels Util is selected.   ".
PRINT "                                                                ".
PRINT " [ ]LES Util   - Jettisons the Launch Escape System when above  ".   //Line 24
PRINT "                 the atmosphere or 3 secs after an abort if the ".
PRINT "                 LES is attached via decoupler or docking port. ".
PRINT "                                                                ".
PRINT " [ ]Autobrake  - Automatically turns on the wheel brakes        ".   //Line 28
PRINT "         Util    and air brakes when on the ground and the      ".
PRINT "                 throttle is zero. Lets them go otherwise.      ".
PRINT "                                                                ".
PRINT " [ ]Empty Slot - Write your own utility and put it here!        ".   //Line 32
PRINT "                                                                ".
PRINT "                                                                ".
PRINT "                                                                ".
PRINT " [ ]Empty Slot - Write your own utility and put it here!        ".   //Line 36
PRINT "                                                                ".
PRINT "                                                                ".
PRINT "                                                                ".
PRINT " [ ]RUN SELECTED UTILITIES                                      ".   //Line 40
PRINT "                                                                ".
PRINT versionNumber.

//Variable to tell whether we're ready to exit the selection loop
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
    FALSE,  //Fairing Util
    FALSE,  //LES Util
    FALSE,  //Autobrake Util
    FALSE,  //Empty Slot
    FALSE,  //Empty Slot
    FALSE   //Run Utilities
).

//We'll call this function when we want to scroll down
FUNCTION scrollDown {
    
    //Clear the selector arrow from its current position
    PRINT " " AT(0, currentSelection * 4).  //Four lines between each selection
    
    //Increment our current selection
    SET currentSelection TO MOD(currentSelection + selectionList:length , selectionList:length) + 1.
    
    //Print a new arrow at the next checkbox down
    PRINT ">" AT(0, currentSelection * 4).  //Four lines between each selection
    
}.

//We'll call this function when we want to scroll up
FUNCTION scrollUp {

    //Clear the selector arrow from its current position
    PRINT " " AT(0, currentSelection * 4).  //Four lines between each selection
    
    //Decrement our current selection
    SET currentSelection TO MOD(currentSelection + selectionList:length - 2, selectionList:length) + 1.
    
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
    IF selectionList[selectionList:LENGTH - 1] = TRUE {    //Last item in the list will be the "Run" option
        
        //Exit the menu/selection loop and move on to the utility loop
        SET selectionMade TO TRUE.
        
    }.
    
}.

//This loop will check for menu inputs and perform the necessary menu operations
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
    } ELSE IF inputMade = TRUE
        AND SHIP:CONTROL:PILOTTOP = 0 
        AND SHIP:CONTROL:PILOTFORE = 0 {
        
        //No input detected, ready the loop for another input
        SET inputMade TO FALSE.
        
    }.
    
    //Keeps our loop from running too fast but still is able to keep up with the user's
    //potential for rapid keypresses
    WAIT 0.01.
    
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

IF selectionList[4] = TRUE {
    PRINT "- Fairing Utility Active".
}.

IF selectionList[5] = TRUE {
    PRINT "- LES Utility Active".
}.

IF selectionList[6] = TRUE {
    PRINT "- Autobrake Utility Active".
}.

//Visual separator
PRINT "-------------------------------" + versionNumber.

//The following functions will be used to perform the utilities. We'll initialize each
//function's variables just above the variable's parent function to keep things organized

//=====Panel Utility=====
//by space_is_hard

//This variable will allow us to track the status of the panels since we can't get
//their status
SET panelsOpen TO FALSE.

FUNCTION panelUtil {
    
    //Only performs the checks within if the panels aren't already open
    IF NOT panelsOpen {
        
        //Checks if we're out of the atmosphere
        IF SHIP:ALTITUDE > BODY:ATM:HEIGHT {
            
            //Opens the panels
            PANELS ON.
            
            //Changes the variable so we can track the status of the panels
            SET panelsOpen TO TRUE.
            
            //Informs the user that we're taking action
            HUDTEXT("Panel Utility: Leaving Atmosphere; Opening Panels", 3, 2, 30, YELLOW, FALSE).
            PRINT "Opening Panels".
            
        }.
        
        //Checks if we're landed and stationary
        IF SHIP:STATUS = "Landed" AND SHIP:VELOCITY:SURFACE:MAG < 0.01 {
            
            //Opens the panels
            PANELS ON.
            
            //Changes the variable so we can track the status
            SET panelsOpen TO TRUE.
            
            //Informs the user that we're taking action
            HUDTEXT("Panel Utility: Landed and stationary; Opening Panels", 3, 2, 30, YELLOW, FALSE).
            PRINT "Opening Panels".
            
        }.
        
    //Only performs the checks within if the panels are already open
    } ELSE IF panelsOpen {
        
        //Checks to see if we're in the atmosphere; doesn't close the panels if we're
        //stationary to prevent it and the stationary check from fighting for control of
        //the panels.
        IF SHIP:ALTITUDE < BODY:ATM:HEIGHT 
            AND SHIP:VELOCITY:SURFACE:MAG >= 0.01 {
            
            //Closes the panels
            PANELS OFF.
            
            //Changes the variable so we can track the status of the panels
            SET panelsOpen TO FALSE.
            
            //Informs the user why we're taking action based on which situation we're in
            IF SHIP:STATUS = "Landed" {
                
                //If we're landed, we're probably starting to move from a standstill
                HUDTEXT("Panel Utility: Landed and moving; Closing Panels", 3, 2, 30, YELLOW, FALSE).
                PRINT "Closing Panels".
                
            } ELSE {
                
                //If we're not landed, we're probably re-entering
                HUDTEXT("Panel Utility: Entering Atmosphere; Closing Panels", 3, 2, 30, YELLOW, FALSE).
                PRINT "Closing Panels".
                
            }.
            
        }.
    
    }.
    
}.

//=====Gear Util=====
//by space_is_hard

//Variable used to determine if we're below 100m. Assumes that we start out on the ground
//but will get immediately corrected if not
SET belowAlt TO TRUE.

FUNCTION gearUtil {

    //Determines whether the vessel is below 100m. Only attempts to change the value if
    //it's different than the current value
    IF ALT:RADAR < 100 {
        
        IF NOT belowAlt {
        
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
//by space_is_hard

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
    
    //Determines whether we're in atmosphere, and below 10km, and descending
    IF SHIP:ALTITUDE < BODY:ATM:HEIGHT 
        AND SHIP:ALTITUDE < 10000
        AND SHIP:VERTICALSPEED < -1 {
        
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

//=====RT Antenna Util=====
//by space_is_hard
//Variable to keep track of whether we've opened the antennas or not
SET antennasOpen TO FALSE.

//List that we'll store all of the antenna parts in
SET antennaList TO LIST().

//Goes over all of the modules on the entire ship, and lists the ones named
//"ModuleRTAntenna" in a list called "RTmodule". This should produce a list of all of the
//RemoteTech antenna modules
FOR RTmodule IN SHIP:MODULESNAMED("ModuleRTAntenna") {
    
    //Checks to see if the part that the antenna module is attached to *also* contains
    //an animation module
    IF RTmodule:PART:MODULES:CONTAINS("ModuleAnimateGeneric") {
        
        //If so, it adds that part to the antenna list
        antennaList:ADD(RTmodule:PART).
        
    }.
    
}.

FUNCTION RTAntennaUtil {
    
    //Only performs the checks within if the antennas aren't already open
    IF NOT antennasOpen {
        
        //Checks if we're out of the atmosphere
        IF SHIP:ALTITUDE > BODY:ATM:HEIGHT {
            
            //Goes over our previously-built antenna list
            FOR antenna IN antennaList {
                
                //Opens each antenna
                antenna:GETMODULE("ModuleRTAntenna"):DOACTION("Activate", TRUE).
                
            }.
            
            //Changes the variable so we can track the status of the panels
            SET antennasOpen TO TRUE.
            
            //Informs the user that we're taking action
            HUDTEXT("RT Antenna Utility: Leaving Atmosphere; Opening Antennas", 3, 2, 30, YELLOW, FALSE).
            PRINT "Opening Antennas".
            
        }.
        
        //Checks if we're landed and stationary
        IF SHIP:STATUS = "Landed" AND SHIP:VELOCITY:SURFACE:MAG < 0.1 {
            
            //Goes over our previously-built antenna list
            FOR antenna IN antennaList {
                
                //Opens each antenna
                antenna:GETMODULE("ModuleRTAntenna"):DOACTION("Activate", TRUE).
                
            }.
            
            //Changes the variable so we can track the status
            SET antennasOpen TO TRUE.
            
            //Informs the user that we're taking action
            HUDTEXT("RT Antenna Utility: Landed and Stationary; Opening Antennas", 3, 2, 30, YELLOW, FALSE).
            PRINT "Opening Antennas".
            
        }.
        
    //Only performs the checks within if the antennas are already open
    } ELSE IF antennasOpen {
        
        //Checks to see if we're in the atmosphere; doesn't close the antennas if we're
        //stationary to prevent it and the stationary check from fighting for control of
        //the antennas.
        IF SHIP:ALTITUDE < BODY:ATM:HEIGHT 
            AND SHIP:VELOCITY:SURFACE:MAG >= 0.1 {
            
            //Goes over our previously-built antenna list
            FOR antenna IN antennaList {
                
                //Closes the antenna
                antenna:GETMODULE("ModuleRTAntenna"):DOACTION("Deactivate", TRUE).
                
            }.
            
            //Changes the variable so we can track the status of the antennas
            SET antennasOpen TO FALSE.
            
            //Informs the user why we're taking action based on which situation we're in
            IF SHIP:STATUS = "Landed" {
                
                //If we're landed, we're probably starting to move from a standstill
                HUDTEXT("RT Antenna Utility: Landed and moving; Closing Antennas", 3, 2, 30, YELLOW, FALSE).
                PRINT "Closing Antennas".
                
            } ELSE {
                
                //If we're not landed, we're probably re-entering
                HUDTEXT("RT Antenna Utility: Entering Atmosphere; Closing Antennas", 3, 2, 30, YELLOW, FALSE).
                PRINT "Closing Antennas".
                
            }.
            
        }.
    
    }.
    
}.

//=====Fairing Util=====
//by TDW89


FUNCTION fairingUtil {

    // This uses 95% of the atmosphere height so that it happens before the solar panels start to deploy.
    IF SHIP:ALTITUDE > 0.95 * BODY:ATM:HEIGHT {

        // Iterates over a list of all parts with the stock fairings module
        FOR module IN SHIP:MODULESNAMED("ModuleProceduralFairing") { // Stock and KW Fairings

            // and deploys them
            module:DOEVENT("deploy").
            HUDTEXT("Fairing Utility: Aproaching edge of atmosphere; Deploying Fairings", 3, 2, 30, YELLOW, FALSE).
            PRINT "Deploying Fairings".

        }.

        // Iterates over a list of all parts using the fairing module from the Procedural Fairings Mod
        FOR module IN SHIP:MODULESNAMED("ProceduralFairingDecoupler") { // Procedural Fairings
        
            // and jettisons them (PF uses the word jettison in the right click menu instead of deploy)
            module:DOEVENT("jettison").
            HUDTEXT("Fairing Utility: Approaching edge of atmosphere; Jettisoning Fairings", 3, 2, 30, YELLOW, FALSE).
            PRINT "Jettisoning Fairings".
            
        }.

        // Deploying fairings is a one time thing so it disables the module after running it
        SET selectionList[4] TO FALSE.
        PRINT "Fairings Utility disabled".

    }.

}.

//=====LES Util=====
//by TDW89

//We'll use this variable to track when the abort command was issued. We'll set it to a
//bogus value to help with debugging. This will also let us check to see if the timer has
//been set, as the game's Universal Time is never below 0.
SET abortTimer TO -1.

FUNCTION LESUtil {
    
    //Here we'll check if the abort action group has been triggered and if it's the first
    //time we've triggered it since running the script
    IF ABORT AND abortTimer < 0 {
        
        //And here we'll set the abort timer to our current time
        SET abortTimer TO TIME:SECONDS.
        
        //And we'll let the user know that we've detected a manual abort
        HUDTEXT("LES Util: Manual abort detected; standby for LES jettison", 3, 2, 30, YELLOW, FALSE).
        PRINT "Manual abort detected".
        
    }.

    // Is the vessel above the atmosphere, or are we three seconds past a detected manual abort?
    IF SHIP:ALTITUDE > BODY:ATM:HEIGHT OR (abortTimer > 0 AND TIME:SECONDS > abortTimer + 3) {
        
        // Iterates over a list of all parts with the name "LaunchEscapeSystem" (the stock LES)
        FOR les IN SHIP:PARTSNAMED("LaunchEscapeSystem") {
            
            // Sets the point part that will detach the LES to the part the LES is attached to
            LOCAL detach_part IS les:PARENT.
            
            // Then if that part is not capable of detaching it continues up the part tree until
            // it finds a valid part or a part with resources or it gets to the root part and cant go any further
            UNTIL detach_part:MODULES:CONTAINS("ModuleDockingNode")         //the LES is attached via a docking node
                OR detach_part:MODULES:CONTAINS("ModuleAnchoredDecoupler")  //the LES is attached via a decoupler
                OR detach_part:MODULES:CONTAINS("ModuleDecouple")           //the LES is attached via a stack separator
                OR NOT detach_part:RESOURCES:EMPTY                          //the LES is attached to a resource containing part and wont be jettisoned
                OR detach_part = SHIP:ROOTPART                              //the root part has no parent so needs to be protected against.
            {
                
                SET detach_part TO detach_part:PARENT.
                
            }.

            // If it is a docking port...
            IF detach_part:MODULES:CONTAINS("ModuleDockingNode") {
                
                // ...it triggers the LES engine...
                les:GETMODULE("ModuleEnginesFX"):DOACTION("activate engine",TRUE).
                
                // ...then undocks it
                detach_part:GETMODULE("ModuleDockingNode"):DOEVENT("decouple node").
                
                //Informs the user that we just took action
                HUDTEXT("LES Utility: Leaving Atmosphere; Jettisoning LES", 3, 2, 30, YELLOW, FALSE).
                PRINT "Jettisoning LES".
                
            // If it is a decoupler...
            } ELSE IF detach_part:MODULES:CONTAINS("ModuleAnchoredDecoupler") {
                
                // ...it triggers the LES engine...
                les:GETMODULE("ModuleEnginesFX"):DOACTION("activate engine",TRUE).
                
                // ...then decouples it
                detach_part:GETMODULE("ModuleAnchoredDecoupler"):DOEVENT("decouple").
                
                HUDTEXT("LES Utility: Leaving Atmosphere; Jettisoning LES", 3, 2, 30, YELLOW, FALSE).
                PRINT "Jettisoning LES".
                
            } ELSE IF detach_part:MODULES:CONTAINS("ModuleDecouple") {
                
                // ... it triggers the LES engine...
                les:GETMODULE("ModuleEnginesFX"):DOACTION("activate engine",TRUE).
                
                // ... then separates it
                detach_part:GETMODULE("ModuleDecouple"):DOEVENT("decouple").
                
                HUDTEXT("LES Utility: Leaving Atmosphere; Jettisoning LES", 3, 2, 30, YELLOW, FALSE).
                PRINT "Jettisoning LES".
                
            } ELSE {
                
                HUDTEXT("LES Utility: [ERR] Unable to identify point to separate from.", 3, 2, 30, RED, FALSE).
                PRINT "LES Utility error; no valid means of detaching found".
                
            }.

        }.
        
        // This is a one use utility so it disables the module after running
        SET selectionList[5] to FALSE.
        PRINT "LES Utility disabled".
        
    }.
    
}.

//=====Autobrake Util=====
//by space_is_hard

//This variable will be used to track if the Autobrake Util is the one triggering the
//brakes. This will prevent the util from turning off the brakes when the user wants them
//on or vice versa
SET autoBrake TO FALSE.

FUNCTION autoBrakeUtil {
    
    //If we're landed, the throttle is zero, the brakes aren't already on, and the
    //autobrake utility has not already tried to turn on the brakes
    IF SHIP:STATUS = "Landed"
        AND SHIP:CONTROL:PILOTMAINTHROTTLE = 0
        AND NOT BRAKES
        AND autoBrake = FALSE {
    
        BRAKES ON.
        
        //We'll note that the utility is the one activating the brakes instead of the
        //user
        SET autoBrake TO TRUE.
        
        //And then we'll notify the user that we're taking action
        HUDTEXT("Autobrake Util: Brakes on", 3, 2, 30, YELLOW, FALSE).
        PRINT "Autobrakes on".
        
    //If we detect liftoff or an increase in throttle, we'll let go of the brakes, but
    //not if the user has deactivated the brakes manually (we don't want to override the
    //user)
    } ELSE IF (
            SHIP:STATUS <> "Landed"
            OR SHIP:CONTROL:PILOTMAINTHROTTLE > 0
        )
        AND BRAKES
        AND autoBrake = TRUE {
        
        BRAKES OFF.
        
        //We'll note that the utility is no longer trying to activate the brakes
        SET autoBrake TO FALSE.
        
        //And then we'll notify the user that we're taking action
        HUDTEXT("Autobrake Util: Brakes off", 3, 2, 30, YELLOW, FALSE).
        PRINT "Autobrakes off".
        
    }.
    
}.

//=====Empty Slot [7]=====

//=====Empty Slot [8]=====

//=====Auto Low Charge Shutdown=====
//by space_is_hard

//This function is always-on, and designed to prevent the kOS core from eating up all of
//the electric charge on a ship, leaving it stranded with no power. It shuts off the core
//when the ship is below 10% power capacity and the charge rate is falling. There is no
//way to turn the core back on via code, it will have to be done manually. Once turned
//back on, the user will have to re-select the desired utilities.

//We'll use this variable to track the previous level of electric charge.
//`SHIP:ELECTRICCHARGE` is a bound variable; a shortcut that can only get us the current
//amount of charge on the ship. We'll set it now and update it every loop.
SET previousCharge TO SHIP:ELECTRICCHARGE.

//We'll use this variable as a flag to let us know if we've already issued a warning about
//low power. We'll flip it to true once the power dips below 15% and we issue the hudtext
//warning to the user
SET lowPowerFlag TO FALSE.

FUNCTION lowChargeShutdown {
    
    //Here, we'll list all of the consumable resources on the entire ship
    LIST RESOURCES IN resourceList.
    
    //We'll then go over every one..
    FOR resource IN resourceList {
        
        //And find the one named "ElectricCharge"
        IF resource:NAME = "ElectricCharge" {
            
            //We'll only perform the shutdown if the charge is both below 10% of the
            //ship's capacity *and* if the current charge is less than it was the last
            //time we performed this function. This tells us if it's decreasing.
            IF resource:AMOUNT / resource:CAPACITY <= 0.1 AND resource:AMOUNT < previousCharge {
                
                //Shuts down the core that we're running the code on
                CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Toggle Power").
                
                //Informs the user of the action we took
                HUDTEXT("kOS Utils: Low power, shutting down", 3, 2, 30, RED, FALSE).
                PRINT "Low power, shutting down".
                
            }.
            
            //If our flag is still false and the power is below 15% and falling
            IF NOT lowPowerFlag
                AND resource:AMOUNT / resource:CAPACITY <= 0.15
                AND resource:AMOUNT < previousCharge {
                
                //Inform the user that the power is low
                HUDTEXT("kOS Utils: Low power", 3, 2, 30, YELLOW, FALSE).
                PRINT "Low power, <15% and falling".
                
                //Set our flag to true so that we don't keep warning the user every time
                //the loop cycles
                SET lowPowerFlag TO TRUE.
                
            //If we're above 15% power, flip the flag back to false so we know to
            //warn the user next time it drops below 15%
            } ELSE IF resource:AMOUNT / resource:CAPACITY > 0.15 {
                
                SET lowPowerFlag TO FALSE.
                
            }.
            
        }.
        
    }.
    
    //Stores the current charge in this variable so that we can check it the next time 
    //that we run the function. The `WAIT` in the main loop will ensure that the next
    //time we poll this variable occurs in a new physics tick.
    SET previousCharge TO SHIP:ELECTRICCHARGE.
    
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
        
        fairingUtil().
        
    }.
    
    IF selectionList[5] = TRUE {
        
        LESUtil().
        
    }.
    
    IF selectionList[6] = TRUE {
        
        autoBrakeUtil().
        
    }.
    
    //IF selectionList[7] = TRUE {
        
        //Empty Slot
        
    //}.
    
    //IF selectionList[8] = TRUE {
        
        //Empty Slot
        
    //}.
    
    //Index number 9 was our checkbox for running the utilities
    
    lowChargeShutdown().
    
    //Small wait to keep our script from running multiple times per physics tick
    WAIT 0.01.
    
}.

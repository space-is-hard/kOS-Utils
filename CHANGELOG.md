#kOS Utils Changelog

##v1.2
* Adjusted selection menu loop time for better responsiveness
* Functionality added to panel util and RT antenna util to allow each to open when the vessel is landed and travelling below 10m/s
* Optimized RT antenna util's setup
* Implemented a function that shuts down the kOS core if the vessel's electric charge is below 10% capacity and falling

##v1.1
* Added small `WAIT` to utility loop to prevent it from running multiple times per physics tick
* Selection menu now loops back to start when scrolling past the last selection (TDW89)
* Added Fairing Util and LES Util (TDW89)
* Added Autobrake Util
* Extended selection menu length to 9 total utils, 7 are active and 2 are empty
* General optimization

##v1.0
* Initial Release

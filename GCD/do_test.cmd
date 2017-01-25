#!/bin/csh -f

if ($#argv == 0) then
    echo "Usage ./do_test.cmd [Test Name] [args...]"
    exit(1)
endif

#Test case name
set tc_name = $argv[1]
if ($#argv > 1) then
	set args    = $#argv	
	set j = 2 # tc_name is already parsed!
	set flags = ""
	while ( $j <= $args )
	    switch ($argv[$j])
	        case [gG][uU][iI]:
                set flags = "$flags -gui"
                breaksw
	        case [rR][aA][nN][dD]:
                set flags = "$flags -svseed random"
                breaksw
	        case [cC][oO][vV]:
                set flags = "$flags -coverage functional -covoverwrite -covfile ${SCRIPTS_DIR}/cov_config.ccf"
                breaksw
	        case [dD][bB][gG]:
                set flags = "$flags -linedebug"
                breaksw
	        default:
	            echo "Invalid argument $argv[$j]"
	            exit(1)
	       endsw
	  @ j++
	end
    irun +access+rwc $tc_name $flags
else
   irun +access+rwc $tc_name 
endif

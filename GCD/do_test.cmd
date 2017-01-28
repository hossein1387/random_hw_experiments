#!/bin/csh -f

#Test case name
if ($#argv >= 1) then
	set args    = $#argv	
	set j = 1 
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
    if ( -f files.f) then 
        set flags = "$flags -f files.f"
    endif
    echo "flags = $flags"
    irun +access+rwc $flags
else
    if ( -f files.f) then
        irun +access+rwc -f files.f
    else
        echo "Usage ./do_test.cmd [Test Name] [args...]"
        exit(1)
    endif
endif

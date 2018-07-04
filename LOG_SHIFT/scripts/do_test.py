#!/usr/bin/env python2

import os
import sys
import argparse
import subprocess

#=======================================================================
# Globals
#=======================================================================
simulator = None
result_dir = "../results"

#=======================================================================
# Utility Funcs
#=======================================================================
def run_simulator_command(command_str):
        try:
            print_log(command_str)
            # subprocess needs to receive args seperately
            subprocess.call(command_str.split())
        except OSError as e:
            print_log("ERROR: Unable to run {0} commands".format(simulator), "ERROR")
            sys.exit()

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--simulator', help='Simulator to use', required=True)
    parser.add_argument('-f', '--files', help='Simulation files', required=True)
    parser.add_argument('-t', '--top_level', help='Top level module for Xilinx tools', required=False)
    parser.add_argument('-g', '--gui', action='store_true', help=' gui mode supported in cadence irun only', required= False)
    parser.add_argument('-v', '--svseed', help=' sv seed supported in cadence irun only', required= False)
    parser.add_argument('-c', '--coverage', action='store_true', help='add coverage supported in cadence irun only', required= False)
    parser.add_argument('-d', '--debug', action='store_true', help='create debug info supported in cadence irun only', required= False)
    args = parser.parse_args()
    return vars(args)

def print_log(log_str, ID_str="INFO"):
    print("[{0}]   {1}".format(ID_str, log_str))

def print_banner(banner_str):
    print_log("=======================================================================")
    print_log(banner_str)
    print_log("=======================================================================")

#=======================================================================
# Main
#=======================================================================
if __name__ == '__main__':
    cmd_to_run = ""
    args = parse_args()
    simulator = args['simulator']
    top_level = args['top_level']
    files = args['files']
    gui = args['gui']
    svseed = args['svseed']
    coverage = args['coverage']
    debug = args['debug']
    if not os.path.exists(result_dir):
        print("Creating a result directory in {0}".format(result_dir))
        os.makedirs(result_dir)
    if simulator.lower() == "xilinx":
        # For Xilinx tools we need to specify top level for creating snapshots which is needed
        # by simulator and synthesis tools
        if top_level == None:
            print_log("Top level was not specified", "ERROR")
            sys.exit()

        print_banner("Compiling input files")
        cmd_to_run = "xvlog --sv -f {0}".format(files)
        run_simulator_command(cmd_to_run)

        print_banner("Creating snapshot")
        cmd_to_run = "xelab {0}".format(top_level)
        run_simulator_command(cmd_to_run)

        print_banner("Running simulation")
        cmd_to_run = "xsim -R {0}".format(top_level)
        run_simulator_command(cmd_to_run)

    elif simulator.lower() == "iverilog":
        print_banner("Running iverilog Simulation")
        cmd_to_run = "iverilog \'-Wall\' \'-g2012\' -f {0} && unbuffer vvp {1}/result.out".format(files, result_dir)
        run_simulator_command(cmd_to_run)
    elif simulator.lower() == "irun":
        iruns_args = ""
        print_banner("Running Cadence irun Simulation")
        if gui:
            iruns_args += "gui "
        if svseed:
            iruns_args += "svseed {0} ".format(svseed)
        if coverage:
            iruns_args += "coverage "
        if debug:
            iruns_args += "debug "
        cmd_to_run = "irun +access+rwc -f {0} {1}".format(files, iruns_args)
        run_simulator_command(cmd_to_run)
        



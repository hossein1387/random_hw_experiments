#include <fstream>
#include <iostream>
#include "verilated_toplevel.h"
#include "verilator_sim_ctrl.h"


int main(int argc, char** argv, char** env) {
    Verilated::commandArgs(argc, argv);

    // Instantiate the Verilated model
    simple_tb* tb = new simple_tb;


    // Initialize lowRISC's verilator utilities
    VerilatorSimCtrl &simctrl = VerilatorSimCtrl::GetInstance();
    simctrl.SetTop(tb, &tb->clk, &tb->rst,
                    VerilatorSimCtrlFlags::ResetPolarityNegative);

    simctrl.SetInitialResetDelay(5);
    simctrl.SetResetDuration(5);

    bool exit_app = false;
    int ret_code = simctrl.ParseCommandArgs(argc, argv, exit_app);
    if (exit_app) {
        return ret_code;
    }

    std::cout << "Simulation of Ara" << std::endl
                << "=================" << std::endl
                << std::endl;

    simctrl.RunSimulation();

    return 0;

    // Create VCD trace file
    // VerilatedVcdC* tfp = new VerilatedVcdC;
    // Verilated::traceEverOn(true);
    // top->trace(tfp, 99);
    // tfp->open("simple_tb.vcd");

    // // Simulation time
    // int sim_time = 0;

    // // Initial reset
    // top->rst = 1;
    // top->clk = 0;

    // // Run simulation
    // while (sim_time < 200) {
    //     if (sim_time == 10) {
    //         top->rst = 0; // Deassert reset
    //     }

    //     // Toggle clock
    //     top->clk = !top->clk;

    //     // Evaluate model
    //     top->eval();
    //     tfp->dump(sim_time);

    //     sim_time++;
    // }

    // // Cleanup
    // tfp->close();
    // delete top;
    // delete tfp;

    return 0;
}
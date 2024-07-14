#include <fstream>
#include <iostream>

#include "verilated_toplevel.h"
#include "verilator_sim_ctrl.h"

int main(int argc, char **argv) {
  // Create an instance of the DUT
  testbench *tb = new testbench;

  // Initialize lowRISC's verilator utilities
  VerilatorSimCtrl &simctrl = VerilatorSimCtrl::GetInstance();
  simctrl.SetTop(tb, &tb->clk_i, &tb->rst_ni,
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

  return tb->dut().exit_o >> 1;
}

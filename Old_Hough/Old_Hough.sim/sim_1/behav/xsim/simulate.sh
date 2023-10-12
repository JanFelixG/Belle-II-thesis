#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2022.2.2 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Mon Sep 11 10:12:01 CEST 2023
# SW Build 3788238 on Tue Feb 21 19:59:23 MST 2023
#
# IP Build 3783773 on Tue Feb 21 23:41:56 MST 2023
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# simulate design
echo "xsim hough_sim1_behav -key {Behavioral:sim_1:Functional:hough_sim1} -tclbatch hough_sim1.tcl -log simulate.log"
xsim hough_sim1_behav -key {Behavioral:sim_1:Functional:hough_sim1} -tclbatch hough_sim1.tcl -log simulate.log


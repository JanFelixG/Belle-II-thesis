library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package main_functions is

type t_cluster_element is record --create cluster element for each cell connected to maximum
value : integer range 0 to 255; --is 0 for 0, 1 otherwise --could be changed
cluster_label : integer range 0 to 3; --maximum of 3 clusters are searched for --4320 if local maxima search is used
end record;
type t_cluster_element_array is array(integer range <>,integer range <>,integer range <>) of t_cluster_element;

type t_Hough_array is array(integer range <>,integer range <>,integer range <>) of integer range 0 to 255; --duplicate here
type t_maximum is array(0 to 2) of integer;
type t_energy is array(0 to 3) of integer;

type bus_array is array(integer range <>) of integer range 0 to 7; --switch to integer
type detector_array is array(integer range <>) of integer range 0 to 2335; --switch to integer

type t_trackgsegments_ids is array (0 to 89) of std_logic_vector(6 downto 0); --defined like that for current hough-map

type t_cluster_element_array_1D is array(integer range <>) of t_cluster_element;

type t_neural_input is array (0 to 4) of std_logic_vector(15 downto 0);

type CoG_array_3D is array(0 to 2) of integer; --CoG only on voxels not in between

end package;





library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package Hough_vectors is
--use fixed values here
constant c_num_detectors : integer := 2334; --number of detectors/track-segments
constant c_hough_size : integer := 4320; --number of entries in Hough-map
type hough_parameter_array is array(0 to c_num_detectors-1) of std_logic_vector(c_hough_size-1 downto 0);--use fixed range later
--write values into array here
constant c_Hough_vectors : hough_parameter_array := (others=>(others=>'0')); -- := put in numbers

end package;
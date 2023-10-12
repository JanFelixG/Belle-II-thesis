library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package Cluster_functions2 is

type t_cluster_element is record --create cluster element for each cell connected to maximum
--core : std_logic; --might need less lut resources on check
value : integer range 0 to 255; --is 0 for 0, 1 otherwise --could be changed
cluster_label : integer range 0 to 3; --maximum of 3 clusters are searched for --4320 if local maxima search is used
end record;
type t_cluster_element_array is array(integer range <>,integer range <>,integer range <>) of t_cluster_element;

type t_Hough_array is array(integer range <>,integer range <>,integer range <>) of integer range 0 to 255; --duplicate here
type t_maximum is array(0 to 2) of integer;

end package;


package body Cluster_functions2 is

end package body Cluster_functions2;
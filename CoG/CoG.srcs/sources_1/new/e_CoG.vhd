library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

use work.main_functions.all;

--takes in a 3D-Array of 7-bit integers of any size and returns the Center of Gravity as 3 integers
--works on cuboids only, can fill empty cells with 0s
--requires 3 divisions currently

entity e_CoG is
    generic(
           int_pT : integer := 40; --distance from origin
           int_phi : integer := 30; --angle from origin/x-axis ?
           int_theta : integer := 9 --9 theta layers
           );
    Port ( i_array : in t_cluster_element_array(0 to int_pT-1,0 to int_phi-1,0 to int_theta-1); --array as input only in vhdl 2008
           o_CoG : out CoG_array_3D -- CoG could be any voxel --maybe optimise for resources
           );
end e_CoG;

architecture Behavioral of e_CoG is

--constant int_65536 : integer := 65536; --2¹⁶ --just use DSPs for now
--constant int_reciprocal_pT :integer := int_65536/int_pT; 
--constant int_reciprocal_phi :integer := int_65536/int_phi;
--constant int_reciprocal_theta :integer := int_65536/int_theta;

signal s_CoG_array_3D : CoG_array_3D;
signal int_totalweight : integer;

begin
process(i_array)
begin
for i in 0 to int_pT-1 loop --loop through all elements of array
    for j in 0 to int_phi-1 loop
        for k in 0 to int_theta-1 loop
            s_CoG_array_3D(0) <= s_CoG_array_3D(0) + i_array(i,j,k).value*i; --add up pT values
            s_CoG_array_3D(1) <= s_CoG_array_3D(0) + i_array(i,j,k).value*j; --add up phi values
            s_CoG_array_3D(2) <= s_CoG_array_3D(0) + i_array(i,j,k).value*k; --add up theta values
            int_totalweight <= int_totalweight + i_array(i,j,k).value;
        end loop;
    end loop;
end loop;
end process;

--assign outputs
o_CoG(0) <= s_CoG_array_3D(0)/int_totalweight; -- change to multiplication with reciprocal
o_CoG(1) <= s_CoG_array_3D(1)/int_totalweight;
o_CoG(2) <= s_CoG_array_3D(2)/int_totalweight;

end Behavioral;

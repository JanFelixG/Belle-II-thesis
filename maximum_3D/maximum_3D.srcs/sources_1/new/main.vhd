library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

use work.main_functions.all;


entity maximum is
generic (
    int_pT : integer := 40;  -- Number of rows
    int_phi : integer := 30;  -- Number of columns
    int_theta : integer := 9   -- Depth
);
port (
    i_cluster_element_array : in t_cluster_element_array(0 to int_pT-1,0 to int_phi-1,0 to int_theta-1);
    i_enable : in std_logic;
    o_maximum : out t_maximum
  );
end maximum;

architecture Behavioral of maximum is

function find_maximum(
    a : t_cluster_element_array_1D; loc : integer range 0 to (int_pT*int_phi*int_theta)-1)   
    return integer is
    variable location, max_loc : integer range 0 to (int_pT*int_phi*int_theta)-1;
    variable left,right  : t_cluster_element_array_1D(0 to a'length/2-1);
    variable max_left, max_right, loc_left, loc_right  : integer range 0 to (int_pT*int_phi*int_theta)-1;
begin
if a'length = 1 then
    location := loc;
else
    -- Split array into left and right halves
    for i in 0 to a'length/2-1 loop
        left(i) := a(i);
        right(i) := a(i+a'length/2);
    end loop;
    --Find maximum location in left and right halves recursively
    max_left := find_maximum(left,loc_left);
    max_right := find_maximum(right,loc_right);
    --Compare the maximum values from left and right halves
    if(a(max_left).value > a(max_right).value) then --check value not location
        location := max_left; --loc_left
     else
        location := max_right + a'length/2; --loc_right
    end if;
end if;
--max_loc := location; --location is not 8 bit
return location;
end function;

signal s_cluster_element_array : t_cluster_element_array_1D(0 to (int_pT*int_phi*int_theta)-1);

signal s_location : integer;

begin
process (i_cluster_element_array)
begin
if(i_enable = '1') then

for pT in 0 to int_pT-1 loop
for phi in 0 to int_phi-1 loop
for theta in 0 to int_theta-1 loop
    --encode 3D to 1D-array here
    if(i_cluster_element_array(pT,phi,theta).cluster_label = 0) then --treat value as 0 if already clustered
        s_cluster_element_array(pT+pT*phi+pT*phi*theta) <= i_cluster_element_array(pT,phi,theta);
    else
        s_cluster_element_array(pT+pT*phi+pT*phi*theta).value <= 0;
    end if;
end loop;
end loop;
end loop;

s_location <= find_maximum(s_cluster_element_array,s_location);
--decode 1D-address here
o_maximum(2) <= s_location/(int_phi*int_pT);--theta range 0 to 8
o_maximum(1) <= s_location/(int_pT)-int_phi*s_location/(int_phi*int_pT); --phi range 0 to 29
o_maximum(0) <= s_location-int_pT*(s_location/(int_pT)-int_phi*s_location/(int_phi*int_pT)); --pT range 0 to 39

end if;
end process;
end Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

package bus_multiplexer_pkg is
        type bus_array is array(integer range <>) of integer range 0 to 63; --switch to integer
end package;
use work.bus_multiplexer_pkg.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

--takes a 1D-input-array of std_logic_vector of any size and returns the maximum value and location
--maximum search is done in a tree structure by comparing two neighbouring values
--tree structure implemented through recursive function-calls
--maximum location found by incrementing counters in each comparison

entity array_maximum is
    generic(
           int_array_size : integer := 10800;--10800=40*30*9  -- Array size -- split array if necessary
           int_element_size : integer := 64  --Element Size
           );
    Port ( i_array : in bus_array(0 to int_array_size-1); --array as input only in vhdl 2008
           o_location : out integer range 0 to int_array_size-1--STD_LOGIC_VECTOR (7 downto 0)
           );
end array_maximum;

architecture Combinatorial of array_maximum is

--declare types and signals
signal s_location  : integer range 0 to int_array_size-1 := 0;

--Combinatorial maximum of array
function find_maximum(
    a : bus_array; loc : integer range 0 to int_array_size-1)   
    return integer is
    variable location, max_loc : integer range 0 to int_array_size-1;
    variable left,right  : bus_array(0 to a'length/2-1);
    variable max_left, max_right, loc_left, loc_right  : integer range 0 to int_array_size-1;
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
    if(a(max_left) > a(max_right)) then --check value not location
        location := max_left; --loc_left
     else
        location := max_right + a'length/2; --loc_right
    end if;
end if;
--max_loc := location; --location is not 8 bit
return location;
end function;

begin

--Assign outputs
o_location <= find_maximum(i_array,s_location);

end architecture Combinatorial;

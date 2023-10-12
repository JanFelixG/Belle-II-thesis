library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package bus_multiplexer_pkg is
        type bus_array is array(integer range <>) of integer range 0 to 7; --maybe use integer
end package;
use work.bus_multiplexer_pkg.all;
use work.slope_functions.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--takes an input-array of std_logic_vector
--removes all values smaller than i_slope from the array by setting those values to zero
--returns updated array

entity slope is
generic(
int_pT : integer := 40;
int_phi : integer := 30;
int_theta :integer := 9
);
Port( 
i_array : in t_cluster_element_array(0 to int_pT-1,0 to int_phi-1,0 to int_theta-1);
i_slope : in integer range 0 to 255;
o_array : out t_cluster_element_array(0 to int_pT-1,0 to int_phi-1,0 to int_theta-1)
);
end slope;

architecture Behavioral of slope is

signal s_array : t_cluster_element_array(0 to int_pT-1,0 to int_phi-1,0 to int_theta-1);

begin

process(i_array) --sum all elements of array
begin

for pT in 0 to int_pT-1 loop --go over all array elements, set to 0 if smaller than slope
for phi in 0 to int_phi-1 loop
for theta in 0 to int_theta-1 loop
    if (i_array(pT,phi,theta).value < i_slope) then
        s_array(pT,phi,theta).value <= 0;
    else 
        s_array(pT,phi,theta).value <= i_array(pT,phi,theta).value;
    end if;
end loop;
end loop;
end loop;
end process;

--assign outputs
o_array <= s_array;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

use work.main_functions.all;


--takes an 1D-input-array of 7-bit integer and calculates the sum of all elements and the average of the none 0-elements
--average of elements done by division/DSP-use currently

entity Energy is
    generic(
           int_pT : integer := 40; --distance from origin
           int_phi : integer := 30; --angle from origin/x-axis ?
           int_theta : integer := 9; --9 theta layers
           int_element_size : integer := 8  --Element Size --currently unused
           );
    Port ( 
           i_array : in t_cluster_element_array(0 to int_pT-1,0 to int_phi-1, 0 to int_theta-1);
           i_maximum : in t_maximum; --maximum size, potentially lower
           o_energy : out t_energy
           );
end Energy;


architecture Behavioral of Energy is

signal s_energy_temp : t_energy;

begin

process(i_array) --sum all elements of array
begin
--energy 0 is value of maximum
s_energy_temp(0) <= i_array(i_maximum(0),i_maximum(1),i_maximum(2)).value;

for pT in 0 to int_pT-1 loop --sum all array elements
for phi in 0 to int_phi-1 loop 
for theta in 0 to int_theta-1 loop 
    for i in -1 to 1 loop --sum of first ring
    if(pT+i < int_pT-1 and pT+i >= 0) then --boundary check? --check this again
    for j in -1 to 1 loop 
    if(phi+j < int_phi-1 and phi+j >= 0) then --boundary check? --check this again
    for k in -1 to 1 loop 
    if(theta+k < int_theta-1 and theta+k >= 0) then --boundary check? --check this again
        s_energy_temp(1) <= i_array(pT,phi,theta).value;
    end if;    
    end loop;
    end if;
    end loop;
    end if;
    end loop; 
      
    for i in -2 to 2 loop --sum of first 2 rings
    if(pT+i < int_pT-1 and pT+i >= 0) then --boundary check? --check this again
    for j in -2 to 2 loop 
    if(phi+j < int_phi-1 and phi+j >= 0) then --boundary check? --check this again
    for k in -2 to 2 loop 
    if(theta+k < int_theta-1 and theta+k >= 0) then --boundary check? --check this again
        s_energy_temp(2) <= i_array(pT,phi,theta).value;
    end if;    
    end loop;
    end if;
    end loop;
    end if;
    end loop; 
    
    for i in -3 to 3 loop --sum of first 3 rings
    if(pT+i < int_pT-1 and pT+i >= 0) then --boundary check? --check this again
    for j in -3 to 3 loop 
    if(phi+j < int_phi-1 and phi+j >= 0) then --boundary check? --check this again
    for k in -3 to 3 loop 
    if(theta+k < int_theta-1 and theta+k >= 0) then --boundary check? --check this again
        s_energy_temp(3) <= i_array(pT,phi,theta).value;
    end if;    
    end loop;
    end if;
    end loop;
    end if;
    end loop;
         
end loop;
end loop;
end loop;

end process;

--assign outputs
o_energy(0) <= s_energy_temp(0);
o_energy(1) <= s_energy_temp(1)-s_energy_temp(0); --subtract value of inner rings from total 
o_energy(2) <= s_energy_temp(2)-s_energy_temp(1);
o_energy(3) <= s_energy_temp(3)-s_energy_temp(2);

end Behavioral;

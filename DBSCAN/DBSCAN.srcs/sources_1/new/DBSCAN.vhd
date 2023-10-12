library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

package bus_multiplexer_pkg is
        --type Hough_array is array(integer range <>,integer range <>,integer range <>) of integer;--3D Hough-Array --can redurce range or use std_logic 0/1 only to reduce resources needed for clustering
        --type max_location is array(integer range <>) of integer;
        type bus_array is array(integer range <>) of integer range 0 to 255; --output array,multiple clusters in one single array
end package;
use work.bus_multiplexer_pkg.all;
use work.Cluster_functions2.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

--Density Based Spatial Clusterting for Applications with Noise
--variation for binned space (Hough-space)
--takes in an Array, and its maximum location and adds all voxels sorrounding the maximum to the cluster
--the maximum number of iterations is set to 80 for now
--to save resources the maximum number of expansions is capped by max_expansions

entity DBSCAN is
    generic(
           int_pT : integer := 40; --distance from origin
           int_phi : integer := 30; --angle from origin/x-axis ?
           int_theta : integer := 9; --9 theta layers
           int_element_size : integer := 8;  --Element Size --currently unused
           cluster_label : integer range 0 to 3 := 1 --for pipelining assign clusterlabels here
           --int_minpts : integer := 1; --1 = every point of cluster is core
           --max_iterations : integer := 3 --quit algorithm after this many clock cycles
           );
    Port ( i_Hough : in t_cluster_element_array(0 to int_pT-1,0 to int_phi-1, 0 to int_theta-1);
           i_clk : in STD_LOGIC;
           i_reset : in std_logic;
           i_maximum: in t_maximum;
           o_ready : out STD_LOGIC;
           o_Hough : out t_cluster_element_array(0 to int_pT-1,0 to int_phi-1, 0 to int_theta-1)
           );
end DBSCAN;

architecture Behavioral of DBSCAN is

signal s_cluster_element_array : t_cluster_element_array(0 to int_pT-1,0 to int_phi-1,0 to int_theta-1); --buffer input-array
--signal s_iterations : integer range 0 to max_iterations := 0;-- range 0 to max_iterations+1;

begin

scan:process(i_clk)
begin
if(rising_edge(i_clk)) then
if(i_reset = '1') then
    --s_iterations <= 0;
    --take in new hough-array
    for pT in 0 to int_pT-1 loop
    for phi in 0 to int_phi-1 loop
    for theta in 0 to int_theta-1 loop
        s_cluster_element_array(pT,phi,theta).value <= i_Hough(pT,phi,theta).value; --copy values
        if(pT=i_maximum(0) and phi=i_maximum(1) and theta=i_maximum(2)) then
            s_cluster_element_array(pT,phi,theta).cluster_label <= cluster_label;
            --expand here once already--should not chnage resource use
            if(pT+1 < s_cluster_element_array'length(1)) then --check out of bounds --try to optimise this away
                if(s_cluster_element_array(pT+1,phi,theta).value /= 0) then --if value is not zero add cell to cluster
                    s_cluster_element_array(pT+1,phi,theta).cluster_label <= cluster_label;
                end if;
            end if;
            if(pT /= 0) then 
                if(s_cluster_element_array(pT-1,phi,theta).value /= 0) then --if value is not zero add cell to cluster
                    s_cluster_element_array(pT-1,phi,theta).cluster_label <= cluster_label;
                end if; 
            end if; --2
            if(phi+1 < s_cluster_element_array'length(2)) then 
                if(s_cluster_element_array(pT,phi+1,theta).value /= 0) then --if value is not zero add cell to cluster
                    s_cluster_element_array(pT,phi+1,theta).cluster_label <= cluster_label;
                end if; 
            end if; --3
            if(phi /= 0) then 
                if(s_cluster_element_array(pT,phi-1,theta).value /= 0) then --if value is not zero add cell to cluster
                    s_cluster_element_array(pT,phi-1,theta).cluster_label <= cluster_label;
                end if; 
            end if; --4
            if(theta+1 < s_cluster_element_array'length(3)) then 
                if(s_cluster_element_array(pT,phi,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT,phi,theta+1).cluster_label <= cluster_label;
            end if; 
        end if; --5
        if(theta /= 0) then 
            if(s_cluster_element_array(pT,phi,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT,phi,theta-1).cluster_label <= cluster_label;
            end if; 
        end if; --6
        --check diagonal here
        --theta +1 8 cases
        if(theta+1 < s_cluster_element_array'length(3) and pT+1 < s_cluster_element_array'length(1) and phi /= 0) then 
            if(s_cluster_element_array(pT+1,phi-1,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT+1,phi-1,theta+1).cluster_label <= cluster_label;
            end if;
         end if; --1
         if(theta+1 < s_cluster_element_array'length(3) and pT /= 0 and phi+1 < s_cluster_element_array'length(2)) then 
            if(s_cluster_element_array(pT-1,phi+1,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT-1,phi+1,theta+1).cluster_label <= cluster_label;
            end if;
         end if; --2           
         if(theta+1 < s_cluster_element_array'length(3) and pT /= 0 and phi /= 0) then 
            if(s_cluster_element_array(pT-1,phi-1,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT-1,phi-1,theta+1).cluster_label <= cluster_label;
            end if;
        end if; --3          
        if(theta+1 < s_cluster_element_array'length(3) and pT+1 < s_cluster_element_array'length(1) and phi+1 < s_cluster_element_array'length(2)) then 
            if(s_cluster_element_array(pT+1,phi+1,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT+1,phi+1,theta+1).cluster_label <= cluster_label;
            end if;
         end if; --4
         if(theta+1 < s_cluster_element_array'length(3) and pT /= 0) then 
            if(s_cluster_element_array(pT-1,phi,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT-1,phi,theta+1).cluster_label <= cluster_label;
            end if;
         end if; --5          
         if(theta+1 < s_cluster_element_array'length(3) and phi /= 0) then 
            if(s_cluster_element_array(pT,phi-1,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT,phi-1,theta+1).cluster_label <= cluster_label;
            end if;           
        end if; --6               
        if(theta+1 < s_cluster_element_array'length(3) and pT+1 < s_cluster_element_array'length(1)) then 
            if(s_cluster_element_array(pT+1,phi,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT+1,phi,theta+1).cluster_label <= cluster_label;
            end if;           
        end if; --7               
       if(theta+1 < s_cluster_element_array'length(3) and phi+1 < s_cluster_element_array'length(2)) then 
            if(s_cluster_element_array(pT,phi+1,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT,phi+1,theta+1).cluster_label <= cluster_label;
            end if;           
        end if; --8 
        --theta -1 8 cases
        if(theta /= 0 and pT+1 < s_cluster_element_array'length(1) and phi /= 0) then 
            if(s_cluster_element_array(pT+1,phi-1,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT+1,phi-1,theta-1).cluster_label <= cluster_label;
            end if;
         end if; --1
         if(theta /= 0 and pT /= 0 and phi+1 < s_cluster_element_array'length(2)) then 
            if(s_cluster_element_array(pT-1,phi+1,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT-1,phi+1,theta-1).cluster_label <= cluster_label;
            end if;
         end if; --2           
         if(theta /= 0 and pT /= 0 and phi /= 0) then 
            if(s_cluster_element_array(pT-1,phi-1,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT-1,phi-1,theta-1).cluster_label <= cluster_label;
            end if;
        end if; --3          
        if(theta /= 0 and pT+1 < s_cluster_element_array'length(1) and phi+1 < s_cluster_element_array'length(2)) then 
            if(s_cluster_element_array(pT+1,phi+1,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT+1,phi+1,theta-1).cluster_label <= cluster_label;
            end if;
         end if; --4
         if(theta /= 0 and pT /= 0) then 
            if(s_cluster_element_array(pT-1,phi,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT-1,phi,theta-1).cluster_label <= cluster_label;
            end if;
         end if; --5          
         if(theta /= 0 and phi /= 0) then 
            if(s_cluster_element_array(pT,phi-1,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT,phi-1,theta-1).cluster_label <= cluster_label;
            end if;           
        end if; --6               
        if(theta /= 0 and pT+1 < s_cluster_element_array'length(1)) then 
            if(s_cluster_element_array(pT+1,phi,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT+1,phi,theta-1).cluster_label <= cluster_label;
            end if;           
        end if; --7               
        if(theta /= 0 and phi+1 < s_cluster_element_array'length(2)) then 
            if(s_cluster_element_array(pT,phi+1,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT,phi+1,theta-1).cluster_label <= cluster_label;
            end if;           
        end if; --8         
        --theta 0  4 cases
            if(pT+1 < s_cluster_element_array'length(1) and phi+1 < s_cluster_element_array'length(2)) then 
                if(s_cluster_element_array(pT+1,phi+1,theta).value /= 0) then --if value is not zero add cell to cluster
                    s_cluster_element_array(pT+1,phi+1,theta).cluster_label <= cluster_label;
                end if; 
            end if; --1
            if(pT /= 0 and phi+1 < s_cluster_element_array'length(2)) then 
                if(s_cluster_element_array(pT-1,phi+1,theta).value /= 0) then --if value is not zero add cell to cluster
                    s_cluster_element_array(pT-1,phi+1,theta).cluster_label <= cluster_label;
                end if; 
            end if; --1
            if(pT /= 0 and phi /= 0) then 
                if(s_cluster_element_array(pT-1,phi-1,theta).value /= 0) then --if value is not zero add cell to cluster
                    s_cluster_element_array(pT-1,phi-1,theta).cluster_label <= cluster_label;
                end if; 
            end if; --1 
            if(pT+1 < s_cluster_element_array'length(1) and phi /= 0) then 
                if(s_cluster_element_array(pT+1,phi-1,theta).value /= 0) then --if value is not zero add cell to cluster
                    s_cluster_element_array(pT+1,phi-1,theta).cluster_label <= cluster_label;
                end if; 
            end if; --1                   
--        else 
--            s_cluster_element_array(pT,phi,theta).core <= '0';            
        end if;
    end loop;
    end loop;
    end loop;
else
    --s_iterations <= s_iterations+1;                 
     --DBSCAN here
        for pT in 0 to int_pT-1 loop
        for phi in 0 to int_phi-1 loop
        for theta in 0 to int_theta-1 loop
        if(pT=i_maximum(0) and phi=i_maximum(1) and theta=i_maximum(2)) then
            s_cluster_element_array(pT,phi,theta).cluster_label <= cluster_label;
            --expand here once already--should not chnage resource use
            if(pT+1 < s_cluster_element_array'length(1)) then --check out of bounds --try to optimise this away
                if(s_cluster_element_array(pT+1,phi,theta).value /= 0) then --if value is not zero add cell to cluster
                    s_cluster_element_array(pT+1,phi,theta).cluster_label <= cluster_label;
                end if;
            end if;
            if(pT /= 0) then 
                if(s_cluster_element_array(pT-1,phi,theta).value /= 0) then --if value is not zero add cell to cluster
                    s_cluster_element_array(pT-1,phi,theta).cluster_label <= cluster_label;
                end if; 
            end if; --2
            if(phi+1 < s_cluster_element_array'length(2)) then 
                if(s_cluster_element_array(pT,phi+1,theta).value /= 0) then --if value is not zero add cell to cluster
                    s_cluster_element_array(pT,phi+1,theta).cluster_label <= cluster_label;
                end if; 
            end if; --3
            if(phi /= 0) then 
                if(s_cluster_element_array(pT,phi-1,theta).value /= 0) then --if value is not zero add cell to cluster
                    s_cluster_element_array(pT,phi-1,theta).cluster_label <= cluster_label;
                end if; 
            end if; --4
            if(theta+1 < s_cluster_element_array'length(3)) then 
                if(s_cluster_element_array(pT,phi,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT,phi,theta+1).cluster_label <= cluster_label;
            end if; 
        end if; --5
        if(theta /= 0) then 
            if(s_cluster_element_array(pT,phi,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT,phi,theta-1).cluster_label <= cluster_label;
            end if; 
        end if; --6
        --check diagonal here
        --theta +1 8 cases
        if(theta+1 < s_cluster_element_array'length(3) and pT+1 < s_cluster_element_array'length(1) and phi /= 0) then 
            if(s_cluster_element_array(pT+1,phi-1,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT+1,phi-1,theta+1).cluster_label <= cluster_label;
            end if;
         end if; --1
         if(theta+1 < s_cluster_element_array'length(3) and pT /= 0 and phi+1 < s_cluster_element_array'length(2)) then 
            if(s_cluster_element_array(pT-1,phi+1,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT-1,phi+1,theta+1).cluster_label <= cluster_label;
            end if;
         end if; --2           
         if(theta+1 < s_cluster_element_array'length(3) and pT /= 0 and phi /= 0) then 
            if(s_cluster_element_array(pT-1,phi-1,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT-1,phi-1,theta+1).cluster_label <= cluster_label;
            end if;
        end if; --3          
        if(theta+1 < s_cluster_element_array'length(3) and pT+1 < s_cluster_element_array'length(1) and phi+1 < s_cluster_element_array'length(2)) then 
            if(s_cluster_element_array(pT+1,phi+1,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT+1,phi+1,theta+1).cluster_label <= cluster_label;
            end if;
         end if; --4
         if(theta+1 < s_cluster_element_array'length(3) and pT /= 0) then 
            if(s_cluster_element_array(pT-1,phi,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT-1,phi,theta+1).cluster_label <= cluster_label;
            end if;
         end if; --5          
         if(theta+1 < s_cluster_element_array'length(3) and phi /= 0) then 
            if(s_cluster_element_array(pT,phi-1,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT,phi-1,theta+1).cluster_label <= cluster_label;
            end if;           
        end if; --6               
        if(theta+1 < s_cluster_element_array'length(3) and pT+1 < s_cluster_element_array'length(1)) then 
            if(s_cluster_element_array(pT+1,phi,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT+1,phi,theta+1).cluster_label <= cluster_label;
            end if;           
        end if; --7               
       if(theta+1 < s_cluster_element_array'length(3) and phi+1 < s_cluster_element_array'length(2)) then 
            if(s_cluster_element_array(pT,phi+1,theta+1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT,phi+1,theta+1).cluster_label <= cluster_label;
            end if;           
        end if; --8 
        --theta -1 8 cases
        if(theta /= 0 and pT+1 < s_cluster_element_array'length(1) and phi /= 0) then 
            if(s_cluster_element_array(pT+1,phi-1,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT+1,phi-1,theta-1).cluster_label <= cluster_label;
            end if;
         end if; --1
         if(theta /= 0 and pT /= 0 and phi+1 < s_cluster_element_array'length(2)) then 
            if(s_cluster_element_array(pT-1,phi+1,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT-1,phi+1,theta-1).cluster_label <= cluster_label;
            end if;
         end if; --2           
         if(theta /= 0 and pT /= 0 and phi /= 0) then 
            if(s_cluster_element_array(pT-1,phi-1,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT-1,phi-1,theta-1).cluster_label <= cluster_label;
            end if;
        end if; --3          
        if(theta /= 0 and pT+1 < s_cluster_element_array'length(1) and phi+1 < s_cluster_element_array'length(2)) then 
            if(s_cluster_element_array(pT+1,phi+1,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT+1,phi+1,theta-1).cluster_label <= cluster_label;
            end if;
         end if; --4
         if(theta /= 0 and pT /= 0) then 
            if(s_cluster_element_array(pT-1,phi,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT-1,phi,theta-1).cluster_label <= cluster_label;
            end if;
         end if; --5          
         if(theta /= 0 and phi /= 0) then 
            if(s_cluster_element_array(pT,phi-1,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT,phi-1,theta-1).cluster_label <= cluster_label;
            end if;           
        end if; --6               
        if(theta /= 0 and pT+1 < s_cluster_element_array'length(1)) then 
            if(s_cluster_element_array(pT+1,phi,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT+1,phi,theta-1).cluster_label <= cluster_label;
            end if;           
        end if; --7               
        if(theta /= 0 and phi+1 < s_cluster_element_array'length(2)) then 
            if(s_cluster_element_array(pT,phi+1,theta-1).value /= 0) then --if value is not zero add cell to cluster
                s_cluster_element_array(pT,phi+1,theta-1).cluster_label <= cluster_label;
            end if;           
        end if; --8         
        --theta 0  4 cases
            if(pT+1 < s_cluster_element_array'length(1) and phi+1 < s_cluster_element_array'length(2)) then 
                if(s_cluster_element_array(pT+1,phi+1,theta).value /= 0) then --if value is not zero add cell to cluster
                    s_cluster_element_array(pT+1,phi+1,theta).cluster_label <= cluster_label;
                end if; 
            end if; --1
            if(pT /= 0 and phi+1 < s_cluster_element_array'length(2)) then 
                if(s_cluster_element_array(pT-1,phi+1,theta).value /= 0) then --if value is not zero add cell to cluster
                    s_cluster_element_array(pT-1,phi+1,theta).cluster_label <= cluster_label;
                end if; 
            end if; --1
            if(pT /= 0 and phi /= 0) then 
                if(s_cluster_element_array(pT-1,phi-1,theta).value /= 0) then --if value is not zero add cell to cluster
                    s_cluster_element_array(pT-1,phi-1,theta).cluster_label <= cluster_label;
                end if; 
            end if; --1 
            if(pT+1 < s_cluster_element_array'length(1) and phi /= 0) then 
                if(s_cluster_element_array(pT+1,phi-1,theta).value /= 0) then --if value is not zero add cell to cluster
                    s_cluster_element_array(pT+1,phi-1,theta).cluster_label <= cluster_label;
                end if; 
            end if; --1                                    
        end if; --end core if
        end loop; --end theta loop
        end loop; --end phi loop
        end loop; --end theta loop
    end if; --end iterations if
end if; --end clk if
end process scan;

--assign outputs
o_hough <= s_cluster_element_array;

end Behavioral;

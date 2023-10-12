library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

--read Hough-vectors from 2nd file
use work.Hough_vectors.all;
use work.main_functions.all;

--takes an 1D-input-vector and adds the corresponding vector to Hough-array
--corresponding vectors are in extra file/ stored in the ram(currently not in ram yet)
--currently combinatorial, could be pipelined for faster clock

entity e_Hough is
    generic(
           int_num_detectors : integer := 90;  -- max Number of detectors -- change to same one as package-file
           int_pT :integer := 40;
           int_phi :integer := 12;
           int_theta :integer := 9
           );
    Port ( i_3D_Array : t_detector_array; --9x10 active detectors per superlayer -- 9 superlayer
           i_clk : in std_logic;
           o_Hough : out t_cluster_element_array(0 to int_pT-1, 0 to int_phi-1, 0 to int_theta-1)
           );
end e_Hough;

architecture Behavioral of e_Hough is

signal s_Hough :t_cluster_element_array(0 to int_pT-1, 0 to int_phi-1, 0 to int_theta-1);

begin

process(i_3D_Array,s_Hough) --warning if s_hough is not here
begin
--axials --axials only contribute to 1 layer of hough-map, because of their geometry(parallel to beam)
--axial 0
for pT in 0 to int_pT-1 loop
for phi in 0 to int_phi-1 loop
for k in 1 to 5 loop --check all 5 possible ids
    for det in 1 to 90 loop --check all detector ids
    if(c_axial0((pT+1)*phi+(pT+1),k,1) = i_3D_Array(det)) then --if detector id is found in cell list add weight to cell
        s_Hough(pT,phi,0).value <= s_Hough(pT,phi,0).value + c_axial0((pT+1)*phi+(pT+1),k,2); --add weight --decode to 3D here
    end if;
    end loop;
end loop; --detector id loop
end loop; --phi
end loop; --axial loop --pT
--axial 2
for pT in 0 to int_pT-1 loop
for phi in 0 to int_phi-1 loop
for k in 1 to 5 loop --check all 5 possible ids
    for det in 1 to 90 loop --check all detector ids
    if(c_axial0((pT+1)*phi+(pT+1),k,1) = i_3D_Array(det)) then --if detector id is found in cell list add weight to cell
        s_Hough(pT,phi,2).value <= s_Hough(pT,phi,2).value + c_axial0((pT+1)*phi+(pT+1),k,2); --add weight --decode to 3D here
    end if;
    end loop;
end loop; --detector id loop
end loop; --phi
end loop; --axial loop --pT
--axial 4
for pT in 0 to int_pT-1 loop
for phi in 0 to int_phi-1 loop
for k in 1 to 5 loop --check all 5 possible ids
    for det in 1 to 90 loop --check all detector ids
    if(c_axial0((pT+1)*phi+(pT+1),k,1) = i_3D_Array(det)) then --if detector id is found in cell list add weight to cell
        s_Hough(pT,phi,4).value <= s_Hough(pT,phi,4).value + c_axial0((pT+1)*phi+(pT+1),k,2); --add weight --decode to 3D here
    end if;
    end loop;
end loop; --detector id loop
end loop; --phi
end loop; --axial loop --pT
--axial 6
for pT in 0 to int_pT-1 loop
for phi in 0 to int_phi-1 loop
for k in 1 to 5 loop --check all 5 possible ids
    for det in 1 to 90 loop --check all detector ids
    if(c_axial0((pT+1)*phi+(pT+1),k,1) = i_3D_Array(det)) then --if detector id is found in cell list add weight to cell
        s_Hough(pT,phi,6).value <= s_Hough(pT,phi,6).value + c_axial0((pT+1)*phi+(pT+1),k,2); --add weight --decode to 3D here
    end if;
    end loop;
end loop; --detector id loop
end loop; --phi
end loop; --axial loop --pT
--axial 8
for pT in 0 to int_pT-1 loop
for phi in 0 to int_phi-1 loop
for k in 1 to 5 loop --check all 5 possible ids
    for det in 1 to 90 loop --check all detector ids
    if(c_axial0((pT+1)*phi+(pT+1),k,1) = i_3D_Array(det)) then --if detector id is found in cell list add weight to cell
        s_Hough(pT,phi,8).value <= s_Hough(pT,phi,8).value + c_axial0((pT+1)*phi+(pT+1),k,2); --add weight --decode to 3D here
    end if;
    end loop;
end loop; --detector id loop
end loop; --phi
end loop; --axial loop --pT
--stereo --stereo wires contribute to all theta layers of hough-map
--stereo1 --fails when using stereo layer without error message
for pT in 0 to int_pT-1 loop --39
for phi in 0 to int_phi-1 loop --11
for theta in 0 to int_theta-4 loop --5 --need new data files
for k in 1 to 5 loop --check all 5 possible ids
    for det in 1 to 90 loop --check all detector ids
    if(c_stereo1((pT+1)*(phi+1)*theta+(pT+1)*phi+(pT+1),k,1) = i_3D_Array(det)) then --if detector id is found in cell list add weight to cell
        s_Hough(pT,phi,theta).value <= s_Hough(pT,phi,theta).value + c_stereo1((pT+1)*(phi+1)*theta+(pT+1)*phi+(pT+1),k,2); --add weight --decode to 3D here
    end if;
    end loop;
end loop; --detector id loop
end loop; --theta
end loop; --phi
end loop; --axial loop --pT
--stereo 3
--for pT in 0 to int_pT-1 loop
--for phi in 0 to int_phi-1 loop
--for theta in 0 to int_theta-4 loop
--for k in 1 to 5 loop --check all 5 possible ids
--    for det in 1 to 90 loop --check all detector ids
--    if(c_stereo3((pT+1)*(phi+1)*theta+(pT+1)*phi+(pT+1),k,1) = i_3D_Array(det)) then --if detector id is found in cell list add weight to cell
--        s_Hough(pT,phi,theta).value <= s_Hough(pT,phi,theta).value + c_stereo3(pT*phi*theta+pT*phi+pT+1,k,2); --add weight --decode to 3D here
--    end if;
--    end loop;
--end loop; --detector id loop
--end loop; --theta
--end loop; --phi
--end loop; --axial loop --pT
----stereo 5
--for pT in 0 to int_pT-1 loop
--for phi in 0 to int_phi-1 loop
--for theta in 0 to int_theta-4 loop
--for k in 1 to 5 loop --check all 5 possible ids
--    for det in 1 to 90 loop --check all detector ids
--    if(c_stereo5((pT+1)*(phi+1)*theta+(pT+1)*phi+(pT+1),k,1) = i_3D_Array(det)) then --if detector id is found in cell list add weight to cell
--        s_Hough(pT,phi,theta).value <= s_Hough(pT,phi,theta).value + c_stereo5(pT*phi*theta+pT*phi+pT+1,k,2); --add weight --decode to 3D here
--    end if;
--    end loop;
--end loop; --detector id loop
--end loop; --theta
--end loop; --phi
--end loop; --axial loop --pT
----stereo 7
--for pT in 0 to int_pT-1 loop
--for phi in 0 to int_phi-1 loop
--for theta in 0 to int_theta-4 loop
--for k in 1 to 5 loop --check all 5 possible ids
--    for det in 1 to 90 loop --check all detector ids
--    if(c_stereo7((pT+1)*(phi+1)*theta+(pT+1)*phi+(pT+1),k,1) = i_3D_Array(det)) then --if detector id is found in cell list add weight to cell
--        s_Hough(pT,phi,theta).value <= s_Hough(pT,phi,theta).value + c_stereo7(pT*phi*theta+pT*phi+pT+1,k,2); --add weight --decode to 3D here
--    end if;
--    end loop;
--end loop; --detector id loop
--end loop; --theta
--end loop; --phi
--end loop; --axial loop --pT
end process;

--assign outputs
o_Hough<=s_Hough;

end Behavioral;

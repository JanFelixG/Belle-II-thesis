library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port ( i_detector_data : in STD_LOGIC_VECTOR(479 downto 0);
           o_Ready : out std_logic;
           o_Hough_Matrix : out STD_LOGIC_VECTOR(479 downto 0)
           );
end main;

architecture Behavioral of main is

type a_input_pipeline is array (0 to 5) of std_logic_vector(479 downto 0);
signal s_input_pipeline: a_input_pipeline;
signal s_Hough : std_logic_vector(479 downto 0);

begin
process begin
--simple data pipeline for storage
s_input_pipeline(0) <= i_detector_data;
for i in 0 to 4 loop
    s_input_pipeline(i+1) <= s_input_pipeline(i);
end loop;

--Hough Transform
s_Hough <= s_input_pipeline(5);


end process;
--Output Assignments
o_ready <= '1';
o_Hough_Matrix <= s_Hough;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
--use for opening textfiles
use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY hough_sim1 IS
END ENTITY hough_sim1;

ARCHITECTURE sim OF hough_sim1 IS

type t_trackgsegments_ids is array (0 to 89) of std_logic_vector(6 downto 0); --defined like that for current hough-map
type t_Hough_array is array(integer range <>,integer range <>,integer range <>) of integer range 0 to 63; --2⁶ = 64

signal s_clk,s_Hough_reset,s_Hough_done,s_Hough_start,s_Hough_idle,s_Hough_ready,s_hough_weightPerLine_V_ap_vld : std_logic := '0';
signal s_hough_map1 : std_logic_vector(25919 downto 0) := (others => '0');
signal s_hough_map2 : t_hough_array(0 to 39,0 to 11,0 to 8);-- := (others => "000000");
signal i_tracksegments : t_trackgsegments_ids := (others => "0000000");

--component hough_convert is
--port (
--    s_hough1 : in std_logic_vector(25919 downto 0);
--    s_hough2 : out t_hough_array);
--end component;

component giveMeHoughMap is
port (
    ap_clk : IN STD_LOGIC; --clock
    ap_rst : IN STD_LOGIC; --reset
    ap_start : IN STD_LOGIC; --start signal
    ap_done : OUT STD_LOGIC; --done signal
    ap_idle : OUT STD_LOGIC; --is idle
    ap_ready : OUT STD_LOGIC; --module is ready
    IDs_SL0_0_V : IN STD_LOGIC_VECTOR (6 downto 0); --tracksegments, 10 per superlayer
    IDs_SL0_1_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL0_2_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL0_3_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL0_4_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL0_5_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL0_6_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL0_7_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL0_8_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL0_9_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL1_0_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL1_1_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL1_2_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL1_3_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL1_4_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL1_5_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL1_6_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL1_7_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL1_8_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL1_9_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL2_0_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL2_1_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL2_2_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL2_3_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL2_4_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL2_5_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL2_6_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL2_7_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL2_8_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL2_9_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL3_0_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL3_1_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL3_2_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL3_3_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL3_4_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL3_5_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL3_6_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL3_7_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL3_8_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL3_9_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL4_0_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL4_1_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL4_2_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL4_3_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL4_4_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL4_5_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL4_6_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL4_7_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL4_8_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL4_9_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL5_0_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL5_1_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL5_2_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL5_3_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL5_4_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL5_5_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL5_6_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL5_7_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL5_8_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL5_9_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL6_0_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL6_1_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL6_2_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL6_3_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL6_4_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL6_5_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL6_6_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL6_7_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL6_8_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL6_9_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL7_0_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL7_1_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL7_2_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL7_3_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL7_4_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL7_5_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL7_6_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL7_7_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL7_8_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL7_9_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL8_0_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL8_1_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL8_2_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL8_3_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL8_4_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL8_5_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL8_6_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL8_7_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL8_8_V : IN STD_LOGIC_VECTOR (6 downto 0);
    IDs_SL8_9_V : IN STD_LOGIC_VECTOR (6 downto 0);
    weightPerLine_V : OUT STD_LOGIC_VECTOR (25919 downto 0); --hough-map --40*12*9*6(pT, phi, omega, depth)
    weightPerLine_V_ap_vld : OUT STD_LOGIC ); --valid-signal
end component;

BEGIN

--hough_convert1: hough_convert
--port map(
--s_hough1 => s_hough_map1,
--s_hough2 => s_hough_map2
--);

-- ## Unit Under Test Instantiation
Hough: giveMeHoughMap 
port map(
    ap_clk  => s_clk,--clock
    ap_rst  => s_Hough_reset, --reset
    ap_start  => s_Hough_start, --start signal
    ap_done  => s_Hough_done, --done signal
    ap_idle  => s_Hough_idle,--is idle
    ap_ready => s_Hough_ready, --module is ready
    IDs_SL0_0_V => i_tracksegments(0), --tracksegments, 10 per superlayer
    IDs_SL0_1_V => i_tracksegments(1),
    IDs_SL0_2_V => i_tracksegments(2),
    IDs_SL0_3_V => i_tracksegments(3),
    IDs_SL0_4_V => i_tracksegments(4),
    IDs_SL0_5_V => i_tracksegments(5),
    IDs_SL0_6_V => i_tracksegments(6),
    IDs_SL0_7_V => i_tracksegments(7),
    IDs_SL0_8_V => i_tracksegments(8),
    IDs_SL0_9_V => i_tracksegments(9),
    IDs_SL1_0_V => i_tracksegments(10),
    IDs_SL1_1_V => i_tracksegments(11),
    IDs_SL1_2_V => i_tracksegments(12),
    IDs_SL1_3_V => i_tracksegments(13),
    IDs_SL1_4_V => i_tracksegments(14),
    IDs_SL1_5_V => i_tracksegments(15),
    IDs_SL1_6_V => i_tracksegments(16),
    IDs_SL1_7_V => i_tracksegments(17),
    IDs_SL1_8_V => i_tracksegments(18),
    IDs_SL1_9_V => i_tracksegments(19),
    IDs_SL2_0_V => i_tracksegments(20),
    IDs_SL2_1_V => i_tracksegments(21),
    IDs_SL2_2_V => i_tracksegments(22),
    IDs_SL2_3_V => i_tracksegments(23),
    IDs_SL2_4_V => i_tracksegments(24),
    IDs_SL2_5_V => i_tracksegments(25),
    IDs_SL2_6_V => i_tracksegments(26),
    IDs_SL2_7_V => i_tracksegments(27),
    IDs_SL2_8_V => i_tracksegments(28),
    IDs_SL2_9_V => i_tracksegments(29),
    IDs_SL3_0_V => i_tracksegments(30),
    IDs_SL3_1_V => i_tracksegments(31),
    IDs_SL3_2_V => i_tracksegments(32),
    IDs_SL3_3_V => i_tracksegments(33),
    IDs_SL3_4_V => i_tracksegments(34),
    IDs_SL3_5_V => i_tracksegments(35),
    IDs_SL3_6_V => i_tracksegments(36),
    IDs_SL3_7_V => i_tracksegments(37),
    IDs_SL3_8_V => i_tracksegments(38),
    IDs_SL3_9_V => i_tracksegments(39),
    IDs_SL4_0_V => i_tracksegments(40),
    IDs_SL4_1_V => i_tracksegments(41),
    IDs_SL4_2_V => i_tracksegments(42),
    IDs_SL4_3_V => i_tracksegments(43),
    IDs_SL4_4_V => i_tracksegments(44),
    IDs_SL4_5_V => i_tracksegments(45),
    IDs_SL4_6_V => i_tracksegments(46),
    IDs_SL4_7_V => i_tracksegments(47),
    IDs_SL4_8_V => i_tracksegments(48),
    IDs_SL4_9_V => i_tracksegments(49),
    IDs_SL5_0_V => i_tracksegments(50),
    IDs_SL5_1_V => i_tracksegments(51),
    IDs_SL5_2_V => i_tracksegments(52),
    IDs_SL5_3_V => i_tracksegments(53),
    IDs_SL5_4_V => i_tracksegments(54),
    IDs_SL5_5_V => i_tracksegments(55),
    IDs_SL5_6_V => i_tracksegments(56),
    IDs_SL5_7_V => i_tracksegments(57),
    IDs_SL5_8_V => i_tracksegments(58),
    IDs_SL5_9_V => i_tracksegments(59),
    IDs_SL6_0_V => i_tracksegments(60),
    IDs_SL6_1_V => i_tracksegments(61),
    IDs_SL6_2_V => i_tracksegments(62),
    IDs_SL6_3_V => i_tracksegments(63),
    IDs_SL6_4_V => i_tracksegments(64),
    IDs_SL6_5_V => i_tracksegments(65),
    IDs_SL6_6_V => i_tracksegments(66),
    IDs_SL6_7_V => i_tracksegments(67),
    IDs_SL6_8_V => i_tracksegments(68),
    IDs_SL6_9_V => i_tracksegments(69),
    IDs_SL7_0_V => i_tracksegments(70),
    IDs_SL7_1_V => i_tracksegments(71),
    IDs_SL7_2_V => i_tracksegments(72),
    IDs_SL7_3_V => i_tracksegments(73),
    IDs_SL7_4_V => i_tracksegments(74),
    IDs_SL7_5_V => i_tracksegments(75),
    IDs_SL7_6_V => i_tracksegments(76),
    IDs_SL7_7_V => i_tracksegments(77),
    IDs_SL7_8_V => i_tracksegments(78),
    IDs_SL7_9_V => i_tracksegments(79),
    IDs_SL8_0_V => i_tracksegments(80),
    IDs_SL8_1_V => i_tracksegments(81),
    IDs_SL8_2_V => i_tracksegments(82),
    IDs_SL8_3_V => i_tracksegments(83),
    IDs_SL8_4_V => i_tracksegments(84),
    IDs_SL8_5_V => i_tracksegments(85),
    IDs_SL8_6_V => i_tracksegments(86),
    IDs_SL8_7_V => i_tracksegments(87),
    IDs_SL8_8_V => i_tracksegments(88),
    IDs_SL8_9_V => i_tracksegments(89),
    weightPerLine_V => s_hough_map1, --hough-map --40*12*9*6(pT, phi, omega, depth)
    weightPerLine_V_ap_vld => s_hough_weightPerLine_V_ap_vld
);

--clock generator
clock_generator : process
begin
s_clk <= not s_clk;
wait for 50ns; --20 MHz clock
end process clock_generator;

--convert process --use alias here
--converter : process
--begin
--for pT in 0 to 39 loop
--for phi in 0 to 11 loop
--for theta in 0 to 8 loop
--    --s_hough_map2(pT,phi,theta) <= to_integer(unsigned(s_hough_map1(  (((pT*phi*theta+pT*phi+pT)+1)*6)  downto (((pT*phi*theta+pT*phi+pT)+1)*6)-6  )));
--end loop;
--end loop;
--end loop;
--end process converter;

-- ## TestBench Enable Signal Generation
stimulus_generator : process
BEGIN
s_Hough_reset <= '0';
s_Hough_start <= '1';
--data
i_tracksegments(0) <= "0000010";--7bit --ID
i_tracksegments(10) <= "0000001";
i_tracksegments(20) <= "0000011";
i_tracksegments(30) <= "0000011";
i_tracksegments(40) <= "0000010";
i_tracksegments(50) <= "0000011";
i_tracksegments(60) <= "0000010";
i_tracksegments(70) <= "0000010";
i_tracksegments(80) <= "0000010";

--i_tracksegments  <=;
wait for 250ns;
s_Hough_reset <= '1';


-- Stop Simulation
--REPORT "End of simulation" SEVERITY FAILURE;
END PROCESS stimulus_generator;

END ARCHITECTURE sim;
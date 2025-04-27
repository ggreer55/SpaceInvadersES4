library iEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- the top module currently contains the code needed to run
-- graphics generated in RGB_generator on the VGA.


entity top is
      port (
            clk : in std_logic;
            RGB_out : out std_logic_vector(5 downto 0); -- 6 bits
            HSYNC : out std_logic;
            VSYNC : out std_logic
      );
end;

architecture synth of top is
component finalPLL is
    port(
        ref_clk_i: in std_logic;
        rst_n_i: in std_logic;
        outcore_o: out std_logic; -- this only goes to upduino pins. do not use internally
        outglobal_o: out std_logic -- this is the usable clock
    );
end component;
      
      component VGA is
            port (
                  clk: in std_logic;
                  HSYNC: out std_logic;
                  VSYNC: out std_logic;
                  rows : out unsigned (9 downto 0);-- max of 524, 10 bits needed. first row = 0, last = 479
                  columns : out unsigned (9 downto 0)  -- max of 799, 10 bits needed. first bit = 0, last = 639
            );
      end component;
      
      component rgb is
            port (
                  row: in unsigned(9 downto 0);
                  column: in unsigned(9 downto 0);
                  -- valid : in std_logic;
                  crab_rgb: in std_logic_vector(5 downto 0);
                  RGB: out std_logic_vector(5 downto 0); -- 6 bits
                  rgb_clk: in std_logic
            );
      end component;
      
      component crab is
            port (
                  crab_clk: in std_logic;
                  --basepixel: in std_logic_vector(19 downto 0); -- concatenation of a 10 bit x coordinate and a 10 bit y coordinate
                  rows : in unsigned (9 downto 0);-- max of 524, 10 bits needed. first row = 0, last = 479. FROM VGA
                  columns : in unsigned (9 downto 0);  -- max of 799, 10 bits needed. first bit = 0, last = 639. FROM VGA
                  crab_rgb: out std_logic_vector(5 downto 0)
            );
      end component;
      
      
signal col : unsigned (9 downto 0);
signal row : unsigned (9 downto 0);
signal clock : std_logic;
signal c_RGB : std_logic_vector (5 downto 0);

begin

      PLL : finalPLL port map (ref_clk_i => clk, outglobal_o => clock, outcore_o => open, rst_n_i => '1');
      VGA1 : VGA port map (clk => clock, HSYNC => HSYNC, VSYNC => VSYNC, rows => row, columns => col);
    crab1 : crab port map(crab_clk => clock, rows => row, columns => col, crab_rgb =>c_RGB);
      RGB1 : rgb port map (row => row, column => col, crab_rgb => c_RGB, RGB => RGB_out, rgb_clk => clock);
end;

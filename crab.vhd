library iEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity crab is
    port (
        crab_clk: in std_logic;
            --basepixel: in std_logic_vector(19 downto 0); -- concatenation of a 10 bit x coordinate and a 10 bit y coordinate
            rows : in unsigned (9 downto 0);-- max of 524, 10 bits needed. first row = 0, last = 479. FROM VGA
            columns : in unsigned (9 downto 0);  -- max of 799, 10 bits needed. first bit = 0, last = 639. FROM VGA
        crab_rgb: out std_logic_vector(5 downto 0)
    );
end;

architecture synth of crab is

-- first, I want to make a ROM.
-- the address is the row. the row is the top 3? bits of "rows" - "basepixel y coordinate"
-- changing that to top 8 for time being^^
-- the data out is an 11 bit standard logic vector
signal address: unsigned(7 downto 0); -- 8 bit
signal data : std_logic_vector(10 downto 0);
signal rgbit: std_logic;


begin
address <= rows(9 downto 2); -- this will eventually be minue basepixel coordinate
process (crab_clk) is begin
      if rising_edge(crab_clk)then
            case address is
                  when "00000000" => data <= "00100000100";
                  when "00000001" => data <= "00010001000";
                  when "00000010" => data <= "00111111100";
                  when "00000011" => data <= "01101110110";
                  when "00000100" => data <= "11111111111"; -- in this row, everything suddenly goes and stays wrong
                  when "00000101" => data <= "10111111101";
                  when "00000110" => data <= "10100000101"; -- until here
                  when "00000111" => data <= "00011011000";
                  when others => data <= "00000000000";
            end case;
            
            -- now we have a std_logic_vector. one bit is the export color
            if (columns = 44) then
                        rgbit <= data(0); --displayed from 0 to 4 clocks
                  elsif (columns = 4) then
                        rgbit <= data(10);
                  elsif (columns = 8) then
                        rgbit <= data(9);
                  elsif (columns = 12) then
                        rgbit <= data(8);
                  elsif (columns = 16) then
                        rgbit <= data(7);
                  elsif (columns = 20) then
                        rgbit <= data(6);
                  elsif (columns = 24) then
                        rgbit <= data(5);
                  elsif (columns = 28) then
                        rgbit <= data(4);
                  elsif (columns = 32) then
                        rgbit <= data(3);
                  elsif (columns = 36) then
                        rgbit <= data(2);
                  elsif (columns = 40) then
                        rgbit <= data(1);
                  elsif (columns = 47) then
                        rgbit <= '0';
                  end if;
                  crab_rgb <= rgbit & rgbit & rgbit & rgbit & rgbit & rgbit;
      end if;
end process;


end;




library iEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rgb is
    port (
        row: in unsigned (9 downto 0);
        column: in unsigned(9 downto 0);
            rgb_clk: in std_logic;
            crab_rgb: in std_logic_vector(5 downto 0);
        RGB: out std_logic_vector(5 downto 0)
    );
end;

architecture synth of rgb is
begin



-- THIS PART must stay. it keeps the signals low when the VGA is not accepting input
RGB <= "000000" when (column > 639) else
       "000000" when (row > 479) else
        
            crab_rgb;

end;

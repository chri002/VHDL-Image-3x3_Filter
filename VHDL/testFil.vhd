
LIBRARY ieee;
USE     ieee.std_logic_1164.ALL;

ENTITY testFil IS
	
END testFil;

ARCHITECTURE structural OF testFil IS

  COMPONENT almMeanFilter IS
	  GENERIC(SIZE   : INTEGER:=8);
	  PORT (val11     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val12     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val13     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val21     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val22     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val23     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val31     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val32     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val33     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			output    : OUT  STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0));
  END COMPONENT;

  constant N : INTEGER := 8;
  constant clk_period : time := 50 ps;
  
  SIGNAL val11S, val12S, val13S, val21S, val22S, val23S, val31S, val32S, val33S, outputS : std_logic_vector(N-1 downto 0) := (others=>'0');

BEGIN

  imFil : almMeanFilter generic map (N)
					port map   (val11 =>val11S,
								val12 =>val12S,
								val13 =>val13S,
								val21 =>val21S,
								val22 =>val22S,
								val23 =>val23S,
								val31 =>val31S,
								val32 =>val32S,
								val33 =>val33S,
								output => outputS);
												
clk_process:
    process 
		variable tmp : std_logic := '0';
    begin
            
		 val11S <= "11111111";
		 val12S <= "10010001";
		 val13S <= "00001000";
		 val21S <= "01100101";
		 val23S <= "01100101";
		 val32S <= "00101001";
		 val33S <= "11011000";
		wait for 1 ns;
		 val31S <= "11111111";
		 val32S <= "10101100";
		 val22S <= "00110111";
		wait for 1 ns;
		 val11S <= "11111111";
		 val12S <= "10010001";
		 val13S <= "00001000";
		 val21S <= "01100101";
		 val23S <= "01100101";
		 val32S <= "00101001";
		 val33S <= "11011000";
	wait for 1 ns;
     end process;


END structural;

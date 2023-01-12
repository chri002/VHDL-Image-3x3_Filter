
LIBRARY ieee;
USE     ieee.std_logic_1164.ALL;

ENTITY testBench IS
	
END testBench;

ARCHITECTURE structural OF testBench IS

  COMPONENT imageFilter IS
    GENERIC(RAMSZ    : INTEGER;
			IMGNAME  : string;
			IMGNAMEO : string);
	  PORT (clk   	  : IN  STD_LOGIC;
			filterMed : IN STD_LOGIC;
			done  	  : OUT STD_LOGIC);
  END COMPONENT;

  constant N : INTEGER := 16;
  constant clk_period : time := 20 ps;
  
  signal clkTB, doneTB : STD_LOGIC:='0';

BEGIN

  imFil : imageFilter GENERIC MAP (RAMSZ   =>1000000,
								   IMGNAME => "./FILE/gufo_noise.bmp",
								   IMGNAMEO=> "./FILE/test_out.bmp")
						  PORT MAP(clk  	 => clkTB,
								   filterMed => '1',
								   done 	 => doneTB);
												
clk_process:
    process 
		variable tmp : std_logic := '0';
    begin
            
         if doneTB='1' then
			wait;
         end if;
		 clkTB <= tmp;
		 tmp := NOT tmp;
		 wait for clk_period/2;
		
     end process;


END structural;

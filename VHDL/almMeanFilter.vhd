LIBRARY ieee;
USE     ieee.std_logic_1164.ALL;
use     ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

ENTITY almMeanFilter IS
  GENERIC(SIZE   : INTEGER:=16);
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
END almMeanFilter;

ARCHITECTURE behavioral OF almMeanFilter IS

  
  component medFilter IS
	  GENERIC(SIZE    : INTEGER:=16);
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
  END component;
  
  COMPONENT mean8Maxi IS
    
	  GENERIC(SIZE    : INTEGER);
	  PORT (val11     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val12     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val13     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val21     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val22     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val23     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val31     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val32     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val33     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			med       : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			output    : OUT  STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0));
  END component;
  
  
    
  
  SIGNAL med1  : STD_LOGIC_VECTOR(SIZE-1 downto 0):=(others=>'0');

BEGIN

	medV : medFilter GENERIC MAP  (SIZE  => SIZE)
						PORT MAP  (val11 => val11,
								   val12 => val12,
								   val13 => val13,
								   val21 => val21,
								   val22 => val22,
								   val23 => val23,
								   val31 => val31,
								   val32 => val32,
								   val33 => val33,
								   output => med1);	
									  
	mean : mean8Maxi GENERIC MAP  (SIZE  => SIZE)
					    PORT MAP  (val11 => val11,
								   val12 => val12,
								   val13 => val13,
								   val21 => val21,
								   val22 => val22,
								   val23 => val23,
								   val31 => val31,
								   val32 => val32,
								   val33 => val33,
								   med   => med1,
					               output => output);	

					            

	
	
END behavioral;
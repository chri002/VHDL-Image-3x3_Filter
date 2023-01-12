LIBRARY ieee;
USE     ieee.std_logic_1164.ALL;
use     ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

ENTITY medFilter IS
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
END medFilter;

ARCHITECTURE behavioral OF medFilter IS
  COMPONENT triSort IS
    
	  GENERIC(SIZE   : INTEGER);
	  PORT (val1     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val2     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val3     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			OV1		 : OUT  STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			OV2		 : OUT  STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			OV3		 : OUT  STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT triMed IS
    
	  GENERIC(SIZE   : INTEGER:=16);
	  PORT (val1     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val2     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val3     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			OV1		 : OUT  STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0));
  END COMPONENT;

  COMPONENT triMin IS
    
	  GENERIC(SIZE   : INTEGER:=16);
	  PORT (val1     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val2     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val3     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			OV1		 : OUT  STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0));
  END COMPONENT;

  COMPONENT triMaxi IS
    
	  GENERIC(SIZE   : INTEGER:=16);
	  PORT (val1     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val2     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			val3     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
			OV1		 : OUT  STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0));
  END COMPONENT;
    
  
  SIGNAL o1_1  : STD_LOGIC_VECTOR(SIZE-1 downto 0):=(others=>'0');
  SIGNAL o2_1  : STD_LOGIC_VECTOR(SIZE-1 downto 0):=(others=>'0');
  SIGNAL o3_1  : STD_LOGIC_VECTOR(SIZE-1 downto 0):=(others=>'0');
  
  SIGNAL o1_2  : STD_LOGIC_VECTOR(SIZE-1 downto 0):=(others=>'0');
  SIGNAL o2_2  : STD_LOGIC_VECTOR(SIZE-1 downto 0):=(others=>'0');
  SIGNAL o3_2  : STD_LOGIC_VECTOR(SIZE-1 downto 0):=(others=>'0');
  
  SIGNAL o1_3  : STD_LOGIC_VECTOR(SIZE-1 downto 0):=(others=>'0');
  SIGNAL o2_3  : STD_LOGIC_VECTOR(SIZE-1 downto 0):=(others=>'0');
  SIGNAL o3_3  : STD_LOGIC_VECTOR(SIZE-1 downto 0):=(others=>'0');
  
  
  SIGNAL max1  : STD_LOGIC_VECTOR(SIZE-1 downto 0):=(others=>'0');
  SIGNAL min1  : STD_LOGIC_VECTOR(SIZE-1 downto 0):=(others=>'0');
  SIGNAL med1  : STD_LOGIC_VECTOR(SIZE-1 downto 0):=(others=>'0');

BEGIN

	triO1 : triSort GENERIC MAP  (SIZE)
					   PORT MAP  (val1 => val11,
								  val2 => val12,
						          val3 => val13,
					              OV1 => o1_1,
					              OV2 => o2_1,
					              OV3 => o3_1);
	
	triO2 : triSort GENERIC MAP  (SIZE => SIZE)
					   PORT MAP  (val1 => val21,
								  val2 => val22,
						          val3 => val23,
					              OV1 => o1_2,
					              OV2 => o2_2,
					              OV3 => o3_2);
								  
	triO3 : triSort GENERIC MAP  (SIZE => SIZE)
					   PORT MAP  (val1 => val31,
								  val2 => val32,
						          val3 => val33,
					              OV1 => o1_3,
					              OV2 => o2_3,
					              OV3 => o3_3);
								  
	minV : triMin   GENERIC MAP  (SIZE => SIZE)
					   PORT MAP  (val1 => o1_1,
								  val2 => o1_2,
						          val3 => o1_3,
					              OV1 => min1);

	maxV : triMaxi  GENERIC MAP  (SIZE => SIZE)
					   PORT MAP  (val1 => o3_1,
								  val2 => o3_2,
						          val3 => o3_3,
					              OV1 => max1);
								  
	medV : triMed   GENERIC MAP  (SIZE => SIZE)
					   PORT MAP  (val1 => o2_1,
								  val2 => o2_2,
						          val3 => o2_3,
					              OV1 => med1);	

	medF : triMed   GENERIC MAP  (SIZE => SIZE)
					   PORT MAP  (val1 => min1,
								  val2 => max1,
						          val3 => med1,
					              OV1 => output);	

	
	
END behavioral;
LIBRARY ieee;
USE     ieee.std_logic_1164.ALL;
use     ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

ENTITY triSort IS
  GENERIC(SIZE   : INTEGER);
  PORT (val1     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
        val2     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
        val3     : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
        OV1		 : OUT  STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
		OV2		 : OUT  STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
		OV3		 : OUT  STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0));
END triSort;

ARCHITECTURE behavioral OF triSort IS

BEGIN

	tri : process(val1, val2, val3)
			BEGIN
				if(not (is_X(val1) or is_X(val2) or is_X(val3))) then 
					if(unsigned(val1) <= unsigned(val2)) then
						if(unsigned(val2) <= unsigned(val3)) then
							OV1 <= val1;
							OV2 <= val2;
							OV3 <= val3;
						elsif (unsigned(val3)<=unsigned(val1)) then
							OV1 <= val3;
							OV2 <= val1;
							OV3 <= val2;
						else
							OV1 <= val1;
							OV2 <= val3;
							OV3 <= val2;
						end if;
					else
						if(unsigned(val1) <= unsigned(val3)) then
							OV1 <= val2;
							OV2 <= val1;
							OV3 <= val3;
						elsif (unsigned(val3)<=unsigned(val2)) then
							OV1 <= val3;
							OV2 <= val2;
							OV3 <= val1;
						else
							OV1 <= val2;
							OV2 <= val3;
							OV3 <= val1;
						end if;
					end if;
				end if;
		  END PROCESS;
  
END behavioral;

LIBRARY ieee;
USE     ieee.std_logic_1164.ALL;
use     ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

ENTITY mean8Maxi IS
  GENERIC(SIZE   : INTEGER);
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
END mean8Maxi;

ARCHITECTURE behavioral OF mean8Maxi IS
	
BEGIN

	medV : process(med)
				variable tempL : std_logic_vector(SIZE+4 downto 0) := (others=>'0');
			begin
				if not (is_X(val11) or is_X(val12) or is_X(val13) or is_X(val21) or is_X(val22) or is_X(val23) or is_X(val31) or is_X(val32) or is_X(val33)) then
					tempL := std_logic_vector(to_unsigned(to_integer(unsigned(val11)) + to_integer(unsigned(val12)) + to_integer(unsigned(val13)) 
											 + to_integer(unsigned(val21)) + to_integer(unsigned(val22)) + to_integer(unsigned(val23))
											+ to_integer(unsigned(val31)) + to_integer(unsigned(val32)) + to_integer(unsigned(val33)) - to_integer(unsigned(med)), tempL'length));
				
					
					tempL := tempL srl 3;
					output <= tempL(SIZE-1 downto 0);
				end if;
		   end process;

					            

	
	
END behavioral;
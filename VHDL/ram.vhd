LIBRARY ieee;
USE     ieee.std_logic_1164.ALL;
USE     ieee.numeric_std.ALL;

ENTITY ram IS
  GENERIC( SIZE : INTEGER);
  PORT (addr  : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
        rd    : IN  STD_LOGIC;
        wr    : IN  STD_LOGIC;
		clk	  : IN  STD_LOGIC;
		deb   : IN 	STD_LOGIC;
        dIN   : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
        dOUT  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END ram;

--component for emulating ram in HW

ARCHITECTURE behavioral OF ram IS

  TYPE instArray IS ARRAY (0 TO integer(SIZE)) OF STD_LOGIC_VECTOR (dIN'range);
  SIGNAL data : instArray;
  SIGNAL rAddr: STD_LOGIC_VECTOR(dIN'range);

BEGIN

  dOUT <= data (TO_INTEGER (UNSIGNED (addr))) WHEN rd = '1' ELSE (OTHERS => 'Z');

dbg: process(deb)
		begin
			if deb = '1' then
				for i in 0 to integer(SIZE/32)-1 loop
					report to_hstring(to_unsigned(i,32)) & ": " & to_hstring(data(i*16)) & " " & to_hstring(data((i*16)+1)) & " " & to_hstring(data((i*16)+2)) & " " & to_hstring(data((i*16)+3)) & " " & to_hstring(data((i*16)+4)) & " " &
						to_hstring(data((i*16)+5)) & " " & to_hstring(data((i*16)+6)) & " " & to_hstring(data((i*16)+7)) & " " & to_hstring(data((i*16)+8)) & " " & to_hstring(data((i*16)+9)) & " " & 
						to_hstring(data((i*16)+10)) & " " & to_hstring(data((i*16)+11)) & " " & to_hstring(data((i*16)+12)) & " " & to_hstring(data((i*16)+13)) & " " & to_hstring(data((i*16)+14)) & " " & 
						to_hstring(data((i*16)+15)) & " " & to_hstring(data(i*16+16)) & " " & to_hstring(data((i*16)+17)) & " " & to_hstring(data((i*16)+18)) & " " & to_hstring(data((i*16)+19)) & " " & to_hstring(data((i*16)+20)) & " " &
						to_hstring(data((i*16)+21)) & " " & to_hstring(data((i*16)+22)) & " " & to_hstring(data((i*16)+23)) & " " & to_hstring(data((i*16)+24)) & " " & to_hstring(data((i*16)+25)) & " " & 
						to_hstring(data((i*16)+26)) & " " & to_hstring(data((i*16)+27)) & " " & to_hstring(data((i*16)+28)) & " " & to_hstring(data((i*16)+29)) & " " & to_hstring(data((i*16)+30)) & " " & 
						to_hstring(data((i*16)+31));
				end loop;
			end if;
	 end process;

sim:  PROCESS (clk)
	  BEGIN
		IF (clk='1' and clk'event) THEN
			IF (wr = '1') THEN
			  data (TO_INTEGER (UNSIGNED (addr))) <= dIN;
			END IF;
			rAddr <= addr;
		END IF;
	  END process;


END behavioral;

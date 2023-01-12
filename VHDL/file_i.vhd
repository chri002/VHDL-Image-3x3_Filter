library ieee;
use ieee.std_logic_1164.all;
USE 	ieee.numeric_std.ALL;
USE     std.textio.ALL;

entity file_i is
	generic(
		NAME  : string);
    port (
        clk:    in  std_logic;
		rd :    in  std_logic;
        Data:   out std_logic_vector(7 downto 0);
        done:   out std_logic);
 end file_i;

architecture behavior of file_i is
	signal doneT : std_logic := '0';
begin

done <= doneT;

File_reader:
    process (clk, rd)
        -- "./makefile/FILE/test.jpg";
        constant filename:  string := NAME;--"./FILE/prova.bmp"; -- local to sim
        variable char_val:  character;
        variable status: FILE_OPEN_STATUS;
        variable openfile:  boolean;  
        type f is file of character;
        file ffile: f;
        variable char_count:    natural := 0;
    begin
        if rising_edge(clk) and doneT='0' and rd ='1' then
            if not openfile then
                file_open (status, ffile, filename, READ_MODE);
                if status /= OPEN_OK then
                    report "FILE_OPEN_STATUS = " & FILE_OPEN_STATUS'IMAGE(status) severity FAILURE;
                end if;
                report "FILE_OPEN_STATUS = " & FILE_OPEN_STATUS'IMAGE(status);
                openfile := TRUE;
				
            else 
                if not endfile(ffile) then
                    read(ffile, char_val);
                    --report "char_val = " & to_hstring(std_logic_vector (to_unsigned(character'pos(char_val), Data'length) ));
                    char_count := char_count + 1;
                    Data  <= std_logic_vector (to_unsigned(character'pos(char_val), Data'length) );
                 end if;
                 if endfile(ffile) then 
                    report "ENDFILE, letto " & integer'image(char_count) & "caratteri";
					FILE_CLOSE(ffile);
					if doneT='0' then
						doneT <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

end architecture behavior;
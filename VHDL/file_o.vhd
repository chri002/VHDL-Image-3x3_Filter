library ieee;
use ieee.std_logic_1164.all;
USE 	ieee.numeric_std.ALL;
USE     std.textio.ALL;

entity file_o is
  GENERIC( NAME : string);
    port (
        clk:    in  std_logic;
		wr :    in  std_logic;
		close:  in  std_logic;
        Data:   in std_logic_vector(7 downto 0);
        done:   out std_logic);
 end file_o;

architecture behavior of file_o is
	signal doneT : std_logic := '0';
begin

done <= doneT;


File_writer:
    process (clk, wr)
        constant filename:  string := NAME;--"./FILE/testo.bmp"; -- local to sim
        variable status: FILE_OPEN_STATUS;
        variable openfile:  boolean:=FALSE;
		variable buff_out: LINE;
        type f is file of character;
        file ffile: TEXT;
    begin
		if rising_edge(clk) and wr ='1' then
            if not openfile and close='0' then
                file_open (status, ffile, filename, WRITE_MODE);
                if status /= OPEN_OK then
                    report "FILE_OPEN_STATUS = " & FILE_OPEN_STATUS'IMAGE(status) severity FAILURE;
                end if;
                report "FILE_OPEN_STATUS = " & FILE_OPEN_STATUS'IMAGE(status);
                openfile := TRUE;
            else
				--report to_hstring(data) & " " &  integer'image(character'pos(character'val(to_integer(unsigned(data)))));
                write(buff_out, character'val(to_integer(unsigned(data))));
				
				   
			end if;
		elsif rising_edge(clk) and wr='0' and openfile=TRUE and close='1' then
			writeline(ffile, buff_out);-- write line to output_image text file.
			openfile:=FALSE;
			doneT <= '1';
        end if;
    end process;
	
end behavior;
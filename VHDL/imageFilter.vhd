library ieee;
use ieee.std_logic_1164.all;
USE 	ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;


entity imageFilter is 
	GENERIC(RAMSZ    : INTEGER;
			IMGNAME  : string;
			IMGNAMEO : string);
	PORT(clk   		: IN  std_logic;
		 filterMed 	: IN  std_logic;
		 done 		: OUT std_logic);
end imageFilter;

architecture behavior of imageFilter is

	component file_i is
		generic(NAME : string);
		 port ( clk   : in  std_logic;
				rd    : in  std_logic;
				Data  : out std_logic_vector(7 downto 0);
				done  : out std_logic);
	end component;
	
	component file_o is
		generic(NAME : string);
		 port ( clk	  : in  std_logic;
				wr 	  : in  std_logic;
				close : in  std_logic;
				Data  : in std_logic_vector(7 downto 0);
				done  : out std_logic);
	end component;
	
	component ram is
		 GENERIC( 	SIZE  : INTEGER);
		 PORT   ( 	addr  : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
					rd    : IN  STD_LOGIC;
					wr    : IN  STD_LOGIC;
					clk	  : IN  STD_LOGIC;
					deb   : IN  STD_LOGIC;
					dIN   : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
					dOUT  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
	end component;
	
	
	component medFilter is
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
				output    : OUT  STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0));
	end component;

	component almMeanFilter is
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
				output    : OUT  STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0));
	end component;

	constant bts   :      INTEGER := 56;
	constant SZFIL :      INTEGER := 8;
	constant UNO   :      std_logic_vector(31 downto 0):= (0=>'1', others=>'0');
	
    signal dataO   :      std_logic_vector(7 downto 0) := (others=>'0');
    signal dataI   :      std_logic_vector(7 downto 0) := (others=>'0');
	signal dataRMI :	  std_logic_vector(31 downto 0):= (others=>'0');
    signal doneTRI :      std_logic 				   := '0';
    signal doneTRO :      std_logic 				   := '0';
    signal doneT   :      std_logic 				   := '0';
	
	signal addrI   :     std_logic_vector(31 downto 0) := (others=>'0');
	signal rdI	   :	 std_logic 				   	   := '0';
	signal wrI	   :	 std_logic 				   	   := '0';
	signal wrIO	   :	 std_logic 				   	   := '0';
	signal closeW  :	 std_logic 				   	   := '0';
	signal rdIO	   :	 std_logic 				   	   := '1';
	signal debI	   :	 std_logic 				   	   := '0';
	signal dataRMO :	 std_logic_vector(31 downto 0) := (others=>'0');
	
	signal t11R, t12R, t13R, t21R, t22R, t23R, t31R, t32R, t33R, moutR, moutR1 : std_logic_vector(SZFIL-1 downto 0) := (others=>'0');
	signal t11B, t12B, t13B, t21B, t22B, t23B, t31B, t32B, t33B, moutB, moutB1 : std_logic_vector(SZFIL-1 downto 0) := (others=>'0');
	signal t11G, t12G, t13G, t21G, t22G, t23G, t31G, t32G, t33G, moutG, moutG1 : std_logic_vector(SZFIL-1 downto 0) := (others=>'0');
	
begin
uuti: file_i 
		 GENERIC map ( NAME => IMGNAME)
			port map (
					   clk  => clk,
					   data => dataI,
					   done => doneTRI,
					   rd   => rdIO
					);
					
uuto: file_o 
		 GENERIC map ( NAME => IMGNAMEO)
			port map (
					   clk => clk,
					   data => dataO,
					   done => doneTRO,
					   wr => wrIO,
					   close => closeW
					);
		
rmP: ram GENERIC MAP (SIZE => RAMSZ)
			PORT MAP (addr => addrI,
					  rd   => rdI,
					  wr   => wrI,
					  clk  => clk,
					  deb  => debI,
					  dIN  => dataRMI,
					  dOUT => dataRMO);
 
filRed: medFilter GENERIC MAP (SIZE => SZFIL)
				  PORT MAP (val11  => t11R,
							val12  => t12R,
							val13  => t13R,
							val21  => t21R,
							val22  => t22R,
							val23  => t23R,
							val31  => t31R,
							val32  => t32R,
							val33  => t33R,
							output => moutR);
 
filBlu: medFilter GENERIC MAP (SIZE => SZFIL)
				  PORT MAP (val11  => t11B,
							val12  => t12B,
							val13  => t13B,
							val21  => t21B,
							val22  => t22B,
							val23  => t23B,
							val31  => t31B,
							val32  => t32B,
							val33  => t33B,
							output => moutB);
 
filGre: medFilter GENERIC MAP (SIZE => SZFIL)
				  PORT MAP (val11  => t11G,
							val12  => t12G,
							val13  => t13G,
							val21  => t21G,
							val22  => t22G,
							val23  => t23G,
							val31  => t31G,
							val32  => t32G,
							val33  => t33G,
							output => moutG);
							
filRed1: almMeanFilter GENERIC MAP (SIZE => SZFIL)
						  PORT MAP (val11  => t11R,
									val12  => t12R,
									val13  => t13R,
									val21  => t21R,
									val22  => t22R,
									val23  => t23R,
									val31  => t31R,
									val32  => t32R,
									val33  => t33R,
									output => moutR1);
 
filBlu1: almMeanFilter GENERIC MAP (SIZE => SZFIL)
						  PORT MAP (val11  => t11B,
									val12  => t12B,
									val13  => t13B,
									val21  => t21B,
									val22  => t22B,
									val23  => t23B,
									val31  => t31B,
									val32  => t32B,
									val33  => t33B,
									output => moutB1);
 
filGre1: almMeanFilter GENERIC MAP (SIZE => SZFIL)
						  PORT MAP (val11  => t11G,
									val12  => t12G,
									val13  => t13G,
									val21  => t21G,
									val22  => t22G,
									val23  => t23G,
									val31  => t31G,
									val32  => t32G,
									val33  => t33G,
									output => moutG1);
							
done <= doneT;
 
 
 
clk_process:
    process(clk)
		variable tmp, x,y,count,XX,YY  : INTEGER 				:= 0;
		variable first, sec, thrd, skip, ending, initWrite, end_write, inc_zero: boolean := TRUE;
		variable widt, heigh, bpp, st_body, end_body			: INTEGER := 0;
		variable doneTR : std_logic 							:= '0';
		variable revTmp : std_logic_vector(0 to 31) 				:= (others=>'0');
		variable revTmp2: std_logic_vector(0 to 15) 				:= (others=>'0');
		variable tmpH   : std_logic_vector((bts)*8-1 downto 0)  := (others=>'0');
		variable tempo  : std_logic_vector(31 downto 0)   		:= (others=>'0');
		variable tempo64: std_logic_vector(63 downto 0)   		:= (others=>'0');
		variable tempo2 : std_logic_vector(32*9-1 downto 0) 	:= (others=>'0');
    begin
		if(rising_edge(clk) and doneT='0') then 
		
			
			if doneTR='0' and not is_X(dataI) then																--read image and copy to ram
				  
				  				  
				  dataRMI((4-tmp)*8-1 downto (4-tmp)*8-8) <= dataI;
				  
				  if(tmp = 3)then
					wrI   <= '1';
					tmp   := 0;
					if not inc_zero then
						addrI <= addrI + UNO;
					else
						inc_zero := FALSE;
					end if;
				  else
					wrI <= '0';
					tmp := tmp+1;
					debI <= '0';
				  end if;		
				  --report std_logic'image(doneTR) & " "& std_logic'image(doneTRIO);
				  doneTR := doneTRI or doneTR;
				  
			elsif doneTR='1' and first then																		--prepare variable to first check of img
				wrI   <= '1';
				addrI <= addrI + UNO;
				dataRMI((4-tmp)*8-1 downto (4-tmp)*8-8) <= dataI;
				
				first := FALSE;
				report integer'image(tmp);
				end_body := to_integer(unsigned(addrI))*4+(tmp+1)*4;
				
				tmp   := 0;
				rdI   <= '1';
				debI <= '1';
				inc_zero := TRUE;
			elsif ((doneTR='1' and (first=FALSE)) and (widt = 0 or heigh = 0 or bpp = 0 or st_body = 0)) then	--read information of img from header
				wrI <= '0';
				
				addrI <= (others=>'0');
				if( tmp<bts)then
					tmpH((bts-tmp)*8-1 downto (bts-1-tmp)*8)   := dataRMO(31 downto 24); 
					tmpH((bts-1-tmp)*8-1 downto (bts-2-tmp)*8) := dataRMO(23 downto 16); 
					tmpH((bts-2-tmp)*8-1 downto (bts-3-tmp)*8) := dataRMO(15 downto 8); 
					tmpH((bts-3-tmp)*8-1 downto (bts-4-tmp)*8) := dataRMO(7  downto 0); 
					if not inc_zero then
						addrI <= addrI + UNO;
					else 
						inc_zero := FALSE;
					end if;
					tmp   :=  tmp+4;
				else				
					debI  <= '0';
					revTmp   := tmpH((bts-12)*8+7 downto (bts-15)*8);
					st_body  := to_integer(unsigned(revTmp));
					
					--revTmp   := tmpH((bts-21)*8+7 downto (bts-24)*8);
					revTmp   := tmpH((bts-22)*8+7 downto (bts-22)*8) & tmpH((bts-21)*8+7 downto (bts-21)*8) & tmpH((bts-24)*8+7 downto (bts-24)*8) & tmpH((bts-23)*8+7 downto (bts-23)*8);
					widt     := to_integer(unsigned(revTmp));
					--report to_hstring(revTmp) & " " & integer'image(widt);
					
					
					--revTmp   := tmpH((bts-25)*8+7 downto (bts-28)*8);
					revTmp   := tmpH((bts-26)*8+7 downto (bts-26)*8) & tmpH((bts-25)*8+7 downto (bts-25)*8) & tmpH((bts-28)*8+7 downto (bts-28)*8) & tmpH((bts-27)*8+7 downto (bts-27)*8);
					heigh 	 := to_integer(unsigned(revTmp));
					--report to_hstring(revTmp) & " " & integer'image(heigh);
					
					
					revTmp2  := tmpH((bts-32)*8+7 downto (bts-33)*8);
					bpp   	 := to_integer(unsigned(revTmp2));
										
					
					
					
					tmp      := 0;
					--report to_hstring(tmpH);
					report integer'image(st_body) & " " & integer'image(end_body) & " " & integer'image(widt) & " " & integer'image(heigh) & " "& integer'IMAge(bpp);
				end if;
			elsif ((doneTR='1' and (first=FALSE)) and (widt > 0 or heigh > 0 or bpp > 0 or st_body > 0) and thrd) then --align img value (bits) with ram word in next memory space ( solo x semplificare )
				
				addrI <= std_logic_vector(to_unsigned((st_body)/4+(y)+2, 32));
				
				
				if(tmp = 3)then
					
					tmp   := 0;
								
					wrI <= '1';
					dataRMI <= tempo(31-((st_body)mod 4)*8 downto 0) & dataRMO(31 downto 31-((st_body)mod 4)*8+1);
					tempo := dataRMO; 
					
					
					addrI <= std_logic_vector(to_unsigned((end_body)/4+(y), 32));
					
					
					if ( y>heigh*widt-1 ) then 
						debI  <= '0';
						wrI   <= '0';
						thrd := FALSE;
						tmp := 0;
						x   := -1;
						y   := -1;
					else
						y:=y+1;
					end if;
				else
					wrI <= '0';
					tmp := tmp+1;
				end if;		
			elsif (not thrd and ending) then																--apply filter on img pixel, when on edge it use 00 when count%0=0 or(AB)^4 when 1 else ff
			
				addrI <= std_logic_vector(to_unsigned((end_body)/4+((y+YY)*widt)+(x+XX), 32));
				
				if(tmp = 3)then
					skip := FALSE;
					tmp  := 0;
					wrI  <='0';
						
					if(count=9) then
						t11B <= tempo2(287 downto 280);
						t11G <= tempo2(279 downto 272);
						t11R <= tempo2(271 downto 264);
						
						t12B <= tempo2(255 downto 248);
						t12G <= tempo2(247 downto 240);
						t12R <= tempo2(239 downto 232);
						
						t13B <= tempo2(223 downto 216);
						t13G <= tempo2(215 downto 208);
						t13R <= tempo2(207 downto 200);
						
						t21B <= tempo2(191 downto 184);
						t21R <= tempo2(183 downto 176);
						t21G <= tempo2(175 downto 168);
						
						t22B <= tempo2(159 downto 152);
						t22G <= tempo2(151 downto 144);
						t22R <= tempo2(143 downto 136);
						
						t23B <= tempo2(127 downto 120);
						t23G <= tempo2(119 downto 112);
						t23R <= tempo2(111 downto 104);
												
						t31B <= tempo2(95  downto 88);
						t31G <= tempo2(87  downto 80);
						t31R <= tempo2(79  downto 72);
						
						t32B <= tempo2(63  downto 56);
						t32G <= tempo2(55  downto 48);
						t32R <= tempo2(47  downto 40);
						
						t33B <= tempo2(31  downto 24);
						t33G <= tempo2(23  downto 16);
						t33R <= tempo2(15  downto 8);
						count := count+1;
					elsif( count =10 ) then
						--report to_hstring(tempo2) ;
						
						addrI <= std_logic_vector(to_unsigned((end_body)/4+((YY)*widt+(XX))+widt*heigh+8, 32));
						wrI   <= '1';
						tempo   := (moutB & moutG & moutR & "11111111") when filterMed='0' else (moutB1 & moutG1 & moutR1 & "11111111");
						dataRMI <= tempo;
						t11B <= (others=>'0');
						t11G <= (others=>'0');
						t11R <= (others=>'0');
						
						t12B <= (others=>'0');
						t12G <= (others=>'0');
						t12R <= (others=>'0');
						
						t13B <= (others=>'0');
						t13G <= (others=>'0');
						t13R <= (others=>'0');
						
						t21B <= (others=>'0');
						t21R <= (others=>'0');
						t21G <= (others=>'0');
						
						t22B <= (others=>'0');
						t22G <= (others=>'0');
						t22R <= (others=>'0');
						
						t23B <= (others=>'0');
						t23G <= (others=>'0');
						t23R <= (others=>'0');
												
						t31B <= (others=>'0');
						t31G <= (others=>'0');
						t31R <= (others=>'0');
						
						t32B <= (others=>'0');
						t32G <= (others=>'0');
						t32R <= (others=>'0');
						
						t33B <= (others=>'0');
						t33G <= (others=>'0');
						t33R <= (others=>'0');
						
						if((YY*widt+XX) mod integer(heigh*widt/10) = 0)then
							report integer'image((YY*widt+XX)) & "/" & integer'image((heigh*widt));
						end if;
						
						--report integer'image(XX) & " " & integer'image(YY) &" "&integer'image(YY*widt+XX);
						
						
						if ( XX >=widt-1  ) then 
							XX:=0; 
							YY:=YY+1; 
							x :=-1;
							y :=-1;
						else 
							XX:=XX+1; 
							x :=-1;
							y :=-1;
						end if;
						if ( YY*widt+XX >= heigh*widt ) then 
							tmp  := 0;
							ending :=FALSE;
							
							report "FINE";
						end if;
						
						count := 0;
					else 
						if (YY=0 and y=-1 and count<=2) then 
							skip := TRUE;
						end if;
						if (XX + x >= widt) then
							skip := TRUE;
						end if;	
						if( XX=0 and x=-1 and (count mod (widt))=0 )then
							skip:=TRUE;
						end if;
						if (YY=heigh-1 and count>5)then
							skip:=TRUE;
						end if;
						
						--report boolean'image(not skip) & " " & integer'image(x) & " " & integer'image(XX) & " " & integer'image(y) & " " & integer'image(YY);
						if (skip=TRUE) then
							tempo := (others=>'0');
						else 
							tempo := dataRMO;
							
						end if;
						
						if(is_X(tempo)) then
							if(count mod 3 = 0) then
								tempo := (others=>'0');
							elsif count mod 3 = 1 then
								tempo := "01010111010101110101011101010111";
							else
								tempo := (others=>'1');
							end if;
						end if;
						
						tempo2((32*9)-(count)*32-1 downto (32*9)-((count+1)*32)) := tempo;
						
						if ( x >=1  ) then 
							x:=-1; 
							y:=y+1; 
						else 
							x:=x+1; 
						end if;
						if ( y >= 2 ) then 
							--debI <= '1';
							tmp  := 0;
							y:=-1;
						end if;
						if count >8 then
							count := 8;
						end if;
						count := count+1;
						
					end if;
					
					
				
				else
					wrI  <= '0';
					tmp  := tmp+1;
					debI <= '0';
				end if;		
			elsif ending=FALSE and initWrite then																--prepare variable to write on file new img
				addrI 	  <= std_logic_vector(to_unsigned((end_body)/4+((YY)*widt+(XX))+widt*heigh+7, 32));
				wrI  	  <= '0';
				tempo     := (moutB & moutG & moutR & "11111111") when filterMed='0' else (moutB1 & moutG1 & moutR1 & "11111111");
				dataRMI   <= tempo;
				initWrite := FALSE;
				tempo     := (others=>'0');
				y         := 0;
				x         := 0;
				tmp       := -1;
				wrIO <= '0';
			elsif ending=FALSE and initWrite=FALSE and end_write then											--write new img
				debI  <= '1';
				rdI   <= '1';
							
				if(tmp = -1)then
					
					if y=1 then
						wrIO  <= '1';
					end if;
			
						
					addrI <= std_logic_vector(to_unsigned((y+x), 32));
					
					
					
					--report integer'image(y+x) & " " & integer'image(y) & " " &integer'image(x);
					
										
					if ( y>=(st_body-(st_body mod 4)) / 4+1) then 
						if x<2  and (y+x+1)*4>st_body then
							x:=2*widt*heigh+10;
							wrIO <= '0';
						elsif (y+x)*4>st_body then
							wrIO <= '1';
							x:=x+1;
						else
							wrIO <= '0';
							x:=0;
						end if;
						if(x>2*widt*heigh+10+widt*heigh) then
							report "forse";
							wrIO <= '0';
							end_write:=FALSE;
						
						end if;
						
					else
						y:=y+1;
					end if;
					tmp := tmp +1;
						
				else
					if tmp=0 then
						if y>1 then
							wrIO  <= '1';
						end if;
						
						--report "::"&" " &integer'image(to_integer(unsigned(addrI))) & " " & to_hstring(addrI) &" : "& to_hstring(tempo)  &"  "&to_hstring(dataRMO);
						
						
					end if;
					if tmp<4 then
						
						if (not is_X(tempo)) and x<2 and y>1 and tmp<4 and y*4+x<=st_body then	
							dataO <= tempo((4-tmp)*8-1 downto (4-tmp)*8-8);
						elsif (not is_X(tempo)) and x>(2*widt*heigh)+11 and tmp<4 then
							if(not is_X(dataRMO)) then
								tempo64 := tempo & dataRMO;
							else
								tempo64 := (63 downto 32=>tempo,others=>'0');
							end if;
							--report integer'image(((st_body)mod 4)*8+(4-tmp)*8-1) &" "& integer'image(((st_body)mod 4)*8+(4-tmp)*8-8);
							dataO   <= tempo64(((st_body)mod 4)*8+(4-tmp)*8-1 downto ((st_body)mod 4)*8+(4-tmp)*8-8);
						end if;	
						
						tmp := tmp+1;
						if (tmp>=4 and x>(2*widt*heigh))then
							wrIO <= '0';
						end if;
						--report to_hstring(tempo) & " "& to_hstring(dataRMO) & " " & integer'image(tmp) & " " & std_logic'image(wrIO) & " " & integer'image(y);
					
					else 
						wrIO <= '0';
						tmp := -1;
						tempo := (dataRMO);
						
					end if;		
				end if;
				
				
			elsif end_write=FALSE then															--ending
				closeW <= '1';
				debI  <= '1';
				doneT <= doneTRO;
			end if;
		
			
		end if;
     end process;
end architecture behavior;


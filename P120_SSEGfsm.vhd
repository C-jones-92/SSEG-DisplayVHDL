library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity P120_SSEGfsm is
    Port ( CLK : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (4 downto 0);
           SSEG_CA : out std_logic_vector (7 downto 0);
           SSEG_AN : out std_logic_vector (3 downto 0));
end P120_SSEGfsm;



architecture Behavioral of P120_SSEGfsm is
    type FSMstates is (s1,s1b,s1bb,s2,s2b,s2bb,s3,s3b,s3bb,s4,s4b,s4bb);
    type MeltStates is (m1,m2,m3,m4,m5,m6,m7,m8);
    type UnmeltStates is (um1, um2,um3,um4,um5,um6,um7,um8);
    signal MCtr: unsigned (31 downto 0) := X"00000000";
    signal WhatToDisplay:  std_logic_vector(7 downto 0) := "10000000";
    signal WhereToDisplay: std_logic_vector(3 downto 0) := "1000";
    signal CurrentState, NextState: FSMstates := s1;
    signal CurrentMelt, NextMelt : MeltStates := m1;
    signal CurrentUnmelt, NextUnmelt : UnmeltStates := um8;
    
begin

process (clk) begin
    if(rising_edge(clk)) then
        MCtr <= MCtr+1;
        if(MCtr > X"05F5_E100") then
            MCtr <= (others => '0');
            CurrentState <= NextState; 
            CurrentMelt <= NextMelt;
            CurrentUnMelt <= NextUnMelt;   
        end if; 
        SSEG_CA <= WhatToDisplay;
        SSEG_AN <= WhereToDisplay;
    end if;
end process;


process (SW(4 downto 0), CurrentState, CurrentMelt, CurrentUnMelt) begin
    if(SW(3) = '1') then
        case (CurrentMelt) is
            when m1 =>   
                NextMelt <= m2;
                NextUnmelt <= um7;
                WhatToDisplay <= "10000000";
            when m2 =>
				NextMelt <= m3;
				NextUnmelt <= um6;	
				WhatToDisplay <= "11000000";
			when m3 =>
				NextMelt <= m4;
				NextUnmelt <= um5;
				WhatToDisplay <= "11100000";
			when m4 =>
				NextMelt <= m5;
				NextUnmelt <= um4;
				WhatToDisplay <= "11110000";
			when m5 =>
				NextMelt <= m6;
				NextUnmelt <= um3;
				WhatToDisplay <= "11111000";
			when m6 =>
				NextMelt <= m7;
				NextUnmelt <= um2;
				WhatToDisplay <= "11111100";
			when m7 =>
				NextMelt <= m8;
				NextUnmelt <= um1;
				WhatToDisplay <= "11111110";
			when m8 =>
			    NextMelt <= m8;
				NextUnmelt <= um1;
				WhatToDisplay <= "11111111";
             when others => 
        end case;
    
    elsif(SW(2) = '1') then
        case(CurrentUnmelt) is 
				when um1 =>								
					NextUnmelt <= um2;
					NextMelt <= m7;			
					WhatToDisplay <= "11111111";
				when um2 =>
					NextUnmelt <= um3;
					NextMelt <= m6;
					WhatToDisplay <= "11111110";
				when um3 =>
					NextUnmelt <= um4;
					NextMelt <= m5;
					WhatToDisplay <= "11111100";
				when um4 =>
					NextUnmelt <= um5;
					NextMelt <= m4;
					WhatToDisplay <= "11111000";
				when um5 =>
					NextUnmelt <= um6;
					NextMelt <= m3;
					WhatToDisplay <= "11110000";
				when um6 =>
					NextUnmelt <= um7;
					NextMelt <= m2;
					WhatToDisplay <= "11100000";
				when um7 =>
					NextUnmelt <= um8;
					NextMelt <= m1;
					WhatToDisplay <= "11000000";
				when um8 =>
					NextUnmelt <= um8;		
					NextMelt <= m1;	
					WhatToDisplay <= "10000000";
				when others =>
			end case;	
			
    else
            case(CurrentState) is
             when s1 =>
                WhereToDisplay <= "0111";
                if(SW(4) = '1') then
                    NextState <= s1b;
                elsif(SW(1) = '1') then
                    if(SW(0) = '1') then
                        NextState  <= s1b;
                    else 
                        NextState <= s2;
                    end if;
                elsif(SW(1) = '0') then
                    if(SW(0) = '1') then
                        NextState <= s1b;
                    else
                    NextState <= s4;
                    end if;
                end if;
             when s2 => 
                WhereToDisplay <= "1011";
                    if(SW(4) = '1') then
                        NextState <= s2b;
                    elsif(SW(1) = '1') then
                        if(SW(0) = '1') then
                            NextState  <= s2b;
                        else 
                            NextState <= s3;
                        end if;
                    elsif(SW(1) = '0') then
                        if(SW(0) = '1') then
                            NextState <= s2b;
                        else
                        NextState <= s1;
                        end if;
                    end if; 
             when s3 => 
                WhereToDisplay <= "1101";   
                    if(SW(4) = '1') then
                        NextState <= s3b;
                    elsif(SW(1) = '1') then
                        if(SW(0) = '1') then
                            NextState  <= s3b;
                        else 
                            NextState <= s4;
                        end if;
                    elsif(SW(1) = '0') then
                        if(SW(0) = '1') then
                            NextState <= s3b;
                        else
                        NextState <= s2;
                        end if;
                    end if;
             when s4 => 
             WhereToDisplay <= "1110";
                    if(SW(4) = '1') then
                        NextState <= s4b;
                    elsif(SW(1) = '1') then
                        if(SW(0) = '1') then
                            NextState  <= s4b;
                        else 
                            NextState <= s1;
                        end if;
                    elsif(SW(1) = '0') then
                        if(SW(0) = '1') then
                            NextState <= s4b;
                        else
                        NextState <= s3;
                        end if;
                    end if;   
             when s1b => 
             WhereToDisplay <= "0111";
                if(SW(4) = '1') then
                    NextState <= s1bb;
                elsif (SW(1) = '1') then
                    NextState <= s2; 
                else
                    NextState <= s4;
                end if;
             when s2b => 
             WhereToDisplay <= "1011";
                if(SW(4) = '1') then
                    NextState <= s2bb;
                elsif (SW(1) = '1') then
                    NextState <= s3; 
                else
                    NextState <= s1;
                end if;
             when s3b =>
             WhereToDisplay <= "1101"; 
                if(SW(4) = '1') then
                    NextState <= s3bb;
                elsif (SW(1) = '1') then
                    NextState <= s4; 
                else
                    NextState <= s2;
                end if;
             when s4b => 
             WhereToDisplay <= "1110";
                if(SW(4) = '1') then
                    NextState <= s4bb;
                elsif (SW(1) = '1') then
                    NextState <= s1; 
                else
                    NextState <= s3;
                end if;   
             when s1bb =>
             WhereToDisplay <= "0111";
                if(sw(1) = '1') then
                    NextState <= s2;
                else
                    NextState <= s4;
                end if; 
            when s2bb =>
            WhereToDisplay <= "1011";
                if(sw(1) = '1') then
                    NextState <= s3;
                else
                    NextState <= s1;
                end if;  
             when s3bb =>
             WhereToDisplay <= "1101";
                if(sw(1) = '1') then
                    NextState <= s4;
                else
                    NextState <= s2;
                end if;     
              when s4bb =>
              WhereToDisplay <= "1110";
                if(sw(1) = '1') then
                    NextState <= s1;
                else
                    NextState <= s3;
                end if;  
         end case;     
         end if;  
    end process;


end Behavioral;

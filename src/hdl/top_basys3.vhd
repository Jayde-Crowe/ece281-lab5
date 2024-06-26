--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
port(
         -- Inputs
        clk : in std_logic;
        btnU : in std_logic;
        btnC : in std_logic;
        sw : in std_logic_vector(7 downto 0); -- two different sets iof switches...?
        
        
        -- Outputs
        led : out std_logic_vector(15 downto 0);
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector (3 downto 0)
);

end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	-- declare components and signals
	
	component TDM4 is 
        generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
        Port ( i_clk        : in  STD_LOGIC;
               i_reset        : in  STD_LOGIC; -- asynchronous
               i_sign         : in  STD_LOGIC;
               i_hund         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_tens         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_ones         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_data        : out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_sel        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
        );
    end component TDM4;
    
    
    
    component clock_divider is
        generic ( constant k_DIV : natural := 2    ); -- How many clk cycles until slow clock toggles
                                                   -- Effectively, you divide the clk double this 
                                                   -- number (e.g., k_DIV := 2 --> clock divider of 4)
        port (     i_clk    : in std_logic;
                i_reset  : in std_logic;           -- asynchronous
                o_clk    : out std_logic           -- divided (slow) clock
        );
    end component clock_divider;
    
    component twoscomp_decimal is
        port (
            i_binary: in std_logic_vector(7 downto 0);
            o_negative: out std_logic;
            o_hundreds: out std_logic_vector(3 downto 0);
            o_tens: out std_logic_vector(3 downto 0);
            o_ones: out std_logic_vector(3 downto 0)
        );
    end component twoscomp_decimal;
    
    component controller_fsm is
            Port ( i_reset   : in  STD_LOGIC;
                   i_adv     : in  STD_LOGIC;
                   i_clk     : In STD_LOGIC;
                   o_cycle   : out STD_LOGIC_VECTOR (3 downto 0)           
                 );
        end component controller_fsm;
    
   component sevenSegDecoder is
             Port ( 
                    i_D : in STD_LOGIC_VECTOR (3 downto 0);
                    o_S : out STD_LOGIC_VECTOR (6 downto 0)
             );
         end component sevenSegDecoder;
         
         component ALU is
         port(
             -- Inputs
             i_a : in std_logic_vector (7 downto 0);
             i_b : in std_logic_vector (7 downto 0);
             i_op : in std_logic_vector (2 downto 0);
             
             -- Outputs
             o_flags : out std_logic_vector (2 downto 0);
             o_results : out std_logic_vector (7 downto 0)
          );
             
         end component ALU;
         
         component MUX is
         port(
             i_input : in std_logic_vector (7 downto 0);
             i_numA : in std_logic_vector(7 downto 0);
             i_numB : in std_logic_vector(7 downto 0);
             i_dec : in std_logic_vector(1 downto 0);
             o_output : out std_logic_vector (7 downto 0)
             );
         end component MUX;
         
         
--signal w_reset : std_logic;
--signal w_clk : std_logic;
--signal w_flag : std_logic_vector (2 downto 0);
--signal w_result : std_logic_vector (7 downto 0);
--signal w_bin : std_logic_vector (7 downto 0);
--signal w_sign : std_logic_vector (3 downto 0);
--signal w_hund : std_logic_vector (3 downto 0);
--signal w_tens : std_logic_vector (3 downto 0);
--signal w_ones : std_logic_vector (3 downto 0);
--signal w_data : std_logic_vector (3 downto 0);
--signal w_sel : std_logic_vector (3 downto 0);
--signal w_redA : std_logic_vector (7 downto 0);
--signal w_redB : std_logic_vector (7 downto 0);
--signal w_adv : std_logic;
--signal w_state :std_logic_vector (3 downto 0);
--signal w_cycle : std_logic_vector (3 downto 0);

signal w_reset : std_logic;
signal w_adv : std_logic;

signal w_cycle : std_logic_vector (3 downto 0);

signal w_redA : std_logic_vector (7 downto 0);
signal w_redB : std_logic_vector (7 downto 0);
--signal w_flags : std_logic_vector (2 downto 0);
signal w_result : std_logic_vector (7 downto 0);

signal w_bin : std_logic_vector (7 downto 0);

signal w_negative : std_logic;
signal w_hund : std_logic_vector (3 downto 0);
signal w_tens : std_logic_vector (3 downto 0);
signal w_ones : std_logic_vector (3 downto 0);

signal w_clk : std_logic;

signal w_data : std_logic_vector (3 downto 0);


  signal w_sel :std_logic_vector (3 downto 0);

begin
	-- PORT MAPS ----------------------------------------
	
		w_reset <= btnU;
        w_adv <= btnC;
        
        
        
         controller_fsm_inst : controller_fsm
           port map(
                  i_clk => clk,
                  i_adv => btnC,
                  i_reset => btnU,
                  o_cycle => w_cycle
           );
           
           ALU_inst : ALU
         port map(
                   i_a => w_redA, 
                   i_b => w_redB,  
                   i_op => sw(2 downto 0),
                   o_flags => led(15 downto 13),
                   o_results => w_result
        );
        
         
        MUX_inst : MUX
        port map(
                   i_numA => w_redA,
                   i_numB => w_redB,
                   i_input => w_result, 
                   i_dec => w_cycle (1 downto 0),
                   o_output => w_bin
        
                );
                
    twoscomp_decimal_inst   : twoscomp_decimal
                            port map (
                                i_binary    => w_bin,
                                o_negative  => w_negative,
                                o_hundreds  => w_hund,
                                o_tens      => w_tens,
                                o_ones      => w_ones
                            );

     clock_divider_inst  : clock_divider
            port map (
                i_clk   => clk,
                i_reset => w_reset,
                o_clk   => w_clk
            );

                
    TDM4_inst   : TDM4
                    port map (
                        i_clk   => w_clk,
                        i_reset => btnU,
                        i_sign    => w_negative,
                        i_hund    => w_hund,
                        i_tens    => w_tens,
                        i_ones    => w_ones,
                        o_data  => w_data,
                        o_sel   => w_sel
                    );
         

    sevenSegDecoder_inst    : sevenSegDecoder
        port map (
            i_D => w_data,
            o_S => seg
        );
        


            

                

                    

         

         
         


	
	-- CONCURRENT STATEMENTS ----------------------------
	
    led(12) <= '0';
    led(11) <= '0';
    led(10) <= '0';
    led(9) <= '0';
    led(8) <= '0';
    led(7) <= '0';
    led(6) <= '0';
    led(5) <= '0';
    led(4) <= '0';
    
    led(3 downto 0) <= w_cycle;
    
 
    -- Registers
    regA_proc: process (w_cycle)
    begin
        if(w_reset = '1') then 
            w_redA <= "00000000";
        elsif(w_cycle="1000") then
            w_redA <= sw(7 downto 0);
        end if;   
     end process;
     
     
     regB_proc : process (w_cycle)
     begin
        if(w_reset = '1') then
            w_redB <= "00000000";
        elsif(w_cycle="0100") then 
            w_redB <= sw(7 downto 0);
        end if;
     end process;
        
            
   an<=x"E" when w_cycle="0000" else w_sel;

	
	
end top_basys3_arch;

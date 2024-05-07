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
               i_D3         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D2         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D1         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D0         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
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
             i_sel : in std_logic;
             
             -- Outputs
             o_flags : out std_logic_vector (2 downto 0);
             o_results : out std_logic_vector (7 downto 0)
          );
               
         
             
         end component ALU;
         
signal w_reset : std_logic;
signal w_clk : std_logic;
signal w_flag : std_logic_vector (3 downto 0);
signal w_result : std_logic_vector (3 downto 0);
signal w_bin : std_logic_vector (7 downto 0);
signal w_sign : std_logic_vector (3 downto 0);
signal w_hund : std_logic_vector (3 downto 0);
signal w_tens : std_logic_vector (3 downto 0);
signal w_ones : std_logic_vector (3 downto 0);
signal w_data : std_logic_vector (3 downto 0);
signal w_sel : std_logic_vector (3 downto 0);
  
begin
	-- PORT MAPS ----------------------------------------

    sevenSegDecoder_inst    : sevenSegDecoder
        port map (
            i_D => w_data,
            o_S => seg
        );
        
     clock_divider_inst  : clock_divider
            port map (
                i_clk   => clk,
                i_reset => w_reset,
                o_clk   => w_clk
            );
            
    twoscomp_decimal_inst   : twoscomp_decimal
                port map (
                    i_binary    => w_bin,
                    o_negative  => w_sign(0),
                    o_hundreds  => w_hund,
                    o_tens      => w_tens,
                    o_ones      => w_ones
                );
                
    TDM4_inst   : TDM4
                    port map (
                        i_clk   => w_clk,
                        i_reset => w_reset,
                        i_D3    => w_sign,
                        i_D2    => w_hund,
                        i_D1    => w_tens,
                        i_D0    => w_ones,
                        o_data  => w_data,
                        o_sel   => an
                    );
                    
          ALU_inst : ALU
          port map(
                    i_a => sw,  -- I need help with this
                    i_b => sw,  -- I need help with this
                    i_sel => w_sel(0),
                    o_flags => w_flag,
                    o_results => w_bin
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
   

	
	
end top_basys3_arch;

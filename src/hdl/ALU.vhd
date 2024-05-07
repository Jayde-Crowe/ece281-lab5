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
--|
--| ALU OPCODES:
--|
--|     ADD     000
--|     SUB     100
--|     OR      010
--|     AND     011
--|     SHIFT L  101  SHIFT R 001
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity ALU is
port(
    -- Inputs
    i_a : in std_logic_vector (7 downto 0);
    i_b : in std_logic_vector (7 downto 0);
    i_sel : in std_logic_vector (2 downto 0);
    
    -- Outputs
    o_flags : out std_logic_vector (2 downto 0);
    o_results : out std_logic_vector (7 downto 0)
 );
      

    
end ALU;

architecture behavioral of ALU is 
  
	-- declare components and signals
	signal w_add_sub : std_logic_vector (7 downto 0) ;
	--signal w_and : std_logic_vector (7 downto 0);
	--signal w_or : std_logic_vector (7 downto 0);
	--signal w_shift : std_logic_vector (7 downto 0);
	signal w_output : std_logic_vector (7 downto 0);

  
begin

w_add_sub <= std_logic_vector(unsigned(i_a) + unsigned (i_b)) when i_sel(0) = '0' else
             std_logic_vector(unsigned(i_a) - unsigned(i_b));    
	
	
	
end behavioral;

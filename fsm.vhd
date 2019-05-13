-- fsm.vhd: Finite State Machine
-- Author(s): Ivan Korneichuk
-- login: xkorne01
-- 1759031990, 1772065713
library ieee;
use ieee.std_logic_1164.all;
-- ----------------------------------------------------------------------------
--                        Entity declaration
-- ----------------------------------------------------------------------------
entity fsm is
port(
   CLK         : in  std_logic;
   RESET       : in  std_logic;

   -- Input signals
   KEY         : in  std_logic_vector(15 downto 0);
   CNT_OF      : in  std_logic;

   -- Output signals
   FSM_CNT_CE  : out std_logic;
   FSM_MX_MEM  : out std_logic;
   FSM_MX_LCD  : out std_logic;
   FSM_LCD_WR  : out std_logic;
   FSM_LCD_CLR : out std_logic
);
end entity fsm;
-- -------------------------------------------------------
--                      Architecture declaration
-- -------------------------------------------------------
architecture behavioral of fsm is
  type t_state is (S1, S2, S_3,
                  S4_1, S4_2,
                  S5_1, S5_2,
                  S6_1, S6_2,
                  S7_1, S7_2,
                  S8_1, S8_2,
                  S9_1, S9_2,
                  S10_1, S10_2,
                  FAIL, SUCCESS, ALLOWED, DENIED, FINISH);
  signal present_state, next_state : t_state;

begin
-- -------------------------------------------------------
sync_logic : process(RESET, CLK)
begin
  if (RESET = '1') then
    present_state <= S1;
  elsif (CLK'event AND CLK = '1') then
    present_state <= next_state;
  end if;
end process sync_logic;
-- -------------------------------------------------------
next_state_logic : process(present_state, KEY, CNT_OF)
begin
  case (present_state) is
    --(1) [1] = 1
    when S1 =>
    next_state <= S1;
    if (KEY(1) = '1') then
      next_state <= S2;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    --(2) [2] = 7
    when S2 =>
    next_state <= S2;
    if (KEY(7) = '1') then
      next_state <= S_3;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    --(3) [3] = 5 | 7
    when S_3 =>
    next_state <= S_3;
    if (KEY(5) = '1') then
      next_state <= S4_1;
    elsif (KEY(7) = '1') then
      next_state <= S4_2;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    --(4.1) [3] = 5 => [4] = 9
    when S4_1 =>
    next_state <= S4_1;
    if (KEY(9) = '1') then
      next_state <= S5_1;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    --(4.2) [3] = 7 && [4] = 2
    when S4_2 =>
    next_state <= S4_2;
    if (KEY(2) = '1') then
      next_state <= S5_2;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    --(5.1) [3] = 5 && [5] = 0
    when S5_1 =>
    next_state <= S5_1;
    if (KEY(0) = '1') then
      next_state <= S6_1;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    --(5.2) [3] = 7 && [5] = 0
    when S5_2 =>
    next_state <= S5_2;
    if (KEY(0) = '1') then
      next_state <= S6_2;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    --(6.1) [3] = 5 && [6] = 3
    when S6_1 =>
    next_state <= S6_1;
    if (KEY(3) = '1') then
      next_state <= S7_1;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    --(6.2) [3] = 7 && [6] = 6
    when S6_2 =>
    next_state <= S6_2;
    if (KEY(6) = '1') then
      next_state <= S7_2;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    --(7.1) [7] = 1
    when S7_1 =>
    next_state <= S7_1;
    if (KEY(1) = '1') then
      next_state <= S8_1;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    --(7.2) [7] = 5
    when S7_2 =>
    next_state <= S7_2;
    if (KEY(5) = '1') then
      next_state <= S8_2;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    --(8.1) [8] = 9
    when S8_1 =>
    next_state <= S8_1;
    if (KEY(9) = '1') then
      next_state <= S9_1;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    -- (8.2) [8] = 7
    when S8_2 =>
    next_state <= S8_2;
    if (KEY(7) = '1') then
      next_state <= S9_2;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    --(9.1) [9] = 9
    when S9_1 =>
    next_state <= S9_1;
    if (KEY(9) = '1') then
      next_state <= S10_1;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    --(9.2) [9] = 1
    when S9_2 =>
    next_state <= S9_2;
    if (KEY(1) = '1') then
      next_state <= S10_2;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    --(10.1) [10] = 0
    when S10_1 =>
    next_state <= S10_1;
    if (KEY(0) = '1') then
      next_state <= SUCCESS;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    --(10.2) [10] = 3
    when S10_2 =>
    next_state <= S10_2;
    if (KEY(3) = '1') then
      next_state <= SUCCESS;
    elsif (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    -- SUCCESS
    when SUCCESS =>
    next_state <= SUCCESS;
    if (KEY(14 downto 0) /= "000000000000000") then
      next_state <= FAIL;
    elsif (KEY(15) = '1') then
      next_state <= ALLOWED;
    end if;
    -- FAIL
    when FAIL =>
    next_state <= FAIL;
    if(KEY(15) = '1') then
      next_state <= DENIED;
    end if;
    -- ALLOWED
    when ALLOWED =>
    next_state <= ALLOWED;
    if (CNT_OF = '1') then
      next_state <= FINISH;
    end if;
    -- DENIED
    when DENIED =>
    next_state <= DENIED;
    if (CNT_OF = '1') then
      next_state <= FINISH;
    end if;
    -- FINISH
    when FINISH =>
    next_state <= FINISH;
    if (KEY(15) = '1') then
      next_state <= S1;
    end if;
    -- others
    when others =>
    next_state <= S1;

  end case;
end process next_state_logic;

output_logic : process(present_state, KEY)
begin
   FSM_CNT_CE     <= '0';
   FSM_MX_MEM     <= '0';
   FSM_MX_LCD     <= '0';
   FSM_LCD_WR     <= '0';
   FSM_LCD_CLR    <= '0';

   case (present_state) is
   -- - - - - - - - - - - - - - - - - - - - - - -
   when ALLOWED =>
   FSM_CNT_CE <= '1';
   FSM_LCD_WR <= '1';
   FSM_MX_LCD <= '1';
   FSM_MX_MEM <= '1';
   -- - - - - - - - - - - - - - - - - - - - - - -
   when DENIED =>
   FSM_CNT_CE <= '1';
   FSM_MX_LCD <= '1';
   FSM_LCD_WR <= '1';
   -- - - - - - - - - - - - - - - - - - - - - - -
   when FINISH =>
   if (KEY(15) = '1') then
     FSM_LCD_CLR <= '1';
   end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when others =>
   if (KEY(15) = '1') then
     FSM_LCD_CLR <= '1';
   elsif (KEY(14 downto 0) /= "000000000000000") then
     FSM_LCD_WR <= '1';
   end if;
   end case;
end process output_logic;

end architecture behavioral;

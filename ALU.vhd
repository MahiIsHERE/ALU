library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ALU is
    Port (
        OperandA    : in  STD_LOGIC_VECTOR (7 downto 0);
        OperandB    : in  STD_LOGIC_VECTOR (7 downto 0);
        Opcode      : in  STD_LOGIC_VECTOR (3 downto 0);
        Result      : out STD_LOGIC_VECTOR (7 downto 0);
        ZeroFlag    : out STD_LOGIC;
        CarryFlag   : out STD_LOGIC;
        OverflowFlag: out STD_LOGIC;
        GreaterFlag : out STD_LOGIC;
        EqualFlag   : out STD_LOGIC
    );
end ALU;


architecture Behavioral of ALU is

    signal TempResult  : UNSIGNED(8 downto 0); -- 9-bit for carry handling
    signal FinalResult : STD_LOGIC_VECTOR(7 downto 0);

begin
    process(OperandA, OperandB, Opcode)
    begin
        -- Default flag values
        ZeroFlag    <= '0';
        CarryFlag   <= '0';
        OverflowFlag<= '0';
        GreaterFlag <= '0';
        EqualFlag   <= '0';

        case Opcode is
            -- Addition
            when "0000" =>
                TempResult   <= ('0' & UNSIGNED(OperandA)) + ('0' & UNSIGNED(OperandB));
                CarryFlag    <= TempResult(8);
                OverflowFlag <= (OperandA(7) and OperandB(7) and not TempResult(7)) or 
                                (not OperandA(7) and not OperandB(7) and TempResult(7));

            -- Subtraction
            when "0001" =>
                TempResult   <= ('0' & UNSIGNED(OperandA)) - ('0' & UNSIGNED(OperandB));
                CarryFlag    <= not TempResult(8);  -- Borrow flag (active-low carry)
                OverflowFlag <= (OperandA(7) and not OperandB(7) and not TempResult(7)) or 
                                (not OperandA(7) and OperandB(7) and TempResult(7));

            -- AND
            when "0010" =>
                TempResult(7 downto 0) <= UNSIGNED(OperandA) and UNSIGNED(OperandB);
                TempResult(8) <= '0';

            -- OR
            when "0011" =>
                TempResult(7 downto 0) <= UNSIGNED(OperandA) or UNSIGNED(OperandB);
                TempResult(8) <= '0';

            -- NOT
            when "0100" =>
                TempResult(7 downto 0) <= not UNSIGNED(OperandA);
                TempResult(8) <= '0';

            -- Comparison (A > B)
            when "1010" =>
                if UNSIGNED(OperandA) > UNSIGNED(OperandB) then
                    TempResult <= "000000001";
                    GreaterFlag <= '1';
                else
                    TempResult <= "000000000";
                end if;

            -- Equality Check (A == B)
            when "1011" =>
                if OperandA = OperandB then
                    TempResult <= "000000001";
                    EqualFlag <= '1';
                else
                    TempResult <= "000000000";
                end if;

            when others =>
                TempResult <= (others => '0');
        end case;

        -- Assign the result to the new signal
        FinalResult <= STD_LOGIC_VECTOR(TempResult(7 downto 0));

        -- Zero Flag (Check if result is 0)
        if FinalResult = "00000000" then
            ZeroFlag <= '1';
        end if;

    end process;

    -- Assign final result to output outside the process
    Result <= FinalResult;

end Behavioral;

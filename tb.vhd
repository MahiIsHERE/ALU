library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ALU_TB is
end ALU_TB;


architecture Behavioral of ALU_TB is

    signal OperandA, OperandB, Result : STD_LOGIC_VECTOR(7 downto 0);
    signal Opcode : STD_LOGIC_VECTOR(3 downto 0);
    signal ZeroFlag, CarryFlag, OverflowFlag, GreaterFlag, EqualFlag : STD_LOGIC;

begin
    -- Instantiate the ALU
    uut: entity work.ALU
        port map (
            OperandA => OperandA,
            OperandB => OperandB,
            Opcode => Opcode,
            Result => Result,
            ZeroFlag => ZeroFlag,
            CarryFlag => CarryFlag,
            OverflowFlag => OverflowFlag,
            GreaterFlag => GreaterFlag,
            EqualFlag => EqualFlag
        );

    -- Test process
    process
    begin
        -- Test Addition (5 + 3 = 8)
        OperandA <= "00000101"; -- 5
        OperandB <= "00000011"; -- 3
        Opcode <= "0000"; -- Addition
        wait for 10 ns;

        -- Test Subtraction (7 - 3 = 4)
        OperandA <= "00000111"; -- 7
        OperandB <= "00000011"; -- 3
        Opcode <= "0001"; -- Subtraction
        wait for 10 ns;

        -- Test AND (5 AND 3 = 1)
        OperandA <= "00000101"; -- 5
        OperandB <= "00000011"; -- 3
        Opcode <= "0010"; -- AND
        wait for 10 ns;

        -- Test OR (5 OR 3 = 7)
        OperandA <= "00000101"; -- 5
        OperandB <= "00000011"; -- 3
        Opcode <= "0011"; -- OR
        wait for 10 ns;

        -- Test NOT (~5)
        OperandA <= "00000101"; -- 5
        Opcode <= "0100"; -- NOT
        wait for 10 ns;

        -- Test Greater (7 > 3)
        OperandA <= "00000111"; -- 7
        OperandB <= "00000011"; -- 3
        Opcode <= "1010"; -- Greater check
        wait for 10 ns;

        -- Test Equal (7 == 7)
        OperandA <= "00000111"; -- 7
        OperandB <= "00000111"; -- 7
        Opcode <= "1011"; -- Equality check
        wait for 10 ns;

        wait;
    end process;

end Behavioral;

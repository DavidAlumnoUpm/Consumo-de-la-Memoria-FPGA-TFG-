library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity tb_I2C_slave is
    generic ( 
                C_CNT_BITS      : natural := 8;                                     -- Counter resolution
                C_CNT_MAX       : natural := 200;                                   -- Maximum count
                C_RSTPOL        : std_logic := '1';                                 -- Reset poling
                DEVICE          : std_logic_vector(7 downto 0) := "01000010"        -- DIRECCIÓN DEL DISPOSITIVO 
    );
end tb_I2C_slave;

architecture Behavioral of tb_I2C_slave is

     constant CLK_PERIOD : time := 8 ns; -- 125 MHz
     signal clk, reset, clr, enable, SDA_IN, SDA_OUT, SCL, NACK, STOP_ACK, READ, WRITE : std_logic;
     signal ADDRESS, DATA_IN, DATA_OUT : std_logic_vector(7 downto 0);
     
begin

    uut: entity work.I2C_slave(Behavioral)
        generic map(
                        C_CNT_BITS  => C_CNT_BITS,
                        C_CNT_MAX   => C_CNT_MAX,
                        C_RSTPOL    => C_RSTPOL,
                        DEVICE      => DEVICE
        )
        port map(
                        clk         => clk,
                        reset       => reset,
                        clr         => clr,
                        enable      => enable,
                        SDA_IN      => SDA_IN,
                        SDA_OUT     => SDA_OUT,
                        SCL         => SCL,
                        ADDRESS     => ADDRESS,
                        DATA_IN     => DATA_IN,
                        DATA_OUT    => DATA_OUT,
                        NACK        => NACK,
                        STOP_ACK    => STOP_ACK,
                        READ        => READ,
                        WRITE       => WRITE
        );
        
    clk_stimuli : process
    begin
        clk <= '1';
        wait for CLK_PERIOD/2;
        clk <= '0';
        wait for CLK_PERIOD/2;
    end process;
            
    uut_stimuli: process
    begin
        reset <= '1';
        SDA_IN <= '0';
        wait for CLK_PERIOD;
        clr <= '0';
        wait for CLK_PERIOD;
        enable <= '0';
        wait for CLK_PERIOD;
        ADDRESS <= "00000010";
        wait for CLK_PERIOD;
        DATA_IN <= "00000101";
        wait for CLK_PERIOD;
        STOP_ACK <= '0';
        wait for CLK_PERIOD;
        READ <= '0';
        wait for CLK_PERIOD;
        WRITE <= '0';
        wait for 100 ns;
        WRITE <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        wait for CLK_PERIOD;
        enable <= '1';
        wait for 10 ms;
        WRITE <= '0';
        SDA_IN <= '0';
        wait for 2000 ns;
        READ <= '1';
        clr <= '1';
        wait for 100 us;
        clr <= '0';
        wait for 5 ms;
        SDA_IN <= '1';
        wait;
    end process;

end Behavioral;

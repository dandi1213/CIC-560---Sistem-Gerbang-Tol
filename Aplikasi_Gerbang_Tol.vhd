library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Aplikasi_Gerbang_Tol is
    Port (
        Gol1 : in STD_LOGIC;
        Gol2 : in STD_LOGIC;
        Gol3 : in STD_LOGIC;
        Buka_Tutup_1 : in STD_LOGIC;
        Buka_Tutup_2 : in STD_LOGIC;
        Clock : in STD_LOGIC;
        Masuk_Lampu_Merah : buffer STD_LOGIC_VECTOR(7 downto 0);
        Masuk_Lampu_Hijau : buffer STD_LOGIC_VECTOR(7 downto 0); 
        Keluar_Lampu_Merah : out STD_LOGIC_VECTOR(7 downto 0);
        Keluar_Lampu_Hijau : out STD_LOGIC_VECTOR(7 downto 0); 
        Seven_Segment : out STD_LOGIC_VECTOR(6 downto 0)
    );
end Aplikasi_Gerbang_Tol;

architecture Behavioral of Aplikasi_Gerbang_Tol is
    signal counter : INTEGER := 0;
    signal display_4 : STD_LOGIC := '0';
    signal display_5 : STD_LOGIC := '0';
    signal display_6 : STD_LOGIC := '0';
begin
    process (Clock)
    begin
        if rising_edge(Clock) then
            if (Gol1 = '1' and Buka_Tutup_2 = '1') then
                if counter < 50000000 then 
                    counter <= counter + 1;
                else
                    display_4 <= '1';
                end if;
            elsif (Gol2 = '1' and Buka_Tutup_2 = '1') then
                if counter < 50000000 then
                    counter <= counter + 1;
                else
                    display_5 <= '1';
                end if;
            elsif (Gol3 = '1' and Buka_Tutup_2 = '1') then
                if counter < 50000000 then
                    counter <= counter + 1;
                else
                    display_6 <= '1';
                end if;
            else
                counter <= 0;
                display_4 <= '0';
                display_5 <= '0';
                display_6 <= '0';
            end if;
        end if;
    end process;

    process (Gol1, Gol2, Gol3, Buka_Tutup_1, Buka_Tutup_2, display_4, display_5, display_6)
    begin
        -- Mengatur lampu masuk
        Masuk_Lampu_Hijau <= (others => Buka_Tutup_1);
        if Buka_Tutup_1 = '0' then
            Masuk_Lampu_Merah <= "11111111"; 
        else
            Masuk_Lampu_Merah <= "00000000"; 
        end if;
        
        -- Mengatur lampu keluar
        if (Gol1 = '1' or Gol2 = '1' or Gol3 = '1') and Buka_Tutup_2 = '1' then
            Keluar_Lampu_Hijau <= "11111111"; 
            Keluar_Lampu_Merah <= "00000000"; 
        else
            Keluar_Lampu_Hijau <= "00000000"; 
            Keluar_Lampu_Merah <= "11111111"; 
        end if;

        -- Mengatur output 7 segment
        if (Gol1 = '1' and Buka_Tutup_2 = '1') then
            if display_4 = '1' then
                Seven_Segment <= "1100110"; 
            else
                Seven_Segment <= "0000110"; 
            end if;
        elsif (Gol2 = '1' and Buka_Tutup_2 = '1') then
            if display_5 = '1' then
                Seven_Segment <= "1111101"; 
            else
                Seven_Segment <= "1011011"; 
            end if;
        elsif (Gol3 = '1' and Buka_Tutup_2 = '1') then
            if display_6 = '1' then
                Seven_Segment <= "1111111"; 
            else
                Seven_Segment <= "1001111"; 
            end if;
        elsif Buka_Tutup_1 = '1' then
            Seven_Segment <= "1101111"; 
        else
            Seven_Segment <= (others => '0'); 
        end if;
    end process;

end Behavioral;

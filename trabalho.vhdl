LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY sema_5af14 IS
	PORT(clk : IN STD_LOGIC;
         Botao : IN STD_LOGIC;
		 saida : OUT STD_LOGIC_VECTOR (0 TO 2));
END sema_5af14;

ARCHITECTURE xxx OF sema_5af14 IS

COMPONENT cont3_5af14 IS
GENERIC (n : NATURAL := 50000000);
PORT
(
BT : IN STD_LOGIC;
clk : IN STD_LOGIC;
f : OUT STD_LOGIC);

END COMPONENT;

TYPE ESTADO_TIPO IS (GR, YW, RW, VW);

SIGNAL estado : ESTADO_TIPO := GR;
SIGNAL seg : INTEGER RANGE 0 TO 9 := 0;
SIGNAL f_c : STD_LOGIC := '0';
SIGNAL f_ant : STD_LOGIC;
SIGNAL BTL : STD_LOGIC := '0';
SIGNAL clk100 : STD_LOGIC := '0';
SIGAN LB_a, LB_b : STD_LOGIC : '0'; 

BEGIN

	cnt : cont3_5af14 PORT MAP (clk => clk, f => f_c);

    cnt100 : cont3_5af14 GENERIC_MAP(n = 500000) PORT_MAP (clk => clk, f => clk100)

    Limpa_Botão : PROCESS(clk100'event and clk100 ='1')
    BEGIN
        LB_a <= not(Botao);
        LB_b <= LB_a;
        BTL <= (LB_a and not(LB_b));
    END PROCESS Limpa_Botão

						
	Maquina_Estados: PROCESS(clk)
	BEGIN
		IF RISING_EDGE(clk) THEN
			f_ant <= f_c;
			saida <= "000";
			
			CASE estado IS
				WHEN GR => saida <= "100";
                    seg <= 0;
                    IF(BTL = '1') THEN
                        estado <= YW;
                        END IF;
				END IF;
				
				WHEN YW => saida <= "010";
				IF f_ant /= f_c THEN
					IF seg = 6 THEN
						estado <= RW;
						seg <= 0;
					ELSE seg <= seg + 1;
					
					END IF;
				END IF;
				
				WHEN RW => saida <= "001";
				IF f_ant /= f_c THEN
					IF seg = 10 THEN
						estado <= GW;
						seg <= 0;
					ELSE seg <= seg + 1;
					
					END IF;
                
                WHEN GW => saida <= "001";
				IF f_ant /= f_c THEN
					IF seg = 5 THEN
						estado <= GR;
						seg <= 0;
					ELSE seg <= seg + 1;
					
					END IF;
				END IF;
			END CASE;
		END IF;
	END PROCESS Maquina_Estados;
END xxx;
				
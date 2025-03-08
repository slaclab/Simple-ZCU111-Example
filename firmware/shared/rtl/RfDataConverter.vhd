-------------------------------------------------------------------------------
-- Company    : SLAC National Accelerator Laboratory
-------------------------------------------------------------------------------
-- Description: RfDataConverter Module
-------------------------------------------------------------------------------
-- This file is part of 'Simple-ZCU111-Example'.
-- It is subject to the license terms in the LICENSE.txt file found in the
-- top-level directory of this distribution and at:
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
-- No part of 'Simple-ZCU111-Example', including this file,
-- may be copied, modified, propagated, or distributed except according to
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiStreamPkg.all;
use surf.AxiLitePkg.all;
use surf.SsiPkg.all;

library work;
use work.AppPkg.all;

library axi_soc_ultra_plus_core;
use axi_soc_ultra_plus_core.AxiSocUltraPlusPkg.all;

library unisim;
use unisim.vcomponents.all;

entity RfDataConverter is
   generic (
      TPD_G            : time := 1 ns;
      AXIL_BASE_ADDR_G : slv(31 downto 0));
   port (
      -- RF DATA CONVERTER Ports
      adcClkP         : in  slv(3 downto 0);
      adcClkN         : in  slv(3 downto 0);
      adcP            : in  slv(7 downto 0);
      adcN            : in  slv(7 downto 0);
      dacClkP         : in  slv(1 downto 0);
      dacClkN         : in  slv(1 downto 0);
      dacP            : out slv(7 downto 0);
      dacN            : out slv(7 downto 0);
      sysRefP         : in  sl;
      sysRefN         : in  sl;
      plClkP          : in  sl;
      plClkN          : in  sl;
      plSysRefP       : in  sl;
      plSysRefN       : in  sl;
      -- ADC/DAC Interface (dspClk domain)
      dspClk          : out sl;
      dspRst          : out sl;
      dspAdc          : out Slv256Array(7 downto 0);
      dspDac          : in  Slv256Array(7 downto 0);
      -- AXI-Lite Interface (axilClk domain)
      axilClk         : in  sl;
      axilRst         : in  sl;
      axilWriteMaster : in  AxiLiteWriteMasterType;
      axilWriteSlave  : out AxiLiteWriteSlaveType;
      axilReadMaster  : in  AxiLiteReadMasterType;
      axilReadSlave   : out AxiLiteReadSlaveType);
end RfDataConverter;

architecture mapping of RfDataConverter is

   component RfDataConverterIpCore
      port (
         adc0_clk_p      : in  std_logic;
         adc0_clk_n      : in  std_logic;
         clk_adc0        : out std_logic;
         adc1_clk_p      : in  std_logic;
         adc1_clk_n      : in  std_logic;
         clk_adc1        : out std_logic;
         adc2_clk_p      : in  std_logic;
         adc2_clk_n      : in  std_logic;
         clk_adc2        : out std_logic;
         adc3_clk_p      : in  std_logic;
         adc3_clk_n      : in  std_logic;
         clk_adc3        : out std_logic;
         dac0_clk_p      : in  std_logic;
         dac0_clk_n      : in  std_logic;
         clk_dac0        : out std_logic;
         dac1_clk_p      : in  std_logic;
         dac1_clk_n      : in  std_logic;
         clk_dac1        : out std_logic;
         s_axi_aclk      : in  std_logic;
         s_axi_aresetn   : in  std_logic;
         s_axi_awaddr    : in  std_logic_vector(17 downto 0);
         s_axi_awvalid   : in  std_logic;
         s_axi_awready   : out std_logic;
         s_axi_wdata     : in  std_logic_vector(31 downto 0);
         s_axi_wstrb     : in  std_logic_vector(3 downto 0);
         s_axi_wvalid    : in  std_logic;
         s_axi_wready    : out std_logic;
         s_axi_bresp     : out std_logic_vector(1 downto 0);
         s_axi_bvalid    : out std_logic;
         s_axi_bready    : in  std_logic;
         s_axi_araddr    : in  std_logic_vector(17 downto 0);
         s_axi_arvalid   : in  std_logic;
         s_axi_arready   : out std_logic;
         s_axi_rdata     : out std_logic_vector(31 downto 0);
         s_axi_rresp     : out std_logic_vector(1 downto 0);
         s_axi_rvalid    : out std_logic;
         s_axi_rready    : in  std_logic;
         irq             : out std_logic;
         sysref_in_p     : in  std_logic;
         sysref_in_n     : in  std_logic;
         user_sysref_adc : in  std_logic;
         user_sysref_dac : in  std_logic;
         vin0_01_p       : in  std_logic;
         vin0_01_n       : in  std_logic;
         vin0_23_p       : in  std_logic;
         vin0_23_n       : in  std_logic;
         vin1_01_p       : in  std_logic;
         vin1_01_n       : in  std_logic;
         vin1_23_p       : in  std_logic;
         vin1_23_n       : in  std_logic;
         vin2_01_p       : in  std_logic;
         vin2_01_n       : in  std_logic;
         vin2_23_p       : in  std_logic;
         vin2_23_n       : in  std_logic;
         vin3_01_p       : in  std_logic;
         vin3_01_n       : in  std_logic;
         vin3_23_p       : in  std_logic;
         vin3_23_n       : in  std_logic;
         vout00_p        : out std_logic;
         vout00_n        : out std_logic;
         vout01_p        : out std_logic;
         vout01_n        : out std_logic;
         vout02_p        : out std_logic;
         vout02_n        : out std_logic;
         vout03_p        : out std_logic;
         vout03_n        : out std_logic;
         vout10_p        : out std_logic;
         vout10_n        : out std_logic;
         vout11_p        : out std_logic;
         vout11_n        : out std_logic;
         vout12_p        : out std_logic;
         vout12_n        : out std_logic;
         vout13_p        : out std_logic;
         vout13_n        : out std_logic;
         m0_axis_aresetn : in  std_logic;
         m0_axis_aclk    : in  std_logic;
         m00_axis_tdata  : out std_logic_vector(127 downto 0);
         m00_axis_tvalid : out std_logic;
         m00_axis_tready : in  std_logic;
         m02_axis_tdata  : out std_logic_vector(127 downto 0);
         m02_axis_tvalid : out std_logic;
         m02_axis_tready : in  std_logic;
         m1_axis_aresetn : in  std_logic;
         m1_axis_aclk    : in  std_logic;
         m10_axis_tdata  : out std_logic_vector(127 downto 0);
         m10_axis_tvalid : out std_logic;
         m10_axis_tready : in  std_logic;
         m12_axis_tdata  : out std_logic_vector(127 downto 0);
         m12_axis_tvalid : out std_logic;
         m12_axis_tready : in  std_logic;
         m2_axis_aresetn : in  std_logic;
         m2_axis_aclk    : in  std_logic;
         m20_axis_tdata  : out std_logic_vector(127 downto 0);
         m20_axis_tvalid : out std_logic;
         m20_axis_tready : in  std_logic;
         m22_axis_tdata  : out std_logic_vector(127 downto 0);
         m22_axis_tvalid : out std_logic;
         m22_axis_tready : in  std_logic;
         m3_axis_aresetn : in  std_logic;
         m3_axis_aclk    : in  std_logic;
         m30_axis_tdata  : out std_logic_vector(127 downto 0);
         m30_axis_tvalid : out std_logic;
         m30_axis_tready : in  std_logic;
         m32_axis_tdata  : out std_logic_vector(127 downto 0);
         m32_axis_tvalid : out std_logic;
         m32_axis_tready : in  std_logic;
         s0_axis_aresetn : in  std_logic;
         s0_axis_aclk    : in  std_logic;
         s00_axis_tdata  : in  std_logic_vector(255 downto 0);
         s00_axis_tvalid : in  std_logic;
         s00_axis_tready : out std_logic;
         s01_axis_tdata  : in  std_logic_vector(255 downto 0);
         s01_axis_tvalid : in  std_logic;
         s01_axis_tready : out std_logic;
         s02_axis_tdata  : in  std_logic_vector(255 downto 0);
         s02_axis_tvalid : in  std_logic;
         s02_axis_tready : out std_logic;
         s03_axis_tdata  : in  std_logic_vector(255 downto 0);
         s03_axis_tvalid : in  std_logic;
         s03_axis_tready : out std_logic;
         s1_axis_aresetn : in  std_logic;
         s1_axis_aclk    : in  std_logic;
         s10_axis_tdata  : in  std_logic_vector(255 downto 0);
         s10_axis_tvalid : in  std_logic;
         s10_axis_tready : out std_logic;
         s11_axis_tdata  : in  std_logic_vector(255 downto 0);
         s11_axis_tvalid : in  std_logic;
         s11_axis_tready : out std_logic;
         s12_axis_tdata  : in  std_logic_vector(255 downto 0);
         s12_axis_tvalid : in  std_logic;
         s12_axis_tready : out std_logic;
         s13_axis_tdata  : in  std_logic_vector(255 downto 0);
         s13_axis_tvalid : in  std_logic;
         s13_axis_tready : out std_logic
         );
   end component;

   signal rfdcAdc   : Slv128Array(7 downto 0) := (others => (others => '0'));
   signal rfdcValid : slv(7 downto 0)         := (others => '0');
   signal rfdcDac   : Slv256Array(7 downto 0) := (others => (others => '0'));

   signal adc      : Slv128Array(7 downto 0) := (others => (others => '0'));
   signal adcValid : slv(7 downto 0)         := (others => '0');

   signal refClk   : sl := '0';
   signal axilRstL : sl := '0';

   signal rfdcClk  : sl := '0';
   signal rfdcRst  : sl := '1';
   signal rfdcRstL : sl := '0';

   signal dspClock  : sl := '0';
   signal dspReset  : sl := '1';
   signal dspResetL : sl := '0';

   signal plSysRefRaw : sl := '0';
   signal adcSysRef   : sl := '0';
   signal dacSysRef   : sl := '0';

begin

   U_plSysRefRaw : IBUFDS
      port map (
         I  => plSysRefP,
         IB => plSysRefN,
         O  => plSysRefRaw);

   U_adcSysRef : entity surf.Synchronizer
      generic map (
         TPD_G => TPD_G)
      port map (
         clk     => rfdcClk,
         dataIn  => plSysRefRaw,
         dataOut => adcSysRef);

   U_dacSysRef : entity surf.Synchronizer
      generic map (
         TPD_G => TPD_G)
      port map (
         clk     => dspClock,
         dataIn  => plSysRefRaw,
         dataOut => dacSysRef);

   U_IpCore : RfDataConverterIpCore
      port map (
         -- Clock Ports
         adc0_clk_p      => adcClkP(0),
         adc0_clk_n      => adcClkN(0),
         adc1_clk_p      => adcClkP(1),
         adc1_clk_n      => adcClkN(1),
         adc2_clk_p      => adcClkP(2),
         adc2_clk_n      => adcClkN(2),
         adc3_clk_p      => adcClkP(3),
         adc3_clk_n      => adcClkN(3),
         dac0_clk_p      => dacClkP(0),
         dac0_clk_n      => dacClkN(0),
         dac1_clk_p      => dacClkP(1),
         dac1_clk_n      => dacClkN(1),
         -- AXI-Lite Ports
         s_axi_aclk      => axilClk,
         s_axi_aresetn   => axilRstL,
         s_axi_awaddr    => axilWriteMaster.awaddr(17 downto 0),
         s_axi_awvalid   => axilWriteMaster.awvalid,
         s_axi_awready   => axilWriteSlave.awready,
         s_axi_wdata     => axilWriteMaster.wdata,
         s_axi_wstrb     => axilWriteMaster.wstrb,
         s_axi_wvalid    => axilWriteMaster.wvalid,
         s_axi_wready    => axilWriteSlave.wready,
         s_axi_bresp     => axilWriteSlave.bresp,
         s_axi_bvalid    => axilWriteSlave.bvalid,
         s_axi_bready    => axilWriteMaster.bready,
         s_axi_araddr    => axilReadMaster.araddr(17 downto 0),
         s_axi_arvalid   => axilReadMaster.arvalid,
         s_axi_arready   => axilReadSlave.arready,
         s_axi_rdata     => axilReadSlave.rdata,
         s_axi_rresp     => axilReadSlave.rresp,
         s_axi_rvalid    => axilReadSlave.rvalid,
         s_axi_rready    => axilReadMaster.rready,
         -- Misc. Ports
         sysref_in_p     => sysRefP,
         sysref_in_n     => sysRefN,
         user_sysref_adc => adcSysRef,
         user_sysref_dac => dacSysRef,
         -- ADC Ports
         vin0_01_p       => adcP(0),
         vin0_01_n       => adcN(0),
         vin0_23_p       => adcP(1),
         vin0_23_n       => adcN(1),
         vin1_01_p       => adcP(2),
         vin1_01_n       => adcN(2),
         vin1_23_p       => adcP(3),
         vin1_23_n       => adcN(3),
         vin2_01_p       => adcP(4),
         vin2_01_n       => adcN(4),
         vin2_23_p       => adcP(5),
         vin2_23_n       => adcN(5),
         vin3_01_p       => adcP(6),
         vin3_01_n       => adcN(6),
         vin3_23_p       => adcP(7),
         vin3_23_n       => adcN(7),
         -- DAC Ports
         vout00_p        => dacP(0),
         vout00_n        => dacN(0),
         vout01_p        => dacP(1),
         vout01_n        => dacN(1),
         vout02_p        => dacP(2),
         vout02_n        => dacN(2),
         vout03_p        => dacP(3),
         vout03_n        => dacN(3),
         vout10_p        => dacP(4),
         vout10_n        => dacN(4),
         vout11_p        => dacP(5),
         vout11_n        => dacN(5),
         vout12_p        => dacP(6),
         vout12_n        => dacN(6),
         vout13_p        => dacP(7),
         vout13_n        => dacN(7),
         -- ADC[1:0] AXI Stream Interface
         m0_axis_aresetn => rfdcRstL,
         m0_axis_aclk    => rfdcClk,
         m00_axis_tdata  => rfdcAdc(0),
         m00_axis_tvalid => rfdcValid(0),
         m00_axis_tready => '1',
         m02_axis_tdata  => rfdcAdc(1),
         m02_axis_tvalid => rfdcValid(1),
         m02_axis_tready => '1',
         -- ADC[3:2] AXI Stream Interface
         m1_axis_aresetn => rfdcRstL,
         m1_axis_aclk    => rfdcClk,
         m10_axis_tdata  => rfdcAdc(2),
         m10_axis_tvalid => rfdcValid(2),
         m10_axis_tready => '1',
         m12_axis_tdata  => rfdcAdc(3),
         m12_axis_tvalid => rfdcValid(3),
         m12_axis_tready => '1',
         -- ADC[5:4] AXI Stream Interface
         m2_axis_aresetn => rfdcRstL,
         m2_axis_aclk    => rfdcClk,
         m20_axis_tdata  => rfdcAdc(4),
         m20_axis_tvalid => rfdcValid(4),
         m20_axis_tready => '1',
         m22_axis_tdata  => rfdcAdc(5),
         m22_axis_tvalid => rfdcValid(5),
         m22_axis_tready => '1',
         -- ADC[7:6] AXI Stream Interface
         m3_axis_aresetn => rfdcRstL,
         m3_axis_aclk    => rfdcClk,
         m30_axis_tdata  => rfdcAdc(6),
         m30_axis_tvalid => rfdcValid(6),
         m30_axis_tready => '1',
         m32_axis_tdata  => rfdcAdc(7),
         m32_axis_tvalid => rfdcValid(7),
         m32_axis_tready => '1',
         -- DAC[3:0] AXI Stream Interface
         s0_axis_aresetn => dspResetL,
         s0_axis_aclk    => dspClock,
         s00_axis_tdata  => rfdcDac(0),
         s00_axis_tvalid => '1',
         s00_axis_tready => open,
         s01_axis_tdata  => rfdcDac(1),
         s01_axis_tvalid => '1',
         s01_axis_tready => open,
         s02_axis_tdata  => rfdcDac(2),
         s02_axis_tvalid => '1',
         s02_axis_tready => open,
         s03_axis_tdata  => rfdcDac(3),
         s03_axis_tvalid => '1',
         s03_axis_tready => open,
         -- DAC[7:4] AXI Stream Interface
         s1_axis_aresetn => dspResetL,
         s1_axis_aclk    => dspClock,
         s10_axis_tdata  => rfdcDac(4),
         s10_axis_tvalid => '1',
         s10_axis_tready => open,
         s11_axis_tdata  => rfdcDac(5),
         s11_axis_tvalid => '1',
         s11_axis_tready => open,
         s12_axis_tdata  => rfdcDac(6),
         s12_axis_tvalid => '1',
         s12_axis_tready => open,
         s13_axis_tdata  => rfdcDac(7),
         s13_axis_tvalid => '1',
         s13_axis_tready => open);

   U_IBUFDS : IBUFDS
      port map(
         I  => plClkP,
         IB => plClkN,
         O  => refClk);

   U_Pll : entity surf.ClockManagerUltraScale
      generic map(
         TPD_G             => TPD_G,
         TYPE_G            => "PLL",
         INPUT_BUFG_G      => true,
         FB_BUFG_G         => true,
         RST_IN_POLARITY_G => '1',
         NUM_CLOCKS_G      => 2,
         -- MMCM attributes
         CLKIN_PERIOD_G    => 1.953,    -- 512 MHz
         DIVCLK_DIVIDE_G   => 2,
         CLKFBOUT_MULT_G   => 4,        -- 1024MHz = 4 x 512 MHz /2
         CLKOUT0_DIVIDE_G  => 2,        -- 512 MHz = 1024MHz/2
         CLKOUT1_DIVIDE_G  => 4)        -- 256 MHz = 1024MHz/4
      port map(
         -- Clock Input
         clkIn     => refClk,
         rstIn     => axilRst,
         -- Clock Outputs
         clkOut(0) => rfdcClk,
         clkOut(1) => dspClock,
         -- Reset Outputs
         rstOut(0) => rfdcRst,
         rstOut(1) => dspReset);

   axilRstL  <= not(axilRst);
   rfdcRstL  <= not(rfdcRst);
   dspResetL <= not(dspReset);

   dspClk <= dspClock;
   dspRst <= dspReset;

   process(rfdcClk)
   begin
      -- Help with making timing
      if rising_edge(rfdcClk) then
         adc      <= rfdcAdc   after TPD_G;
         adcValid <= rfdcValid after TPD_G;
      end if;
   end process;

   process(dspClock)
   begin
      -- Help with making timing
      if rising_edge(dspClock) then
         rfdcDac <= dspDac after TPD_G;
      end if;
   end process;

   U_Gearbox : entity axi_soc_ultra_plus_core.Ssr8ToSsr16Gearbox
      generic map (
         TPD_G    => TPD_G,
         NUM_CH_G => 8)
      port map (
         -- Slave Interface
         wrClk  => rfdcClk,
         wrData => adc,
         -- Master Interface
         rdClk  => dspClock,
         rdRst  => dspReset,
         rdData => dspAdc);

end mapping;

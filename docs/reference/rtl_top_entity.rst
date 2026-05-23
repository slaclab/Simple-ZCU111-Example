Top-Level RTL Entity
====================

The top-level firmware target is ``SimpleZcu111Example`` (architecture
``top_level``). The full source lives in
:repo:`firmware/targets/SimpleZcu111Example/hdl/SimpleZcu111Example.vhd`.

Entity surface
--------------

The entity is the top FPGA target loaded by the Processing System at boot. It
maps physical board I/O to internal AXI buses and three clock domains:

* **LMK/LMX I2C ports:** ``i2cScl`` and ``i2cSda`` (2-bit each) for the
  on-board clock synthesizer chips.
* **RF data converter ports:** ADC differential clock and data
  (``adcClkP/N`` 4-bit, ``adcP/N`` 8-bit); DAC differential clock and data
  (``dacClkP/N`` 2-bit, ``dacP/N`` 8-bit); SYSREF and PL clock differential
  pairs (``sysRefP/N``, ``plClkP/N``, ``plSysRefP/N``).
* **SYSMON ports:** ``vPIn``, ``vNIn``.

Build-time generics are ``TPD_G`` (propagation-delay convention from surf) and
``BUILD_INFO_G`` (build metadata struct populated by ruckus).

Instantiated blocks
-------------------

.. list-table::
   :header-rows: 1
   :widths: 25 35 40

   * - Block
     - Source
     - Role
   * - ``AxiSocUltraPlusCore``
     - submodule (platform core)
     - Platform core: DMA engine, AXI-Lite bridge to PS, SysMon.
   * - ``RfDataConverter``
     - :repo:`firmware/shared/rtl/RfDataConverter.vhd`
     - Wraps the Xilinx RFDC IP; generates ``dspClk`` from the ``plClk`` PLL.
   * - ``Application``
     - :repo:`firmware/shared/rtl/Application.vhd`
     - Top-level application logic; second-level AXI-Lite crossbar.

The top-level AXI-Lite crossbar splits the application address window across
the three blocks at indices ``HW_INDEX_C = 0``, ``RFDC_INDEX_C = 1``, and
``APP_INDEX_C = 2`` (see :doc:`register_map`).

Clock domains
-------------

.. list-table::
   :header-rows: 1
   :widths: 20 25 55

   * - Clock
     - Frequency
     - Role
   * - ``axilClk``
     - 100 MHz
     - Register access (PS-facing AXI-Lite); also drives ``auxClk`` /
       ``appClk`` inputs of the platform core.
   * - ``dspClk``
     - DSP rate
     - DSP / DAC sample bus (``Slv256Array``, 16 samples per cycle).
       Generated from ``plClk`` PLL inside ``RfDataConverter``.
   * - ``adcClock``
     - ADC sample rate
     - RFDC ADC output clock. Generated from the second RFDC PLL output.

All cross-domain crossings use surf ``Synchronizer`` or ``Ssr12ToSsr16Gearbox``
primitives; the domains are declared as asynchronous groups in the XDC.
For the platform-level CDC philosophy, see
:hub:`explanation/architecture.html#clock-domains`.

Async clock groups (XDC)
------------------------

The XDC declares the PLL outputs as asynchronous clock groups so the
Vivado timing engine does not attempt to close timing across domains:

.. code-block:: text

   create_clock -name plClkP -period  1.953 [get_ports {plClkP}]

   set_clock_groups -asynchronous \
       -group [get_clocks -of_objects [get_pins U_Core/REAL_CPU.U_CPU/U_Pll/PllGen.U_Pll/CLKOUT0]] \
       -group [get_clocks -of_objects [get_pins U_Core/REAL_CPU.U_CPU/U_Pll/PllGen.U_Pll/CLKOUT1]] \
       -group [get_clocks -of_objects [get_pins U_RFDC/U_Pll/PllGen.U_Pll/CLKOUT0]] \
       -group [get_clocks -of_objects [get_pins U_RFDC/U_Pll/PllGen.U_Pll/CLKOUT1]]

Sourced from
:repo:`firmware/targets/SimpleZcu111Example/hdl/SimpleZcu111Example.xdc`.

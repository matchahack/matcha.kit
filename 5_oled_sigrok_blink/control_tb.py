import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Edge, with_timeout
from cocotb.result import SimTimeoutError


@cocotb.test()
async def control_tb(dut):
    CLK_PERIOD = 3.704
    DURATION   = 1500000

    # Initial conditions
    dut.clk.value = 0
    dut.bbutton.value = 1

    # Start clock
    clk = Clock(dut.clk, CLK_PERIOD, 'ns')
    await cocotb.start(clk.start())

    # Run for DURATION
    try:
        await with_timeout(tb_logic(dut), DURATION, 'ns')
    except SimTimeoutError:
        pass

    dut._log.info(f"Final sck={int(dut.sck.value)} bbutton={int(dut.bbutton.value)}")


async def tb_logic(dut):
    clk_counter = 0

    while True:
        await Edge(dut.clk)
        clk_counter += 1

        if (clk_counter == 2000):
            dut.bbutton.value = 0
        
        if (clk_counter == 2500):
            dut.bbutton.value = 1
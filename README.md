# Black Magic Probe Using Blue Pill

The project uses Visual Studio Code [Dev containers](https://code.visualstudio.com/docs/devcontainers/containers) for building [Black Magic Probe](https://github.com/blackmagic-debug/blackmagic) binaries.

## Flashing

```bash
# check if chip is accessible
st-info --descr

st-flash --reset write /blackmagic/src/blackmagic_dfu.bin 0x8000000
st-flash --flash=128k write /blackmagic/src/blackmagic.bin 0x8002000
```

## Wiring

| Blue Pill Probe | Pin       | Function            | Type     | Target                                               |
| --------------- | --------- | ------------------- | -------- | ---------------------------------------------------- |
| GND             | GND       | GND                 |          | GND                                                  |
| SWCLK           | 37 (PA14) | SWCLK/JTCK          | SWD/JTAG | SWCLK (Serial Wire Clock) /TCK (Test Clock)          |
| SWIO            | 34 (PA13) | SWDIO/JTMS          | SWD/JTAG | SWDIO (Serial Wire Data I/O) /TMS (Test Mode Select) |
| A15             | 38        | JTDI                | JTAG     | TDI (Test Data In)                                   |
| B3              | 39        | JTDO                | JTAG     | TDO (Test Data Out)                                  |
| B4              | 40        | nRST/JNTRST         | JTAG     | RESET/TRST (Test Reset)                              |
| B6              | 42        | UART1 TX            | UART     | UART RX                                              |
| B7              | 43        | UART1 RX            | UART     | UART TX                                              |
| A3              | 13        | UART2 RX (TRACESWO) | UART/SWD |                                                      |

## UDEV Rules

The below rules are borrowed from [the original source](https://github.com/blackmagic-debug/blackmagic/tree/main/driver).

```bash
# Black Magic Probe
# there are two connections, one for GDB and one for UART debugging
# copy this to /etc/udev/rules.d/99-blackmagic.rules
# and run sudo udevadm control -R
ACTION!="add|change", GOTO="blackmagic_rules_end"
SUBSYSTEM=="tty", ACTION=="add", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBmpGdb"
SUBSYSTEM=="tty", ACTION=="add", ATTRS{interface}=="Black Magic UART Port", SYMLINK+="ttyBmpTarg"
SUBSYSTEM=="tty", ACTION=="add", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBmpGdb%E{ID_SERIAL_SHORT}"
SUBSYSTEM=="tty", ACTION=="add", ATTRS{interface}=="Black Magic UART Port", SYMLINK+="ttyBmpTarg%E{ID_SERIAL_SHORT}"
SUBSYSTEM=="usb", ATTR{idVendor}=="1d50", ATTR{idProduct}=="6017", MODE="0666", GROUP="dialout", TAG+="uaccess"
SUBSYSTEM=="usb", ATTR{idVendor}=="1d50", ATTR{idProduct}=="6018", MODE="0666", GROUP="dialout", TAG+="uaccess"
LABEL="blackmagic_rules_end"
```

## Serial

```bash
minicom -b 115200 -8 -D /dev/ttyBmpTarg
```

## STM32 Blue Pill Pinout

![!blue pill pinout](./Bluepillpinout.gif)

## References

- [blackmagic-debug/blackmagic](https://github.com/blackmagic-debug/blackmagic)
- [Blackmagic for STM8S Discovery and STM32F103 Minimum System Development Board](https://github.com/blackmagic-debug/blackmagic/tree/8e83cc369ffd529d62ab2da88d4b2ae0b3633402/src/platforms/swlink)
- [Black Magic Official Page](https://black-magic.org/index.html)
- [Blue Pill to Black Magic Probe](https://hackaday.io/project/187043/instructions)
- [EXPERIMENTING WITH A BLUE PILL, BLACK MAGIC PROBE AND PLATFORMIO](https://www.cocoacrumbs.com/blog/2019-09-30-stm32-blue-pill-and-black-magic-probe/)
- [Black Magic Probe](https://jeelabs.org/202x/bmp/)
- [The Drone Embedded Operating System: Black Magic Probe from a Blue Pill](https://book.drone-os.com/bmp-from-bluepill.html)
- [JTAG](https://en.wikipedia.org/wiki/JTAG)
- [Book: Embedded Debugging with the Black Magic Probe](https://www.compuphase.com/electronics/BlackMagicProbe.pdf)

# GBB flag overwriter for school chromebooks

**UNTESTED:** needs testing.

Script works on Debian / Ubuntu, may work on WSL

# Guide
### Most steps are taken from [this mrchromebox.tech tutorial](https://docs.mrchromebox.tech/docs/support/unbricking/unbrick-ch341a.html)

### Requirements

1. A ch341a USB flash programmer
2. A 1.8v adapter

    **TIP:**<br>
    The adapter is required for devices which use 1.8v flash chips. Some/Most Baytrail, Braswell, Skylake and many newer devices use a 1.8v flash chip. Baytrail is more reliable flashing at 3.3v though due to current leakage

3. Either a SOIC-8 chip clip or a WSON-8 probe

    **TIP:**<br>
    Most Skylake and older models (with a few exceptions) use a SOIC-8 flash chip which is easily clippable. Most if not all Kabylake/Apollolake and newer devices use a WSON-8 flash chip which can't be clipped, instead you need a WSON-8 probe. Check the part number of your flash chip to find the correct size needed.

A ch341a programmer, 1.8v adapter, and a SOIC-8 clip  are often bundled together at a lower cost, and if you're unsure if your device uses a 1.8v flash chip or a 3.3v one, it makes sense to have the adapter on hand if needed. You can look up the part number of your flash chip to determine which voltage it needs.

### Disassemble Hardware

While this is somewhat device-specific, the main points are the same:

* Disconnect all external power
* Remove bottom cover (screws are often located under rubber feet or strips)
  * Some Chromebooks open up through the back and some through the keyboard, and as mentioned in [Disabling write protect via Battery](https://docs.mrchromebox.tech/docs/firmware/wp/disabling.html#disconnecting-the-battery). On keyboard, you have to pry it out and remove a ribbon wire under the keyboard.
* Disconnect the internal battery (for Chromeboxes, disconnect the small CMOS battery)
* Locate the SPI flash chip

**DANGER:**<br>
Most ChromeOS devices use a Winbond flash chip, though some use a compatible chip from another manufacturer, eg Gigadevices. It will be either an 8MB, 16MB, or 32MB chip, with the identifier W25Q64[xx] (8MB),  W25Q128[xx] (16MB), or W25Q256[xx] (32MB) where [xx] is usually FV or DV. We do **not** want to touch the EC firmware chip, which is identified by W25X40[xx].

**WARNING:**<br>
Unfortunately, many devices have the flash chip located on the top side of the main board, and require fully removing the main board in order to flash.

**TIP:**<br>
Pin 1 of the flash chip will be notated by a dot/depression on the chip; be sure to align this with pin 1 on the chip clip wiring.

Googling should locate a disassembly guide for most models. If you can't find one for your exact model, try to find one for another model of the same manufacturer as the bottom cover (or keyboard) removal tends to be very similar.

## Attach Flasher

1. Assemble ch341a programmer, 1.8v adapter (if needed), and chip clip/wiring. Ensure that pin 1 is correct and consistent.

   ![image](https://docs.mrchromebox.tech/ch341aunbrick/500px-Ch341a_annotated.png)
2. Connect the chip clip to the SPI flash chip, or get ready to hold down your WSON-8 probe, rubber bands can be used to hold it down while flashing, then connect the CH341a to the Linux host machine. Note the dot/depression indicating pin 1.

   ![image](https://docs.mrchromebox.tech/ch341aunbrick/500px-SOIC-8_chip.jpg)

## Run Script

Now, make sure you have linux up, and run this in a terminal (it may need sudo):
```bash
git clone https://github.com/geodebreaker/gbb
cd gbb
chmod +x gbb.sh
./gbb.sh ch341a_spi
```
Or, you can download `gbb.sh` directly and run it.<br>
Once you have completed the flashing, reassemble the computer.

# Done

Once you are in dev mode, you can refer to [this official tutorial](https://www.chromium.org/chromium-os/developer-library/guides/device/developer-mode/)

If you would like, you could use a thumbdrive with an old version of chromeos to use different exploits.

If you would like to use different flags, you can use [this tool](https://binbashbanana.github.io/gbbflaginator/) to find the value and put that into the command as a second argument
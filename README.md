# HAM SHACK!

### Automated Antenna Controller

**WIP**: Work in Progress :joy:

### rpi

Must run on: Raspberry Pi 2 B+

* rbenv sudo

  `rbenv sudo ruby rpi/main.rb`

* rvm sudo

  `rvm sudo ruby rpi/main.rb`

### host machine

**the heavy lifter - can also run on the rpi**

**easier to debug the parsing and add new features if ran on a host**

Should work on: Windows 10 - macOS - Linux

No sudo needed (no GPIO) on this end:

`ruby host/main.rb`

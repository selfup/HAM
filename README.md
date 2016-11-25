# HAM SHACK!

### Automated Antenna Controller

***

# INSTRUCTIONS

If you do not have ruby on a raspberry pi:

Highly recommend using `rbenv` and you will need the `rbenv sudo` plugin to run the GPIO ports

Install ruby 2.3.1 or greater on a raspberry pi (rbenv, rvm, or chruby)

`gem install bundler`

***

1. `cd` into this project dir after cloning:

  `git clone https://github.com/selfup/HAM && cd HAM`

1. Now `bundle`

  ..and wait a while :smile:

### What to Run

**host** dir: run `ruby host/main.rb`

  1. This can run on a raspberry pi
  1. This can run on another machine: *min::ruby 2.3.1 - (no need to bundle)*

**rpi** dir: run `rbenv sudo ruby rpi/main.rb -o 0.0.0.0`

  1. This must run on a raspberry pi :joy:

# DISCLAIMER

This a continuation of *HAM Radio* side projects

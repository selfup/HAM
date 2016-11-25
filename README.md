# HAM SHACK!

### Automated Antenna Controller

**WIP**: Work in Progress :joy:

# INSTRUCTIONS

***

If you already have ruby 2.3.1 or greater, and rvm or rbenv, just get the sudo package for either tools (rvmsudo) or (rbenvsudo) and go to the section with a checkmark in the title. Enjoy talking to your flex radio with a raspberry pi!

***

Ruby version and tools required for this to run on a raspberry pi:

### Git
If you do not have **git** installed:

  `sudo apt-get update && sudo apt-get install git -y`
### rbenv
 Follow [THIS](http://www.iconoclastlabs.com/blog/ruby-on-rails-on-the-raspberry-pi-b-with-rbenv) tutorial (CHANGE 2.1.2 to 2.3.1) and *stop* at the **Moving To Rails** section

### rbenv sudo

  Once you have installed ruby 2.3.1 with `rbenv`

  **If** `ruby -v` does not say *2.3.1* **or** *greater* and you followed the rbenv tutorial do the following and wait:

  ```
  rbenv install 2.3.1 && rbenv global 2.3.1 && rbenv rehash
  ```

  Now **actually install** `rbenv sudo`

  `git clone git://github.com/dcarley/rbenv-sudo.git ~/.rbenv/plugins/rbenv-sudo`

:tada:

### Ruby 2.3.1 - Rbenv - Rbenv Sudo :white_check_mark:

1. `gem install bundler`

1. `cd` into this project dir after cloning:

  `git clone https://github.com/selfup/HAM && cd HAM`

1. Now `bundle`

  ..and wait a while :smile:

### What to Run

`rbenv sudo ruby src/main.rb`

# DISCLAIMER

This a continuation of *HAM Radio* side projects

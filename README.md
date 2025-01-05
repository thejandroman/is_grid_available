# Is Grid Available
This application reads the inverter frequency value from solar assistant mqtt. If the grid frequency is correct it turns on a green LED. If the grid frequency is below a defined threshold it turns on a red LED. It was built to be run on a Raspberry Pi Zero W running Raspberry Pi OS Bullseye.

# Install
```
sudo apt install ruby ruby-dev
sudo gem install bundler
cd is_grid_available
sudo bundle install
```

# Ruby Version
This project is built against Ruby 2.7.4 as it is what ships by default with Raspberry Pi OS Bullseye.

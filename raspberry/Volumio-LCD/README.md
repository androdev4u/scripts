The code Adafruit_CharLCDPlate is from:
https://github.com/spotrh/rpihacks/tree/master/Adafruit_CharLCDPlate


This Code comes from R.U.Sirius and was fixed by aubreykloppers .

See https://aubreykloppers.wordpress.com/2014/01/30/raspberry-pi-volumio-a-new-music-player-and-it-works-out-the-box.

The showSongInfo.py is originaly from http://didtheypush.blogspot.de/2013/10/raspyfi-and-adafruit-16x2-char-lcd-plate.html
A fixed version from https://www.dropbox.com/s/iqoyy5lm2tik1my/LCD%20Python%20Script.zip .

should be used.


To get this running, you need a  Adafruit 16x2 Char LCD Plate.

The Volumio 1.55 works with it.

I worked in the /home/volumio folder!

You have to do the following things listed on https://learn.adafruit.com/adafruit-16x2-character-lcd-plus-keypad-for-raspberry-pi/usage

sudo apt-get update
sudo apt-get install python-smbus
sudo apt-get install i2c-tools
sudo apt-get install build-essential python-dev python-smbus python-pip git
sudo pip install RPi.GPIO
git clone https://github.com/adafruit/Adafruit_Python_CharLCD.git
cd Adafruit_Python_CharLCD
sudo python setup.py install

Install the packages, yes with updates!


nano /etc/modules

add

i2c-bcm2708
i2c-dev

nano /boot/config.txt

add 

device_tree=bcm2708-rpi-b.dtb
device_tree_param=i2c1=on
device_tree_param=spi=on
dtparam=i2c1=on
dtparam=i2c_arm=on

!!! Reboot !!!

sudo i2cdetect -y 1 # for new raspberry pi 2 Hardware revision 2 512MB
or 
sudo i2cdetect -y 0 # for old raspberry pi 1 Hardware revision 1 256MB



Copy the lcdSongInfo.py file to Adafruit_CharLCDPlate directory.

Create the autostart with: sudo crontab -e

@reboot sudo python /home/volumio/Adafruit_CharLCDPlate/lcdSongInfo.py .

Now set up your Volumio and reboot.

The LCD starts automatically.

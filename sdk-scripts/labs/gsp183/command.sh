
sudo apt-get update
sudo apt-get install git -y
sudo apt-get install python3-setuptools python3-dev build-essential -y
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
python3 --version
pip3 --version
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/developingapps/v1.3/python/devenv ~/devenv
cd ~/devenv/
sudo python3 server.py
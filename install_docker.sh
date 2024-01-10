 
#!/bin/bash

# Update the packages
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm pacman-contrib base-devel git

# Install yay if not installed
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

#Install Docker
yay -S --noconfirm docker

#Start Docker Service
sudo systemctl enable docker.service
sudo systemctl start docker.service

#Add the user to dockergroup
sudo usermod -aG docker $vardans

#Install Docker Compose
yay -S --noconfirm docker-compose


#Print Message
echo "Please restart your shell to apply the Dockerchanges."

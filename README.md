
# intuji-devops-internshipchallange

This repository describes the following:
- Install Docker in Linux Machine with Bash Scrpiting
- Clone simple php-helloworld project.
- Dockerize the php-helloword Project.
- Build the image for the project and push it to docker hub.
- Make docker-compose file for the given project.
- Install Jenkins
- Create a freestyle project for building a CI/CD pipeline for the above application which will build artifacts using a docker file directly from your GitHub repo. 


# Built with
- PHP(composer)
- Shell
- Dockerfile
- Jenkins

## Install Docker with Bash Script

- Create a file as install_docker.sh(File name could be of your choice).
- Open the file and write the script for installing docker on Linux Machine(I am working with Endeavour os-Arch linux)

```bash
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
```
- Firstly,I update the packages on my os.
```bash
 # Update the packages
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm pacman-contrib base-devel git

```
- Then I checked if yay(Package Manager) is installed on my os(if yay is not installed then it is installed on my system).
```bash
 # Install yay if not installed
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

```
-Then I Installed Docker and Started Docker Services
```bash
#Install Docker
yay -S --noconfirm docker

#Start Docker Service
sudo systemctl enable docker.service
sudo systemctl start docker.service

```
- Add your user to the docker group to run Docker commands without sudo
```bash
#Install Docker
sudo usermod -aG docker $vardans

```
-Install Docker compose 
```bash
#Install Docker Compose
yay -S --noconfirm docker-compose
```
-Print Message 
```bash
#Install Docker Compose
echo "Please restart your shell to apply the Dockerchanges."
```
- Save the file with .sh(My file name install_docker.sh)
- The Saved bashscript file should have execute permision .To give execute permision we should:
```bash
chmod +x install_docker.sh

```
- To execute the file we should go to location of the saved scrpit then we should run following on terminal
```bash
./install_docker.sh

```
![Bash Scrpit]https://github.com/VardanShrestha/intuji-devops-internshipchallange/blob/main/screenshots/Bash%20Scrpit.png?raw=true)
### Run Project Locally 
- Clone the Project as 
```bash
git clone https://github.com/silarhi/php-hello-world.git

```
- Create index.php file on root directory of project.
- Install the dependencies as: 
```bash
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-plugins --no-scripts --no-autoloader
composer update silarhi/hello-world

```
- Run project locally as :
```bash
php -S localhost:9090 -t

```
-Project can be accessed on localhost:9090

![Running Php Project Locally](https://github.com/VardanShrestha/intuji-devops-internshipchallange/blob/main/screenshots/Running%20Locally.png?raw=true)

## Dockerize the Project 

- Make file as Dockerfile on root
- Write DockerFile for the given Project as :
```bash
# Use php and apache image
FROM php:7.4-apache


# Setting working directory to /var/www/html
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    curl

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


COPY . /var/www/html/

# Install dependencies using Composer
RUN composer install --no-plugins --no-scripts --no-autoloader


# Expose port 80 
EXPOSE 80

# Start PHP-apache
CMD ["apache2-foreground"]


```
## Build the Image and push it to Docker hub

- To Build the image as : 
```bash
docker build -t php-hello-world-php-apache:tag(latest)

```
- To run Dockerfile
```bash
docker run -p 8080:80 -it php-hello-world-php-apache:tag(latest)

```
- Now, your application inside the container should be accessible on http://localhost:8080. Adjust the port numbers as needed based on your application's configuration.
- Push docker image to Dockerhub:
1. Make sure you have created Docker Hub account.
2. Make a repository for docker image to be pushed
- To push docker image on docker hub repository:
```bash
docker tag php-hello-world-php-apache:latest vrdn/php-hello-world-php-apache:latest.
docker login vrdn
docker push vrdn/phphelloworld:latest

```
- Link for docker hub repository:
https://hub.docker.com/repository/docker/vrdn/phphelloworld/general

![alt text](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)

## Creating Docker Compose File
- Make docker compose file as "docker-compose.yml" on root of the directory.
-Write docker-compose file as:
```bash
version: '3'
services:
  php-apache:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8080:80"
    
    networks:
      - my_network

networks:
  my_network:
    driver: bridge


```
- Run docker-compose file as : 
```bash
docker compose up --build


```
-This will automatically build image and run the container.
-Application will run on http://localhost:8080/

![alt text](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)

1. Since,I pulled php:apache image the configuration file for is automatically configured.
2. If we have pulled only php image then we should also give configurtion file on the docker image.(If we do it from nginx then we should give configuration file for the following project.)

## Install Jenkins
- To install we should install java first on our system(Endeavour os)
```bash
sudo pacman -S jdk-openjdk
```
- Install jenkins on Arch Linux(Endeavour os)as:
```bash
sudo pacman-key --init
sudo pacman-key --recv-keys D50582E6
echo '[jenkins]
Server = http://pkg.jenkins-ci.org/arch/' | sudo tee -a /etc/pacman.conf(add jenkinsrepository to system)
sudo pacman -S jenkins(pacman is the package manager for Endeavour Os)
```
- Enable Jenkis Services on system
```bash
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins(To check whether jenkis is running or not )

```
- Jenkins is available on http://localhost:8090/.(Since 8090 port is occupied by other services my jenkins is running on 8090 port ).

-Configure Jenkins
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
- Initial password could be accessed from the given location.
- Copy the password and Login into Jenkins.
## Buildind CI/CD with Jenkins
- Click into New item and select Freestyle Project
![alt text](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)
- On General click on Github Project(copy the url of the repository)
![alt text](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)
- Click on Git on Source Code Management and copy url of the repository.
![alt text](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)
- On Build Triggers click on Poll Scm and set a cron job for it.( I set it as "* * * * *" which states Jenkins will send request on Git every minute to check whether there is any commit).
![alt text](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)
- On Build Steps click on Add build steps and click on Execute Shell and write the command to build the docker file.
```bash
docker compose up --build
```
![alt text](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)

- Click on Save and Apply
- Check on dashboard of the job is failed or passed.
- Check Build status on Git Polling log 
![alt text](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)


























    
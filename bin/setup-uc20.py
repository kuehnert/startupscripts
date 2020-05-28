#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Version 1.0.3
# Call with:
# python3 <(curl -L -s l.mso.onl/uc20)
# python3 <(curl -s "https://gist.githubusercontent.com/kuehnert/093163cbe0fcf6c82d736f872bbe33f0/raw/fc2be8f333951354999ec27b16a804fa7cdafc58/setup-uc20.py?$(date +%s)")

import subprocess
import sys
import os
import re
import socket
import time

os.chdir(os.environ["HOME"])

if not os.path.isfile('/usr/bin/pip3'):
  print("pip3 not installed. Installing...")
  os.system("sudo apt -y update && sudo apt -y install python3-pip")
  print("Please re-run script")

if not os.path.isfile('/usr/lib/python3/dist-packages/click'):
  os.system("sudo python3 -m pip install click")

import click

def header(title):
  click.secho("######## " + title, nl=False, fg='green', bold=True)

def run(command):
  click.secho("\nExecuting: " + click.style(command, bold=True), bg="blue")
  result = os.system(command)
  if result != 0:
    click.secho("An error has occurred. Exiting.", fg='red', bold=True, err=True)
    exit(1)

def tick():
  click.secho('✔', fg="yellow", bold=True)

def create_user(username):
  header("Creating user {}... ".format(username))
  if (os.path.isdir('/home/{}/.ssh'.format(username))):
    tick()
  else:
    userpass = input("\n===> Password for new user: ")
    userhome = "/home/{}".format(username)
    run('sudo useradd {} --groups sudo --create-home --password $(openssl passwd -1 {})'.format(username, userpass))
    run('sudo chsh {} -s $(which bash)'.format(username))
    run("sudo chown -R {} {}".format(username, userhome))
    header("Setup rbenv for user {}... ".format(os.environ["USER"]))


click.clear()
click.secho("###################################################################", bg="red", fg="white")
click.secho("#          Python Setup Script for Ubuntu Client 20.04            #", bg="red", fg="white")
click.secho("###################################################################\n", bg="red", fg="white")

# answer = input("Do you really want to init Ruby on Rails on this machine, '{}' (yes/no)? ".format(socket.gethostname()))
answer = "yes"
if answer != 'yes':
  click.secho("Aborting script.")
  exit(0)

header("Updating system... ")
# if not os.path.isfile('/etc/apt/sources.list.d/passenger.list'):
  # run('sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7')
  # run('sudo add-apt-repository -y ppa:certbot/certbot')

modTime = os.path.getmtime('/var/cache/apt/pkgcache.bin')
now = time.time()
if (now - modTime) <= 60 * 60 * 2: # last update less than 2 hours ago
  tick()
else:
  run('sudo apt -y update')
  run('sudo apt -y full-upgrade')

# What's with libssl-dev? jpegoptim npm
header("Installing needed packages... ")
result = os.system('which zsh >/dev/null')
# if (now - modTime) <= 60 * 60 * 2: # last update less than 2 hours ago
if result == 0:
  tick()
else:
  run('sudo apt -y install \
    git git-flow \
    build-essential \
    zsh')

# """
# Users
# """
header("Checking users... \n")
if os.environ["USER"] == "root":
  main_user = input("main user name: ")
  create_user(main_user)
  click.secho("User created. Login as {} and re-run script.".format(main_user))
  exit(0)

header("Disable adding of Windows path... ")
if (os.path.isfile('/etc/wsl.conf')):
  tick()
else:
  run('sudo sh -c \'echo "[interop]\nappendWindowsPath=false" > /etc/wsl.conf\'')

header("Installing Oh-My-Zsh... ")
if (os.path.isdir('{}/.oh-my-zsh'.format(os.environ["HOME"]))):
  tick()
else:
  run('git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh')

header("Installing zplug... ")
if (os.path.isdir('{}/.zplug'.format(os.environ["HOME"]))):
  tick()
else:
  run('curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh')

header("Cloning startupscripts... ")
if (os.path.isfile('{}/GITProjects/startupscripts/zshrc'.format(os.environ["HOME"]))):
  tick()
else:
  run('mkdir ~/GITProjects; cd ~/GITProjects; git clone https://github.com/kuehnert/startupscripts.git')
  run('python3 ~/GITProjects/startupscripts/bin/setup.py')
  click.secho("Please log in again to activate startup scripts")
  exit(0)

header("Changing default shell to zsh... ")
correct_shell = False
f = open("/etc/passwd", "r")
if f.mode == 'r':
  passwd = f.read()
  match = re.search(r"\/home\/mk:\/usr\/bin\/zsh", passwd)
  correct_shell = match != None
f.close()

if correct_shell:
  tick()
else:
  run('chsh -s $(which zsh)')

# Setup nvm
# nvm install --latest-npm
# nvm alias default node


header("Setup rbenv for user {}... ".format(os.environ["USER"]))
if (os.path.isfile('{}/.rbenv/shims/foreman'.format(os.environ["HOME"]))):
  tick()
else:
  answer = input("\nDo you wish to setup ruby 2.5.5 with rbenv (y/n)?")
  if answer == "y":
    run('sudo apt install -y libssl-dev libreadline-dev postgresql libpq-dev redis-server')
    run('rm -rf ~/.rbenv; git clone https://github.com/sstephenson/rbenv.git ~/.rbenv')
    run('mkdir -p ~/.rbenv/plugins/ruby-build')
    run('git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build')
    run('eval "$(~/.rbenv/bin/rbenv init -)"')
    run('echo \'export PATH="$HOME/.rbenv/bin:$PATH"\neval "$(rbenv init -)"\' > ~/.bash_profile')
    run('rbenv install 2.5.5')
    run('rbenv global 2.5.5')
    run('echo "gem: --no-document" > ~/.gemrc')
    run('gem install bundler foreman')

click.secho("Finiss!")
exit(0)

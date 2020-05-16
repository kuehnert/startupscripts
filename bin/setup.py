import click
import os

files2link = [
    "bash",
    "bashrc",
    "bin",
    "gemrc",
    "gitattributes",
    "gitconfig",
    "gitignore_global",
    "irbrc",
    "p10k.zsh",
    "profile",
    "railsrc",
    "tmux.conf",
    "zshenv",
    "zshrc",
]

click.secho("Linking files to this folder...")
abspath = os.path.abspath(os.path.join(os.path.dirname(__file__),".."))
click.secho(abspath)

for file in files2link:
  source = os.path.join(abspath, file)
  dest = os.path.join(os.environ["HOME"], "." + file)
  cmd = "ln -f -s {} {}".format(source, dest)
  click.secho(cmd)
  os.system(cmd)

click.secho("Finiss!")

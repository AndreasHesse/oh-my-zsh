<<<<<<< HEAD
#!zsh
# 
# Installation
# ------------
# 
# To achieve fabfile completion nirvana:
# 
#   Copy this file somewhere (e.g. ~/.fab-comletion.zsh) and put the following line in your .zshrc:
# 
#        source ~/.fab-comletion.zsh
#
#    Or, use this file as a oh-my-zsh plugin.
#

_fab_list() {
	reply=(`fab --shortlist`) 
}
compctl -K _fab_list fab

=======
# DECLARION: This plugin was created by vhbit. What I did is just making a portal from https://github.com/vhbit/fabric-zsh-autocomplete.
>>>>>>> 3d5b3430fd9da12f6e33f534e487fe9b18928ac7

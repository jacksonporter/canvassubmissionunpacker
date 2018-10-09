#!/bin/bash

###########################################
#                                         #
#     ########  ###########  #        #   #
#    #          #            #        #   #
#   #           #            #        #   #
#   #           ###########  #        #   #
#   #                     #  #        #   #
#    #                    #  #        #   #
#     ########  ###########  ##########   #
#                                         #
###########################################
# Canvas Submission Unpacker 
# https://github.com/jacksonporter/canvassubmissionunpacker
# Is NOT affiliated with Canvas by Instructure.

# This script takes a compressed zip folder of submissions from Canvas by Instructure
# unzips it, creates a new directory, creates a new folder for each student 
# submission, renames the files to have the original name (part of the problem with
# downloading all submissions from a single assingment in Canvas).

# There are no guarantees from using this script. This is a Bash shell script, which uses
# various Linux/Unix programs to complete the above described tasks. I do not take 
# responsibility for the usage and output of this software. USE AT YOUR OWN RISK!
# This script/program is lisened by the MIT License. Please see the GitHub repository
# below and open the License file for more information.

# This is a project based at: https://github.com/jacksonporter/canvassubmissionunpacker

# Functions:








# Main:

# Print welcome messages.
printf "You are running the Canvas Submission Unpacker Bash Script.\n"
printf "This project is available at https://github.com/jacksonporter/canvassubmissionunpacker\n\n"

# Start running tasks in an interactive way with the user. 
printf "Please type in the name of the ZIP compressed folder with the submissions (don't forget the .zip at the end): "
read COMPRESSEDSUBMISSIONS

# Grab the locatin of the submissions compressed zip folder from the user.
if [ -f "./$COMPRESSEDSUBMISSIONS" ]
then
    printf "\nGreat! I see your zip compressed folder is in the same directory as me :)\n"
else
    while [ ! -f "$COMPRESSEDSUBMISSIONS" ]
    do
        printf "\nLooks like I can't see that file. Please type the full path of the file (Press CTRL+C to quit): "
        read COMPRESSEDSUBMISSIONS
    done
    printf "\nGreat! I see your zip commpressed folder!\n"
fi


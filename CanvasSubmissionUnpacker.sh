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

# Global Variables
COMPRESSEDSUBMISSIONS=""
ASSINGMENTNAME="Default"

# Functions:

function cleanUpCtrlC() {
    cleanUp "Program killed by (CTRL + C)." 1
}

# Cleans up the program by printing thank you message and an additional message if needed 
# and clears the console.
function cleanUp() {
    clear # clear the console
    printf "Closing Canvas Submission Unpacker. " # print closing message

    if [[ "$1" != "" ]] && [[ "$1" != "0" ]] && [[ "$1" != "1" ]] #if an argument is provided, print it.
    then
        printf "\n\nMessage: $1\n"
        shift
    fi

    if [ $1 -eq 1 ]
    then
        if [ -d "./$ASSINGMENTNAME" ] # Did I make a directory to work in?
        then 
            printf "Since an error occured, would you like to delete the working directory? (y/N): "
            read input #Get user input to delete working directory

            if [ input == "Y" ] || [ input == "y" ]
            then 
                printf "Deleting all folders/files in created directory and deleting directory, $createdDir."
                rm -rf "./$ASSINGMENTNAME"
            else
                printf "The $ASSINGMENTNAME directory was left behind.\n"
            fi
        fi
    fi

    exit $1
}

# Set location of compressed zip folder containing assingment submissions
function setCompressedZipSubmissions() {
    if [[ "$COMPRESSEDSUBMISSIONS" != "" ]]
    then 
        if [ -f "./$COMPRESSEDSUBMISSIONS" ]
        then
            printf "\nGreat! I see your zip compressed folder.\n"
        else
            cleanUp "Can't see compresssed zip folder. Try again: bash CanvasSubmissionUnpacker -s \"\\path\\to\\zip.zip\"" 1
           printf "\nLooks like I can't see that compressed zip folder. Please try again. [Press (CTRL + C) to quit]: "
        fi
    else  # Grab the location of the submissions compressed zip folder from the user.
        printf "Please type in the name of the ZIP compressed folder with the submissions (don't forget the .zip at the end): "
        read COMPRESSEDSUBMISSIONS

       
        if [ -f "./$COMPRESSEDSUBMISSIONS" ]
        then
            printf "\nGreat! I see your zip compressed folder is in the same directory as me :)\n"
        else
            while [ ! -f "$COMPRESSEDSUBMISSIONS" ]
            do
                printf "\nLooks like I can't see that file. Please type the full path of the file [Press (CTRL + C) to quit]: "
                read COMPRESSEDSUBMISSIONS
            done
            printf "\nGreat! I see your zip commpressed folder!\n"
        fi
    fi
}

function makeAssingmentDirectory() {
    if [[ "$ASSINGMENTNAME" != "Default" ]]
    then 
        if [ -d "./$ASSINGMENTNAME" ]
        then
            printf "\nThere is already a directory with this name in this folder. I will write into this directory.\n"
        else
            mkdir "./$ASSINGMENTNAME"
            printf "\nCreated diretory: $ASSINGMENTNAME."
        fi
    else  # Grab the location of the submissions compressed zip folder from the user.
        printf "Please type in the name of the assingment that goes with the submissions (Please, no spaces): "
        read ASSINGMENTNAME

        if [ -d "./$ASSINGMENTNAME" ]
        then
            printf "\nThere is already a directory with this name in this folder. I will write into this directory.\n"
        else
            mkdir "./$ASSINGMENTNAME"
            printf "\nCreated diretory: $ASSINGMENTNAME."
        fi
    fi
}


# Main:

# Trap SIGINT (Ctrl + C) if pressed.
trap cleanUpCtrlC SIGINT

# Print welcome messages.
printf "You are running the Canvas Submission Unpacker Bash Script.\n"
printf "This project is available at https://github.com/jacksonporter/canvassubmissionunpacker\n\n"

# Start running tasks in an interactive way with the user. 
setCompressedZipSubmissions #set the location of submission compressed zip folder
makeAssingmentDirectory #create a directory for this assingment and more me to work in



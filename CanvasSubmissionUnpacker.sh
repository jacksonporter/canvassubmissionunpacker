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

function setGlobalVariables() {
    if [ -z "$COMPRESSEDSUBMISSIONS" ]
    then
        COMPRESSEDSUBMISSIONS=""
    fi

    if [[ -z "$ASSINGMENTNAME" ]]
    then
        ASSINGMENTNAME="DEFAULT"
    fi
}

function printUsage() {
    printf "USAGE: \nbash CanvasSubmissionUnPacker.sh\nOptions:"
    printf "\n\t -a NameOfAssingment (Name of assingment associated with submission)"
    printf "\n\t -u (Displayes usage of CanvasSubmissionUnpacker bash shell script)"
    printf "\n"
}

function cleanUpCtrlC() {
    printf "\n\nProgram killed by (CTRL + C)"
    cleanUp 1
}

# Cleans up the program by printing thank you message and an additional message if needed 
# and clears the console.
function cleanUp() {
    printf "\n\n\nClosing Canvas Submission Unpacker.\n" # print closing message

    if [ $1 -eq 1 ]
    then
        if [ -d "./$ASSINGMENTNAME" ] # Did I make a directory to work in?
        then 
            printf "Since an error occured, would you like to delete the working directory? (y/N): "
            read input #Get user input to delete working directory

            if [ input == "Y" ] || [ input == "y" ]
            then 
                printf "Deleting all folders/files in created directory and deleting directory, $ASSINGMENTNAME."
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
            printf "\nCan't see compresssed zip folder. Try again: bash CanvasSubmissionUnpacker -s \"\\path\\to\\zip.zip\""
            cleanUp 1
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
            printf "\nCreated directory: $ASSINGMENTNAME.\n"
        fi
    else  # Grab the location of the submissions compressed zip folder from the user.
        printf "Please type in the name of the assingment that goes with the submissions (Please, no spaces): "
        read ASSINGMENTNAME

        if [ -d "./$ASSINGMENTNAME" ]
        then
            printf "\nThere is already a directory with this name in this folder. I will write into this directory.\n"
        else
            mkdir "./$ASSINGMENTNAME"
            printf "\nCreated directory: $ASSINGMENTNAME.\n"
        fi
    fi
}


# Main:

# Trap SIGINT (Ctrl + C) if pressed.
trap cleanUpCtrlC SIGINT

# Print welcome messages.
printf "You are running the Canvas Submission Unpacker Bash Script.\n"
printf "This project is available at https://github.com/jacksonporter/canvassubmissionunpacker\n\n"

# Process command line arguments.
if [ $# -eq 0 ]
then 
    printf "\nWill run in interactive mode."
    setGlobalVariables
else
    while [ $# -ne 0 ]
    do
        num1=$1
        printf "\nnum1 is: $num1\n"

        if [[ $num1 == -* ]]
        then
            num1="${num1#?}"
            printf "\nnum1 now is: $num1\n"

            while [[ ! -z "$num1" ]]
            do
                firstLetter="$(echo $num1 | head -c 1)"
                printf "firstLetter is: $firstLetter\n"
                if [[ "$firstLetter" == "u" ]]
                then
                    printUsage
                    cleanUp 0
                elif [[ "$firstLetter" == "i" ]]
                then
                    while [ ! -z $1 ]
                    do
                        shift 1
                    done

                    setGlobalVariables

                    printf "\n***Will run in interactive mode.***\n\n"
                    num1=""
                    break
                elif [[ "$firstLetter" == "s" ]]
                then
                    shift 1
                    COMPRESSEDSUBMISSIONS="$1"
                    printf "Set compressed zip folder as: $COMPRESSEDSUBMISSIONS\n"
                    shift 1
                elif [[ "$firstLetter" == "a" ]]
                then
                    shift 1
                    ASSINGMENTNAME="$1"
                    printf "Set assingment name as: $ASSINGMENTNAME\n"
                    shift 1
                else
                    printf "\nInvalid argument or missing value. Run bash CanvasSubmissionUnpacker.sh -u for usage."
                    cleanUp 1
                fi

                num1=${num1#?}
                printf "\nnum1 reset in condition is: $num1\n"
            done
        elif [[ -z "$num1" ]]
        then
            printf "\nNo more args!\n"
        else
            printf "\nInvalid argument or missing value. Run bash CanvasSubmissionUnpacker.sh -u for usage."
            cleanUp 1
        fi
    done
fi

# Start running tasks
setCompressedZipSubmissions #set the location of submission compressed zip folder
makeAssingmentDirectory #create a directory for this assingment and more me to work in



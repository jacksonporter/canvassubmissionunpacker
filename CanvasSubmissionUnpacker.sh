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
# downloading all submissions from a single assignment in Canvas).

# There are no guarantees from using this script. This is a Bash shell script, which uses
# various Linux/Unix programs to complete the above described tasks. I do not take 
# responsibility for the usage and output of this software. USE AT YOUR OWN RISK!
# This script/program is licensed by the MIT License. Please see the GitHub repository
# listed above and open the License file for more information.

# Functions:

function setGlobalVariables() {
    if [ -z "$COMPRESSEDSUBMISSIONS" ]
    then
        COMPRESSEDSUBMISSIONS=""
    fi

    if [[ -z "$assignmentNAME" ]]
    then
        assignmentNAME="Submissions"
    fi
}

function printUsage() {
    printf "USAGE: \nbash CanvasSubmissionUnPacker.sh\nOptions:"
    printf "\n\t -u (Displays usage of CanvasSubmissionUnpacker bash shell script)"
    printf "\n\t -i (Provides interactive mode, interacts with user on command line)"
    printf "\n\t -s PathToZip.zip (Path to compressed zip folder containing submissions)"
    printf "\n\t -a NameOfassignment (Name of assignment associated with submission)"
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
        if [ -d "./$assignmentNAME" ] # Did I make a directory to work in?
        then 
            printf "Since an error occured, would you like to delete the working directory? (y/N): "
            read input #Get user input to delete working directory

            echo "INPUT: $input"

            if [[ "$input" == "Y" ]] || [[ "$input" == "y" ]]
            then 
                printf "Deleting all folders/files in created directory and deleting directory: $assignmentNAME.\n"
                rm -rf "./$assignmentNAME"
            else
                printf "The $assignmentNAME directory was left behind.\n"
            fi
        fi
    fi

    exit $1
}

# Set location of compressed zip folder containing assignment submissions
function setCompressedZipSubmissions() {
    if [[ "$COMPRESSEDSUBMISSIONS" != "" ]]
    then 
        if [ -f "./$COMPRESSEDSUBMISSIONS" ]
        then
            printf "\nGreat! I see your zip compressed folder.\n"
        else
            printf "\nCan't see compresssed zip folder. Try again: bash CanvasSubmissionUnpacker -s \"/\path\/to\/zip.zip\""
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

function makeassignmentDirectory() {
    if [ "$assignmentNAME" != "Submissions" ]
    then 
        if [ -d "./$assignmentNAME" ]
        then
            printf "There is already a directory \"$assignmentNAME\" in this folder. I will write into this directory.\n"
        else
            mkdir "./$assignmentNAME"
            printf "\nCreated directory: $assignmentNAME.\n"
        fi
    else  # Grab the location of the submissions compressed zip folder from the user.
        printf "Please type in the name of the assignment that goes with the submissions (Please, no spaces): "
        read assignmentNAME

        if [ -d "./$assignmentNAME" ]
        then
            printf "There is already a directory with this name in this folder. I will write into this directory.\n"
        else
            mkdir "./$assignmentNAME"
            printf "\nCreated directory: $assignmentNAME.\n"
        fi
    fi
}

function unzipSubmissions() {
    mkdir "$assignmentNAME/ExtractedSubmissions"
    unzipLocation="$(which unzip)"

    if [ -z "$unzipLocation" ]
    then
        printf "Unzip is not installed on your system! You'll need to install it before this script can run.\n"
        printf "Would you like me to install it (Debain/Ubuntu/Other APT using systems only)? (Y/n): "
        read input

        if [[ "$input" == "N" ]] || [[ "$input" == "n" ]]
        then 
            printf "\nRun this script again once unzip is installed.\n"
            cleanUp 1
        fi

        printf "If you are prompted for a password, please type it below (if you're not and administrator this won't work):\n"
        sudo apt update

        if [ $? -ne 0 ]
        then 
            printf "Couldn't update software sources. Are you connected to the internet?2\n"
            cleanUp 1
        fi

        sudo apt install unzip --yes

        if [ $? -ne 0 ]
        then 
            printf "\nInstallation failed. Are you connected to the internet?\n"
            cleanUp 1
        fi
    fi

    unzip $COMPRESSEDSUBMISSIONS -d "$assignmentNAME/ExtractedSubmissions"
    if [ $? -ne 0 ]
    then 
        printf "\nCouldn't extract your zip file. It may be corrupted.\n"
        cleanUp 1
    fi
}

#Based on the beginnings of file names, create directories of students to put indivudal submisisons in.
function makeStudentDirectoriesRenameFilesUnzip(){
    for FILE in ./$assignmentNAME/ExtractedSubmissions/*.*
    do
        initialFileName="$(echo "$FILE" | awk '{split($0,a,"/"); print a[4]}')"
        studentName="$(echo "$initialFileName" | awk '{split($0,a,"_"); print a[1]}')"


        if [ ! -d "./$assignmentNAME/$studentName" ]
        then
            printf "New Student Directory: $studentName\n" 
            mkdir "./$assignmentNAME/$studentName"
        fi

        #Generate correct filename
        fileName="$(echo "$initialFileName" | awk '{split($0,a,"_"); print a[4]}')"
        printf "Renaming $initialFileName to $fileName\n"

        mv "$FILE" "./$assignmentNAME/$studentName/$fileName"

        fileExt="$(echo "$fileName" | awk '{n=split($0,a,"."); print a[n]}')" 
        #printf "FILEXT: $fileExt\n"

        if [[ "$fileExt" == "zip" ]] || [[ "$fileExt" == "ZIP" ]]
        then
            unzip "./$assignmentNAME/$studentName/$fileName" -d "./$assignmentNAME/$studentName"
        fi     

        printf "\n"
    done
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
    printf "\n***Will run in interactive mode.***\n\n"
    setGlobalVariables
else
    count=0
    while [ $# -ne 0 ]
    do
        if [ $count -eq 0 ]
        then
            count=$(($count + 1))
            num1=$1
        else
            shift 1
            num1=$1
        fi
        

        if [[ $num1 == -* ]]
        then
            num1="${num1#?}"

            while [[ ! -z "$num1" ]]
            do
                firstLetter="$(echo $num1 | head -c 1)"
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
                    setGlobalVariables                    
                elif [[ "$firstLetter" == "a" ]]
                then
                    shift 1
                    assignmentNAME="$1"
                    printf "Set assignment name as: $assignmentNAME\n"
                    setGlobalVariables
                else
                    printf "\nInvalid argument or missing value. Run bash CanvasSubmissionUnpacker.sh -u for usage."
                    cleanUp 1
                fi

                num1=${num1#?}
            done
        elif [[ -z "$num1" ]]
        then
            printf ""
            #printf "\nNo more args!\n"
        else
            printf "\nInvalid argument or missing value. Run bash CanvasSubmissionUnpacker.sh -u for usage."
            cleanUp 1
        fi
    done
fi

# Start running tasks
setCompressedZipSubmissions #set the location of submission compressed zip folder
makeassignmentDirectory #create a directory for this assignment and more me to work in
unzipSubmissions #unzip the submissions to a subdirectory inside the assignment folder.
makeStudentDirectoriesRenameFilesUnzip #creates subdirectories with student names based on file names



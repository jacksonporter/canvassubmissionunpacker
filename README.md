
# Canvas Submission Unpacker
[GitHub Repo](https://github.com/jacksonporter/canvassubmissionunpacker)

The Canvas Submission Unpacker helps make an easy transition from downloaded Canvas submissions in a zip folder to an organized file/directory structure.

### License / Usage
I do not take responsibility for the usage and output of this software. USE AT YOUR OWN RISK! This script is licensed by the MIT License. Please see the GitHub repository listed and open the License file for more information. There are no guarantees from using this script, described outcome is not promised.

### Description
This script takes a compressed zip folder of submissions from Canvas by Instructure (rights are owned by Instructure) unzips it, creates a new directory, creates a new folder for each student submission, renames the files to have the original name (part of the problem with downloading all submissions from a single assignment in Canvas). 

### Software Needed
This is a Bash shell script, which uses various GNU Linux/Unix programs to complete the above described tasks. The following software is used to run and execute the various tasks in the script. Usually all linux distributions have the following software, with the exception of unzip. Download unzip using your package manager.

* [Bash Shell](https://www.gnu.org/software/bash/)
* UnZip (debian)
* [GNU Awk (Gawk)](https://www.gnu.org/software/gawk/manual/gawk.html)
* mv (move)
* mkdir (make directory)

#### Usage
To run the script, run using bash: 
* bash CanvasSubmissionUnpacker.sh
OR
* ./CanvasSubmissionUnpacker.sh  - if you mark the script as executable by running:
	* chmod 554 CanvasSubmissionUnpacker.sh

If you run the script with no command line options, it will automatically run in interactive mode. Here are examples of other options you can use:

* Display Usage:
	*  bash CanvasSubmissionUnpacker.sh -u
* Provide Path to Submissions compressed zip folder
	*  bash CanvasSubmissionUnpacker.sh -s "/path/to/submissions.zip"
* Provide Name of Assignment
	*  bash CanvasSubmissionUnpacker.sh -a AssignmentName
* Run in interactive
	* bash CanvasSubmissionUnpacker.sh OR bash CanvasSubmissionUnpacker.sh -i

**Notes:**
* If you use the -u option with any other options, the program will eventually stop and show usage.
* If you use the -i option with any other options, the program will run as interactive as it can based on if you provided the path to the compressed zip folder and homework assignment name.

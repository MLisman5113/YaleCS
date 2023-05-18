# CPSC 484: HCI Group Project (Group 5)

### Members

1. Jackson Grady
2. Marcus Lisman
3. Misho Gabashvili
4. Danu Metaferia

## Installing Dependencies and Running the Project
<p>No additional dependencies are required for this project. It integrates p5.js with normal vanilla JavaScript, HTMl, CSS (with Bootstrap integrated for formatting), but as for additional dependencies, everything the project needs to run is already imported and included in the project files.</p>

## Project Description and What the Installation Addresses
<p>Our group's project is an interactive polling program that seeks to gather student input about interesting and pertinent issues with minimal barriers to entry. When conducting our research about the problem space, the main concern students had was that making their voice heard too/Users/marcuslisman/Coding/MLisman5113/CS484/hci-project-group-main/tv67.jsk too much time or was too much of an effort that they didn't bother to use whatever system that specific poller at the time had in place. Our project removes those barriers by displaying questions on the screen that the user can respond to using simple poses that are read in as input by the Kinect system and processed as answers to that question. The user has full control over which questions they can answer and has full control over their experience with making their voice heard. The project displays as many questions as the user wants to answer and then displays the responses of other students in the form of a pie chart.</p>

<p>The installation addresses the barriers present to gathering student input as well as making one's voice heard. By making it easy for students to answer questions and easy for organizations to display questions and gather input in a fun, interactive way, the installation allows for a more effective and representative reading of student sentiment on certain issues, which can then inform university policy or give users a general idea of how students feel about certain topics. Essentially, it's an interactive system that makes polling easier for both the party gathering the information and the parties providing it.</p>

## Constraints from the Deployment Environment
<p>For our project to function as intended, only <b>ONE</b> user should be in front of the TV installation. Our code can only process one user going at a time since it uses the coordinates of the different poses on one person, so multiple users will result in an unsuccessful test run of the installation or unintended behavior.</p>

<p>Additionally, for the application to run as intended, the user should stand about 4-5 feet from the installation for the application to run. Various y-axis measurements of the arms corresponding to the poses are being used to process user input and therefore decide what gets displayed on the screen, so it is important that the user remains at that distance so there is room for the Kinect to see that vertical change in movement from each of the respective poses </p>

## Collaboration Record

1. Jackson Grady
    - NetID:
    - Contribution:
2. Marcus Lisman
    - NetID: mal249
    - Contribution: I helped with the question and answer database for the installation as well as writing up the Markdown file for the assignment that described dependencies, project description, and the collaboration record. 
3. Misho Gabashvili
    - NetID:
    - Contribution:
4. Danu Metaferia
    - NetID:
    - Contribution:

       IDENTIFICATION DIVISION.
       PROGRAM-ID. ARTISTS-CLUB.
       AUTHOR. MANUS AI.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT APPLICATION-FILE ASSIGN TO "applications.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT REVIEW-FILE ASSIGN TO "reviews.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  APPLICATION-FILE.
       01  APPLICATION-RECORD PIC X(600).
       FD  REVIEW-FILE.
       01  REVIEW-RECORD PIC X(300).

       WORKING-STORAGE SECTION.
       01  MENU-CHOICE PIC 9 VALUE 0.
       01  END-FLAG PIC X VALUE "N".
       01  APPLICANT-EMAIL PIC X(120).
       01  DISPLAY-NAME PIC X(80).
       01  EDUCATION-STATUS PIC X(20).
       01  STATEMENT-TEXT PIC X(220).
       01  DRAWING-TITLE PIC X(80).
       01  PAINTING-TITLE PIC X(80).
       01  COMPOSITION-TITLE PIC X(80).
       01  MEDIA-TYPE PIC X(12).
       01  MEDIA-FILENAME PIC X(120).
       01  REVIEW-DRAWING PIC 99.
       01  REVIEW-PAINTING PIC 99.
       01  REVIEW-COMPOSITION PIC 99.
       01  REVIEW-NOTE PIC X(180).
       01  ROLE-NAME PIC X(20).
       01  STATUS-TEXT PIC X(20).
       01  TODAY-TEXT PIC X(10).
       01  ANSWER PIC X.

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM INITIALIZE-DATA
           PERFORM UNTIL END-FLAG = "Y"
               DISPLAY " "
               DISPLAY "=========================================="
               DISPLAY "  CLOSED ARTISTS CLUB / COBOL CORE"
               DISPLAY "=========================================="
               DISPLAY "1. New membership application"
               DISPLAY "2. Review application"
               DISPLAY "3. List applications"
               DISPLAY "4. Exit"
               ACCEPT MENU-CHOICE
               EVALUATE MENU-CHOICE
                   WHEN 1 PERFORM NEW-APPLICATION
                   WHEN 2 PERFORM REVIEW-APPLICATION
                   WHEN 3 PERFORM LIST-APPLICATIONS
                   WHEN 4 MOVE "Y" TO END-FLAG
                   WHEN OTHER DISPLAY "Unknown menu choice."
               END-EVALUATE
           END-PERFORM
           DISPLAY "Session closed."
           STOP RUN.

       INITIALIZE-DATA.
           ACCEPT TODAY-TEXT FROM DATE YYYYMMDD.

       NEW-APPLICATION.
           DISPLAY "Applicant email: " WITH NO ADVANCING
           ACCEPT APPLICANT-EMAIL
           DISPLAY "Display name: " WITH NO ADVANCING
           ACCEPT DISPLAY-NAME
           DISPLAY "Profile education verified? (Y/N): " WITH NO ADVANCING
           ACCEPT ANSWER
           IF ANSWER = "Y" OR ANSWER = "y"
               MOVE "EDUCATION" TO EDUCATION-STATUS
           ELSE
               MOVE "PORTFOLIO" TO EDUCATION-STATUS
           END-IF
           DISPLAY "Statement of artistic practice: " WITH NO ADVANCING
           ACCEPT STATEMENT-TEXT
           DISPLAY "Drawing work title: " WITH NO ADVANCING
           ACCEPT DRAWING-TITLE
           DISPLAY "Painting work title: " WITH NO ADVANCING
           ACCEPT PAINTING-TITLE
           DISPLAY "Composition work title: " WITH NO ADVANCING
           ACCEPT COMPOSITION-TITLE
           DISPLAY "Media type for the three files (PHOTO/VIDEO/AUDIO): "
               WITH NO ADVANCING
           ACCEPT MEDIA-TYPE
           DISPLAY "Shared media filename or object key: " WITH NO ADVANCING
           ACCEPT MEDIA-FILENAME
           MOVE "SUBMITTED" TO STATUS-TEXT
           OPEN EXTEND APPLICATION-FILE
           STRING APPLICANT-EMAIL DELIMITED BY SIZE
               "|" DELIMITED BY SIZE DISPLAY-NAME DELIMITED BY SIZE
               "|" DELIMITED BY SIZE EDUCATION-STATUS DELIMITED BY SIZE
               "|" DELIMITED BY SIZE STATUS-TEXT DELIMITED BY SIZE
               "|" DELIMITED BY SIZE DRAWING-TITLE DELIMITED BY SIZE
               "|" DELIMITED BY SIZE PAINTING-TITLE DELIMITED BY SIZE
               "|" DELIMITED BY SIZE COMPOSITION-TITLE DELIMITED BY SIZE
               "|" DELIMITED BY SIZE MEDIA-TYPE DELIMITED BY SIZE
               "|" DELIMITED BY SIZE MEDIA-FILENAME DELIMITED BY SIZE
               "|" DELIMITED BY SIZE STATEMENT-TEXT DELIMITED BY SIZE
               INTO APPLICATION-RECORD
           END-STRING
           WRITE APPLICATION-RECORD
           CLOSE APPLICATION-FILE
           DISPLAY "Application saved with status SUBMITTED."
           DISPLAY "No sponsor or advertiser path exists in this workflow."

       REVIEW-APPLICATION.
           DISPLAY "Applicant email to review: " WITH NO ADVANCING
           ACCEPT APPLICANT-EMAIL
           DISPLAY "Drawing score (1-10): " WITH NO ADVANCING
           ACCEPT REVIEW-DRAWING
           DISPLAY "Painting score (1-10): " WITH NO ADVANCING
           ACCEPT REVIEW-PAINTING
           DISPLAY "Composition score (1-10): " WITH NO ADVANCING
           ACCEPT REVIEW-COMPOSITION
           DISPLAY "Commission note: " WITH NO ADVANCING
           ACCEPT REVIEW-NOTE
           IF REVIEW-DRAWING >= 6 AND REVIEW-PAINTING >= 6
               AND REVIEW-COMPOSITION >= 6
               MOVE "VERIFIED_ARTIST" TO ROLE-NAME
               MOVE "APPROVED" TO STATUS-TEXT
           ELSE
               MOVE "APPLICANT" TO ROLE-NAME
               MOVE "APPEALABLE" TO STATUS-TEXT
           END-IF
           OPEN EXTEND REVIEW-FILE
           STRING APPLICANT-EMAIL DELIMITED BY SIZE
               "|" DELIMITED BY SIZE TODAY-TEXT DELIMITED BY SIZE
               "|" DELIMITED BY SIZE REVIEW-DRAWING DELIMITED BY SIZE
               "|" DELIMITED BY SIZE REVIEW-PAINTING DELIMITED BY SIZE
               "|" DELIMITED BY SIZE REVIEW-COMPOSITION DELIMITED BY SIZE
               "|" DELIMITED BY SIZE STATUS-TEXT DELIMITED BY SIZE
               "|" DELIMITED BY SIZE ROLE-NAME DELIMITED BY SIZE
               "|" DELIMITED BY SIZE REVIEW-NOTE DELIMITED BY SIZE
               INTO REVIEW-RECORD
           END-STRING
           WRITE REVIEW-RECORD
           CLOSE REVIEW-FILE
           DISPLAY "Decision: " STATUS-TEXT
           DISPLAY "Role: " ROLE-NAME

       LIST-APPLICATIONS.
           OPEN INPUT APPLICATION-FILE
           PERFORM UNTIL 1 = 0
               READ APPLICATION-FILE
                   AT END EXIT PERFORM
                   NOT AT END DISPLAY APPLICATION-RECORD
               END-READ
           END-PERFORM
           CLOSE APPLICATION-FILE.

       END PROGRAM ARTISTS-CLUB.

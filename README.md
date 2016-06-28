# Schedule Backup files to S3

This scripts used to sync the file which is new created or modified to S3：
  - install AWS Command Line Interface
  - configure aws profile
  - configure windows scheduler

### Installation

requires [AWS CLI](https://aws.amazon.com/cli/) and [Robocopy](https://www.microsoft.com/en-us/download/details.aspx?id=17657) to run.

### configure aws profile:
```sh
$ cd C:\Program Files\Amazon\AWSCLI\
$ aws configure --profile WelabAccount1
$ aws configure set AWS_ACCESS_KEY_ID xxxxxx
$ aws configure set AWS_SECRET_ACCESS_KEY xxxxxx
$ aws configure set default.region ap-southeast-1
```

### sync cli:
```sh
$ aws s3 sync \\172.22.7.2\calls s3://welend-call-backups/calls
$ robocopy \\172.22.7.2\calls \\172.22.3.20\welab\calls /e /xo /COPY:DAT
```

### DailyBackup.bat
```sh
@ECHO OFF
ECHO ***********************************************************
ECHO *This scripts used to backup the file which is new created*
ECHO *or modified to S3                                        *
ECHO ***********************************************************

echo Connecting Drive
echo This may take sometime

net use X: \\172.22.7.2\calls /user:xxx xxx /Persistent:NO
net use W: \\172.22.3.20\welab\calls /user:xxx xxx /Persistent:NO

echo Connetion completed
echo ====================
echo Transferring new files

cd C:\Program Files\Amazon\AWSCLI\
aws configure --profile WelabAccount1
aws configure set AWS_ACCESS_KEY_ID xxxxxx
aws configure set AWS_SECRET_ACCESS_KEY xxxxxx
aws configure set default.region ap-southeast-1

aws s3 sync \\172.22.7.2\calls s3://welend-call-backups/calls
robocopy \\172.22.7.2\calls \\172.22.3.20\welab\calls /e /xo /COPY:DAT

echo ===================
echo Copy files completed, now delete network drive

net use X: /delete /yes
net use W: /delete /yes

 if errorlevel 4 goto lowmemory
 if errorlevel 2 goto abort
 if errorlevel 0 goto exit
 
:lowmemory
 echo Insufficient memory to copy files or
 echo invalid drive or command-line syntax.
 goto exit
 
:abort
 echo You pressed CTRL+C to end the copy operation.
 goto exit

echo =========================
echo All task completed, exit
echo ========================= 
:exit
```



# BASH
Some BASH scripting

File listing - 

1)`AWS_ENVSETTINGS.sh` - Automatically finds and scrapes the .credentials files created by running `aws-adfs login` for access keys. Scrapes the file, finds the key and token values , sets the environment variables for AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN, AWS_REGION as export statements in .bash_profile.

The current version is meant to run on Vagrant sandboxes only. 

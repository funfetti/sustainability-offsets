#!/usr/bin/env bash

# run chmod u+x scratch-bash.sh
# to actually execute: bash scratch-bash.sh
#
# your project-scratch-def.json should look something like this
# {
#  "orgName": "sustainability cloud scratch",
#  "edition": "Developer",
#  "features": [
#    "DevelopmentWave",
#    "SustainabilityCloud"
#  ]
# }
#
# need to add in 
# - copy in new project-scratch-def.json
# - copy in data 
# 

# get alias from user 
echo "name your sustainability scratch org:"
read sname

echo "your org is $sname"
echo creating your scratch org... 
sfdx force:org:create -f config/project-scratch-def.json -s -a sname

# 1.10
sfdx force:package:install -p 04t3k000001yv66AAA -w 20 

# output looks like: 
# PackageInstallRequest is currently InProgress. You can continue to query the status using
# sfdx force:package:install:report -i 0Hf210000004kNqCAI -u test-sptpbsctyvpw@example.com

# PSL/Perms 
# using shane's plugins https://github.com/mshanemc/shane-sfdx-plugins

sfdx shane:user:psl -l User -g User -n sustain_app_SustainabilityCloudPsl
sfdx shane:user:psl -l User -g User -n InsightsInboxAdminAnalyticsPsl

sfdx force:user:permset:assign -n SustainabilityAnalytics
sfdx force:user:permset:assign -n SustainabilityAppAuditor
sfdx force:user:permset:assign -n SustainabilityAppManager
sfdx force:user:permset:assign -n SustainabilityCloud

# make the EA dashboards populate correctly 
sfdx shane:user:permset:assign -l User -g Integration -n SustainabilityAnalytics

#load data
#sfdx automig:load -d demo-data/ --concise --mappingobjects RecordType:DeveloperName,sustain_app__EmissionFactorElectricity__c:Name,sustain_app__EmissionFactorOther__c:Name,sustain_app__EmissionFactorScope3__c:Name

#create EA apps
#sfdx analytics:app:create -m Sustainability  
#sfdx analytics:app:create -m Sustainability_Audit -a 

# alrighty lets push source
# make sure wave folder is deleted or empty!!! 
sfdx force:source:push
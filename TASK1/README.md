https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html

follow above document and create EFS mount point. It is the only storage class having multiple readwrite capability. 

after that run all yaml files.

apart from this , need to create a Jenkins server with webhook integration of GitHub. 
It will trigger build once a change detected in the repo.

In this approach , a Jenkins need to run 24/7 and should have a public endpoint. 

Another approach is to use aws code deploy which will trigger a lambda. Then lambda will fetch the change and push to EFS.
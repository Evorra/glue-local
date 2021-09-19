# glue-local
A local environment to develop Glue scripts (build a Docker image).  

Available for Glue 2.0 and Glue 3.0.  
Go in the corresponding folder and use the provided scripts:  
- build.sh to build the image and register it locally  
- run.sh to launch a container instance and connect a bash terminal to it  
- push.sh to push the image to an ECR repository  

Glue 3.0 follows a spcial process.  
- Follow the instratructions in https://github.com/alrouen/local-aws-glue-v3-zeppelin.  
- Use the provided python script to zip Glue distribution and save it in one of your s3 bucker.  
- From there download the zip, store it in a zip folder, translate it into a tgz archive preserving ./opt/amazon as root folder.  
- From there use the ./build.sh script.  

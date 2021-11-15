# glue-local
A local environment to develop Glue scripts (build a Docker image).  

Available for Glue 2.0 and Glue 3.0.  
Go in the corresponding folder and use the provided scripts:  
- build.sh to build the image and register it locally  
- run.sh to launch a container instance and connect a bash terminal to it  
- push.sh to push the image to an ECR repository  

Glue 3.0 follows a spcial process.  
- Follow the instratructions in https://github.com/alrouen/local-aws-glue-v3-zeppelin.  
- Use the provided python script to zip Glue distribution and save it in one of your s3 bucket.  
- From there download the zip, store it in a zip folder, translate it into a tgz archive preserving ./opt/amazon as root folder.  
- Use the ./build.sh script.
- I added support for Jupyter notebooks in this image, launch the container with the command `jupyter-lab --allow-root --no-browser --ip=0.0.0.0` and connect to the service with the URL displayed in the terminal

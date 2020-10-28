# WebApp-with-Docker-on-AWS
Create webapplication usind docker on AWS


## Create your own project or clone repo from below git repository

```
$ git clone https://github.com/recroviral/portfolio.git
$ cd portfolio
```

> This should be cloned on the machine where you are running the docker commands and not inside a docker container.

## Dockerfile

A Dockerfile is a simple text-file that contains a list of commands that the Docker client calls while creating an image.

you can get docker file command from below link
https://docs.docker.com/engine/reference/builder/#from


We start with specifying our base image. Use the FROM keyword to do that -

```
FROM nginx:alpine
```
The next step usually is to write the commands of copying the files and installing the dependencies. Luckily for us, the onbuild version of the image takes care of that. The next thing we need to specify is the port number that needs to be exposed. Since our flask app is running on port 5000, that's what we'll indicate.

```
EXPOSE 80

COPY html /usr/share/nginx/html
```

Now that we have our Dockerfile, we can build our image. The docker build command does the heavy-lifting of creating a Docker image from a Dockerfile.

```
$ docker build -t recroviral/portfolio .
```
The last step in this section is to run the image and see if it actually works (replacing my username with yours).

```
$ docker run -p 8888:80 recroviral/portfolio
```


## Docker on AWS

What good is an application that can't be shared with friends, right? So in this section we are going to see how we can deploy our awesome application to the cloud so that we can share it with our friends! We're going to use AWS Elastic Beanstalk to get our application up and running in a few clicks. We'll also see how easy it is to make our application scalable and manageable with Beanstalk!

### Docker push

The first thing that we need to do before we deploy our app to AWS is to publish our image on a registry which can be accessed by AWS. There are many different Docker registries you can use (you can even host your own). For now, let's use Docker Hub to publish the image. To publish, just type

```
$ docker push recroviral/portfolio
```

If this is the first time you are pushing an image, the client will ask you to login. Provide the same credentials that you used for logging into Docker Hub.

```
$ docker login
Username: *******
Password: *******
Login Succeeded
```

Remember to replace the name of the image tag above with yours. It is important to have the format of username/image_name so that the client knows where to publish.

Once that is done, you can view your image on Docker Hub. For example, here's the web page for my image.

> Note: One thing that I'd like to clarify before we go ahead is that it is not imperative to host your image on a public registry (or any registry) in order to deploy to AWS. In case you're writing code for the next million-dollar unicorn startup you can totally skip this step. The reason why we're pushing our images publicly is that it makes deployment super simple by skipping a few intermediate configuration steps.

Now that your image is online, anyone who has docker installed can play with your app by typing just a single command.

```
$ docker run -p 8888:5000 recroviral/portfolio
```

If you've pulled your hair in setting up local dev environments / sharing application configuration in the past, you very well know how awesome this sounds. That's why Docker is so cool!

### Beanstalk

AWS Elastic Beanstalk (EB) is a PaaS (Platform as a Service) offered by AWS. If you've used Heroku, Google App Engine etc. you'll feel right at home. As a developer, you just tell EB how to run your app and it takes care of the rest - including scaling, monitoring and even updates. In April 2014, EB added support for running single-container Docker deployments which is what we'll use to deploy our app. Although EB has a very intuitive CLI, it does require some setup, and to keep things simple we'll use the web UI to launch our application.

To follow along, you need a functioning AWS account. If you haven't already, please go ahead and do that now - you will need to enter your credit card information. But don't worry, it's free and anything we do in this tutorial will also be free! Let's get started.

Here are the steps:

1. Login to your AWS console.
2. Click on Elastic Beanstalk. It will be in the compute section on the top left. Alternatively, you can access the Elastic Beanstalk console.
3. Elastic Beanstalk start
4. Click on "Create New Application" in the top right
5. Give your app a memorable (but unique) name and provide an (optional) description
6. In the New Environment screen, create a new environment and choose the Web Server Environment.
7. Fill in the environment information by choosing a domain. This URL is what you'll share with your friends so make sure it's easy to remember.
8. Under base configuration section. Choose Docker from the predefined platform.
9. Elastic Beanstalk Environment Type
10. Now we need to upload our application code. But since our application is packaged in a Docker container, we just need to tell EB about our container. Open the Dockerrun.aws.json file located in the folder and edit the Name of the image to your image's name. Don't worry, I'll explain the contents of the file shortly. When you are done, click on the radio button for "Upload your Code", choose this file, and click on "Upload".
11. Now click on "Create environment". The final screen that you see will have a few spinners indicating that your environment is being set up. It typically takes around 5 minutes for the first-time setup.
12. While we wait, let's quickly see what the Dockerrun.aws.json file contains. This file is basically an AWS specific file that tells EB details about our application and docker configuration.

```
{
  "AWSEBDockerrunVersion": "1",
  "Image": {
    "Name": "recroviral/portfolio",
    "Update": "true"
  },
  "Ports": [
    {
      "ContainerPort": "5000"
    }
  ],
  "Logging": "/var/log/nginx"
}
```

The file should be pretty self-explanatory, but you can always reference the official documentation for more information. We provide the name of the image that EB should use along with a port that the container should open.

Hopefully by now, our instance should be ready. Head over to the EB page and you should see a green tick indicating that your app is alive and kicking.

### EB deploy

Go ahead and open the URL in your browser and you should see the application in all its glory.

Congratulations! You have deployed your first Docker application! 



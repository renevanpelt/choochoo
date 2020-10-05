# Choo choo!

Choo is a ruby application framework that uses CQRS and event sourcing to manage the state of your application data.

This framework is still being developed, as soon as basic structure is decided upon and a stable version is ready, we'll start using correct version numbers.


## The idea

A basic Choo app has 2 databases, one for the event log and one for storing the current state of the application data.

Where in Ruby on Rails you would define a model, in Choo you define resources. You define resources and corresponding commands and events to update a resource instance's state.



## Getting started

Considering you have ruby installed on your machine, run:

```
$ choo new [application_name]
$ cd [application_name]
$ bundle

# for example:

$ choo new demo_blog
$ choo cd demo_blog
$ bundle

```

Now you are in your choo application folder. To run the development server, run:

```
$ choo server -p 9292

# shorthand: 

$ choo s
```

Navigate to `localhost:9292/admin` to see the automatically generated admin interface.

The next step is to generate the files and folders for an application resource. You can do this using the following command:

```
$ choo generate resource [resource_name] [field_1_name]:[field_1_type] [field_2_name]:[field_2_type] ... [field_n_name]:[field_n_type]

# example with shorthand: 

$ choo g resource posts title:string body:string
```

Your terminal will tell you which folders and files are created. Restart your server using:

```
$ choo s
```

And navigate to `localhost:9292/admin` and click the resources button in the sidebar, then click on the posts resource you just created. On the next screen you will see the commands and events related to the posts resource. Clicking on a command name allows you to try out the command by passing the payload parameters in the automatically generated form on the page.

After you have run some commands, you will see the events on the event log in detail. You will also see the current state of all created posts when you click resources > posts.

## Design goals

- Providing clear visual insight to an application's codebase
- Deployment is part of the framework design. State is a no-go. Deploying to either a serverless PaaS or any ubuntu VPS should be an arbitrary job.
- The framework should provide 'rails' for connecting the application backend to a javascript front-end, for example by providing POJO's to interact with read models and perform commands (like meteor js?)

## To do

- Specify gem versions in the gemspec
- Implement database migrations like in RoR
- A lot more
# Intro to Airflow
## WTF is Airflow

"Airflow is a platform to programmaticaly author, schedule and monitor data pipelines". Airflow was open-sourced by Airbnb and is now an Apache project. It's quickly becoming a popular tool for ETL and similar jobs/pipelines.

Note: the document below is intended for a relatively technical audience and is written from a Unix perspective since Airflow doesn't currently work on Windows

## Reasons to use to Airflow

"Technical":   

- Handles jobs with complex logical flow and/or dependenices and automatically creates directed acyclic graphs (DAG) of pipeline tasks
- Handles jobs with a mix of different types of tasks (e.g., The job mixes `python`, `bash`, and `sql` tasks)
- Automatically configured to store logs in a database. Logas are also easily searchable/auditable
- Schedules jobs similar to `cron` (but using a web UI) 
- Has the option to distribute jobs across multiple workers   
- Google offers a managed/serverless verison of Airflow called "Cloud Composer" which takes a lot of the work out of setup/management   
- Capable of tracking/visualizing many configured jobs 

"Business":    

- Airflow code is relatively easy-to-read and requires little if any `python` background to understand   
- Web UI allows both technical and non-technical users the following tools:    
   a. Visualize DAG for understanding pipeline task dependencies   
   b. Start/stop non-scheduled jobs  
   c. Monitor pipeline task status, restart tasks, investigate task failures  
   d. Manage Airflow configuration (e.g., database connections, global variables)   
   e. Manage users    


## Reasons to consider not using Airflow

Airflow is a relatively heavy-duty tool and time is required to understand the system and properly configure the tool. To put this in perspective, most Airflow blog posts are authored by large companies running a lot of complex batch jobs (Airbnb, Twitter, Quizlet, etc.). A few things I would consider before configuring and deploying Airflow:

- Airflow doesn't run on Windows (as far as I can tell)
- If the job/pipeline has a mix of tasks but has totally linear dependencies, I would consider writing a `bash` script instead
- If the job/pipeline has relatively few types of tasks but has relatively complex logical flow, I would maybe consider wirting a `python` script instead
- If the job/pipeline must be scheduled but doesn't need strict monitoring or visualization, I would consider using `cron`
- If the Web UI would not be useful for the user group involved, a simpler tool might work better    
- If the intended use-case is to monitor relatively few jobs, a simpler tool might work better


## Example Airflow Pipeline (for a consulting project)

COMING SOON

## Links

[Quizlet blog post about pros/cons of airflow](https://medium.com/@dustinstansbury/how-quizlet-uses-apache-airflow-in-practice-a903cbb5626d)

[How twitter uses Airflow (complex)](https://blog.twitter.com/engineering/en_us/topics/insights/2018/ml-workflows.html)

[Airflow setup instructions and how to write custom integrations](http://michal.karzynski.pl/blog/2017/03/19/developing-workflows-with-apache-airflow/)

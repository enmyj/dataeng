Steps to set up Airflow:
```bash
pip install apache-airflow
airflow initdb
airflow variables -s sql_path /Users/ian.myjer/airflow/sql/
```
I typically use the Web interface to add databae connections but I'm sure there's a CLI way to do it

Steps to make Airflow Run:
```bash
airflow webserver -p 8080
airflow scheduler
```

Steps to run DAG:
```bash
run `python ~/airflow/dags/dag.py` and make sure there are no errors
# Go into Airflow web UI and turn on the dag
run `airflow trigger_dag dag` # or run from the web UI
```
Make sure whatever was supposed to happen did happen

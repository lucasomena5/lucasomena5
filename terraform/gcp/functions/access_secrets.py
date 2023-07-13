import sqlalchemy
import pandas as pd
import pymysql
from sqlalchemy import create_engine
import os
import hashlib
from google.cloud import secretmanager
# It is mandatory to create the Secret Manager Client
client = secretmanager.SecretManagerServiceClient()
# Build the resource name of the secret version
name_var = f"projects/<project-id>/secrets/db_name/versions/latest"  #TODO DB Name Secret and Project ID
user_var = f"projects/<project-id>/secrets/db_user/versions/latest"  #TODO DB Username Secret and Project ID
pwd_var = f"projects/<project-id>/secrets/db_pwd/versions/latest"    #TODO DB Password Secret and Project ID
# Access the secret version
name_response = client.access_secret_version(name=name_var)
user_response = client.access_secret_version(name=user_var)
pwd_response = client.access_secret_version(name=pwd_var)

# Access the secret material
name = name_response.payload.data.decode("UTF-8")
user = user_response.payload.data.decode("UTF-8")
password = pwd_response.payload.data.decode("UTF-8")

connection_name = "<project-id>:us-central1:<whizlabs-instance>"  #TODO

# If your database is MySQL, uncomment the following two lines:
driver_name = 'mysql+pymysql'
query_string = dict({"unix_socket": "/cloudsql/{}".format(connection_name)})
def access_secrets(request):
    # creating connection with DB instance
    db = sqlalchemy.create_engine(
      sqlalchemy.engine.url.URL(
        drivername=driver_name,
        username=user,
        password=password,
        database=name,
        query=query_string,
      ),
      pool_size=5,
      max_overflow=2,
      pool_timeout=30,
      pool_recycle=1800
    )
    try:
        with db.connect() as conn:
            create = "CREATE TABLE if not exists user_details (id INT NOT NULL AUTO_INCREMENT, username                      VARCHAR(255),email VARCHAR(255), age INT, PRIMARY KEY(id))"
            conn.execute(create)
            #for row in temp.itertuples():
            stmt = 'INSERT INTO user_details (id,username,email,age) VALUES (1,"martha","martha@whizlabs.com",25)'
            #stmt = stmt.format(id=row.id,username=row.username,email=row.email,age=row.age)
            conn.execute(stmt)
    except Exception as e:
        return 'Error: {}'.format(str(e))
    return 'okk'
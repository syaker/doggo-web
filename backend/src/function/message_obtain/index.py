import json
import pymysql
import datetime
from pymysql.err import IntegrityError

# parametro de conexión RDS
rds_host = "doggodb.c9tbszia7mni.eu-west-1.rds.amazonaws.com"
db_user = "admin"
db_password = "c6*fjC(b[A5jaZk?9~Iut>P:wR.D"
db_name = "doggodb"


def handler(event, context):
    connection = pymysql.connect(
        host=rds_host, user=db_user, password=db_password, database=db_name
    )

    try:
        with connection.cursor(pymysql.cursors.DictCursor) as cursor:
            cursor.execute("SELECT * FROM messages;")
            results = cursor.fetchall()

            for row in results:
                if "created_at" in row and isinstance(
                    row["created_at"], datetime.datetime
                ):
                    row["created_at"] = row["created_at"].strftime("%Y-%m-%d %H:%M:%S")

        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps(results),
        }

    except Exception as e:
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}

    finally:
        connection.close()

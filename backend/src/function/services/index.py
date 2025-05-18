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
    http_method = event.get("httpMethod", "")

    if http_method == "GET":
        try:
            connection = pymysql.connect(
                host=rds_host,
                user=db_user,
                password=db_password,
                database=db_name,
                cursorclass=pymysql.cursors.DictCursor,
            )

            with connection.cursor() as cursor:
                sql = "SELECT id, title, price, sitter_id, created_at FROM services"
                cursor.execute(sql)
                result = cursor.fetchall()

            return {
                "statusCode": 200,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps(result, default=str),
            }

        except Exception as e:
            return {"statusCode": 500, "body": json.dumps({"error": str(e)})}

    else:
        return {
            "statusCode": 405,
            "body": json.dumps({"message": f"Method {http_method} not allowed"}),
        }

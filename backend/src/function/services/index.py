import json
import pymysql
import datetime
from pymysql.err import IntegrityError

# Parámetros de conexión a la base de datos
rds_host = "doggodb.c9tbszia7mni.eu-west-1.rds.amazonaws.com"
db_user = "admin"
db_password = "c6*fjC(b[A5jaZk?9~Iut>P:wR.D"
db_name = "doggodb"

CORS_HEADERS = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "OPTIONS,GET",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
}

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
                "headers": {"Content-Type": "application/json", **CORS_HEADERS},
                "body": json.dumps(result, default=str),
            }

        except Exception as e:
            return {
                "statusCode": 500,
                "headers": CORS_HEADERS,
                "body": json.dumps({"error": str(e)}),
            }

    else:
        return {
            "statusCode": 405,
            "headers": CORS_HEADERS,
            "body": json.dumps({"message": f"Method {http_method} not allowed"}),
        }

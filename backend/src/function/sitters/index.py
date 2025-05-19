import json
import pymysql
import datetime

# parametro de conexión RDS
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
    try:
        connection = pymysql.connect(
            host=rds_host,
            user=db_user,
            password=db_password,
            db=db_name,
            cursorclass=pymysql.cursors.DictCursor,
        )

        with connection.cursor() as cursor:
            sql = "SELECT id, name, email, role, created_at FROM users WHERE role = %s"
            cursor.execute(sql, ("sitter",))
            sitters = cursor.fetchall()

        # convertir datetime a string
        for sitter in sitters:
            if isinstance(sitter.get("created_at"), datetime.datetime):
                sitter["created_at"] = sitter["created_at"].isoformat()

        return {
            "statusCode": 200,
            "headers": CORS_HEADERS,
            "body": json.dumps({"sitters": sitters}),
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": CORS_HEADERS,
            "body": json.dumps({"error": str(e)}),
        }

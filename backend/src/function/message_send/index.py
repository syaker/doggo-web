import json
import pymysql
import datetime

# parametro de conexión RDS
rds_host = "doggodb.c9tbszia7mni.eu-west-1.rds.amazonaws.com"
db_user = "admin"
db_password = "c6*fjC(b[A5jaZk?9~Iut>P:wR.D"
db_name = "doggodb"

def handler(event, context):
    try:
        data = json.loads(event["body"])

        content = data.get("content")
        sitter_id = data.get("sitter_id")
        client_id = data.get("client_id")

        # validar campos obligatorios
        if not all([content, sitter_id, client_id]):
            return {
                "statusCode": 400,
                "body": json.dumps(
                    {
                        "error": "Faltan campos obligatorios: content, sitter_id, client_id"
                    }
                ),
            }

        connection = pymysql.connect(
            host=rds_host,
            user=db_user,
            password=db_password,
            db=db_name,
            cursorclass=pymysql.cursors.DictCursor,
        )

        with connection.cursor() as cursor:
            sql = """
                INSERT INTO messages (content, sitter_id, client_id, created_at)
                VALUES (%s, %s, %s, %s)
            """
            created_at = datetime.datetime.utcnow().isoformat()

            cursor.execute(sql, (content, sitter_id, client_id, created_at))
            connection.commit()

            inserted_id = cursor.lastrowid

        return {
            "statusCode": 201,
            "body": json.dumps(
                {"message": "Mensaje enviado correctamente", "message_id": inserted_id}
            ),
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
        }

    except Exception as e:
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}

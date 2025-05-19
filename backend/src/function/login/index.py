import json
import pymysql
import bcrypt
import jwt
import datetime

# parametros conexión RDS
rds_host = "doggodb.c9tbszia7mni.eu-west-1.rds.amazonaws.com"
db_user = "admin"
db_password = "c6*fjC(b[A5jaZk?9~Iut>P:wR.D"
db_name = "doggodb"

SECRET_KEY = "3jI+eJg94dHhiD6skc7ZACFqXr7G/G/q/OVi7z9U9cNKeXrdFAV2m6vkr3msio5k"

CORS_HEADERS = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "OPTIONS,POST",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
}

def handler(event, context):
    try:
        data = json.loads(event["body"])

        email = data.get("email")
        password = data.get("password")

        if not all([email, password]):
            return {
                "statusCode": 400,
                "headers": CORS_HEADERS,
                "body": json.dumps({"error": "Faltan campos obligatorios"}),
            }

        connection = pymysql.connect(
            host=rds_host,
            user=db_user,
            password=db_password,
            db=db_name,
            cursorclass=pymysql.cursors.DictCursor,
        )

        with connection.cursor() as cursor:
            # Procedimiento almacenado para obtener hash y datos del usuario
            cursor.callproc("sp_get_password_hash", (email,))
            user = cursor.fetchone()

            if not user:
                return {
                    "statusCode": 404,
                    "headers": CORS_HEADERS,
                    "body": json.dumps({"error": "No existe el Usuario"}),
                }

            hashed_password = user["encrypted_password"].encode("utf-8")
            password_bytes = password.encode("utf-8")

            # Verificar contraseña con bcrypt
            if not bcrypt.checkpw(password_bytes, hashed_password):
                return {
                    "statusCode": 401,
                    "headers": CORS_HEADERS,  #
                    "body": json.dumps({"error": "Contraseña incorrecta"}),
                }

            # Generar token JWT
            payload = {
                "user_id": user["id"],
                "email": email,
                "role": user["role"],
                "exp": datetime.datetime.utcnow()
                + datetime.timedelta(hours=2),  # Expira en 2 horas
            }
            token = jwt.encode(payload, SECRET_KEY, algorithm="HS256")

        return {
            "statusCode": 200,
            "headers": CORS_HEADERS,
            "body": json.dumps({"success": "True", "token": token, "email": email}),
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": CORS_HEADERS,
            "body": json.dumps({"error": str(e)}),
        }

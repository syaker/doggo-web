import json
import pymysql
import datetime
import bcrypt
from pymysql.err import IntegrityError

# Parámetros de conexión RDS
rds_host = "doggodb.c9tbszia7mni.eu-west-1.rds.amazonaws.com"
db_user = "admin"
db_password = "c6*fjC(b[A5jaZk?9~Iut>P:wR.D"
db_name = "doggodb"

# Encabezados CORS mínimos
CORS_HEADERS = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "OPTIONS,POST",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
}


def handler(event, context):
    try:
        data = json.loads(event["body"])

        name = data.get("names") + " " + data.get("surnames")
        email = data.get("email")
        password = data.get("password")
        role = "user"
        created_at = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")

        if not all([name, email, password]):
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
            # Encriptar contraseña
            password_bytes = password.encode("utf-8")
            hashed = bcrypt.hashpw(password_bytes, bcrypt.gensalt())
            hashed_password = hashed.decode("utf-8")

            # Insertar nuevo usuario
            sql = """
            INSERT INTO users (name, email, encrypted_password, role, created_at)
            VALUES (%s, %s, %s, %s, %s)
            """
            try:
                cursor.execute(sql, (name, email, hashed_password, role, created_at))
                connection.commit()
            except IntegrityError as ie:
                if "Duplicate entry" in str(ie):
                    return {
                        "statusCode": 409,
                        "headers": CORS_HEADERS,
                        "body": json.dumps(
                            {"error": "El correo electrónico ya está registrado"}
                        ),
                    }
                else:
                    raise

        return {
            "statusCode": 201,
            "headers": CORS_HEADERS,
            "body": json.dumps({"message": "Registro exitoso"}),
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": CORS_HEADERS,
            "body": json.dumps({"error": str(e)}),
        }

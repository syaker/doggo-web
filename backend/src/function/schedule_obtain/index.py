import json
import pymysql

# parametro de conexión RDS
rds_host = "doggodb.c9tbszia7mni.eu-west-1.rds.amazonaws.com"
db_user = "admin"
db_password = "c6*fjC(b[A5jaZk?9~Iut>P:wR.D"
db_name = "doggodb"

def handler(event, context):
    try:
        # extraer sitterId de pathParameters
        sitter_id_raw = event.get("pathParameters", {}).get("sitterId")

        if not sitter_id_raw:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Falta parámetro sitterId"}),
            }

        try:
            sitter_id = int(sitter_id_raw)
        except ValueError:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "sitterId debe ser un número entero"}),
            }

        # conexión con la db
        connection = pymysql.connect(
            host=rds_host,
            user=db_user,
            password=db_password,
            db=db_name,
            cursorclass=pymysql.cursors.DictCursor,
        )

        with connection.cursor() as cursor:
            # obtener sitter_id, appointment_date y appointment_range
            sql = "SELECT sitter_id, appointment_date, appointment_range FROM schedulings WHERE sitter_id = %s"
            cursor.execute(sql, (sitter_id,))
            schedulings = cursor.fetchall()

        if not schedulings:
            return {
                "statusCode": 404,
                "body": json.dumps({"error": "No se encontró agenda para el cuidador"}),
            }

        # devuelve los días disponibles y los rangos
        days_available = []

        for sched in schedulings:
            # extraer la fecha y el rango de la cita
            appointment_date = str(sched["appointment_date"])
            appointment_range = sched["appointment_range"]

            days_available.append(
                {
                    "appointment_date": appointment_date,
                    "appointment_range": appointment_range,
                }
            )

        return {
            "statusCode": 200,
            "body": json.dumps({"days_available": days_available}),
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }

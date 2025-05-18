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

        data = json.loads(event.get("body", "{}"))

        client_id_raw = data.get("client_id")
        appointment_date_str = data.get("appointment_date")
        appointment_range = data.get("appointment_range")

        if not all([client_id_raw, appointment_date_str, appointment_range]):
            return {
                "statusCode": 400,
                "body": json.dumps(
                    {
                        "error": "Faltan campos obligatorios: client_id, appointment_date, appointment_range"
                    }
                ),
            }

        try:
            client_id = int(client_id_raw)
        except ValueError:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "client_id debe ser un número entero"}),
            }

        try:
            appointment_date = datetime.datetime.strptime(
                appointment_date_str, "%Y-%m-%d"
            ).date()
        except ValueError:
            return {
                "statusCode": 400,
                "body": json.dumps(
                    {"error": "Formato inválido para appointment_date. Usa YYYY-MM-DD"}
                ),
            }

        # conexión db
        connection = pymysql.connect(
            host=rds_host,
            user=db_user,
            password=db_password,
            db=db_name,
            cursorclass=pymysql.cursors.DictCursor,
            autocommit=False,
        )

        try:
            with connection.cursor() as cursor:
                # consultar la disponibilidad del cuidador
                cursor.execute(
                    "SELECT appointment_date, appointment_range FROM schedulings WHERE sitter_id = %s",
                    (sitter_id,),
                )
                schedulings = cursor.fetchall()

                if not schedulings:
                    return {
                        "statusCode": 404,
                        "body": json.dumps(
                            {"error": "No se encontró agenda para el cuidador"}
                        ),
                    }

                # comprobar día y el rango están disponibles
                is_available = False
                for sched in schedulings:
                    if (
                        str(sched["appointment_date"]) == appointment_date_str
                        and sched["appointment_range"] == appointment_range
                    ):
                        is_available = True
                        break

                if not is_available:
                    return {
                        "statusCode": 400,
                        "body": json.dumps(
                            {"error": "El día o el rango solicitado no está disponible"}
                        ),
                    }

                # validar está disponible, bloquear ese rango de disponibilidad
                cursor.execute(
                    """
                    DELETE FROM schedulings
                    WHERE sitter_id = %s AND appointment_date = %s AND appointment_range = %s
                    """,
                    (sitter_id, appointment_date_str, appointment_range),
                )

                # insertar la cita en la tabla appointments
                cursor.execute(
                    """
                    INSERT INTO appointments (sitter_id, client_id, appointment_date, appointment_range, status, created_at)
                    VALUES (%s, %s, %s, %s, 'Agendada', NOW())
                    """,
                    (sitter_id, client_id, appointment_date, appointment_range),
                )

                # confirmar la reserva
                connection.commit()

                return {
                    "statusCode": 201,
                    "body": json.dumps(
                        {
                            "message": "Cita agendada correctamente",
                            "appointment_date": appointment_date_str,
                            "appointment_range": appointment_range,
                        }
                    ),
                    "headers": {
                        "Content-Type": "application/json",
                        "Access-Control-Allow-Origin": "*",
                    },
                }

        finally:
            connection.close()

    except Exception as e:
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}

import json
from datetime import datetime
import pymysql

def handler(event, context):
    http_method = event.get('httpMethod')
    
    if not http_method:
        return {
            'statusCode': 400,
            'headers': {
                'Content-Type': 'application/json'
            },
            'body': json.dumps({
                'message': 'Bad Request: httpMethod is missing'
            })
        }
    
    if http_method == 'POST':
        try:
            body = json.loads(event['body'])
            email = body['email']
            password = body['password']
            
            # Connect to the RDS MySQL database
            connection = pymysql.connect(
                host='your-rds-endpoint',
                user='master',
                password='1XX4apk99*99',
                database='doggo'
            )
            
            with connection.cursor() as cursor:
                # Check if the user already exists
                cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
                user = cursor.fetchone()
                
                if user:
                    return {
                        'statusCode': 409,
                        'headers': {
                            'Content-Type': 'application/json'
                        },
                        'body': json.dumps({
                            'message': 'User already exists'
                        })
                    }
                
                # Insert the new user into the database
                cursor.execute("INSERT INTO users (email, password) VALUES (%s, %s)", (email, password))
                connection.commit()
            
            return {
                'statusCode': 201,
                'headers': {
                    'Content-Type': 'application/json'
                },
                'body': json.dumps({
                    'message': 'User registered successfully'
                })
            }
        except Exception as e:
            return {
                'statusCode': 500,
                'headers': {
                    'Content-Type': 'application/json'
                },
                'body': json.dumps({
                    'message': str(e)
                })
            }
        finally:
            connection.close()
    else:
        return {
            'statusCode': 405,
            'headers': {
                'Content-Type': 'application/json'
            },
            'body': json.dumps({
                'message': 'Method not allowed'
            })
        }
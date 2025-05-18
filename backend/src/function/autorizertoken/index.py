import json
import jwt
import os

# Clave secreta JWT
SECRET_KEY = os.getenv("JWT_SECRET_KEY", "3jI+eJg94dHhiD6skc7ZACFqXr7G/G/q/OVi7z9U9cNKeXrdFAV2m6vkr3msio5k")

def handler(event, context):
    try:
        # Obtener el token
        auth_token = event['authorizationToken']
        
        if not auth_token:
            print("Error: No authorization token provided")
            return generate_policy("user", "Deny", event.get("methodArn"), f"Unauthorized:  {event['headers']['Authorization2']} ")


        # Decodificar el token JWT
        user_details = decode_auth_token(auth_token, SECRET_KEY)


        # generar la política de autorización
        print('Authorized JWT Token')
        return generate_policy(user_details.get('user_id', 'user'), 'Allow', event['methodArn'], "Authorized: Valid JWT Token")

    except jwt.ExpiredSignatureError:
        print("Error: Token has expired")
        return generate_policy("user", "Deny", event.get("methodArn"), "Error: Token has expired")

    except jwt.InvalidTokenError:
        print("Error: Invalid token")
        return generate_policy("user", "Deny", event.get("methodArn"), "Error: Invalid JWT Token")

    except Exception as e:
        print(f"Lambda Error: {str(e)}")
        return generate_policy("user", "Deny", event.get("methodArn"), f"Lambda Error: {str(e)}")


def generate_policy(principal_id, effect, resource, message):
    """
    Genera una política de autorización que API Gateway utilizará para permitir o denegar el acceso.
    """
    authResponse = {
        'principalId': principal_id,
        'policyDocument': {
            'Version': '2012-10-17',
            'Statement': [{
                'Action': 'execute-api:Invoke',
                'Effect': effect,
                'Resource': resource
            }]
        },
        "context": {
            "errorMessage": message
        }
    }
    return authResponse

def decode_auth_token(auth_token: str, secret_key: str):
    """
    Decodifica el token JWT utilizando la clave secreta para verificar su firma.
    """
    auth_token = auth_token.replace('Bearer ', '')  # Eliminar "Bearer " del token

    # Decodificar el JWT (verificando la firma y la expiración)
    return jwt.decode(jwt=auth_token, key=secret_key, algorithms=["HS256"], options={"verify_signature": True, "verify_exp": True})


# Function for creating cleaner dynamic OpenAPI error responses
def get_error_response(status_code: int, entity) -> dict:
    
    default_response = {
        "description": "An unexpected error occurred",
        "content": {
            "application/json": {
                "example": {
                    "status_code": status_code,
                    "detail": f"An error occurred with status code {status_code}"
                }
            }
        }
    }
    
    openapi_responses = {
        200: {
            "description": "Item retrieved successfully",
            "content": {
                "application/json": {
                    "example": {
                        "status_code": 200,
                        "message": "OK",
                        "entity": entity
                    }
                }
            }
        },
        201: {
            "description": "Item created successfully",
            "content": {
                "application/json": {
                    "example": {
                        "status_code": 201,
                        "message": "Created",
                        "entity": entity
                    }
                }
            }
        },
        404: {
            "description": "Database Error: Item not found",
            "content": {
                "application/json": {
                    "example": {
                        "status_code": 404,
                        "message": "Not Found",
                        "entity": entity
                    }
                }
            }
        },
        409: {
            "description": "Integrity Error: Item already exists",
            "content": {
                "application/json": {
                    "example": {
                        "status_code": 409,
                        "message": "Already exists",
                        "entity": entity
                    }
                }
            }
        }
    }

    return openapi_responses.get(status_code, default_response)
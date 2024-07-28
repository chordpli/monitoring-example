from fastapi import APIRouter

router = APIRouter(prefix="/api/v1/test")


@router.get("/{id}")
async def get_test(id: int):
    return {
        "id": id,
        "body": "test"
    }
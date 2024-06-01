from drf_yasg import openapi


token=openapi.Parameter(
            name="access token",
            in_=openapi.IN_HEADER,
            type=openapi.TYPE_STRING,
            required=True,
            description="format --> JWT [access token]"
        )
from django.urls import path
from .views import RegisterView, MessageListCreateView
from rest_framework_simplejwt.views import TokenObtainPairView

urlpatterns = [
    path("register/", RegisterView.as_view(), name="register"),
    path("login/", TokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("messages/", MessageListCreateView.as_view(), name="messages"),
]

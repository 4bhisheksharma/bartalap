from rest_framework import generics, permissions
from .serializers import RegisterSerializer
from .models import Message
from rest_framework import serializers
from rest_framework.permissions import IsAuthenticated
from rest_framework.generics import ListCreateAPIView

class RegisterView(generics.CreateAPIView):
    serializer_class = RegisterSerializer
    permission_classes = (permissions.AllowAny,)

class MessageSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source="user.username", read_only=True)

    class Meta:
        model = Message
        fields = ("id", "username", "content", "timestamp")

class MessageListCreateView(ListCreateAPIView):
    serializer_class = MessageSerializer
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        return Message.objects.all().order_by("timestamp")

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


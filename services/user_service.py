from bottle import request
from models.user import UserModel, User, Admin
from typing import Any, cast

class UserService:
    def __init__(self):
        self.user_model = UserModel()

    def get_all(self):
        """Retorna todos os usuários."""
        return self.user_model.get_all()

    def save(self):
        """Cria um novo usuário comum com os dados do formulário."""
        # Para satisfazer Pyright, interpretamos forms como Any
        form = cast(Any, request.forms)

        # Calcula próximo ID
        last_id = max((u.id for u in self.user_model.get_all()), default=0)
        new_id = last_id + 1

        # Campos do formulário
        name = form.get('name')  # type: ignore
        email = form.get('email')  # type: ignore
        password = form.get('password')  # type: ignore
        birthdate = form.get('birthdate')  # type: ignore

        # Criação do usuário
        user = User(id=new_id, name=name, email=email, password=password, birthdate=birthdate)
        self.user_model.add_user(user)
        return user

    def get_by_id(self, user_id):
        """Busca usuário por ID."""
        return self.user_model.get_by_id(user_id)

    def edit_user(self, current_user, target_id=None):
        """Edita dados de um usuário.

        Se target_id for fornecido e current_user for Admin, edita outro usuário;
        caso contrário, edita o próprio usuário.
        """
        form = cast(Any, request.forms)

        # Busca usuário a ser editado
        if target_id and isinstance(current_user, Admin):
            user = self.user_model.get_by_id(target_id)
        else:
            user = self.user_model.get_by_id(current_user.id)

        if not user:
            raise ValueError("Usuário não encontrado.")

        # Novos dados (se formulário não fornecer, mantém valor atual)
        name = form.get('name') or user.name  # type: ignore
        email = form.get('email') or user.email  # type: ignore
        birthdate = form.get('birthdate') or user.birthdate  # type: ignore
        password = form.get('password') or user.password  # type: ignore

        updated = User(
            id=user.id,
            name=name,
            email=email,
            password=password,
            birthdate=birthdate
        )

        # Aplicação das regras de edição
        current_user.edit_user(updated, self.user_model)
        return updated

    def delete_user(self, current_user, target_id=None):
        """Deleta um usuário: próprio ou, se Admin, outro (passar target_id)."""
        if target_id and isinstance(current_user, Admin):
            current_user.delete_user(self.user_model, target_id)
        else:
            current_user.delete_user(self.user_model)

    def create_admin(self, current_user):
        """Permite a um Admin criar outro Admin."""
        if not isinstance(current_user, Admin):
            raise PermissionError("Somente Admin pode criar administradores.")

        form = cast(Any, request.forms)
        last_id = max((u.id for u in self.user_model.get_all()), default=0)
        new_id = last_id + 1

        name = form.get('name')  # type: ignore
        email = form.get('email')  # type: ignore
        password = form.get('password')  # type: ignore
        birthdate = form.get('birthdate')  # type: ignore

        new_admin = Admin(id=new_id, name=name, email=email, password=password, birthdate=birthdate)
        current_user.create_admin(new_admin, self.user_model)
        return new_admin

import json
import os
from dataclasses import dataclass, asdict
from typing import List

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')

class User:
    def __init__(self, id, name, email, password, birthdate):
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.birthdate = birthdate

    def __repr__(self):
        return (f"User(id={self.id}, name='{self.name}', "
                f"email='{self.email}', birthdate='{self.birthdate}')")

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'email': self.email,
            'password': self.password,
            'birthdate': self.birthdate
        }

    @classmethod
    def from_dict(cls, data):
        # Fornece valores padrão para campos faltantes
        return cls(
            id=data.get('id', 0),
            name=data.get('name', ''),
            email=data.get('email', ''),
            password=data.get('password', ''),
            birthdate=data.get('birthdate', '')
        )


class UserModel:
    FILE_PATH = os.path.join(DATA_DIR, 'users.json')

    def __init__(self):
        self.users = self._load()

    def _load(self):
        # Se o arquivo não existe, cria um arquivo vazio
        if not os.path.exists(self.FILE_PATH):
            with open(self.FILE_PATH, 'w') as f:
                json.dump([], f)
            return []
        
        try:
            with open(self.FILE_PATH, 'r', encoding='utf-8') as f:
                # Verifica se o arquivo está vazio
                content = f.read().strip()
                if not content:
                    return []
                
                data = json.loads(content)
                
                # Verifica se o JSON é uma lista
                if not isinstance(data, list):
                    print(f"Formato inválido em {self.FILE_PATH}. Deve ser uma lista.")
                    return []
                
                return [User.from_dict(item) for item in data]
                
        except json.JSONDecodeError as e:
            print(f"Erro ao decodificar JSON em {self.FILE_PATH}: {e}")
            return []
        except Exception as e:
            print(f"Erro inesperado ao carregar usuários: {e}")
            return []

    def _save(self):
        with open(self.FILE_PATH, 'w', encoding='utf-8') as f:
            json.dump([u.to_dict() for u in self.users], f, indent=4, ensure_ascii=False)


    def get_all(self):
        return self.users


    def get_by_id(self, user_id: int):
        return next((u for u in self.users if u.id == user_id), None)


    def add_user(self, user: User):
        self.users.append(user)
        self._save()


    def update_user(self, updated_user: User):

        existing_user = self.get_by_id(updated_user.id)
    
        if not existing_user:
            raise ValueError("Usuário não encontrado")
    
        if not updated_user.password:
            updated_user.password = existing_user.password
    
        for i, user in enumerate(self.users):
            if user.id == updated_user.id:
                self.users[i] = updated_user
                self._save()
            break

    def delete_user(self, user_id: int):
        self.users = [u for u in self.users if u.id != user_id]
        self._save()

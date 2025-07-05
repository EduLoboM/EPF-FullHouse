import json
import os

# Modelo de dados para listas de favoritos
DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')

class FavoriteList:
    def __init__(self, id, user_id, name, game_ids=None):
        self.id = id                   # Identificador único da lista
        self.user_id = user_id         # ID do usuário dono da lista
        self.name = name               # Nome descritivo da lista
        self.game_ids = game_ids or [] # Lista de IDs dos jogos favoritos

    def __repr__(self):
        return (f"FavoriteList(id={self.id}, user_id={self.user_id}, "
                f"name='{self.name}', game_ids={self.game_ids})")

    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'name': self.name,
            'game_ids': self.game_ids
        }

    @classmethod
    def from_dict(cls, data):
        return cls(
            id=data.get('id', 0),
            user_id=data.get('user_id', 0),
            name=data.get('name', ''),
            game_ids=data.get('game_ids', [])
        )

class FavoriteListModel:
    FILE_PATH = os.path.join(DATA_DIR, 'favorites.json')

    def __init__(self):
        self.lists = self._load()

    def _load(self):
        if not os.path.exists(self.FILE_PATH):
            with open(self.FILE_PATH, 'w', encoding='utf-8') as f:
                json.dump([], f)
            return []

        try:
            with open(self.FILE_PATH, 'r', encoding='utf-8') as f:
                content = f.read().strip()
                if not content:
                    return []
                data = json.loads(content)
                if not isinstance(data, list):
                    print(f"Formato inválido em {self.FILE_PATH}. Deve ser uma lista.")
                    return []
                return [FavoriteList.from_dict(item) for item in data]
        except json.JSONDecodeError as e:
            print(f"Erro ao decodificar JSON em {self.FILE_PATH}: {e}")
            return []
        except Exception as e:
            print(f"Erro inesperado ao carregar listas de favoritos: {e}")
            return []

    def _save(self):
        with open(self.FILE_PATH, 'w', encoding='utf-8') as f:
            json.dump([lst.to_dict() for lst in self.lists], f, indent=4, ensure_ascii=False)

    def _next_id(self):
        if not self.lists:
            return 1
        return max(lst.id for lst in self.lists) + 1

    def get_all(self):
        return self.lists

    def get_by_id(self, list_id: int):
        return next((lst for lst in self.lists if lst.id == list_id), None)

    def get_by_user(self, user_id: int):
        return [lst for lst in self.lists if lst.user_id == user_id]

    def create_default_list(self, user_id: int):
        """
        Cria a lista padrão 'Favoritos' vazia para o usuário, se ainda não existir.
        """
        existing = [lst for lst in self.lists if lst.user_id == user_id and lst.name == 'Favoritos']
        if existing:
            return existing[0]
        fav = FavoriteList(id=self._next_id(), user_id=user_id, name='Favoritos')
        self.lists.append(fav)
        self._save()
        return fav

    def create_list(self, user_id: int, name: str):
        """Cria uma nova lista de favoritos para um usuário."""
        fav = FavoriteList(id=self._next_id(), user_id=user_id, name=name)
        self.lists.append(fav)
        self._save()
        return fav

    def delete_list(self, list_id: int, user_id: int):
        """Deleta a lista se pertencer ao usuário."""
        lst = self.get_by_id(list_id)
        if not lst:
            raise ValueError("Lista não encontrada")
        if lst.user_id != user_id:
            raise PermissionError("Não autorizado a deletar lista de outro usuário.")
        self.lists = [l for l in self.lists if l.id != list_id]
        self._save()

    def add_game_to_list(self, list_id: int, game_id: int, user_id: int):
        """Adiciona um jogo à lista se pertencer ao usuário."""
        lst = self.get_by_id(list_id)
        if not lst:
            raise ValueError("Lista não encontrada")
        if lst.user_id != user_id:
            raise PermissionError("Não autorizado a modificar lista de outro usuário.")
        if game_id not in lst.game_ids:
            lst.game_ids.append(game_id)
            self._save()
        return lst

    def remove_game_from_list(self, list_id: int, game_id: int, user_id: int):
        """Remove um jogo da lista se pertencer ao usuário."""
        lst = self.get_by_id(list_id)
        if not lst:
            raise ValueError("Lista não encontrada")
        if lst.user_id != user_id:
            raise PermissionError("Não autorizado a modificar lista de outro usuário.")
        if game_id in lst.game_ids:
            lst.game_ids.remove(game_id)
            self._save()
        return lst

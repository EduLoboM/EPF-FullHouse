import json
import os

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')

class Review:
    def __init__(self, id, game_id, user_id, rating, text):
        self.id = id
        self.game_id = game_id
        self.user_id = user_id
        self.rating = rating
        self.text = text

    def __repr__(self):
        return (f"Review(id={self.id}, game_id={self.game_id}, user_id={self.user_id}, "
                f"rating={self.rating}, text='{self.text}')")

    def to_dict(self):
        return {
            'id': self.id,
            'game_id': self.game_id,
            'user_id': self.user_id,
            'rating': self.rating,
            'text': self.text
        }

    @classmethod
    def from_dict(cls, data):
        return cls(
            id=data.get('id', 0),
            game_id=data.get('game_id', 0),
            user_id=data.get('user_id', 0),
            rating=data.get('rating', 0),
            text=data.get('text', '')
        )

class ReviewModel:
    FILE_PATH = os.path.join(DATA_DIR, 'reviews.json')

    def __init__(self):
        self.reviews = self._load()

    def _load(self):
        # Cria arquivo vazio se não existir
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
                return [Review.from_dict(item) for item in data]
        except json.JSONDecodeError as e:
            print(f"Erro ao decodificar JSON em {self.FILE_PATH}: {e}")
            return []
        except Exception as e:
            print(f"Erro inesperado ao carregar reviews: {e}")
            return []

    def _save(self):
        with open(self.FILE_PATH, 'w', encoding='utf-8') as f:
            json.dump([r.to_dict() for r in self.reviews], f, indent=4, ensure_ascii=False)

    def get_all(self):
        return self.reviews

    def get_by_id(self, review_id: int):
        return next((r for r in self.reviews if r.id == review_id), None)

    def get_by_game_id(self, game_id: int):
        return [r for r in self.reviews if r.game_id == game_id]

    def get_by_user_id(self, user_id: int):
        return [r for r in self.reviews if r.user_id == user_id]

    def add_review(self, review: Review):
        self.reviews.append(review)
        self._save()

    def update_review(self, updated_review: Review):
        existing = self.get_by_id(updated_review.id)
        if not existing:
            raise ValueError("Review não encontrada")
        for i, r in enumerate(self.reviews):
            if r.id == updated_review.id:
                self.reviews[i] = updated_review
                self._save()
                return

    def delete_review(self, review_id: int):
        self.reviews = [r for r in self.reviews if r.id != review_id]
        self._save()

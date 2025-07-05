import os
from typing import Dict, Any

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')

class Game:
    def __init__(
        self,
        steam_id: str,
        name: str,
        description: str = "",
        release_date: str = "",
        price: str = "",
        poster_url: str = "",
        first_image_url: str = "",
        trailer_url: str = "",
        second_image_url: str = ""
    ):
        self.steam_id = steam_id
        self.name = name
        self.description = description
        self.release_date = release_date
        self.price = price
        # Novos atributos
        self.poster_url = poster_url
        self.first_image_url = first_image_url
        self.trailer_url = trailer_url
        self.second_image_url = second_image_url

    def to_dict(self) -> Dict[str, Any]:
        return {
            'steam_id': self.steam_id,
            'name': self.name,
            'description': self.description,
            'release_date': self.release_date,
            'price': self.price,
            'poster_url': self.poster_url,
            'first_image_url': self.first_image_url,
            'trailer_url': self.trailer_url,
            'second_image_url': self.second_image_url
        }

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> 'Game':
        return cls(
            steam_id=data.get('steam_id', ''),
            name=data.get('name', ''),
            description=data.get('description', ''),
            release_date=data.get('release_date', ''),
            price=data.get('price', ''),
            poster_url=data.get('poster_url', ''),
            first_image_url=data.get('first_image_url', ''),
            trailer_url=data.get('trailer_url', ''),
            second_image_url=data.get('second_image_url', '')
        )

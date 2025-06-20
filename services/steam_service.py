import sys
import os
import requests
from typing import Optional

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, PROJECT_ROOT)

from models.game import Game  # Importe sua classe Game

STEAM_API_KEY = '5F6D18612C18FD88C024A778365AAFA5'
STEAM_API_BASE_URL = 'https://store.steampowered.com/api'

class SteamService:
    def __init__(self, api_key: str = STEAM_API_KEY):
        self.api_key = api_key
        self.base_url = "https://store.steampowered.com/api/appdetails"

    def get_game_details(self, steam_id: str) -> Optional[Game]:
        try:
            params = {'appids': steam_id, 'l': 'pt', 'cc': 'br'}
            response = requests.get(self.base_url, params=params)
            response.raise_for_status()
            
            data = response.json()
            game_data = data.get(str(steam_id), {}).get('data', {})
            
            screenshots = game_data.get('screenshots', [])
            movies = game_data.get('movies', [])
            
            return Game(
                steam_id=steam_id,
                name=game_data.get('name', ''),
                description=game_data.get('detailed_description', ''),
                release_date=game_data.get('release_date', {}).get('date', ''),
                price=game_data.get('price_overview', {}).get('final_formatted', 'Gratuito'),
                poster_url=game_data.get('header_image', ''),
                first_image_url=screenshots[0].get('path_full') if screenshots else '',
                trailer_url=movies[0].get('mp4', {}).get('max') if movies else '',
                second_image_url=screenshots[1].get('path_full') if len(screenshots) > 1 else ''
            )
        except (requests.RequestException, KeyError, ValueError):
            return None
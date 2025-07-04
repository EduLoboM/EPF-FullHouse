from bottle import static_file
import sys
import os
import requests
from typing import Optional

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, PROJECT_ROOT)

class BaseController:
    def __init__(self, app):
        self.app = app
        self._setup_base_routes()

    def _setup_base_routes(self):
        """Configura rotas básicas comuns a todos os controllers"""
        self.app.route('/', method='GET', callback=self.home_redirect)
        self.app.route('/helper', method=['GET'], callback=self.helper)
        self.app.route('/test-game', method=['GET'], callback=self.test_game)
        self.app.route('/game/<steam_id:int>', method=['GET'], callback=self.game_details)
        self.app.route('/static/<filename:path>', callback=self.serve_static)

    def home_redirect(self):
        """Redireciona a rota raiz para /users"""
        return self.redirect('/users')

    def helper(self):
        return self.render('helper-final')

    def serve_static(self, filename):
        """Serve arquivos estáticos da pasta static/"""
        return static_file(filename, root='./static')

    def render(self, template, **context):
        """Método auxiliar para renderizar templates"""
        from bottle import template as render_template
        return render_template(template, **context)

    def redirect(self, path):
        """Método auxiliar para redirecionamento"""
        from bottle import redirect as bottle_redirect
        return bottle_redirect(path)

    def test_game(self):
        """Página de teste para verificar a integração com a API Steam"""
        from services.steam_service import SteamService
        steam_service = SteamService()

        test_ids = ["730", "570", "1102930", "1973530", "2357570", "2767030"]
        games = []

        for steam_id in test_ids:
            game = steam_service.get_game_details(steam_id)
            if game:
                games.append(game)  # Mantém como objeto Game, não dicionário
        return self.render('game_test', games=games)

    def game_details(self, steam_id):
        """Página de detalhes de um jogo específico"""
        try:
            from services.steam_service import SteamService
            steam_service = SteamService()

            # Buscar detalhes completos do jogo
            game = steam_service.get_game_details(steam_id)

            if game:
                return self.render('game_details', game=game)
            else:
                return self.render('error', message="Jogo não encontrado", error_code=404)

        except Exception as e:
            print(f"Erro ao carregar detalhes do jogo {steam_id}: {str(e)}")
            return self.render('error', message=f"Erro ao carregar detalhes do jogo: {str(e)}", error_code=500)

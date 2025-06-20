from bottle import static_file

class BaseController:
    def __init__(self, app):
        self.app = app
        self._setup_base_routes()

    def _setup_base_routes(self):
        """Configura rotas básicas comuns a todos os controllers"""
        self.app.route('/', method='GET', callback=self.home_redirect)
        self.app.route('/helper', method=['GET'], callback=self.helper)
        self.app.route('/test-game', method=['GET'], callback=self.test_game)
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
        from .steam_service import SteamService
        steam_service = SteamService()
    
        test_ids = ["730", "570", "1849000"]
        games = []
    
        for steam_id in test_ids:
            game = steam_service.get_game_details(steam_id)
            if game:
                games.append(game)  # Mantém como objeto Game, não dicionário
        return self.render('game_test', games=games)

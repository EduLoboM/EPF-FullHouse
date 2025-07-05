from bottle import static_file, request, response, redirect, abort
import sys
import os
import uuid
from datetime import datetime

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, PROJECT_ROOT)

# Importar as classes de usuário
from models.user import User, Admin, UserModel

class BaseController:
    def __init__(self, app):
        self.app = app
        self.user_model = UserModel()  # Modelo de usuário com persistência
        self.sessions = {}  # Sessões ativas
        self._setup_base_routes()

    def _setup_base_routes(self):
        """Configura rotas básicas comuns a todos os controllers"""
        # Rotas de autenticação (não precisam de login)
        self.app.route('/login', method='GET', callback=self.login_form)
        self.app.route('/login', method='POST', callback=self.login)
        self.app.route('/signup', method='GET', callback=self.signup_form)
        self.app.route('/signup', method='POST', callback=self.signup)
        self.app.route('/logout', method='GET', callback=self.logout)

        # Rotas protegidas (precisam de login)
        self.app.route('/', method='GET', callback=self.require_login(self.home_redirect))
        self.app.route('/helper', method=['GET'], callback=self.require_login(self.helper))
        self.app.route('/test-game', method=['GET'], callback=self.require_login(self.test_game))
        self.app.route('/game/<steam_id:int>', method=['GET'], callback=self.require_login(self.game_details))
        self.app.route('/game/<steam_id:int>/review', method=['GET'], callback=self.require_login(self.game_review))

        # Arquivos estáticos (não precisam de login)
        self.app.route('/static/<filename:path>', callback=self.serve_static)
        self.app.route('/css/<filename:path>', callback=self.serve_css)

    def get_session(self):
        """Pega a sessão atual baseada no cookie"""
        session_id = request.get_cookie('session_id')
        if session_id and session_id in self.sessions:
            return self.sessions[session_id]
        return None

    def create_session(self, user_data):
        """Cria uma nova sessão para o usuário"""
        session_id = str(uuid.uuid4())
        self.sessions[session_id] = user_data
        response.set_cookie('session_id', session_id, max_age=3600*24)  # 24 horas
        return session_id

    def require_login(self, func):
        """Decorator para rotas que precisam de autenticação"""
        def wrapper(*args, **kwargs):
            session = self.get_session()
            if not session:
                return redirect('/login')
            return func(*args, **kwargs)
        return wrapper

    def get_next_user_id(self):
        """Gera o próximo ID de usuário"""
        users = self.user_model.get_all()
        if not users:
            return 1
        return max(user.id for user in users) + 1

    def find_user_by_email(self, email):
        """Busca usuário por email"""
        users = self.user_model.get_all()
        return next((user for user in users if user.email == email), None)

    def validate_email(self, email):
        """Validação básica de email"""
        return '@' in email and '.' in email

    def validate_password(self, password):
        """Validação básica de senha"""
        return len(password) >= 3  # Mínimo 3 caracteres

    # Rotas de autenticação
    def login_form(self):
        """Exibe formulário de login"""
        return self.render('login', erro=None)

    def login(self):
        """Processa login do usuário"""
        email = getattr(request.forms, 'email', '')
        password = getattr(request.forms, 'password', '')

        if not email or not password:
            return self.render('login', erro="Email e senha são obrigatórios")

        # Buscar usuário por email
        user = self.find_user_by_email(email)
        if user and user.password == password:  # Comparação direta sem hash
            # Cria sessão
            session_data = {
                'id': user.id,
                'email': user.email,
                'name': user.name,
                'birthdate': user.birthdate,
                'is_admin': isinstance(user, Admin)
            }
            self.create_session(session_data)
            return redirect('/test-game')

        return self.render('login', erro="Email ou senha incorretos")

    def signup_form(self):
        """Exibe formulário de cadastro"""
        return self.render('signup', erro=None)

    def signup(self):
        """Processa cadastro do usuário"""
        name = getattr(request.forms, 'name', '')
        email = getattr(request.forms, 'email', '')
        birthdate = getattr(request.forms, 'birthdate', '')
        password = getattr(request.forms, 'password', '')
        confirm_password = getattr(request.forms, 'confirm_password', '')

        # Validações
        if not all([name, email, birthdate, password, confirm_password]):
            return self.render('signup', erro="Todos os campos são obrigatórios")

        if not self.validate_email(email):
            return self.render('signup', erro="Email inválido")

        if not self.validate_password(password):
            return self.render('signup', erro="Senha deve ter pelo menos 3 caracteres")

        if password != confirm_password:
            return self.render('signup', erro="Senhas não coincidem")

        # Verificar se email já existe
        if self.find_user_by_email(email):
            return self.render('signup', erro="Email já está em uso")

        # Criar usuário
        user_id = self.get_next_user_id()
        new_user = User(
            id=user_id,
            name=name,
            email=email,
            password=password,  # Senha salva em texto plano
            birthdate=birthdate
        )

        # Salvar usuário
        self.user_model.add_user(new_user)

        # Criar sessão automaticamente
        session_data = {
            'id': user_id,
            'email': email,
            'name': name,
            'birthdate': birthdate,
            'is_admin': False
        }
        self.create_session(session_data)

        return redirect('/test-game')

    def logout(self):
        """Faz logout do usuário"""
        session_id = request.get_cookie('session_id')
        if session_id and session_id in self.sessions:
            del self.sessions[session_id]
        response.delete_cookie('session_id')
        return redirect('/login')

    # Rotas originais (agora protegidas)
    def home_redirect(self):
        """Redireciona a rota raiz para /test-game"""
        return redirect('/test-game')

    def helper(self):
        session = self.get_session()
        return self.render('helper-final', user=session)

    def test_game(self):
        """Página de teste para verificar a integração com a API Steam"""
        session = self.get_session()
        from services.steam_service import SteamService
        steam_service = SteamService()
        test_ids = ["730", "570", "1102930", "1973530", "2357570", "2767030"]
        games = []
        for steam_id in test_ids:
            game = steam_service.get_game_details(steam_id)
            if game:
                games.append(game)
        return self.render('game_test', games=games, user=session)

    def game_details(self, steam_id):
        """Página de detalhes de um jogo específico"""
        session = self.get_session()
        try:
            from services.steam_service import SteamService
            steam_service = SteamService()
            game = steam_service.get_game_details(steam_id)
            if game:
                return self.render('game_details', game=game, user=session)
            else:
                return self.render('error', message="Jogo não encontrado", error_code=404, user=session)
        except Exception as e:
            print(f"Erro ao carregar detalhes do jogo {steam_id}: {str(e)}")
            return self.render('error', message=f"Erro ao carregar detalhes do jogo: {str(e)}", error_code=500, user=session)

    def game_review(self, steam_id):
        """Página para escrever review de um jogo específico"""
        session = self.get_session()
        try:
            from services.steam_service import SteamService
            steam_service = SteamService()
            game = steam_service.get_game_details(steam_id)
            if game:
                return self.render('review_template', game=game, user=session)
            else:
                return self.render('error', message="Jogo não encontrado", error_code=404, user=session)
        except Exception as e:
            print(f"Erro ao carregar página de review do jogo {steam_id}: {str(e)}")
            return self.render('error', message=f"Erro ao carregar página de review: {str(e)}", error_code=500, user=session)

    # Métodos auxiliares
    def serve_static(self, filename):
        """Serve arquivos estáticos da pasta static/"""
        return static_file(filename, root='./static')

    def serve_css(self, filename):
        """Serve arquivos CSS"""
        return static_file(filename, root='./static/css')

    def render(self, template, **context):
        """Método auxiliar para renderizar templates"""
        from bottle import template as render_template
        return render_template(template, **context)

    def redirect(self, path):
        """Método auxiliar para redirecionamento"""
        from bottle import redirect as bottle_redirect
        return bottle_redirect(path)

from bottle import static_file, request, response, redirect
import sys
import os
import uuid
import json
from typing import Optional, Any, cast, Dict, Any
from models.lista import FavoriteListModel
from services.steam_service import SteamService


PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, PROJECT_ROOT)

# Importar as classes de usuário e review
from models.user import User, Admin, UserModel
from models.review import Review, ReviewModel

class BaseController:
    def __init__(self, app):
        self.app = app
        self.user_model = UserModel()  # Modelo de usuário com persistência
        self.review_model = ReviewModel()  # Modelo de review com persistência
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
        # após as rotas de review...
        self.app.route('/game/<steam_id:int>/lista',
                       method='GET',
                       callback=self.require_login(self.list_lists))
        self.app.route('/game/<steam_id:int>/lista/criar',
                       method='POST',
                       callback=self.require_login(self.create_list_and_add))
        self.app.route('/game/<steam_id:int>/lista/<list_id:int>/adicionar',
                       method='POST',
                       callback=self.require_login(self.toggle_in_list))

        self.app.route('/game/<steam_id:int>/review', method=['GET'], callback=self.require_login(self.game_review))
        self.app.route('/profile', method=['GET'], callback=self.require_login(self.profile))

        self.app.route('/favorite/<steam_id:int>', method='POST',
                       callback=self.require_login(self.toggle_favorite))

        # Nova rota para salvar reviews
        self.app.route('/game/<steam_id:int>/review', method=['POST'], callback=self.require_login(self.save_review))

        # Rota para API de reviews (JSON)
        self.app.route('/api/reviews/<steam_id:int>', method=['GET'], callback=self.require_login(self.get_reviews_json))

        # Arquivos estáticos (não precisam de login)
        self.app.route('/static/<filename:path>', callback=self.serve_static)
        self.app.route('/css/<filename:path>', callback=self.serve_css)

    def get_session(self) -> Optional[Dict[str, Any]]:
        """Pega a sessão atual baseada no cookie"""
        session_id = request.get_cookie('session_id')
        if session_id and session_id in self.sessions:
            return self.sessions[session_id]
        return None

    def create_session(self, user_data: Dict[str, Any]) -> str:
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

    def get_next_user_id(self) -> int:
        """Gera o próximo ID de usuário"""
        users = self.user_model.get_all()
        if not users:
            return 1
        return max(user.id for user in users) + 1

    def get_next_review_id(self) -> int:
        """Gera o próximo ID de review"""
        reviews = self.review_model.get_all()
        if not reviews:
            return 1
        return max(review.id for review in reviews) + 1

    def find_user_by_email(self, email: str) -> Optional[User]:
        """Busca usuário por email"""
        users = self.user_model.get_all()
        return next((user for user in users if user.email == email), None)

    def validate_email(self, email: str) -> bool:
        """Validação básica de email"""
        return '@' in email and '.' in email

    def validate_password(self, password: str) -> bool:
        """Validação básica de senha"""
        return len(password) >= 3  # Mínimo 3 caracteres

    def safe_get_form_data(self, field_name: str, default: str = '') -> str:
        """Método auxiliar para acessar dados do formulário de forma segura"""
        try:
            # Em Bottle, request.forms é um FormsDict que permite acesso por atributo
            if hasattr(request.forms, field_name):
                value = getattr(request.forms, field_name)
                return value if value is not None else default
            return default
        except (AttributeError, KeyError):
            return default

    def safe_get_json_data(self) -> Optional[Dict[str, Any]]:
        """Método auxiliar para acessar dados JSON de forma segura"""
        try:
            # request.json pode ser None se não houver JSON válido
            json_data = request.json
            if json_data is None:
                return None
            # Converter para dict se necessário
            if isinstance(json_data, dict):
                return json_data
            return None
        except (AttributeError, ValueError, TypeError):
            return None

    # Rotas de autenticação
    def login_form(self):
        """Exibe formulário de login"""
        return self.render('login', erro=None)

    def login(self):
        """Processa login do usuário"""
        email = self.safe_get_form_data('email')
        password = self.safe_get_form_data('password')

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
        name = self.safe_get_form_data('name')
        email = self.safe_get_form_data('email')
        birthdate = self.safe_get_form_data('birthdate')
        password = self.safe_get_form_data('password')
        confirm_password = self.safe_get_form_data('confirm_password')

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
        fav_model = FavoriteListModel()
        fav_model.create_default_list(user_id)

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
        if not session:
            return redirect('/login')
        return self.render('helper-final', user=session)

    def test_game(self):
        """Página de teste para verificar a integração com a API Steam"""
        session = self.get_session()
        if not session:
            return redirect('/login')

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
        if not session:
            return redirect('/login')

        try:
            from services.steam_service import SteamService
            steam_service = SteamService()
            game = steam_service.get_game_details(steam_id)
            if game:
                # Buscar reviews do jogo
                reviews = self.review_model.get_by_game_id(steam_id)

                # Calcular estatísticas das reviews
                total_reviews = len(reviews)
                avg_rating = 0
                if total_reviews > 0:
                    avg_rating = sum(r.rating for r in reviews) / total_reviews

                return self.render('game_details',
                                 game=game,
                                 user=session,
                                 reviews=reviews,
                                 total_reviews=total_reviews,
                                 avg_rating=avg_rating)
            else:
                return self.render('error', message="Jogo não encontrado", error_code=404, user=session)
        except Exception as e:
            print(f"Erro ao carregar detalhes do jogo {steam_id}: {str(e)}")
            return self.render('error', message=f"Erro ao carregar detalhes do jogo: {str(e)}", error_code=500, user=session)

    def game_review(self, steam_id):
        """Página para escrever review de um jogo específico"""
        session = self.get_session()
        if not session:
            return redirect('/login')

        try:
            from services.steam_service import SteamService
            steam_service = SteamService()
            game = steam_service.get_game_details(steam_id)
            if game:
                # Verificar se o usuário já fez review deste jogo
                existing_review = None
                user_reviews = self.review_model.get_by_user_id(session['id'])
                for review in user_reviews:
                    if review.game_id == steam_id:
                        existing_review = review
                        break

                return self.render('review_template',
                                 game=game,
                                 user=session,
                                 existing_review=existing_review)
            else:
                return self.render('error', message="Jogo não encontrado", error_code=404, user=session)
        except Exception as e:
            print(f"Erro ao carregar página de review do jogo {steam_id}: {str(e)}")
            return self.render('error', message=f"Erro ao carregar página de review: {str(e)}", error_code=500, user=session)

    def save_review(self, steam_id):
        """Salva ou atualiza uma review"""
        session = self.get_session()
        if not session:
            return redirect('/login')

        try:
            rating = None
            text = ''

            # Verificar se é uma requisição JSON (AJAX)
            if request.content_type and 'application/json' in request.content_type:
                json_data = self.safe_get_json_data()
                if json_data:
                    rating = json_data.get('rating')
                    text = json_data.get('text', '')
            else:
                # Formulário HTML tradicional
                rating = self.safe_get_form_data('rating')
                text = self.safe_get_form_data('text')

            # Limpar texto
            text = text.strip() if text else ''

            # Validações
            if not rating or not str(rating).isdigit():
                response.status = 400
                return json.dumps({'error': 'Rating é obrigatório e deve ser um número'})

            rating = int(rating)
            if rating < 1 or rating > 4:
                response.status = 400
                return json.dumps({'error': 'Rating deve estar entre 1 e 4'})

            if len(text) > 500:
                response.status = 400
                return json.dumps({'error': 'Texto da review deve ter no máximo 500 caracteres'})

            # Verificar se já existe uma review do usuário para este jogo
            existing_review = None
            user_reviews = self.review_model.get_by_user_id(session['id'])
            for review in user_reviews:
                if review.game_id == steam_id:
                    existing_review = review
                    break

            if existing_review:
                # Atualizar review existente
                existing_review.rating = rating
                existing_review.text = text
                self.review_model.update_review(existing_review)
                message = 'Review atualizada com sucesso!'
            else:
                # Criar nova review
                review_id = self.get_next_review_id()
                new_review = Review(
                    id=review_id,
                    game_id=steam_id,
                    user_id=session['id'],
                    rating=rating,
                    text=text
                )
                self.review_model.add_review(new_review)
                message = 'Review salva com sucesso!'

            # Resposta JSON para AJAX
            if request.content_type and 'application/json' in request.content_type:
                response.content_type = 'application/json'
                return json.dumps({
                    'success': True,
                    'message': message,
                    'redirect': f'/game/{steam_id}'
                })
            else:
                # Redirecionamento para formulário HTML
                return redirect(f'/game/{steam_id}')

        except Exception as e:
            print(f"Erro ao salvar review: {str(e)}")
            response.status = 500

            if request.content_type and 'application/json' in request.content_type:
                return json.dumps({'error': f'Erro interno: {str(e)}'})
            else:
                return self.render('error', message=f"Erro ao salvar review: {str(e)}", error_code=500, user=session)

    def get_reviews_json(self, steam_id):
        """Retorna reviews em formato JSON"""
        try:
            reviews = self.review_model.get_by_game_id(steam_id)

            # Converter para formato mais amigável
            reviews_data = []
            for review in reviews:
                # Buscar dados do usuário
                user = next((u for u in self.user_model.get_all() if u.id == review.user_id), None)
                user_name = user.name if user else "Usuário Desconhecido"

                reviews_data.append({
                    'id': review.id,
                    'rating': review.rating,
                    'text': review.text,
                    'user_name': user_name,
                    'user_id': review.user_id
                })

            response.content_type = 'application/json'
            return json.dumps({
                'reviews': reviews_data,
                'total': len(reviews_data),
                'average_rating': sum(r['rating'] for r in reviews_data) / len(reviews_data) if reviews_data else 0
            })

        except Exception as e:
            print(f"Erro ao buscar reviews: {str(e)}")
            response.status = 500
            return json.dumps({'error': str(e)})

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

    def profile(self):
        """Página de perfil mostrando listas de favoritos e reviews do usuário."""
        # 1) Garante sessão válida
        session = self.get_session()
        if session is None:
            return redirect('/login')
        session = cast(Dict[str, Any], session)

        user_id = session['id']

        # 2) Pega as reviews do usuário
        reviews = self.review_model.get_by_user_id(user_id)

        # 3) Pega as listas de favoritos
        fav_model = FavoriteListModel()
        raw_lists = fav_model.get_by_user(user_id)

        steam = SteamService()
        favorite_lists = []
        for lst in raw_lists:
            games = [steam.get_game_details(gid) for gid in lst.game_ids]
            favorite_lists.append({
                'list': lst,
                'games': games
            })

        # 4) Renderiza template
        return self.render(
            'profile',
            user=session,
            favorite_lists=favorite_lists,
            reviews=reviews
        )

    def toggle_favorite(self, steam_id):
        """Adiciona ou remove o jogo da lista 'Favoritos' do usuário logado."""
        # 1) Garante sessão válida
        session = self.get_session()
        if session is None:
            return redirect('/login')
        # Assegura ao Pyright que session['id'] é um int
        user_id = int(session['id'])

        # 2) Puxa ou cria a lista padrão “Favoritos”
        from models.lista import FavoriteListModel
        fav_model = FavoriteListModel()
        fav_list = fav_model.create_default_list(user_id)

        # 3) Toggle: se já estiver, remove; caso contrário, adiciona
        if steam_id in fav_list.game_ids:
            fav_model.remove_game_from_list(fav_list.id, steam_id, user_id)
            action = 'removed'
        else:
            fav_model.add_game_to_list(fav_list.id, steam_id, user_id)
            action = 'added'

        # 4) Retorna JSON para o front indicar o novo estado
        response.content_type = 'application/json'
        return json.dumps({
            'status': 'ok',
            'action': action,
            'steam_id': steam_id
        })

    def list_lists(self, steam_id):
        session = self.get_session()
        if session is None:
            return redirect('/login')
        session = cast(Dict[str, Any], session)
        user_id = int(session['id'])           # ← define user_id

        # Busca detalhes do jogo
        steam = SteamService()
        game = steam.get_game_details(steam_id)
        if not game:
            return self.render('error', message="Jogo não encontrado", error_code=404, user=session)

        fav_model = FavoriteListModel()
        fav_model.create_default_list(user_id)

        raw = fav_model.get_by_user(user_id)
        user_lists = []
        for lst in raw:
            user_lists.append({
                'id': lst.id,
                'name': lst.name,
                'count': len(lst.game_ids),
                'has_game': steam_id in lst.game_ids
            })

        return self.render('lists', game=game, user=session, user_lists=user_lists)


    def create_list_and_add(self, steam_id):
        session = self.get_session()
        if session is None:
            return redirect('/login')
        session = cast(Dict[str, Any], session)
        user_id = int(session['id'])           # ← define user_id

        name = self.safe_get_form_data('name')
        fav_model = FavoriteListModel()
        new_list = fav_model.create_list(user_id, name)
        fav_model.add_game_to_list(new_list.id, steam_id, user_id)

        return redirect(f'/game/{steam_id}/lista')


    def toggle_in_list(self, steam_id, list_id):
        """Adiciona ou remove o jogo da lista, conforme presença atual."""
        session = self.get_session()
        if session is None:
            return redirect('/login')
        session = cast(Dict[str, Any], session)
        user_id = int(session['id'])

        fav_model = FavoriteListModel()
        lst = fav_model.get_by_id(list_id)
        if not lst or lst.user_id != user_id:
            return self.render('error', message="Lista não encontrada ou não autorizada", error_code=403, user=session)

        # Se já está na lista, remove; caso contrário, adiciona
        if steam_id in lst.game_ids:
            fav_model.remove_game_from_list(list_id, steam_id, user_id)
        else:
            fav_model.add_game_to_list(list_id, steam_id, user_id)

        return redirect(f'/game/{steam_id}/lista')

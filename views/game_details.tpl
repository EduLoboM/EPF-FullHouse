<!DOCTYPE html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{ game.name }} - Detalhes</title>
  <link rel="stylesheet" href="/static/css/game_details.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body style="--bg-image: url('{{ game.first_image_url }}')">
  <div class="container">
    <!-- Header com navegação -->
    <header class="header">
      <div class="nav-container">
        <img src="/static/img/FULL-removebg-preview_1.webp" alt="Full House Logo" class="full-house">
        <a href="/test-game" class="btn-back">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M19 12H5M12 19l-7-7 7-7"/>
          </svg>
          Voltar para jogos
        </a>
        <div class="header-actions">
          <button id="btn-favorite" class="btn-favorite" onclick="toggleFavorite({{game.steam_id}})">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
            </svg>
          </button>
          <button class="btn-share" onclick="shareGame()">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8M16 6l-4-4-4 4M12 2v13"/>
            </svg>
          </button>
        </div>
      </div>
    </header>

    <!-- Hero Section -->
    <section class="hero">
      <div class="hero-background">
        % if hasattr(game, 'background') and game.background:
        <img src="{{ game.background }}" alt="Background" class="bg-image">
        % elif hasattr(game, 'poster_url') and game.poster_url:
        <img src="{{ game.poster_url }}" alt="Background" class="bg-image">
        % end
        <div class="hero-overlay"></div>
      </div>

      <div class="hero-content">
        <div class="hero-main">
          <div class="game-poster">
            % if hasattr(game, 'poster_url') and game.poster_url:
            <img src="{{ game.poster_url }}" alt="{{ game.name }}" class="poster-image">
            % else:
            <div class="poster-placeholder">
              <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
                <circle cx="8.5" cy="8.5" r="1.5"/>
                <polyline points="21,15 16,10 5,21"/>
              </svg>
            </div>
            % end
          </div>

          <div class="game-info">
            <h1 class="game-title">{{ game.name }}</h1>

            <!-- Sistema de Avaliação com Naipes -->
            <div class="game-rating">
% # Converte média 1–4 para 0–10
% score = avg_rating * 2.5 if avg_rating else 0
% # Determina quantos naipes "cheios" (1 a 4)
% filled = int(score // 2.5) if score > 0 else 0
% if filled > 4:
%   filled = 4
% end
% # Ordem dos naipes: ouros, paus, copas, espadas
% suits = ['♦', '♣', '♥', '♠']

              <div class="rating-suits">
% for i in range(4):
%   if i < filled:
                <span class="suit filled">{{ suits[i] }}</span>
%   else:
                <span class="suit empty">{{ suits[i] }}</span>
%   end
% end
              </div>

              <div class="rating-info">
% if total_reviews > 0:
                <span class="rating-score">{{ '{:.1f}'.format(score) }}/10</span>
                <span class="rating-count">{{ total_reviews }} {{ 'avaliação' if total_reviews == 1 else 'avaliações' }}</span>
% else:
                <span class="rating-score">–/10</span>
                <span class="rating-count">Sem avaliações</span>
% end
              </div>
            </div>

            <div class="game-meta">
              <div class="meta-item">
                <span class="meta-label">Lançamento:</span>
                <span class="meta-value">{{ game.release_date }}</span>
              </div>
              % if hasattr(game, 'price') and game.price:
              <div class="meta-item">
                <span class="meta-label">Preço:</span>
                <span class="meta-value price">{{ game.price }}</span>
              </div>
              % end
            </div>

            <div class="action-buttons">
              <button class="btn-primary" onclick="window.location.href='/game/{{ game.steam_id }}/review'">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M21 12V7a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h7"/>
                  <path d="M16 16h6v6h-6z"/>
                  <path d="M19 19v.01"/>
                </svg>
                Escreva uma Review!
              </button>
              <button class="btn-secondary" onclick="window.location.href='/game/{{ game.steam_id }}/lista'">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                </svg>
                Adicione a uma Lista
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Media Section -->
    % if (hasattr(game, 'second_image_url') and game.second_image_url) or (hasattr(game, 'trailer_url') and game.trailer_url):
    <section class="media-section">
      <div class="section-header">
        <h2>Mídia</h2>
      </div>

      <div class="media-grid">
        % if hasattr(game, 'trailer_url') and game.trailer_url:
        <div class="media-item media-video-item">
          <div class="video-container">
            <video class="media-video" controls poster="{{game.poster_url if hasattr(game, 'poster_url') else ''}}">
              <source src="{{game.trailer_url}}" type="video/mp4">
              Seu navegador não suporta o elemento de vídeo.
            </video>
          </div>
        </div>
        % end

        % if hasattr(game, 'first_image_url') and game.first_image_url:
        <div class="media-item">
          <img src="{{game.first_image_url}}" alt="Screenshot 1" class="media-image" onclick="openFullscreen('{{game.first_image_url}}')">
        </div>
        % end

        % if hasattr(game, 'second_image_url') and game.second_image_url:
        <div class="media-item">
          <img src="{{game.second_image_url}}" alt="Screenshot 2" class="media-image" onclick="openFullscreen('{{game.second_image_url}}')">
        </div>
        % end
      </div>
    </section>
    % end

    <!-- Description Section -->
    % if hasattr(game, 'description') and game.description:
    <section class="description-section">
      <div class="section-header">
        <h2>Sobre este jogo</h2>
      </div>
      <div class="description-content">
        {{! game.description }}
      </div>
    </section>
    % end

  </div>

  <!-- Modal para imagem em tela cheia -->
  <div id="fullscreen-modal" class="modal" onclick="closeFullscreen()">
    <div class="modal-content">
      <span class="modal-close" onclick="closeFullscreen()">&times;</span>
      <img id="fullscreen-image" alt="Screenshot em tela cheia">
    </div>
  </div>

  <script>
    function openFullscreen(imageSrc) {
      const modal = document.getElementById('fullscreen-modal');
      modal.style.display = 'flex';
      document.getElementById('fullscreen-image').src = imageSrc;
      document.body.style.overflow = 'hidden';
    }

    function closeFullscreen() {
      const modal = document.getElementById('fullscreen-modal');
      modal.style.display = 'none';
      document.body.style.overflow = 'auto';
    }

    async function toggleFavorite(steamId) {
      const btn = document.getElementById('btn-favorite');
      try {
        const res = await fetch(`/favorite/${steamId}`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' }
        });
        const data = await res.json();
        if (data.status === 'ok') {
          // adiciona ou remove a class 'active' conforme a ação
          if (data.action === 'added') {
            btn.classList.add('active');
          } else {
            btn.classList.remove('active');
          }
        } else {
          console.error('Falha ao favoritar:', data);
        }
      } catch (err) {
        console.error('Erro de rede:', err);
      }
    }

    function shareGame() {
      if (navigator.share) {
        navigator.share({
          title: '{{ game.name }}',
          text: 'Confira {{ game.name }}',
          url: window.location.href
        });
      } else {
        navigator.clipboard.writeText(window.location.href);
        alert('Link copiado!');
      }
    }

    // Função para renderizar rating com naipes
    function renderRating(rating, totalReviews) {
      const suitsContainer = document.querySelector('.rating-suits');
      const ratingScore = document.querySelector('.rating-score');
      const ratingCount = document.querySelector('.rating-count');

      if (!suitsContainer || !ratingScore || !ratingCount) return;

      // Limpar naipes existentes
      suitsContainer.innerHTML = '';

      // Definir naipes do baralho na ordem: ouros, paus, copas, espadas
      const suits = ['♦', '♣', '♥', '♠'];

      // Calcular naipes preenchidos (cada naipe vale 2.5 pontos)
      const filledSuits = Math.min(4, Math.floor(rating / 2.5));

      // Renderizar naipes
      suits.forEach((suit, index) => {
        const suitElement = document.createElement('span');
        suitElement.className = 'suit';
        suitElement.textContent = suit;

        if (index < filledSuits) {
          suitElement.classList.add('filled');
        } else {
          suitElement.classList.add('empty');
        }

        suitsContainer.appendChild(suitElement);
      });

      // Atualizar informações
      ratingScore.textContent = `${rating.toFixed(1)}/10`;
      ratingCount.textContent = `${totalReviews} ${totalReviews === 1 ? 'avaliação' : 'avaliações'}`;
    }

    // Event listener para ESC key
    document.addEventListener('keydown', e => {
      if (e.key === 'Escape') closeFullscreen();
    });
  </script>
</body>
</html>

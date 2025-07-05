<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Review - {{ game.name if hasattr(game, 'name') else '' }}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="/static/css/review-styles.css">
</head>
<body style="--bg-image: url('{{ game.first_image_url if hasattr(game, 'first_image_url') else '' }}')">
  <div class="container">

    <!-- Header -->
    <header class="header">
      <div class="nav-container">
        <a href="/game/{{ game.steam_id if hasattr(game, 'steam_id') else '' }}" class="btn-back">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M19 12H5M12 19l-7-7 7-7"/>
          </svg>
          Voltar ao jogo
        </a>
        <div class="header-title">Escreva sua Review</div>
        <div class="header-actions">
          <button class="btn-favorite" onclick="toggleFavorite()">
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
              <div class="rating-suits">
                <span class="suit filled">♠</span>
                <span class="suit filled">♥</span>
                <span class="suit filled">♦</span>
                <span class="suit empty">♣</span>
              </div>
              <div class="rating-info">
                <span class="rating-score">8.5/10</span>
                <span class="rating-count">234 avaliações</span>
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
              <button type="button" class="btn-primary" id="submitReviewHero" disabled>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                  <polyline points="22,4 12,14.01 9,11.01"/>
                </svg>
                Publicar sua Review
              </button>
              <button type="button" class="btn-secondary" id="cancelReviewHero">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M18 6L6 18M6 6l12 12"/>
                </svg>
                Cancelar sua Review
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Review Form -->
    <section class="review-form">
      <div class="section-header">
        <h2>Sua Avaliação</h2>
      </div>

      <div class="rating-section">
        <div class="rating-stars">
          <button class="star" data-rating="1" title="1 estrela - Ruim">♠</button>
          <button class="star" data-rating="2" title="2 estrelas - Regular">♥</button>
          <button class="star" data-rating="3" title="3 estrelas - Bom">♦</button>
          <button class="star" data-rating="4" title="4 estrelas - Excelente">♣</button>
        </div>
        <p class="rating-text">Clique nos naipes para avaliar de 1 a 4 estrelas</p>
      </div>

      <div class="review-section">
        <div class="section-header">
          <h2>Comentário</h2>
        </div>
        <textarea id="reviewText" class="review-textarea" placeholder="Conte-nos o que você achou do jogo..." maxlength="500" rows="6"></textarea>
        <div class="char-count"><span id="charCount">0</span>/500 caracteres</div>
      </div>

      <!-- REMOVIDO: Botões de enviar e cancelar que estavam aqui -->
    </section>

    <!-- Review Preview -->
    <section class="review-preview" id="reviewPreview" style="display: none;">
      <div class="section-header">
        <h3>Preview da sua Review</h3>
      </div>
      <div class="preview-rating">
        <span class="preview-stars"></span>
        <span class="preview-rating-text"></span>
      </div>
      <div class="preview-text"></div>
    </section>

  </div>

  <script>
    // Extrair Steam ID
    const steamId = '{{ game.steam_id if hasattr(game, 'steam_id') else '' }}';

    let currentRating = 0;
    const stars = document.querySelectorAll('.star');
    const reviewText = document.getElementById('reviewText');
    const charCount = document.getElementById('charCount');
    const reviewPreview = document.getElementById('reviewPreview');
    const submitHeroBtn = document.getElementById('submitReviewHero');

    const suits = ['♠', '♥', '♦', '♣'];
    const suitNames = ['Ruim', 'Regular', 'Bom', 'Excelente'];

    function updateRating(rating) {
      currentRating = rating;
      stars.forEach((star, i) => {
        star.classList.toggle('selected', i < rating);
        star.classList.toggle('unselected', i >= rating);
      });

      // Atualizar botão no hero
      submitHeroBtn.disabled = rating === 0;

      updatePreview();
    }

    stars.forEach((star, idx) => star.addEventListener('click', () => updateRating(idx + 1)));

    reviewText.addEventListener('input', function() {
      charCount.textContent = this.value.length;
      updatePreview();
    });

    function updatePreview() {
      if (currentRating > 0 || reviewText.value.trim()) {
        reviewPreview.style.display = 'block';
        let starsHtml = Array(currentRating).fill().map((_, i) => suits[i]).join(' ');
        document.querySelector('.preview-stars').innerHTML = starsHtml;
        document.querySelector('.preview-rating-text').textContent = currentRating > 0
          ? `${currentRating}/4 estrelas - ${suitNames[currentRating-1]}`
          : 'Sem avaliação';
        document.querySelector('.preview-text').textContent = reviewText.value.trim() || 'Nenhum comentário escrito.';
      } else {
        reviewPreview.style.display = 'none';
      }
    }

    function submitReview() {
      if (!currentRating) {
        alert('Selecione uma avaliação!');
        return;
      }

      const reviewData = {
        steamId,
        rating: currentRating,
        text: reviewText.value.trim(),
        timestamp: new Date().toISOString()
      };

      // Desabilitar botão
      submitHeroBtn.textContent = 'Enviando...';
      submitHeroBtn.disabled = true;

      setTimeout(() => {
        alert(`Review enviada! ${currentRating}/4 (${suitNames[currentRating-1]})`);
        window.location.href = `/game/${steamId}`;
      }, 1000);
    }

    function cancelReview() {
      if (currentRating || reviewText.value.trim()) {
        if (confirm('Cancelar e perder o que foi escrito?')) {
          window.history.back();
        }
      } else {
        window.history.back();
      }
    }

    // Event listeners para os botões no hero
    document.getElementById('submitReviewHero').addEventListener('click', submitReview);
    document.getElementById('cancelReviewHero').addEventListener('click', cancelReview);

    function toggleFavorite() {
      document.querySelector('.btn-favorite').classList.toggle('active');
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

      // Limpar naipes existentes
      suitsContainer.innerHTML = '';

      // Definir naipes do baralho
      const suits = ['♠', '♥', '♦', '♣'];

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
      ratingCount.textContent = `${totalReviews} avaliações`;
    }

    // Inicializar preview
    updatePreview();
  </script>
</body>
</html>

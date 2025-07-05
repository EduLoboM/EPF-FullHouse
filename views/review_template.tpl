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
        <div class="header-title">
          % if existing_review:
          Editar sua Review
          % else:
          Escreva sua Review
          % end
        </div>
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
            <div class="game-rating" id="gameRating">
              <div class="rating-suits" id="ratingSuits">
                <span class="suit empty">♠</span>
                <span class="suit empty">♥</span>
                <span class="suit empty">♦</span>
                <span class="suit empty">♣</span>
              </div>
              <div class="rating-info">
                <span class="rating-score" id="ratingScore">-/10</span>
                <span class="rating-count" id="ratingCount">Carregando...</span>
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
                % if existing_review:
                Atualizar sua Review
                % else:
                Publicar sua Review
                % end
              </button>
              <button type="button" class="btn-secondary" id="cancelReviewHero">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M18 6L6 18M6 6l12 12"/>
                </svg>
                Cancelar
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
        % if existing_review:
        <p class="edit-notice">Editando sua review existente</p>
        % end
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
        <textarea id="reviewText" class="review-textarea" placeholder="Conte-nos o que você achou do jogo..." maxlength="500" rows="6">{{ existing_review.text if existing_review else '' }}</textarea>
        <div class="char-count"><span id="charCount">0</span>/500 caracteres</div>
      </div>
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

    <!-- Loading Overlay -->
    <div id="loadingOverlay" class="loading-overlay" style="display: none;">
      <div class="loading-spinner"></div>
      <p>Salvando sua review...</p>
    </div>

  </div>

  <script>
    // Extrair Steam ID e dados existentes
    const steamId = '{{ game.steam_id if hasattr(game, 'steam_id') else '' }}';
    const existingReview = {{ ('{"rating": ' + str(existing_review.rating) + ', "text": "' + (existing_review.text or '').replace('"', '\\"').replace('\n', '\\n') + '"}') if existing_review else 'null' }};

    let currentRating = 0;
    const stars = document.querySelectorAll('.star');
    const reviewText = document.getElementById('reviewText');
    const charCount = document.getElementById('charCount');
    const reviewPreview = document.getElementById('reviewPreview');
    const submitHeroBtn = document.getElementById('submitReviewHero');
    const loadingOverlay = document.getElementById('loadingOverlay');

    const suits = ['♠', '♥', '♦', '♣'];
    const suitNames = ['Ruim', 'Regular', 'Bom', 'Excelente'];

    // Inicializar com dados existentes se houver
    if (existingReview) {
      currentRating = existingReview.rating;
      reviewText.value = existingReview.text;
      updateRating(currentRating);
    }

    // Carregar rating atual do jogo
    async function loadGameRating() {
      try {
        const response = await fetch(`/api/reviews/${steamId}`);
        const data = await response.json();

        if (response.ok) {
          const avgRating = data.average_rating || 0;
          const totalReviews = data.total || 0;

          // Calcular rating em escala 0-10 (média * 2.5)
          const gameRating = avgRating * 2.5;

          // Atualizar display
          updateGameRatingDisplay(gameRating, totalReviews);
        }
      } catch (error) {
        console.error('Erro ao carregar rating:', error);
        document.getElementById('ratingScore').textContent = 'N/A';
        document.getElementById('ratingCount').textContent = 'Erro ao carregar';
      }
    }

    function updateGameRatingDisplay(rating, totalReviews) {
      const ratingSuits = document.getElementById('ratingSuits');
      const ratingScore = document.getElementById('ratingScore');
      const ratingCount = document.getElementById('ratingCount');

      // Limpar naipes existentes
      ratingSuits.innerHTML = '';

      // Calcular naipes preenchidos (cada naipe representa 2.5 pontos)
      const filledSuits = Math.floor(rating / 2.5);
      const partialSuit = (rating % 2.5) / 2.5; // Para futuras implementações de naipes parciais

      // Renderizar naipes
      suits.forEach((suit, index) => {
        const suitElement = document.createElement('span');
        suitElement.className = 'suit';
        suitElement.textContent = suit;

        if (index < filledSuits) {
          suitElement.classList.add('filled');
        } else if (index === filledSuits && partialSuit > 0.5) {
          // Naipe parcialmente preenchido (opcional)
          suitElement.classList.add('partial');
        } else {
          suitElement.classList.add('empty');
        }

        ratingSuits.appendChild(suitElement);
      });

      // Atualizar informações
      ratingScore.textContent = totalReviews > 0 ? `${rating.toFixed(1)}/10` : 'Sem avaliações';
      ratingCount.textContent = totalReviews === 1 ? '1 avaliação' : `${totalReviews} avaliações`;
    }

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

    async function submitReview() {
      if (!currentRating) {
        alert('Por favor, selecione uma avaliação!');
        return;
      }

      // Mostrar loading
      loadingOverlay.style.display = 'flex';
      submitHeroBtn.disabled = true;
      submitHeroBtn.textContent = 'Enviando...';

      try {
        const reviewData = {
          rating: currentRating,
          text: reviewText.value.trim()
        };

        const response = await fetch(`/game/${steamId}/review`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(reviewData)
        });

        const result = await response.json();

        if (response.ok && result.success) {
          // Sucesso
          alert(result.message || 'Review salva com sucesso!');
          window.location.href = result.redirect || `/game/${steamId}`;
        } else {
          // Erro do servidor
          throw new Error(result.error || 'Erro ao salvar review');
        }
      } catch (error) {
        console.error('Erro ao enviar review:', error);
        alert('Erro ao salvar review: ' + error.message);

        // Restaurar estado dos botões
        submitHeroBtn.disabled = false;
        submitHeroBtn.textContent = existingReview ? 'Atualizar sua Review' : 'Publicar sua Review';
      } finally {
        // Esconder loading
        loadingOverlay.style.display = 'none';
      }
    }

    function cancelReview() {
      const hasChanges = currentRating > 0 || reviewText.value.trim();

      if (hasChanges) {
        if (confirm('Tem certeza que deseja cancelar? Todas as alterações serão perdidas.')) {
          window.location.href = `/game/${steamId}`;
        }
      } else {
        window.location.href = `/game/${steamId}`;
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

    // Inicializar contadores e preview
    charCount.textContent = reviewText.value.length;
    updatePreview();

    // Carregar rating do jogo
    loadGameRating();
  </script>

  <style>
    .loading-overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.8);
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      z-index: 9999;
      color: white;
    }

    .loading-spinner {
      width: 40px;
      height: 40px;
      border: 4px solid #333;
      border-top: 4px solid #007bff;
      border-radius: 50%;
      animation: spin 1s linear infinite;
      margin-bottom: 20px;
    }

    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }

    .edit-notice {
      color: #007bff;
      font-size: 14px;
      margin-top: 5px;
    }

    .star {
      background: none;
      border: none;
      font-size: 2rem;
      cursor: pointer;
      color: #ccc;
      transition: color 0.2s;
    }

    .star:hover,
    .star.selected {
      color: #007bff;
    }

    .star.unselected {
      color: #ccc;
    }

    .preview-stars {
      font-size: 1.5rem;
      color: #007bff;
      margin-right: 10px;
    }

    .btn-primary:disabled {
      opacity: 0.6;
      cursor: not-allowed;
    }

    .rating-section {
      margin-bottom: 30px;
    }

    .rating-stars {
      display: flex;
      gap: 10px;
      margin-bottom: 10px;
    }

    .rating-text {
      color: #666;
      font-size: 14px;
    }

    .review-section {
      margin-bottom: 30px;
    }

    .review-textarea {
      width: 100%;
      min-height: 120px;
      padding: 15px;
      border: 2px solid #ddd;
      border-radius: 8px;
      font-family: inherit;
      font-size: 14px;
      resize: vertical;
    }

    .review-textarea:focus {
      outline: none;
      border-color: #007bff;
    }

    .char-count {
      text-align: right;
      color: #666;
      font-size: 12px;
      margin-top: 5px;
    }

    .review-preview {
      background: #f8f9fa;
      padding: 20px;
      border-radius: 8px;
      margin-top: 20px;
    }

    .preview-rating {
      display: flex;
      align-items: center;
      margin-bottom: 10px;
    }

    .preview-text {
      color: #333;
      line-height: 1.5;
      font-style: italic;
    }

    .suit {
      font-size: 1.5rem;
      margin-right: 5px;
      transition: color 0.3s ease;
    }

    .suit.filled {
      color: #007bff;
    }

    .suit.empty {
      color: #ccc;
    }

    .suit.partial {
      color: #66b3ff;
    }
  </style>
</body>
</html>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="/css/user-form.css">

<section class="form-section">
  <div class="form-container">
    <div class="form-header">
      <div class="header-content">
        <div class="icon-wrapper">
          <i class="fas fa-user-plus"></i>
        </div>
        <h1>{{ 'Editar Usuário' if user else 'Criar Usuário' }}</h1>
        <p class="subtitle">
          {{ 'Atualize as informações do usuário' if user else 'Preencha os dados para criar uma nova conta' }}
        </p>
      </div>
    </div>

    <form action="{{ action }}" method="post" class="user-form">
      % if user:
        <input type="hidden" name="id" value="{{ user.id }}">
      % end

      <div class="form-grid">
        <div class="form-group">
          <label for="name">Nome Completo</label>
          <div class="input-wrapper">
            <input type="text" id="name" name="name" required
                   value="{{ user.name if user else '' }}"
                   placeholder="Digite seu nome completo">
            <i class="fas fa-user input-icon"></i>
          </div>
        </div>

        <div class="form-group">
          <label for="email">Email</label>
          <div class="input-wrapper">
            <input type="email" id="email" name="email" required
                   value="{{ user.email if user else '' }}"
                   placeholder="exemplo@email.com">
            <i class="fas fa-envelope input-icon"></i>
          </div>
        </div>

        <div class="form-group">
          <label for="birthdate">Data de Nascimento</label>
          <div class="input-wrapper">
            <input type="date" id="birthdate" name="birthdate" required
                   value="{{ user.birthdate if user else '' }}">
            <i class="fas fa-calendar-alt input-icon"></i>
          </div>
        </div>

        <div class="form-group">
          <label for="password">Senha</label>
          <div class="input-wrapper">
            <input type="password" id="password" name="password"
                   % if not user:
                     required
                   % end
                   placeholder="{{ 'Deixe em branco para manter atual' if user else 'Digite sua senha' }}">
            <i class="fas fa-lock input-icon"></i>
            <button type="button" class="toggle-password" onclick="togglePassword()">
              <i class="fas fa-eye"></i>
            </button>
          </div>
        </div>
      </div>

      <div class="form-actions">
        <button type="submit" class="btn btn-primary">
          <i class="fas fa-check"></i>
          <span>{{ 'Atualizar Usuário' if user else 'Criar Conta' }}</span>
        </button>

        % if is_admin:
          <a href="/admin" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i>
            <span>Voltar à Gestão</span>
          </a>
        % else:
          <a href="/profile" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i>
            <span>Voltar ao Perfil</span>
          </a>
        % end
      </div>
    </form>
  </div>
</section>

<script>
function togglePassword() {
  const passwordInput = document.getElementById('password');
  const toggleIcon = document.querySelector('.toggle-password i');
  if (passwordInput.type === 'password') {
    passwordInput.type = 'text';
    toggleIcon.classList.replace('fa-eye', 'fa-eye-slash');
  } else {
    passwordInput.type = 'password';
    toggleIcon.classList.replace('fa-eye-slash', 'fa-eye');
  }
}
</script>

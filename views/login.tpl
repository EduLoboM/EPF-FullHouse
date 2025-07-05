% rebase('layout', title='Login')

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="/css/user-form.css">

<section class="form-section">
    <div class="form-container">
        <div class="form-header">
            <div class="header-content">
                <div class="icon-wrapper">
                    <i class="fas fa-sign-in-alt"></i>
                </div>
                <h1>Login</h1>
                <p class="subtitle">
                    Faça login para acessar sua conta
                </p>
            </div>
        </div>

        % if erro:
            <div class="alert alert-danger">
                {{erro}}
            </div>
        % end

        <form action="/login" method="post" class="user-form">
            <div class="form-grid">
                <div class="form-group">
                    <label for="email">Email</label>
                    <div class="input-wrapper">
                        <input type="email" id="email" name="email" required
                            placeholder="exemplo@email.com">
                        <i class="fas fa-envelope input-icon"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Senha</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password" required
                            placeholder="Digite sua senha">
                        <i class="fas fa-lock input-icon"></i>
                        <button type="button" class="toggle-password" onclick="togglePassword()">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-sign-in-alt"></i>
                    <span>Entrar</span>
                </button>
                <a href="/signup" class="btn btn-secondary">
                    <i class="fas fa-user-plus"></i>
                    <span>Criar Conta</span>
                </a>
            </div>
        </form>
    </div>
</section>

<script>
function togglePassword() {
    const passwordInput = document.getElementById('password');
    const toggleButton = document.querySelector('.toggle-password i');

    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        toggleButton.classList.remove('fa-eye');
        toggleButton.classList.add('fa-eye-slash');
    } else {
        passwordInput.type = 'password';
        toggleButton.classList.remove('fa-eye-slash');
        toggleButton.classList.add('fa-eye');
    }
}
</script>

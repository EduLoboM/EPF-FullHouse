% rebase('layout', title='Criar Conta')

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="/css/user-form.css">
<link rel="stylesheet" href="/static/css/signup.css">

<section class="form-section">
    <img src="/static/img/FULL-removebg-preview 2.png" alt="Full House Logo" class="full-house">
    <div class="form-container">
        <div class="form-header">
            <div class="header-content">
                <div class="icon-wrapper">
                    <i class="fas fa-user-plus"></i>
                </div>
                <h1 class="create-title">Criar Conta</h1>
                <img src="/static/img/image 5.png" alt="Logo Perfil" class="logo-perfil">
                <p class="subtitle">
                    Preencha os dados para criar uma nova conta
                </p>
            </div>
        </div>

        % if erro:
        <div class="alert alert-danger">
            {{erro}}
        </div>
        % end

        <form action="/signup" method="post" class="user-form">
            <div class="form-grid">
                <div class="form-group">
                    <label for="name">Nome Completo</label>
                    <div class="input-wrapper">
                        <input type="text" id="name" name="name" required placeholder="Digite seu nome completo">
                        <i class="fas fa-user input-icon"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="email">Email</label>
                    <div class="input-wrapper">
                        <input type="email" id="email" name="email" required placeholder="exemplo@email.com">
                        <i class="fas fa-envelope input-icon"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="birthdate">Data de Nascimento</label>
                    <div class="input-wrapper">
                        <input type="date" id="birthdate" name="birthdate" required>
                        <i class="fas fa-calendar-alt input-icon"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Senha</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password" required
                            placeholder="Digite uma senha forte">
                        <i class="fas fa-lock input-icon"></i>
                        <button type="button" class="toggle-password" onclick="togglePassword()">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirm_password">Confirmar Senha</label>
                    <div class="input-wrapper">
                        <input type="password" id="confirm_password" name="confirm_password" required
                            placeholder="Repita sua senha">
                        <i class="fas fa-lock input-icon"></i>
                    </div>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-check"></i>
                    <span>Criar Conta</span>
                </button>
                <a href="/login" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i>
                    <span>Voltar para Login</span>
                </a>
            </div>
        </form>
    </div>
</section>

<script>
    function togglePassword() {
        const passwordInput = document.getElementById('password');
        const confirmInput = document.getElementById('confirm_password');
        const toggleButton = document.querySelector('.toggle-password i');

        const toggleField = (field) => {
            if (field.type === 'password') {
                field.type = 'text';
            }
        }
    }
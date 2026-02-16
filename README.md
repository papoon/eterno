# Wedding Guest Manager

[![CI](https://github.com/papoon/eterno/actions/workflows/ci.yml/badge.svg)](https://github.com/papoon/eterno/actions/workflows/ci.yml)

**Wedding Guest Manager** é uma aplicação web elegante para gerir convidados de casamentos, RSVP online e check-in no dia do evento.  
A versão B2B suporta wedding planners com múltiplos eventos e planos de assinatura recorrentes.

---

## 🌟 Features

### Fase 1 — MVP (B2C / casamento único)

- Gestão de convidados (CRUD)
- Importação de convidados via CSV
- RSVP online para convidados
- Dashboard de confirmação de convidados
- Check-in no dia do casamento
- Pagamento único por casamento via Stripe
- Estatísticas simples: total de convidados, confirmados, recusados

### Fase 2 — B2B / Multi-evento

- Suporte para wedding planners com múltiplos casamentos
- Limite de eventos por plano de assinatura
- Dashboard multi-evento com métricas agregadas
- Exportação de relatórios CSV/PDF
- Alertas de limite de eventos e pagamento falhado
- Upgrade/downgrade de plano via Stripe
- Recorrência e SaaS para wedding planners

---

## 🧱 Arquitetura

Seguindo padrão **Clean Architecture / Laravel Service Layer**:

- **Controllers**: recebem requests, validam via FormRequest e chamam Actions  
- **Actions**: representam casos de uso (ex: `CreateWeddingAction`, `SubmitRSVPAction`)  
- **Services**: lógica de negócio reutilizável (ex: `RSVPService`, `CheckInService`)  
- **DTOs**: transportam dados entre Controller → Action → Service  
- **Enums**: estados fixos (ex: `RSVPStatus`, `PaymentStatus`)  
- **Policies**: autorização  
- **Blade Components**: UI consistente (Botões, Cards, Forms, Tables, Metrics)  

---

## 🎨 Design System

- Layout centrado (`max-w-5xl`)
- Tipografia elegante e consistente
- Paleta suave: rose-500, gray-50, gray-700
- Botões com `rounded-lg` e padding consistente
- Cards para agrupamento de conteúdo
- Inputs, forms, tabelas, métricas padronizados
- Check-in mode tablet-friendly e dark mode

---

## 🛠️ Code Quality Tools

This project enforces strict code quality standards for all new code:

### Available Commands

```bash
# Format code (PSR-12)
composer pint

# Static analysis (PHPStan Level 8)
composer phpstan

# Automated refactoring (Rector)
composer rector

# Run all quality checks + tests
composer quality
```

### Configuration Files

- **pint.json** — PSR-12 code formatting rules
- **phpstan.neon** — PHPStan Level 8 static analysis
- **rector.php** — PHP 8.3 upgrade and code quality rules

### Before Every Commit

```bash
composer pint      # Auto-format code
composer phpstan   # Check for type errors
composer test      # Run all tests
```

**For detailed code style guidelines, see [CODING_STYLE_GUIDELINES.md](CODING_STYLE_GUIDELINES.md).**

---

## 🔄 Continuous Integration

This project uses GitHub Actions to automatically run quality checks on every push and pull request:

### CI Pipeline

The CI workflow (`.github/workflows/ci.yml`) runs the following checks:

1. **Tests** — PHPUnit tests on PHP 8.2 and 8.3
2. **Laravel Pint** — Code style validation (PSR-12)
3. **PHPStan** — Static analysis (Level 8)
4. **Rector** — Code quality checks (dry-run)

All checks must pass before code can be merged.

### Viewing CI Results

- CI status is shown on pull requests
- Click "Details" next to any check to see logs
- Failed checks will block merging until fixed

---

## ⚙️ Stack Tecnológico

- Laravel 11  
- PHP 8+  
- MySQL / PostgreSQL  
- Tailwind CSS  
- Paddle (pagamento único e assinatura)  
- Blade Components  

---

## 🧪 Testes

- PHPUnit (unit + feature tests)  
- Testes por feature seguindo `TESTING_GUIDELINES.md`  
- Cobertura mínima: 80%  
- Actions e Services testados em prioridade  
- Mock de Paddle e emails  

---

## 🚀 Instalação Local

```bash
git clone https://github.com/papoon/eterno.git
cd eterno
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
npm install
npm run dev
php artisan serve

Webhooks para planos de assinatura
```
🧩 Estrutura de Pastas
```
app/
 ├── Actions/
 ├── Services/
 ├── DTOs/
 ├── Enums/
 ├── Models/
 ├── Policies/
 └── Http/
      ├── Controllers/
      └── Requests/
resources/views/components/
 ├── button.blade.php
 ├── card.blade.php
 ├── input.blade.php
 ├── table.blade.php
 └── metric-card.blade.php
```

---

## 📝 Contribuição

Before contributing:

1. **Follow architectural patterns** — [Architecture Guidelines](ARCHITECTURES_GUIDELINES.md)
2. **Follow UI/UX principles** — [UI Guidelines](UI_GUIDELINES.md)
3. **Follow testing rules** — [Testing Guidelines](TESTING_GUIDELINES.md)
4. **Follow code style standards** — [Coding Style Guidelines](CODING_STYLE_GUIDELINES.md)
5. **Use Actions → Services → DTOs** pattern
6. **Run quality checks** before committing:
   ```bash
   composer pint      # Format code
   composer phpstan   # Static analysis
   composer test      # Run tests
   ```

---

## 📊 Roadmap
 MVP: casamento único, RSVP, check-in, pagamento único

 Fase 2: Multi-evento e B2B para wedding planners

 Upsell de features: SMS, seating planner, notificações avançadas

 Expansão internacional: Espanha, Brasil

💰 Modelo de Negócio
MVP: pagamento único por casamento (149–299€)

B2B: assinatura recorrente por plano (Starter / Pro / Enterprise)

Multi-evento → receita previsível e escalável

## 📚 Documentação

- **[Architecture Guidelines](ARCHITECTURES_GUIDELINES.md)** — Architecture patterns and layer responsibilities
- **[UI Guidelines](UI_GUIDELINES.md)** — UI/UX design principles
- **[Testing Guidelines](TESTING_GUIDELINES.md)** — Comprehensive testing rules and patterns
- **[Coding Style Guidelines](CODING_STYLE_GUIDELINES.md)** — Code style, formatting, and quality standards
- **[GitHub Copilot Instructions](.github/copilot-instructions.md)** — Instructions for GitHub Copilot and LLMs

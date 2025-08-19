# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Zaisan (財産) is a personal asset management Rails application for tracking financial accounts and monitoring asset balances over time. The application is designed for Japanese users and supports Japanese financial institutions.

## Development Commands

### Essential Commands

```bash
# Start development server with hot reloading (Rails + Tailwind watch)
bin/dev

# Run tests
bin/rails test
bin/rails test test/models/user_test.rb  # Run specific test file

# Database operations
bin/rails db:migrate
bin/rails db:rollback
bin/rails db:seed
bin/rails console  # Rails console for debugging

# Code quality checks
bin/rubocop         # Ruby style guide enforcement
bin/rubocop -a      # Auto-fix style violations
bin/brakeman        # Security vulnerability scanning

# Asset management
bin/rails tailwindcss:watch    # Watch Tailwind CSS changes
bin/rails assets:precompile    # Precompile assets for production

# Deployment
bin/kamal deploy    # Deploy to production
```

## Architecture & Key Patterns

### Core Models & Relationships
```
User (has_secure_password)
  └── Account (multiple financial accounts)
        └── AccountSnapshot (time-series balance data)
```

### Account Types
- `mufg` - 三菱UFJ銀行
- `rakuten_sec` - 楽天証券  
- `daiwa_sec` - 大和証券
- `other` - その他

### Technology Stack
- **Rails 8.0.2+** with traditional MVC architecture
- **SQLite** for all environments (including production with Solid adapters)
- **Tailwind CSS 4.3** for styling
- **Stimulus.js & Turbo** (Hotwire) for interactivity
- **Session-based authentication** using bcrypt
- **Docker & Kamal** for containerization and deployment

### Database Design Notes
- Amounts are stored as INTEGER (Japanese yen) to avoid decimal precision issues
- Optimized indexes for time-series queries on account_snapshots
- Foreign keys with proper CASCADE DELETE constraints

### Key Files & Directories
- `app/controllers/` - RESTful controllers with authentication filters
- `app/models/` - ActiveRecord models with validations
- `app/views/` - ERB templates with Japanese UI
- `config/routes.rb` - RESTful routes with session management
- `db/schema.rb` - Database schema definition
- `config/deploy.yml` - Kamal deployment configuration
- `Dockerfile` - Multi-stage Docker build

### Development Workflow
1. Always run `bin/dev` for development (starts Rails server + Tailwind watch)
2. Run tests before committing: `bin/rails test`
3. Check code style: `bin/rubocop`
4. Check security: `bin/brakeman`
5. Database changes require migrations: `bin/rails generate migration`

### Testing Approach
- Minitest for unit and integration tests
- System tests configured with Capybara and Selenium
- Test fixtures in `test/fixtures/`
- Parallel test execution enabled

### Important Conventions
- All UI text is in Japanese
- Use `before_action :require_login` for authenticated routes
- Follow Rails RESTful conventions for controllers
- Amount fields should always be integers (yen)
- Time-series data queries should use the optimized indexes
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Task Management System')</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --bs-body-bg: #ffffff;
            --bs-body-color: #212529;
            --task-card-bg: #ffffff;
            --task-card-border: #dee2e6;
            --navbar-bg: #0d6efd;
            --status-pending-bg: #fff3cd;
            --status-in-progress-bg: #d1ecf1;
            --status-completed-bg: #d4edda;
            --filter-card-bg: #ffffff;
        }

        [data-theme="dark"] {
            --bs-body-bg: #0d1117;
            --bs-body-color: #f0f6fc;
            --task-card-bg: #161b22;
            --task-card-border: #30363d;
            --navbar-bg: #161b22;
            --status-pending-bg: #332701;
            --status-in-progress-bg: #0c2d48;
            --status-completed-bg: #0f2419;
            --filter-card-bg: #161b22;
        }

        body {
            background-color: var(--bs-body-bg) !important;
            color: var(--bs-body-color) !important;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .card {
            background-color: var(--task-card-bg) !important;
            border-color: var(--task-card-border) !important;
            color: var(--bs-body-color) !important;
        }

        .navbar-dark {
            background-color: var(--navbar-bg) !important;
        }

        .task-card {
            transition: transform 0.2s, background-color 0.3s ease;
            background-color: var(--task-card-bg) !important;
        }
        
        .task-card:hover {
            transform: translateY(-2px);
        }
        
        .priority-low { border-left: 5px solid #28a745; }
        .priority-medium { border-left: 5px solid #ffc107; }
        .priority-high { border-left: 5px solid #dc3545; }
        
        .status-pending { 
            background-color: var(--status-pending-bg) !important; 
        }
        .status-in_progress { 
            background-color: var(--status-in-progress-bg) !important; 
        }
        .status-completed { 
            background-color: var(--status-completed-bg) !important; 
        }

        .theme-toggle {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 56px;
            height: 56px;
            border-radius: 50%;
            border: 2px solid var(--bs-border-color);
            background: var(--bs-body-bg);
            color: var(--bs-body-color);
            font-size: 1.4rem;
            cursor: pointer;
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 1050;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .theme-toggle:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 24px rgba(0,0,0,0.25);
            border-color: var(--bs-primary);
            background: var(--bs-primary);
            color: white;
        }

        .theme-toggle:active {
            transform: scale(0.95);
        }

        /* Dark mode specific styles for the toggle */
        [data-theme="dark"] .theme-toggle {
            border-color: #30363d;
            background: #161b22;
            color: #f0f6fc;
            box-shadow: 0 4px 16px rgba(255,255,255,0.1);
        }

        [data-theme="dark"] .theme-toggle:hover {
            border-color: var(--bs-warning);
            background: var(--bs-warning);
            color: #000;
            box-shadow: 0 8px 24px rgba(255,193,7,0.3);
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .theme-toggle {
                bottom: 20px;
                right: 20px;
                width: 48px;
                height: 48px;
                font-size: 1.2rem;
            }
        }

        /* Animation for icon rotation */
        .theme-toggle i {
            transition: transform 0.3s ease;
        }

        .theme-toggle:hover i {
            transform: rotate(20deg);
        }

        .theme-toggle.rotating i {
            transform: rotate(180deg);
        }

        /* Pulse animation for initial attention */
        @keyframes pulse {
            0% { box-shadow: 0 4px 16px rgba(0,0,0,0.15); }
            50% { box-shadow: 0 4px 16px rgba(13, 110, 253, 0.4); }
            100% { box-shadow: 0 4px 16px rgba(0,0,0,0.15); }
        }

        .theme-toggle.pulse {
            animation: pulse 2s infinite;
        }

        /* Custom Pagination Styles */
        .pagination-custom {
            gap: 0.25rem;
        }

        .pagination-custom .page-link {
            border: 1px solid var(--bs-border-color);
            background-color: var(--bs-body-bg);
            color: var(--bs-body-color);
            padding: 0.5rem 0.75rem;
            border-radius: 0.375rem;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .pagination-custom .page-link:hover {
            background-color: var(--bs-primary);
            border-color: var(--bs-primary);
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }

        .pagination-custom .page-item.active .page-link {
            background-color: var(--bs-primary);
            border-color: var(--bs-primary);
            color: white;
            font-weight: 600;
        }

        .pagination-custom .page-item.disabled .page-link {
            opacity: 0.5;
            cursor: not-allowed;
            background-color: var(--bs-secondary-bg);
        }

        /* Dark mode pagination adjustments */
        [data-theme="dark"] .pagination-custom .page-link {
            border-color: #30363d;
            background-color: #161b22;
            color: #f0f6fc;
        }

        [data-theme="dark"] .pagination-custom .page-link:hover {
            background-color: #0d6efd;
            border-color: #0d6efd;
            color: white;
            box-shadow: 0 2px 8px rgba(13, 110, 253, 0.3);
        }

        [data-theme="dark"] .pagination-custom .page-item.disabled .page-link {
            background-color: #21262d;
            color: #656d76;
        }

        /* Dark mode form controls */
        [data-theme="dark"] .form-control,
        [data-theme="dark"] .form-select {
            background-color: #2b2b2b !important;
            border-color: #444444 !important;
            color: #ffffff !important;
        }

        [data-theme="dark"] .form-control:focus,
        [data-theme="dark"] .form-select:focus {
            background-color: #333333 !important;
            border-color: #0d6efd !important;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25) !important;
        }

        [data-theme="dark"] .btn-outline-primary {
            color: #6ea8fe !important;
            border-color: #6ea8fe !important;
        }

        [data-theme="dark"] .btn-outline-primary:hover {
            background-color: #6ea8fe !important;
            border-color: #6ea8fe !important;
            color: #000 !important;
        }

        [data-theme="dark"] .text-muted {
            color: #adb5bd !important;
        }

        [data-theme="dark"] .alert-success {
            background-color: #0f2027 !important;
            border-color: #28a745 !important;
            color: #75b798 !important;
        }

        [data-theme="dark"] .alert-danger {
            background-color: #2c0b0e !important;
            border-color: #dc3545 !important;
            color: #ea868f !important;
        }

        /* Dark mode pagination */
        [data-theme="dark"] .page-link {
            background-color: #161b22 !important;
            border-color: #30363d !important;
            color: #6ea8fe !important;
        }

        [data-theme="dark"] .page-link:hover {
            background-color: #21262d !important;
            border-color: #30363d !important;
            color: #f0f6fc !important;
        }

        [data-theme="dark"] .page-item.active .page-link {
            background-color: #0d6efd !important;
            border-color: #0d6efd !important;
        }

        /* Dark mode badges */
        [data-theme="dark"] .badge.bg-secondary {
            background-color: #30363d !important;
        }

        [data-theme="dark"] .badge.bg-warning {
            background-color: #9e6a03 !important;
            color: #000 !important;
        }

        /* Dark mode buttons */
        [data-theme="dark"] .btn-outline-info {
            color: #6ea8fe !important;
            border-color: #6ea8fe !important;
        }

        [data-theme="dark"] .btn-outline-info:hover {
            background-color: #6ea8fe !important;
            color: #000 !important;
        }

        [data-theme="dark"] .btn-outline-warning {
            color: #ffc107 !important;
            border-color: #ffc107 !important;
        }

        [data-theme="dark"] .btn-outline-warning:hover {
            background-color: #ffc107 !important;
            color: #000 !important;
        }

        [data-theme="dark"] .btn-outline-danger {
            color: #dc3545 !important;
            border-color: #dc3545 !important;
        }

        [data-theme="dark"] .btn-outline-danger:hover {
            background-color: #dc3545 !important;
            color: #fff !important;
        }

        /* Theme toggle pulse effect */
        .theme-toggle.rotating {
            animation: pulse 0.3s ease-in-out;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        /* Smooth transitions for all interactive elements */
        .card, .btn, .form-control, .form-select, .badge, .alert {
            transition: all 0.3s ease;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="{{ route('tasks.index') }}">
                <i class="fas fa-tasks"></i> Task Management
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('tasks.index') }}">All Tasks</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('tasks.create') }}">Add Task</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        @if(session('success'))
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                {{ session('success') }}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        @endif

        @if(session('error'))
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                {{ session('error') }}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        @endif

        @yield('content')
    </div>

    <!-- Floating Dark Mode Toggle -->
    <button id="themeToggle" class="theme-toggle" title="Toggle Dark Mode">
        <i class="fas fa-moon" id="themeIcon"></i>
    </button>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Dark Mode Toggle Functionality
        class ThemeManager {
            constructor() {
                this.themeToggle = document.getElementById('themeToggle');
                this.themeIcon = document.getElementById('themeIcon');
                this.currentTheme = localStorage.getItem('theme') || 'light';
                
                this.init();
            }
            
            init() {
                // Apply saved theme on page load
                this.applyTheme(this.currentTheme);
                
                // Add click event listener
                this.themeToggle.addEventListener('click', () => {
                    this.toggleTheme();
                });
                
                // Update icon based on current theme
                this.updateIcon();
            }
            
            toggleTheme() {
                // Add rotation animation with pulse effect
                this.themeToggle.classList.add('rotating');
                
                // Toggle theme
                this.currentTheme = this.currentTheme === 'light' ? 'dark' : 'light';
                
                // Apply new theme with smooth transition
                this.applyTheme(this.currentTheme);
                
                // Save to localStorage
                localStorage.setItem('theme', this.currentTheme);
                
                // Update icon with delay for smooth animation
                setTimeout(() => {
                    this.updateIcon();
                    this.themeToggle.classList.remove('rotating');
                }, 200);
                
                // Optional: Show brief feedback (you can uncomment this)
                // this.showThemeChangeNotification();
            }
            
            applyTheme(theme) {
                document.documentElement.setAttribute('data-theme', theme);
                
                // Update meta theme-color for mobile browsers
                let metaThemeColor = document.querySelector('meta[name=theme-color]');
                if (!metaThemeColor) {
                    metaThemeColor = document.createElement('meta');
                    metaThemeColor.name = 'theme-color';
                    document.head.appendChild(metaThemeColor);
                }
                metaThemeColor.content = theme === 'dark' ? '#0d1117' : '#0d6efd';
            }
            
            updateIcon() {
                if (this.currentTheme === 'dark') {
                    this.themeIcon.className = 'fas fa-sun';
                    this.themeToggle.title = 'Switch to Light Mode';
                } else {
                    this.themeIcon.className = 'fas fa-moon';
                    this.themeToggle.title = 'Switch to Dark Mode';
                }
            }
            
            // Optional notification method (can be enabled in toggleTheme)
            showThemeChangeNotification() {
                const notification = document.createElement('div');
                notification.style.cssText = `
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    background: ${this.currentTheme === 'dark' ? '#161b22' : '#ffffff'};
                    color: ${this.currentTheme === 'dark' ? '#f0f6fc' : '#212529'};
                    padding: 12px 16px;
                    border-radius: 8px;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                    border: 1px solid ${this.currentTheme === 'dark' ? '#30363d' : '#dee2e6'};
                    z-index: 9999;
                    font-size: 14px;
                    opacity: 0;
                    transition: opacity 0.3s ease;
                `;
                
                notification.innerHTML = `
                    <i class="fas fa-${this.currentTheme === 'dark' ? 'moon' : 'sun'} me-2"></i>
                    ${this.currentTheme === 'dark' ? 'Dark' : 'Light'} mode activated
                `;
                
                document.body.appendChild(notification);
                
                // Fade in
                setTimeout(() => notification.style.opacity = '1', 10);
                
                // Auto remove after 2 seconds
                setTimeout(() => {
                    notification.style.opacity = '0';
                    setTimeout(() => document.body.removeChild(notification), 300);
                }, 2000);
            }
        }
        
        // Initialize theme manager when DOM is loaded
        document.addEventListener('DOMContentLoaded', function() {
            new ThemeManager();
        });
        
        // Smooth transition on theme change
        document.addEventListener('DOMContentLoaded', function() {
            // Add transition class to body after initial load
            setTimeout(() => {
                document.body.style.transition = 'background-color 0.3s ease, color 0.3s ease';
            }, 100);
            
            // Add pulse animation to theme toggle for brief attention
            const themeToggle = document.getElementById('themeToggle');
            if (themeToggle) {
                setTimeout(() => {
                    themeToggle.classList.add('pulse');
                    // Remove pulse after 6 seconds
                    setTimeout(() => {
                        themeToggle.classList.remove('pulse');
                    }, 6000);
                }, 1000);
            }
        });
    </script>
    
    @yield('scripts')
</body>
</html>

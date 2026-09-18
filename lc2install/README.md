# LetzteChance - Second Chance Job Portal

A modern Angular application inspired by [letztechance.org](https://www.letztechance.org) that connects job seekers with employers who believe in second chances. Built with Angular 21 and Tauri for cross-platform desktop support.

## usage

the following required arguments are:
-

## Download Binary/Installer

<a href="https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/lc2install/lc2install.exe"><img src="https://www.letztechance.org/img.png?width=400&height=400&image=logo.png&text=lc2install/lc2install.exe&r=20&g=20&b=20&test=" alt="lc2install/lc2install.exe Screenshot" width="400" /></a>

- https://raw.githubusercontent.com/David-Honisch/Microsoft-Windows/refs/heads/master/lc2install/lc2install.exe

## Download

<a href="https://raw.githubusercontent.com/David-Honisch/Microsoft-Windows/refs/heads/master/lc2nav2026/lc2nav2026.exe"><img src="https://www.letztechance.org/img.png?width=400&height=400&image=logo.png&text=lc2nav2026.exe&r=20&g=20&b=20&test=" alt="LC2Navigator2025/26 Installer Screenshot" width="400" /></a>

## 🌟 Features

- **Job Listings**: Browse available job opportunities with detailed information
- **Advanced Filtering**: Search and filter jobs by type, category, location, and keywords
- **Detailed Job Views**: View comprehensive job details including requirements, benefits, and contact information
- **Responsive Design**: Fully responsive UI that works on desktop, tablet, and mobile devices
- **Modern UI/UX**: Beautiful gradient designs with smooth animations and transitions
- **SOAP API Integration**: Full integration with letztechance.org web services (WSDL)
- **Cross-Platform**: Desktop application support via Tauri

## 🚀 Technologies

- **Angular 21**: Modern web framework
- **TypeScript 5.9**: Type-safe development
- **Tauri 2.9**: Cross-platform desktop application framework
- **RxJS 7.8**: Reactive programming
- **SCSS**: Advanced styling
- **ngx-translate**: Internationalization support

## 📋 Prerequisites

- Node.js >= 22.12.0 or >= 24.0.0
- npm or yarn
- Rust (for Tauri builds)

## 🛠️ Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd lc2news
```

2. Install dependencies:
```bash
npm install
```

## 🏃 Running the Application

### Web Development Server
```bash
npm run web:serve
```
Navigate to `http://localhost:4200/`

### Tauri Development
```bash
npm run tauri:serve
```
Launches the desktop application in development mode

### Production Build

#### Web Build
```bash
npm run web:prod
```

#### Tauri Build
```bash
npm run tauri:bundle
```

## 📁 Project Structure

```
lc2news/
├── src/
│   ├── app/
│   │   ├── core/
│   │   │   └── services/
│   │   │       ├── api/
│   │   │       │   └── letztechance-api.service.ts  # SOAP API integration
│   │   │       ├── job/
│   │   │       │   └── job.service.ts               # Job management service
│   │   │       └── tauri/
│   │   │           └── tauri.service.ts             # Tauri integration
│   │   ├── home/
│   │   │   ├── home.component.ts                    # Main job listings page
│   │   │   ├── home.component.html
│   │   │   └── home.component.scss
│   │   ├── detail/
│   │   │   ├── detail.component.ts                  # Job detail page
│   │   │   ├── detail.component.html
│   │   │   └── detail.component.scss
│   │   └── shared/
│   │       ├── models/
│   │       │   └── job.model.ts                     # Data models
│   │       └── components/
│   ├── assets/
│   │   ├── i18n/                                    # Translation files
│   │   └── icons/                                   # Application icons
│   └── environments/                                # Environment configs
├── src-tauri/                                       # Tauri configuration
└── package.json
```

## 🔌 API Integration

The application integrates with the letztechance.org SOAP web services. The `LetztechanceApiService` provides methods for:

### News Management
- `getNews()`: Retrieve all news items
- `getNewsById(id)`: Get specific news item
- `createNews(news)`: Create new news item
- `updateNews(id, news)`: Update existing news
- `deleteNews(id)`: Delete news item

### Job Management
- `getJobs()`: Retrieve all job offers
- `getJobById(id)`: Get specific job offer
- `createJob(job)`: Create new job offer
- `updateJob(id, job)`: Update existing job
- `deleteJob(id)`: Delete job offer

### User Management
- `login(username, password)`: User authentication
- `register(user)`: User registration
- `getUserById(id)`: Get user details
- `updateUser(id, user)`: Update user information
- `deleteUser(id)`: Delete user account

## 🎨 UI Components

### Home Page
- Header with navigation
- Hero section with tagline
- Advanced filter panel (search, type, category, location)
- Job cards grid with featured highlighting
- Responsive footer

### Job Detail Page
- Comprehensive job information
- Requirements and benefits lists
- Contact information sidebar
- Application call-to-action
- Share and save functionality

## 🧪 Testing

Run unit tests:
```bash
npm test
```

Run tests in watch mode:
```bash
npm run test:watch
```

## 📝 Code Quality

Lint the code:
```bash
npm run lint
```

## 🌍 Internationalization

The application supports multiple languages through ngx-translate. Translation files are located in `src/assets/i18n/`.

Currently supported:
- English (en)

To add a new language:
1. Create a new JSON file in `src/assets/i18n/` (e.g., `de.json`)
2. Add translations following the existing structure
3. Update the language configuration in `main.ts`

## 🎯 Key Features Explained

### Job Filtering
The application provides real-time filtering capabilities:
- **Text Search**: Search across job titles, companies, and descriptions
- **Job Type**: Filter by employment type (Full-time, Part-time, Contract, etc.)
- **Category**: Filter by industry category
- **Location**: Search by city or region

### Featured Jobs
Jobs marked as "featured" are highlighted with:
- Gold border and background gradient
- Star badge
- Priority placement in listings

### Responsive Design
The application is fully responsive with breakpoints at:
- Desktop: > 1024px
- Tablet: 768px - 1024px
- Mobile: < 768px

## 🔒 Security Considerations

- CORS handling for SOAP requests
- Input sanitization for XML/SOAP payloads
- Secure credential handling
- XSS protection through Angular's built-in sanitization

## 🚧 Development Notes

### SOAP Integration
The application uses a custom SOAP client implementation to communicate with the letztechance.org web services. XML parsing is handled through the browser's native DOMParser.

### State Management
Currently using RxJS BehaviorSubjects for state management. For larger applications, consider implementing NgRx or Akita.

### Performance
- Lazy loading for routes (can be implemented)
- OnPush change detection strategy (can be optimized)
- Virtual scrolling for large job lists (can be added)

## 📄 License

This project is licensed under the MIT License - see the LICENSE.md file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 Support

For support, please contact the development team or open an issue in the repository.

## 🙏 Acknowledgments

- Inspired by [letztechance.org](https://www.letztechance.org)
- Built with Angular and Tauri
- Icons and design elements from various open-source projects

## 📊 Project Status

Current Version: 2.0.0

Status: Active Development

Last Updated: May 2026

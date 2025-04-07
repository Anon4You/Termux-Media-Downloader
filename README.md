# Termux Media Downloader 🚀

![Termux](https://img.shields.io/badge/Termux-000000?style=for-the-badge&logo=termux) 
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white) 
![License](https://img.shields.io/badge/License-MIT-blue.svg)

A high-performance media downloader for Termux that combines power and simplicity ✨

## 🔥 Key Features

- **📹 Video Downloading**: Support for 480p, 720p, 1080p formats
- **🎵 Audio Extraction**: MP3 conversion with quality preservation
- **📂 Playlist Handling**: Full or partial playlist downloads
- **🖼️ Media Enhancement**: Auto-embed thumbnails & metadata
- **⏭️ SponsorBlock**: Skip sponsors automatically
- **📊 Smart History**: Searchable/downloadable record of all downloads
- **⚙️ Configurable**: Persistent settings with easy customization

## 💻 Installation

### 🚀 One-Command Install (Recommended)
```bash
curl -sL https://is.gd/ZKUaLN | bash
```

### 📦 Repository Install (Advanced)
```bash
apt update && apt install termux-media-downloader
```
🔗 *Repository URL: https://anon4you.github.io/alienkrishn*

## 🏁 Getting Started

1. Launch the application:
```bash
tmd
```

2. Use the intuitive menu system:
   - 🎬 Download single videos
   - 🎧 Extract audio tracks
   - 📜 Process entire playlists
   - ⚙️ Configure preferences
   - 🕵️ Review download history

## ⚙️ Configuration

All settings stored in:  
`$HOME/.config/tmd_config/`

| File         | Description               | Emoji |
|--------------|---------------------------|-------|
| `config`     | User preferences          | ⚙️   |
| `history.log`| Complete download records | 📜   |
| `format`     | Preferred media format    | 🎞️   |

## 📂 Default Storage
```
/sdcard/Youtube_Downloads/
├── Video_Title.mp4         🎥
├── Playlist_Folder/        📁
│   ├── Episode_1.mp4       🎬
│   └── Song_2.mp3          🎵
```

## 📋 Requirements

- Termux v0.118.0+
- Python 3.8+
- FFmpeg (for format conversion)
- 50MB+ available storage

## ❓ Support

🐛 Found an issue?  
[Open a ticket](https://github.com/Anon4You/Termux-Media-Downloader/issues)

## 🤝 Contributing

We welcome contributions!  
🔧 Fork → Patch → Push → Pull Request

## 📜 License

MIT Licensed - See `LICENSE` for details.

---
**Maintainer**: [Alienkrishn](https://github.com/Anon4You) 👨‍💻  
**Project Link**: [GitHub Repo](https://github.com/Anon4You/Termux-Media-Downloader) 🔗

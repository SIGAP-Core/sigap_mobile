# 📱 SIGAP Mobile Auth

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Auth-FFCA28?logo=firebase)](https://firebase.google.com/)
[![Provider](https://img.shields.io/badge/State_Management-Provider-blue)](#)

**SIGAP (Sistem Integrasi Gerbang & Akses Pintar)** - Aplikasi _mobile_ (Flutter) yang berfungsi sebagai kunci digital karyawan.

Fitur utama:

- Autentikasi via Firebase Auth.
- Pemindai QR Code khusus SIGAP.
- Validasi akses gerbang ke API Next.js.

---

## 🛠️ Instalasi & Setup Lingkungan

Ikuti langkah-langkah berikut untuk menjalankan proyek di komputer lokal Anda:

### 1. Kloning Repositori & Ambil Dependensi

```bash
git clone [https://github.com/SIGAP-Core/sigap_mobile.git](https://github.com/SIGAP-Core/sigap_mobile.git)
cd sigap_mobile
flutter pub get
```

### 2. Konfigurasi API Endpoint (.env)

Aplikasi ini membutuhkan URL dari backend API Next.js agar dapat melakukan validasi QR Code.

1. Hubungi **Pemilik Proyek (Project Owner)** untuk meminta file konfigurasi `.env`.
2. Letakkan file `.env` tersebut tepat di **root direktori** proyek ini (sejajar dengan file `pubspec.yaml`).

> [!IMPORTANT]
> File `.env` sengaja di-ignore melalui `.gitignore` karena berisi URL lokal sementara (Ngrok/IP Lokal) selama masa _development_ dan demi menjaga keamanan sistem saat aplikasi dirilis.

---

## 💻 Menjalankan Aplikasi

Jalankan aplikasi ke emulator atau perangkat fisik menggunakan perintah berikut:

```bash
flutter run
```

> [!TIP]
> **Struktur Folder (Feature-Based):**
> Proyek ini menggunakan arsitektur _feature-based_ untuk kerapian kode:
>
> - `lib/features/auth/` - Logika & UI Autentikasi (Login).
> - `lib/features/qr/` - Logika Kamera Scanner & API.
> - `lib/shared/` - Komponen & _utilities_ bersama.

---

## 🏗️ Tech Stack

- **UI Framework:** [Flutter](https://flutter.dev/)
- **State Management:** [Provider](https://pub.dev/packages/provider)
- **HTTP Client:** [Dio](https://pub.dev/packages/dio)
- **QR Scanner:** [mobile_scanner](https://pub.dev/packages/mobile_scanner)
- **Auth Service:** [Firebase Authentication](https://pub.dev/packages/firebase_auth)

---

_Developed with 💡 by the SIGAP-Core Team._

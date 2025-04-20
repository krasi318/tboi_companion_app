
A mobile companion app for *The Binding of Isaac*, designed to help players identify in-game items using image scanning and pixel-based hashing. Built with Flutter and powered by custom image recognition logic, this app allows you to snap a photo or pick an image of an item and instantly find a match from your local item library.

---

## 📸 Features

- 🖼️ **Image Scanning:** Snap a photo of an item or select one from your gallery.
- 🧠 **Pixel Hash Matching:** Converts images into binary pixel hashes and compares them using Hamming distance.
- 📚 **Item Library:** Browse all items, complete with icons and detailed descriptions.
- 🔍 **Search Functionality:** Quickly look up items by name or keyword.
- ⚡ **Offline-First:** All data is stored locally — no internet connection required.

---

## 🛠️ Tech Stack

| Layer                | Tools / Libraries                                                                                        |
| -------------------- | -------------------------------------------------------------------------------------------------------- |
| **Framework**        | [Flutter](https://flutter.dev/)                                                                          |
| **Language**         | Dart                                                                                                     |
| **Image Processing** | [`image`](https://pub.dev/packages/image)                                                                |
| **Database**         | [`sqflite`](https://pub.dev/packages/sqflite), [`path_provider`](https://pub.dev/packages/path_provider) |
| **Hashing Logic**    | Custom brightness-based binary hashing + Hamming distance                                                |
| **Development**      | Visual Studio Code, Obsidian for documentation                                                           |

---

## 📂 Project Structure

lib/
│
├── db/
│   ├── database_helper.dart     # Handles local DB operations
│   └── seed_data.dart           # Seeds item data into the DB
│
├── models/
│   └── item.dart                # Item model (ID, name, hash, image ref, etc.)
│
├── screens/
│   ├── item_detail_screen.dart  # Shows detailed item info
│   ├── item_library_screen.dart # Grid/List of all known items
│   ├── scan_screen.dart         # Camera/Picker + matching logic
│   └── search_screen.dart       # Manual keyword search
│
├── utils/
│   ├── hash_matcher.dart        # Compares hash strings to find matches
│   ├── image_cropper.dart       # (Optional) crops scanned images
│   ├── image_handling.dart      # Image loading/handling helpers
│   └── image_to_hash.dart       # Converts image to binary pixel hash
│
└── main.dart                    # Entry point, sets up routing and theme


---

## 🔍 How It Works

1. **Image Input**: User selects or takes a photo of an item.
2. **Hashing**: The image is resized to 64x64 and converted to a binary string based on pixel brightness.
3. **Matching**: The hash is compared to pre-generated hashes in the database using Hamming distance.
4. **Result**: The closest match is displayed.

---

## 🌟 Future Ideas

-  Add multi-language support for item descriptions.
-  Allo custom image input (e.g. screenshot from clipboard).
-  Add more accurate matching (e.g., deep model).
-  Show similarity confidence percentage.
-  Scan from live camera feed.

### 🧠 Why Use Pixel Hashing?

Instead of OCR or ML, we use **binary pixel hash comparison**. It's:

- ✅ Fast
- ✅ Simple
- ✅ Doesn’t require heavy models


## 🚀 Getting Started

```bash
# 1. Clone the repo
git clone https://github.com/yourusername/tboi-companion.git

# 2. Change into the project directory
cd tboi-companion

# 3. Install dependencies
flutter pub get

# 4. Run the app
flutter run
bash```

## ❤️ Credits

- Inspired by _The Binding of Isaac_ by Edmund McMillen
- Built with love using Flutter 💙


# 🎧 Dual Output Audio Manager (PipeWire + Zenity)

A simple GUI utility for Ubuntu that lets you play audio on both **Bluetooth** and **3.5mm (jack)** outputs simultaneously, with optional delay compensation for sync.

---

## 🛠 Requirements

Make sure the following packages are installed:
```bash
sudo apt install pipewire pipewire-pulse zenity
🚀 Installation Guide
1️⃣ Clone or Download

Clone this repository:

git clone https://github.com/shyamangku123/dual-output-manager.git
cd dual-output-manager


Or download and extract the .zip manually.

2️⃣ Run the Installer

Give permissions and run the installer:

chmod +x install.sh
sudo ./install.sh


The installer will:

Copy the main script to /usr/local/bin/dual-output-manager

Make it executable

Automatically create a desktop shortcut at:

~/.local/share/applications/dual-output-manager.desktop


Add it to your App Launcher / Activities Menu

3️⃣ Launch the App

You can start the tool in any of the following ways:

dual-output-manager


or search Dual Output Manager in your desktop applications menu.

🧹 Uninstallation

To remove the tool and its shortcut:

sudo rm /usr/local/bin/dual-output-manager
rm ~/.local/share/applications/dual-output-manager.desktop

💡 Features

GUI-based output selection (via Zenity)

Combines Bluetooth and 3.5mm audio outputs

Adjustable delay for perfect sync

Auto cleanup when stopped

Desktop shortcut support

🪪 License

Licensed under the Apache License 2.0

You may freely use, modify, and distribute this software,
but must provide credit.
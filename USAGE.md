# VPN Gaming Autoscript - Usage Guide

## 🚀 Super Simple - Just Type `menu`

### First Time Setup

```bash
# 1. Download
wget https://your-server/menu

# 2. Make executable
chmod +x menu

# 3. Run (it will auto-install itself)
./menu
```

**What happens:**
- ✅ Script automatically installs itself to `/usr/local/bin/`
- ✅ You can now type just `menu` from anywhere!
- ✅ No need for `./` prefix anymore

### After First Run

```bash
# Just type this from anywhere:
menu
```

**That's it!** 🎉

---

## 📋 How It Works

### First Time You Run It:

```bash
./menu

[!] First-time setup: Installing 'menu' command...
[i] This requires root privileges
[✓] Installation complete!
[i] You can now type 'menu' from anywhere!

╔════════════════════════════════════════╗
║   VPN Gaming Autoscript v2.0           ║
║   Optimized for Low-Ping Gaming        ║
╚════════════════════════════════════════╝
```

### Every Time After:

```bash
menu

╔════════════════════════════════════════╗
║   VPN Gaming Autoscript v2.0           ║
║   Optimized for Low-Ping Gaming        ║
╚════════════════════════════════════════╝
```

---

## 💡 Usage Examples

### Install Trojan
```bash
menu
# Choose: 1
```

### Install Xray
```bash
menu
# Choose: 2
```

### Switch Protocols
```bash
menu
# Choose: 5
```

### View Connection Info
```bash
menu
# Choose: 6
```

### Optimize for Gaming
```bash
menu
# Choose: 7
```

---

## 🎯 Complete Example

```bash
# Download and setup
wget https://your-server/menu
chmod +x menu

# First run (auto-installs)
./menu
# → Choose 1 (Install Trojan)

# Second run (just type menu)
menu
# → Choose 7 (Optimize for gaming)

# Third run
menu
# → Choose 6 (View connection info)

# From now on, always just:
menu
```

---

## 🔄 Protocol Switching

```bash
# Install both protocols
menu → 1  (Trojan)
menu → 2  (Xray)

# Switch to Xray
menu → 5 → 1

# Switch back to Trojan
menu → 5 → 1
```

---

## 🌐 Multi-IP Setup

```bash
# Main IP
menu → 1 or 2

# Floating IP 1
menu → 3 or 4
# Select IP

# Floating IP 2
menu → 3 or 4
# Select different IP
```

---

## ✨ Key Features

✅ **Auto-installs** - First run installs to PATH
✅ **Just type `menu`** - No `./` needed
✅ **Works anywhere** - Run from any directory
✅ **Auto-permission** - Handles sudo automatically
✅ **Protocol switching** - Built-in
✅ **Multi-IP support** - For floating IPs

---

## 🎮 Quick Commands

| Command | Description |
|---------|-------------|
| `menu` | Open VPN menu |
| `menu` → 1 | Install Trojan |
| `menu` → 2 | Install Xray |
| `menu` → 5 | Switch protocol |
| `menu` → 6 | View connection info |
| `menu` → 7 | Optimize for gaming |

---

## 🔧 Troubleshooting

### Issue: "menu: command not found"

**First time?**
```bash
# Run with ./
./menu
# It will auto-install, then you can use just 'menu'
```

**Already ran once?**
```bash
# Check if installed
ls -l /usr/local/bin/menu

# If not there, run again:
./menu
```

### Issue: Permission Denied

```bash
# Make sure it's executable
chmod +x menu

# Then run
./menu
```

---

## 📂 File Locations

**Menu script (after auto-install):**
- `/usr/local/bin/menu`

**Credentials:**
- `~/vpn-clients/trojan-credentials.txt`
- `~/vpn-clients/xray-credentials.txt`

**Configurations:**
- `/usr/local/etc/trojan/config.json`
- `/usr/local/etc/xray/config.json`

---

## 🎉 Summary

### Download Once:
```bash
wget https://your-server/menu
chmod +x menu
```

### First Run:
```bash
./menu
# Auto-installs to system PATH
```

### Forever After:
```bash
menu
# Just type 'menu' anywhere!
```

**That's it!** 🚀

---

**Enjoy your low-ping gaming VPN!** 🎮

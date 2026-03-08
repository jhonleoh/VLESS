# VPN Gaming Autoscript - Troubleshooting Guide

## Issue: Xray Not Showing in Menu / Connection Info

### Problem Description

After installing Xray successfully, you see:
- ✅ "Xray service started successfully"
- ✅ Connection URI displayed
- ❌ But Xray doesn't show in the menu
- ❌ Not visible in "View Connection Info"
- ❌ Connection doesn't work in client

### Root Cause: Port Conflict

**Both Trojan and Xray use port 443 by default!**

When you have Trojan running and install Xray:
1. Trojan is already using port 443
2. Xray tries to start on port 443
3. Xray fails to bind to port (already in use)
4. Xray service stops immediately
5. Menu shows only Trojan (the one actually running)

### How to Verify

Run the diagnostic script:

```bash
bash vpn-diagnostic.sh
```

Look for:
```
Port 443 (VPN):
tcp   LISTEN 0   128   0.0.0.0:443   0.0.0.0:*   users:(("trojan",pid=1234))
                                                   ↑ Only Trojan is here!
```

Or check manually:
```bash
# Check what's using port 443
ss -tlnp | grep :443

# Check service status
systemctl status trojan
systemctl status xray
```

### Solutions

You have **3 options**:

---

## Option 1: Use Only ONE Protocol (Recommended for Single IP)

**Choose either Trojan OR Xray, not both on the same IP.**

### If you want Trojan:
```bash
# Stop and disable Xray
systemctl stop xray
systemctl disable xray

# Keep Trojan running
systemctl status trojan
```

### If you want Xray:
```bash
# Stop and disable Trojan
systemctl stop trojan
systemctl disable trojan

# Restart Xray (it will now get port 443)
systemctl restart xray
systemctl status xray
```

---

## Option 2: Use Multi-IP Setup (Best for Multiple IPs)

**If you have floating IPs, use one protocol per IP.**

### Example Setup:
- **Main IP (94.237.78.42)**: Trojan on port 443
- **Floating IP 1**: Xray on port 443 (bound to that IP)
- **Floating IP 2**: Another Trojan on port 443 (bound to that IP)

### How to do it:

1. **Keep Trojan on main IP** (already running)

2. **Install Xray on floating IP**:
   ```bash
   bash vpn-setup.sh
   # Choose option 4: Add Xray on Additional IP
   # Select your floating IP
   ```

This way each IP has its own service on port 443!

---

## Option 3: Use Different Ports (Advanced)

**Run both on same IP but different ports.**

### Manually edit Xray config:

```bash
# Stop Xray
systemctl stop xray

# Edit config
nano /usr/local/etc/xray/config.json

# Change port from 443 to 8443:
"port": 8443,

# Restart Xray
systemctl restart xray
```

**Note**: You'll need to update your client connection to use port 8443.

---

## Fixing the Menu Display Issue

The menu checks if services are active. If Xray failed due to port conflict, it won't show.

### After fixing the port conflict:

1. **Restart the service**:
   ```bash
   systemctl restart xray
   ```

2. **Verify it's running**:
   ```bash
   systemctl status xray
   ```

3. **Check the menu again**:
   ```bash
   bash vpn-setup.sh
   # You should now see:
   # [✓] Xray: Running
   ```

---

## Why Connection Doesn't Work in NekoRay/v2rayN

If Xray service isn't actually running (due to port conflict), the connection will fail:

### Symptoms:
- Connection timeout
- "Connection refused"
- "No response"

### Fix:
1. **Ensure Xray is actually running**:
   ```bash
   systemctl status xray
   ```

2. **If not running, fix port conflict first** (see solutions above)

3. **Then test connection again**

---

## Checking Actual Service Status

### Command to check both services:

```bash
# Quick check
systemctl is-active trojan && echo "Trojan: RUNNING" || echo "Trojan: STOPPED"
systemctl is-active xray && echo "Xray: RUNNING" || echo "Xray: STOPPED"

# Detailed check
systemctl status trojan
systemctl status xray

# Check port usage
ss -tlnp | grep :443
```

### What you should see:

**If Trojan is running:**
```
● trojan.service - Trojan-GFW Server
   Active: active (running)
```

**If Xray is running:**
```
● xray.service - Xray Service
   Active: active (running)
```

**If Xray failed due to port conflict:**
```
● xray.service - Xray Service
   Active: failed (Result: exit-code)
   
   Error: failed to listen on address: 0.0.0.0:443
```

---

## Recommended Setup for Your Situation

Based on your setup (1 main IP + 4 floating IPs):

### Best Configuration:

**Main IP (94.237.78.42)**:
- Trojan on port 443 ✅ (already installed)

**Floating IP 1**:
- Xray on port 443 (use option 4 in menu)

**Floating IP 2**:
- Trojan on port 443 (use option 3 in menu)

**Floating IP 3**:
- Xray on port 443 (use option 4 in menu)

**Floating IP 4**:
- Trojan on port 443 (use option 3 in menu)

### Result:
- ✅ 5 independent VPN servers
- ✅ No port conflicts (each IP is separate)
- ✅ Mix of Trojan and Xray
- ✅ All on port 443
- ✅ All show in menu correctly

---

## Step-by-Step Fix for Your Current Issue

### Step 1: Check Current Status
```bash
bash vpn-diagnostic.sh
```

### Step 2: Decide What to Do

**Option A: Keep only Trojan on main IP**
```bash
systemctl stop xray
systemctl disable xray
```

**Option B: Switch to Xray on main IP**
```bash
systemctl stop trojan
systemctl disable trojan
systemctl restart xray
```

**Option C: Use Xray on floating IP instead**
```bash
# Stop Xray on main IP
systemctl stop xray
systemctl disable xray

# Run the script
bash vpn-setup.sh

# Choose option 4: Add Xray on Additional IP
# Select one of your floating IPs
```

### Step 3: Verify
```bash
# Check services
systemctl status trojan
systemctl status xray

# Check menu
bash vpn-setup.sh
# Should now show correct status
```

### Step 4: Test Connection
- Import the connection URI to your client
- Try to connect
- Should work now! ✅

---

## Understanding the Menu Display Logic

The menu checks:
```bash
if systemctl is-active --quiet trojan; then
    echo "[✓] Trojan: Running"
fi

if systemctl is-active --quiet xray; then
    echo "[✓] Xray: Running"
fi
```

**If service is not active, it won't show.**

This is why after Xray failed (port conflict), it didn't appear in the menu.

---

## Prevention for Future Installations

### Rule of Thumb:

**One protocol per IP address (on the same port)**

- ✅ Trojan on IP1:443 + Xray on IP2:443 = OK
- ✅ Trojan on IP1:443 + Trojan on IP2:443 = OK
- ❌ Trojan on IP1:443 + Xray on IP1:443 = CONFLICT
- ✅ Trojan on IP1:443 + Xray on IP1:8443 = OK (different ports)

### When Installing:

1. **Check what's already running**:
   ```bash
   ss -tlnp | grep :443
   ```

2. **If port 443 is in use**:
   - Use a different IP (multi-IP setup)
   - OR use a different port
   - OR stop the existing service

3. **After installation, always verify**:
   ```bash
   systemctl status [service-name]
   ```

---

## Quick Reference Commands

```bash
# Diagnostic
bash vpn-diagnostic.sh

# Check services
systemctl status trojan
systemctl status xray

# Check ports
ss -tlnp | grep :443

# Stop services
systemctl stop trojan
systemctl stop xray

# Start services
systemctl start trojan
systemctl start xray

# Restart services
systemctl restart trojan
systemctl restart xray

# Enable/disable autostart
systemctl enable trojan
systemctl disable xray

# View logs
journalctl -u trojan -f
journalctl -u xray -f

# View connection info
cat ~/vpn-clients/trojan-credentials.txt
cat ~/vpn-clients/xray-credentials.txt
```

---

## Summary

**Your issue**: Xray installed but not showing/working
**Cause**: Port 443 already used by Trojan
**Solution**: Choose one of:
1. Use only one protocol on main IP
2. Use Xray on a floating IP instead
3. Change Xray to different port

**Recommended**: Use multi-IP setup with one protocol per IP!

---

Need help? Run `bash vpn-diagnostic.sh` and share the output!

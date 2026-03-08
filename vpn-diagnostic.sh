#!/bin/bash

###############################################################################
# VPN Gaming Autoscript - Diagnostic Tool
# Checks status of all VPN services and identifies issues
###############################################################################

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   VPN Diagnostic Tool                  ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

echo -e "${CYAN}=== System Information ===${NC}"
echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo "Kernel: $(uname -r)"
echo "Date: $(date)"
echo ""

echo -e "${CYAN}=== Service Status ===${NC}"
echo ""

# Check Trojan
echo -e "${YELLOW}Trojan Service:${NC}"
if systemctl list-units --type=service --all | grep -q "trojan.service"; then
    echo "  Service file: EXISTS"
    if systemctl is-active --quiet trojan; then
        echo -e "  Status: ${GREEN}RUNNING${NC}"
        systemctl status trojan --no-pager -l | head -10
    else
        echo -e "  Status: ${RED}STOPPED${NC}"
        systemctl status trojan --no-pager -l | head -10
    fi
else
    echo "  Service file: NOT FOUND"
fi
echo ""

# Check Xray
echo -e "${YELLOW}Xray Service:${NC}"
if systemctl list-units --type=service --all | grep -q "xray.service"; then
    echo "  Service file: EXISTS"
    if systemctl is-active --quiet xray; then
        echo -e "  Status: ${GREEN}RUNNING${NC}"
        systemctl status xray --no-pager -l | head -10
    else
        echo -e "  Status: ${RED}STOPPED${NC}"
        systemctl status xray --no-pager -l | head -10
    fi
else
    echo "  Service file: NOT FOUND"
fi
echo ""

echo -e "${CYAN}=== Port Usage ===${NC}"
echo ""
echo "Port 443 (VPN):"
ss -tlnp | grep :443 || echo "  Port 443 is FREE"
echo ""
echo "Port 80 (HTTP):"
ss -tlnp | grep :80 || echo "  Port 80 is FREE"
echo ""

echo -e "${CYAN}=== Configuration Files ===${NC}"
echo ""
echo "Trojan config:"
if [ -f /usr/local/etc/trojan/config.json ]; then
    echo "  EXISTS: /usr/local/etc/trojan/config.json"
    echo "  Port: $(jq -r '.local_port' /usr/local/etc/trojan/config.json 2>/dev/null || echo 'N/A')"
else
    echo "  NOT FOUND"
fi
echo ""

echo "Xray config:"
if [ -f /usr/local/etc/xray/config.json ]; then
    echo "  EXISTS: /usr/local/etc/xray/config.json"
    echo "  Port: $(jq -r '.inbounds[0].port' /usr/local/etc/xray/config.json 2>/dev/null || echo 'N/A')"
else
    echo "  NOT FOUND"
fi
echo ""

echo -e "${CYAN}=== Client Credentials ===${NC}"
echo ""
if [ -d ~/vpn-clients ]; then
    echo "Credential files:"
    ls -lh ~/vpn-clients/ 2>/dev/null || echo "  Directory empty"
else
    echo "  ~/vpn-clients directory NOT FOUND"
fi
echo ""

echo -e "${CYAN}=== Recent Logs ===${NC}"
echo ""
echo -e "${YELLOW}Trojan logs (last 5 lines):${NC}"
journalctl -u trojan -n 5 --no-pager 2>/dev/null || echo "  No logs available"
echo ""
echo -e "${YELLOW}Xray logs (last 5 lines):${NC}"
journalctl -u xray -n 5 --no-pager 2>/dev/null || echo "  No logs available"
echo ""

echo -e "${CYAN}=== Recommendations ===${NC}"
echo ""

# Check for port conflicts
if ss -tlnp | grep -q :443; then
    PROCESS=$(ss -tlnp | grep :443 | awk '{print $6}' | head -1)
    echo -e "${YELLOW}⚠${NC}  Port 443 is in use by: $PROCESS"
    echo "   → Only ONE service can use port 443 at a time"
    echo "   → If you want both Trojan and Xray, you need to:"
    echo "      1. Use different ports, OR"
    echo "      2. Use multi-IP setup (bind to different IPs)"
fi

# Check if both services are trying to run
TROJAN_ACTIVE=$(systemctl is-active trojan 2>/dev/null)
XRAY_ACTIVE=$(systemctl is-active xray 2>/dev/null)

if [ "$TROJAN_ACTIVE" = "active" ] && [ "$XRAY_ACTIVE" = "active" ]; then
    echo -e "${YELLOW}⚠${NC}  Both Trojan and Xray are trying to run"
    echo "   → This will cause port conflicts"
    echo "   → Choose ONE protocol or use multi-IP setup"
elif [ "$TROJAN_ACTIVE" = "active" ]; then
    echo -e "${GREEN}✓${NC}  Trojan is running correctly"
elif [ "$XRAY_ACTIVE" = "active" ]; then
    echo -e "${GREEN}✓${NC}  Xray is running correctly"
else
    echo -e "${RED}✗${NC}  No VPN services are running"
fi

echo ""
echo -e "${CYAN}=== Quick Commands ===${NC}"
echo ""
echo "Check Trojan status:  systemctl status trojan"
echo "Check Xray status:    systemctl status xray"
echo "Restart Trojan:       systemctl restart trojan"
echo "Restart Xray:         systemctl restart xray"
echo "Stop Trojan:          systemctl stop trojan"
echo "Stop Xray:            systemctl stop xray"
echo "View Trojan logs:     journalctl -u trojan -f"
echo "View Xray logs:       journalctl -u xray -f"
echo ""

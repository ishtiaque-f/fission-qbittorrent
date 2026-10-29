#!/usr/bin/env bash
# builds fission.qbtheme with the rcc that matches your qBittorrent's Qt version
cd "$(dirname "$0")"
qt=$(ldd "$(command -v qbittorrent)" 2>/dev/null | grep -oE 'libQt[56]Core' | head -1 | grep -oE '[56]')
echo "qBittorrent uses Qt${qt:-?}"
if [ "$qt" = 6 ]; then cands=(/usr/lib/qt6/libexec/rcc /usr/lib/qt6/bin/rcc rcc6 rcc)
else cands=(/usr/lib/qt5/bin/rcc rcc-qt5 rcc); fi
for r in "${cands[@]}"; do
  if command -v "$r" >/dev/null 2>&1 || [ -x "$r" ]; then
    "$r" -binary resources.qrc -o fission.qbtheme && echo "built: $(pwd)/fission.qbtheme" && exit 0
  fi
done
echo "rcc not found. Install it: sudo apt install qt6-base-dev-tools   (Qt6)  or  sudo apt install qtbase5-dev-tools   (Qt5)"
exit 1
